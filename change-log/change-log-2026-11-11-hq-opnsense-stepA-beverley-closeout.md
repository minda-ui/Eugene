# Change log — 2026-11-11 (Wed, HQ → Beverley) — HQ Step A complete, Beverley close-out, 7 skills built

_Guide-only (§3). Minda ran every live step and holds every secret (1Password); Eugene never saw a value._

## HQ — OPNsense pair takes over all internal VLANs (Step A complete)
| Item | Result |
|---|---|
| Live ASA re-check (Rule C) | no drift vs 1 Nov; HQ ASA pair = secondary active; outside_bt dead 5 weeks |
| 3850 | VLAN 250 transit + VLAN 9 OOB; Po5 (Gi1/0/42+Gi2/0/42) hq-fw-a, Po6 (Gi1/0/43+Gi2/0/43) hq-fw-b |
| Window 0 | ASA Po1.250 transit 10.224.250.1/29 standby .5; pair .2/.3, CARP .4 |
| Window 1 | guest Wi-Fi (21) — Kea had never been enabled (fixed) |
| Window 2 | inside 11, cctv 12, wifi 20 — admin lockout handled via guest Wi-Fi; Kea "auto collect" off |
| Window 3 | mgmt 10 — DocuSeal + ssh-gw forwards moved; TELEPHONY address removed until its window |
| Window 4 | telephony 13 — internal/out/in calls ✅ |
| After | OOB VLAN 9 emergency port Gi1/0/46; Kea HA (8000/8001 port lesson); T2/T3 tightening (T1 dropped); ASA `permit ip any any` removed, 22999 closed |
| Saved | write memory ASA + 3850 after each window; hq-fw-a backups in 1Password |

## Beverley close-out
| Item | Result |
|---|---|
| Duplicate IPs | home-sw Vlan10/11 SVIs .252 clashed with hq-fw-a → moved to .249 (Eugene's miss; lesson recorded) |
| Ext 1006 | re-patched Gi1/0/10; 403 = password → reset; registered; calls OK (+44 is the SIP provider's rule) |
| bev-fw | gateway switching on; Tailscale rule → This Firewall:443; mounted in the rack; final backup |
| home-sw | Gi1/0/48 shut "spare"; old ASA removed (kept 30 days) |

## Other
- Step B plan v0.1 (`Runbooks/Plan-OPNsense-HQ-StepB-WANs.md`): FTTB is a /30; new **Sky Ethernet 1G** on order (Giacom 5020640, /30) — Minda asked the provider for a /29. Shelf → ASA slot same day; CP400e → pve-ai slot 3; 3 m cable OK.
- R710 copy-3 parts **ordered**: Dell H200 IT (P20+BIOS) + 7× HPE 1.2 TB SAS (4 used + 3 spare). PBS usage 13 GB.
- OI-34 (Cloud Key, no admin login; 6 APs) — reset planned.
- **7 adopted skills built** (SC-13…SC-19); pve-gpu skill flagged "verify reconstructed details on first use".
