# Runbook — Beverley fixed IPs: Loxone + HP printer (AWT-1063)

_Guide-only (§3): Minda performs; Eugene verifies. Beverley ASA DHCP pool on vlan 111 = .10–.248, so statics use .2–.9.
The ASA (9.1) can't reserve by MAC — when OPNsense replaces it, these can become DHCP reservations instead._

| Device | MAC | Now | Fixed |
|---|---|---|---|
| HP Color LaserJet Pro MFP M479dw (wired, SN CNCRNC55BR) | F8:0D:AC:D8:5C:63 | .12 | **10.224.111.5** |
| Intercom "Home Intercom" | 50:4F:94:E0:D6:FA | .11 | **10.224.111.4** |
| Audio Server "Music Box" | 50:4F:94:F0:C1:33 | .14 | **10.224.111.3** |
| Miniserver MSC91A | 50:4F:94:A2:C9:1B | .77 | **10.224.111.2** (last) |
Common: mask `255.255.255.0`, gateway `10.224.111.1`, DNS `1.0.0.1`, `8.8.8.8`.

## 0. Check the addresses are free
From the Lenovo shell: `for i in 2 3 4 5; do ping -c1 -W1 10.224.111.$i >/dev/null && echo ".$i IN USE" || echo ".$i free"; done`

## 1. Printer
1. Browser → `http://10.224.111.12` (HP Embedded Web Server) → **Networking → IPv4 Configuration** → **Manual IP** → address/mask/gateway/DNS above → **Apply**. Reconnect at `http://10.224.111.5`.
2. **Settings → System/Energy → "Shut Down After" = Never** (keep Sleep on).
3. On each PC: remove the old printer, then **Add printer → "The printer that I want isn't listed" → TCP/IP address → `10.224.111.5`** (not WSD).
4. Test print from each PC.

## 2. Intercom → .4
Loxone Config → Intercom → **Device Configuration (>)** → network: static `10.224.111.4` + mask/gw/DNS → apply (device restarts).
Then set its **Network Address** field to `10.224.111.4` → **Save to Miniserver**. Test a doorbell press / video.

## 3. Audio Server → .3
Same: **Device Configuration** → static `10.224.111.3` → apply; set **Local Address** = `10.224.111.3` → **Save to Miniserver**. Test music in one room.

## 4. Miniserver → .2 (last)
**Miniserver Configuration (>)** → network: static `10.224.111.2` + mask/gw/DNS → save; it restarts (~1–2 min).
Loxone Config reconnects by hostname `MSC91A`; Loxone Cloud remote access is unaffected. Check the app, the Intercom and the Audio Server all show **online**.

## 5. Verify (Eugene)
Ping .2–.5 from the Lenovo; Loxone app OK; print test OK. Note: the old DHCP leases (.11/.12/.14/.77) expire by themselves.

## Progress log
- 2026-11-01 11:38 — **Printer done:** static 10.224.111.5, Shutdown 'disable when ports active' on; HOMEOFFICEPC re-added as **"Beverley Printer"**, port 10.224.111.5 (RAW), HP M479 PCL-6 V4 driver; **test page printed** ✅. Other PCs: repeat if any.
- 2026-11-01 — **Printer tray prompt fixed:** cause was Tray 2 type set to "HP LaserJet 90g" (driver sends Plain → no match → fell back to Tray 1 manual feed and prompted). Fix: EWS Tray and Paper Management → Tray 2 = A4 / Plain, Manually Feed Prompt = Unless loaded, Size/Type Prompt = Do not display, Alternative Letter/A4 = Enabled; PC Printing preferences = A4 / Automatically select / Unspecified. Minda confirmed it prints with no prompt ✅.
- 2026-11-01 — **Intercom done:** now on 10.224.111.4 (Device Configuration + Network Address updated, saved to Miniserver) ✅.
- 2026-11-01 — **Audio Server done:** now on 10.224.111.3 ✅.
- 2026-11-01 — **Rollback/incident:** devices never actually took the new IPs (Intercom still .11 by arp); Loxone Config Network Address had been changed to .3/.4 → both showed unreachable. Minda then removed both from the project and saved to Miniserver; Network Search could not find them (still paired). Both ping on old .11 / .14. **Re-adding** both manually by serial (Audio Server 504F94F0C133 → .14, Intercom 504F94E0D6FA → .11), links to be rebuilt (option: copy blocks from the 14 Aug project on Drive, `6 Beverley Place.Loxone` id 1UsY8aJxg6DUz5a3QDkR4THS7lPEch2IU). Fixed IPs .3/.4 **on hold**; Miniserver .2 **not done**. Lesson: ping the new IP *before* changing Network Address; take a File→Save As copy before any removal. Loxone project backup only from Aug → set up regular backups.
- 2026-11-01 — **Root cause found:** Loxone Config Device Configuration (Audio Server) shows *"The device can only be configured for 1 hour after a power cycle"* → the earlier static-IP changes were never accepted by the devices. **Correct method for next attempt:** power-cycle the device → within 1 h open Device Configuration → static IP + mask/gw/DNS → **Apply and send to Audio Devices** → ping new IP → only then change Network Address → Save to Miniserver. Loxone Config crashed once during re-add (reopen via Load from Miniserver).
- 2026-11-01 ~14:00 — **Paused by Minda** after Loxone Config lost the Miniserver (suspected .3 clash: Minda reports Miniserver on .3). Full write-up dropped into the Loxone KB `Raw/` (My Drive/Loxone/Raw, `2026-11-01_beverley-fixed-ip-attempt-and-audio-intercom-repair.md`, id 1-lJHU369Zne9NFOGSvs8hH1bHt8sTlm5). From now on Loxone material lives in that KB; Eugene adds via its Raw/ only. Next: Minda to supply Loxone documentation (or allow www.loxone.com in session network settings).
- 2026-11-01 ~14:30 — **Recovered:** Minda moved the **Miniserver to 10.224.111.2**; Audio Server ("Home Music Server", hostname `asc133`) keeps **10.224.111.3** (its static IP had been applied → it clashed with the Miniserver on .3). Manuals now in Loxone KB `Raw/Manuals/` (Audioserver, Intercom, speakers, etc.). Key facts from them: Local/Network Address only tells the Miniserver where to connect (does not change the device); static IP set via *Configure Device* in the search window before pairing or via the device web UI; Intercom enters pairing mode 15 s after boot if it cannot reach its old Miniserver (up to 120 min); factory reset = Format SD Card in Config. Next: verify .2/.3, then Intercom → .4.
- 2026-11-01 ~15:00 — **Intercom re-paired and working** (Minda: "It works!"). Was not on .11 after power-cycle; paired via Network Periphery → Network Device Search. Target address .4 — confirm in Config. Remaining: Tree Turbo speakers re-pair, rebuild Audio Player zones + intercom/doorbell logic if lost, Loxone app local address → .2, regular Loxone project backup, update Loxone KB Raw note.
