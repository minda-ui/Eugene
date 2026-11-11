---
name: loxone-device-fixed-ip
description: Give a Loxone network device (Miniserver, Audio Server, Intercom) a fixed IP the safe way - check the address is free and the site's real gateway/DNS, power-cycle, set the static IP ON THE DEVICE first (Loxone Config Search window - Configure Device, or the device web UI), ping the new IP, and only THEN change the Local/Network Address in the project and Save to Miniserver. Prefers a DHCP reservation on the site firewall (OPNsense Kea) as the cleaner route, and carries the recovery paths (re-pair via search + replace arrow, SD-card reset). Use whenever Minda says "Loxone lost connection", "give the Miniserver a fixed IP", "the Audio Server/Intercom is offline after an IP change", "set a static IP on the Loxone", "the Loxone app can't find the Miniserver", "Loxone Radio won't load", or is moving Loxone devices to new addresses at Beverley or any other site. Guide-only (charter §3) - Eugene dictates and verifies; Minda does every live step and holds all Loxone logins in her 1Password. Built 2026-11-11 from the 1 Nov Beverley fixed-IP afternoon (AWT-1063) and the Beverley OPNsense Kea reservations (AWT-1069c).
---

# Loxone device fixed IP (device first, project second)

On 1 Nov at Beverley a "quick" fixed-IP job for the Loxone kit cost an afternoon: the project's Network
Address was changed before the devices had moved, two devices were deleted from the project, the Audio
Server clashed with the Miniserver, and Eugene gave the wrong DNS. This skill is the order that works.
**Guide-only (§3): Minda does every click; Eugene dictates, reads screenshots and pings.**

## The one mental model
The **Local / Network Address** field in Loxone Config does **not** change the device. It only tells the
Miniserver *where to look*. So the device must be on its new IP **before** the project points at it.
Change the project first and the device shows "unreachable" — and the temptation to "fix" it by deleting
it is what loses all its links.

## Better option first: a DHCP reservation
If the site firewall can reserve by MAC, do that instead of (or as well as) a static IP — one place to
manage, no device-side config, no clash with the pool.
- **Beverley (OPNsense bev-fw, Kea DHCPv4, INSIDE 10.224.111.0/24):** reservations already exist —
  **Miniserver .2, Audio Server .3, Intercom .4, Printer .5** (MAC-based; MACs are in the plan, not here).
  The pool is .10–.248, so .2–.9 stay outside it.
- The old Beverley ASA (9.1) could not reserve by MAC — that's why the devices got statics on 1 Nov.
- A device keeping its static IP that matches its reservation is fine. Just never point two at one address.

## Step 0 — before touching anything
1. **Back up the project:** Loxone Config → **File → Save As** a dated copy (and file it in the Loxone KB
   via its `Raw/`). Do this before any change, and *always* before any removal.
2. **Is the target address free?** From a box on the same LAN (e.g. the site Proxmox shell):
   `for i in 2 3 4; do ping -c1 -W1 10.224.111.$i >/dev/null && echo ".$i IN USE" || echo ".$i free"; done`
   Check against what *every* Loxone device actually has now — on 1 Nov the Audio Server already held .3.
3. **Confirm the site's real gateway and DNS** from the firewall/DHCP config — don't assume the gateway is
   a DNS server. Beverley: gateway `10.224.111.1`, mask `255.255.255.0`, DNS **`1.0.0.1`** (+ `8.8.8.8`).
4. **Do one device at a time; Miniserver last.**

## Step 1 — make the device configurable
- Loxone devices only accept network config **for 1 hour after a power cycle** ("The device can only be
  configured for 1 hour after a power cycle"). Changes made outside that window are silently not applied.
- So: **power-cycle the device** (also the fix if it's unreachable), wait for it to boot, then work
  inside the hour. An Intercom that can't reach its old Miniserver drops into pairing mode ~15 s after boot.

## Step 2 — set the static IP on the device itself
Either route, with IP + mask + gateway + DNS from Step 0:
- **Loxone Config → Search window** (Network Periphery → Network Device Search / Search Audioservers) →
  select the device → **Configure Device** → static IP → **Apply / send to the device**. It restarts.
- Or the **device web UI** at its current address.
Minda types any login from her 1Password — Eugene never asks for, sees or writes it down.

## Step 3 — prove it moved
`ping -c3 <new-ip>` from the LAN, and confirm the old IP no longer answers (`arp -n` shows the MAC on the
new address). **No reply on the new IP = stop.** Don't touch the project; go back to Step 1.

## Step 4 — only now update the project
Device's **Local / Network Address** = the new IP → **Save to Miniserver**. Check it shows online, then
test the real function (doorbell + video for the Intercom; music in one room and Loxone Radio for the
Audio Server — Radio failing to load = DNS wrong). For the **Miniserver**: Miniserver Configuration →
static IP → save; it restarts (~1–2 min); Config reconnects by hostname; check the app's local address.

## Recovery paths (if it goes wrong)
- **Device "unreachable" after a project change:** don't delete it. Put the Network Address back to where
  the device really is (ping/arp to find it), Save, then redo Steps 1–4.
- **Lost / unpaired device:** power-cycle → Search window → find it → **Configure Device** (IP/gw/DNS) →
  use the **replace arrow** to map it onto the existing project object (keeps its links) → Save to Miniserver.
- **Config loses the Miniserver / crashes:** reopen via **Load from Miniserver**; check for an IP clash first.
- **Last resort — factory reset:** Loxone Config → **Format SD Card** for that device, then re-pair as
  above. Re-check paired extras afterwards (e.g. Tree Turbo speakers, Audio Player zones, doorbell logic).

## Traps from 1 Nov (Beverley, AWT-1063)
- Changed the **Network Address before the device IP** → both devices "unreachable".
- **Deleted devices** from the project and saved → links lost, search couldn't see them (still paired).
- **IP clash:** Audio Server took .3 while the Miniserver was also on .3 → Config lost the Miniserver.
- **Wrong DNS:** Eugene said DNS = 10.224.111.1; the Beverley ASA isn't a DNS server → Loxone Radio
  "No items could be loaded". Correct: 1.0.0.1.
- Settings "applied" outside the 1-hour post-power-cycle window never took effect.

## Record it
Update the site device map / `Infra-Inventory/`, the processed-items ledger and the dated change-log.
Loxone know-how belongs in the **Loxone KB** — Eugene adds to it via its `Raw/` only (§1). IPs are fine
in git; no MACs, serials of personal kit, logins or household detail.

## §3 / safety
Guide-only: Minda performs every Config, web-UI, power-cycle, firewall and SD-card step. Eugene never
holds a Loxone (or firewall) password — they live only in Minda's 1Password. A Format SD Card or a device
removal is irreversible-ish: flag it, take the project backup first, do it with Minda's go-ahead.
