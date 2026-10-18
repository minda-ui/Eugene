---
name: site-link-triage
description: Diagnose a down site-to-site (inter-site) link fast and in the right order — is it the site, the link, the radio, or the switch port? Use whenever a remote site (Beverley, HQ, a future site) can't reach the other, a phone or service that registers across sites goes "No Service"/offline, an airFiber radio or site-to-site VPN looks down, or Minda says "<site> can't reach <site>", "the link is down", "the Beverley phone isn't working", "check the radio". Guide-only (charter §3): Eugene gives the ping/console commands and reads the output; Minda runs them on the live boxes and holds all device creds. Built 2026-10-17 from the Beverley airFiber outage (dish had lost power; its data cable was mis-plugged into the ASA-uplink port).
---

# Site-link triage (is it the site, the link, the radio, or the port?)

A phone or service that registers across sites going offline is usually **not** the phone — it's the
**inter-site path**. HQ and Beverley are joined by an **airFiber radio** (primary) with a **site-to-site
VPN** fallback; VLANs 10/11 are bridged across the radio so both sites share `10.224.10/11.x`. This skill
finds the break in the right order so you don't chase the wrong box. **Guide-only (§3): Minda runs every
command; Eugene reads the output and decides the next step.**

## The one mental model
Work **outwards from the affected site**: is the **site** itself up? → is the **inter-site path** up? →
is it the **radio** or the **VPN**? → is it the **switch port / cabling**? Stop at the first layer that
fails — that's the fault.

## Step 1 — is the local site healthy? (from a box at the affected site, e.g. its Proxmox shell)
```
ping -c 3 <local-gateway>     # e.g. 10.224.111.1 (the site ASA) — local LAN up?
ping -c 3 8.8.8.8             # site internet up?
```
- Both reply → the site is fine; the fault is the **inter-site path** → Step 2.
- Local gateway fails → local LAN/switch problem (not an inter-site issue).
- Gateway OK, internet fails → the site's **WAN/ASA** is down (that also kills the VPN fallback).

## Step 2 — is the inter-site path up? (same shell)
```
ping -c 3 <a-known-up-box-at-the-OTHER-site>   # e.g. HQ Proxmox 10.224.10.10
ping -c 3 <the-service-it-needs>               # e.g. HQ PBX 10.224.13.9
```
- Other site replies → the link carries traffic; the problem is the service/registration, not the link.
- **All HQ addresses 100% loss while local+internet are fine → the inter-site link is DOWN** → Step 3.
- ⚠️ **Tailscale working ≠ the native link is up.** Tailscale rides the internet via the subnet routers,
  a separate path. A native `ping` across the link is the real test.

## Step 3 — radio or VPN? Look at the physical radio first (fastest on-site)
The airFiber dish is powered by a **PoE injector**. The most common cause is simply **lost power**.
- Check the **injector power LED** and both cables (one to the mast, one to the switch). Re-power / re-seat.
- A switch port showing **UP only proves power + Ethernet to the dish** — NOT that the RF link to the far
  end is passing traffic. After re-powering, give the radio **~5 min** to boot and re-acquire the far dish,
  then re-run Step 2.
- To see the RF link itself, open the **airFiber dashboard** (its mgmt IP is on its own isolated subnet —
  at Beverley `192.168.5.20` / HQ `192.168.5.21`; reach it from a device on `192.168.5.0/24` or a temporary
  switch SVI). Check link up/down + signal. A persistently-down RF link = alignment or the far dish.
- If the radio is fine but still no traffic → the **site-to-site VPN** / ASA routing: on the ASA,
  `show route` for the far subnets, `show crypto isakmp sa` / `show vpn-sessiondb` for the tunnel.

## Step 4 — switch port / cabling (if the port or its config is suspect)
Get onto the site switch (console is surest; SSH to its mgmt SVI if known) and read it — the switch tells
you the truth:
```
enable
terminal length 0
show interface status            # which port is the radio's, and is it connected?
show run | include description   # find the port labelled AirFiber / radio / PtP / uplink
show etherchannel summary        # BEFORE touching any uplink cable — is the ASA port-channel whole?
```
- The radio has a **named port** (e.g. `Gi1/1/2 "AirFiber to office"`, a trunk, often on an SFP module).
  **Put the radio there — nowhere else.**
- ⚠️ **Never plug the radio into an ASA port-channel member** (`Po1` members). Doing so won't pass the
  radio traffic AND, if you displaced an ASA cable to free the port, it drops a firewall uplink. Always run
  `show etherchannel summary` and confirm both members are `(P)` bundled before and after.
- A switch port showing `connected trunk a-1000` for the radio = L1 good; re-check Step 2 after the RF
  link has had time to lock.

## Close out
- Once the far site pings, the dependent service follows — e.g. **power-cycle the handset** (pull LAN 10 s,
  replug) and confirm it registers.
- Record any newly-discovered IPs/ports (switch mgmt SVI, radio mgmt IPs, the radio's switch port) in
  `Infra-Inventory/` and the site device-map. Raise/!update the matching **OI** and close the Hub row.

## Gotchas (learned 2026-10-17, Beverley)
- The dish being **off** (no power) looked like a dead phone; it was the whole inter-site link.
- "G2"/front ports vs the **SFP uplink module** matter — the radio was on `Gi1/1/2` (SFP), not a front port.
- `get_sheet_summary`-style sampling is irrelevant here; this is all native `ping` + switch `show`.

## §3 / safety
Guide-only: Minda executes every ping/console/cabling step and holds all device creds (ASA, switch,
airFiber). Eugene reads output and decides; never holds a secret; never changes a live config without
Minda at the keyboard. Any irreversible step (re-cabling the ASA uplink, a switch config change) is flagged
and done in a window.
