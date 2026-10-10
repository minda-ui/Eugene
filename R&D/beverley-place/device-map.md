# Beverley Place — device map (physical recon, 2026-10-10)

_RND-4 recon output. Built from Minda's on-site photos (UniFi controller recon was blocked — Cloud Key
password not held; pivoted to physical/photo recon). Read-only; nothing changed. Guide-only — Minda on
site, Eugene mapping, no credential held. Legitimate recovery: Minda owns 6 Beverley Place (her home /
the registered address)._

## The rack (top → bottom)
| # | Device | Identified as | Notes / to confirm |
|---|---|---|---|
| 1 | Patch panel | 24-port **Cat.5e** | ports numbered 1–24 |
| 2 | Small server / mini-PC (black; DisplayPort + multiple USB3 + 2 expansion-slot covers "1/2") | **Proxmox box** (expected) | model TBD; is this the one with the round blue LED on top? |
| 3 | UniFi **Cloud Key** (Gen2 family; white unit w/ icon display in photo 1) | UniFi controller | **password NOT held**; try `unifi.ui.com` (ui.com SSO) before any reset — never factory-reset (wipes config + un-adopts live net) |
| 4 | **Cisco ASA 5550** (single) | Firewall — **SAME MODEL AS HQ** | serial **MX1512L0FD** (~2015 build). Single unit → no failover pair → simpler than HQ. HQ recovery method applies directly. |
| 5 | **Cisco Catalyst 3850, 48-port** + **C3850-NM-2-10G** (2×10G uplink module) | Switch (single, no stack) | port labels seen up to 36X/37X → 48-port. Single switch → no StackWise, likely no `CSCvj49423` flood bug. |
| 6 | **APC UPS** | Power protection | 5 green LEDs = healthy/online. Model TBD. Folds into OI-7 power picture. |

_(A loose TP-Link Archer Wi-Fi6/BT PCIe card is sitting on the shelf — spare part, not installed, ignore.)_

## Why this is the easy version of HQ
- **ASA 5550, single** — exactly the HQ box, but no active/standby pair → **direct console ROMMON
  password recovery**, no controlled failover needed.
- **3850, single (no stack)** — no StackWise cables, no `CSCvj49423` console-flood bug → straightforward
  bootloader password recovery, then rebuild access VLANs from the switch's own config / the map.
- **Proxmox mini-PC, no iLO** — recover with **direct keyboard+monitor**: GRUB → `init=/bin/bash` →
  remount rw → `passwd root` → remove contractor SSH keys → reboot. **Back up the VMs first.**
- **APC UPS** present and healthy — power is covered.
- Telephony: Beverley phone (ext **1006**) registers to the HQ FusionPBX over the VPN/airFiber bridge.

## Access status
- **Held:** nothing device-level yet (Cloud Key password also not held — the one we thought we had).
- **Route in (on-site):** physical/console on each box, reusing the proven HQ playbook. Does **not** need
  the Cloud Key.
- **Cloud Key:** try `unifi.ui.com` (ui.com account) first for the full UniFi map without a reset.

## Still to capture
1. ASA exact label photo (confirm 5550 + full serial) — Minda says **same model as HQ = 5550**. ✅ (photo nice-to-have)
2. The **small server's model** (brand/model badge) — to size the Proxmox recovery + its role as the
   RND-3 off-site replica node.
3. `unifi.ui.com` login result (does the Beverley console appear?).
4. Switch port map (what's plugged where) — can read from the switch config once consoled in, or a
   back-of-switch photo.

## Next (when Minda commits — graduates out of R&D)
- Eugene drafts `Runbooks/Runbook-Beverley-Place-Recovery.md` (mirror of the HQ runbook, Beverley
  specifics) + raises an **OI-<n>** (same as the HQ recovery). Then on-site: console each box →
  document running config → back up → reset creds into Minda's 1Password. Guide-only; Minda executes.
- Delivers the RND-3 off-site replica node (the Proxmox box) too.

## Links
`R&D/beverley-place/recon.md` (RND-4 plan); OI-7 (backups); HQ recovery change-logs 2026-10-01/02;
HQ ASA = Cisco ASA 5550 (same model).
