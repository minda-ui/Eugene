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
