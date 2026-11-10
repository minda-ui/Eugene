# Change log — 2026-11-10 (Tue, Minda at Beverley) — bev-fw remote access + password reset into 1Password

## Update 2026-11-10 ~19:50 UTC — Beverley SWAP done: bev-fw live (guide-only §3)
| Item | Result |
|---|---|
| Pre-check Source NAT | HQMGMT not NATed ✅; WAN2_RES had no NAT → fixed (interface gateway = BT_RESIDENTIAL) |
| Swap | old ASA off; Po1 cables → bev-fw Gi0/1+Gi0/2; lagg0 + 6 VLANs up; BT_BUSINESS active, BT_RESIDENTIAL + HQ_RADIO green |
| Fault found + fixed | Wi-Fi "couldn't get IP": Dnsmasq held UDP 67 on all interfaces → Kea couldn't bind. MGMT DHCP moved to Kea, Dnsmasq disabled → clients get addresses |
| Tests | Wi-Fi ✅ internet ✅ Loxone ✅ IoT leases ✅ bev-fw→PBX 1.2 ms ✅ · UniFi not checked · **ext 1006 open** (patch cable pulled from its termination — Minda re-terminates 11 Nov) |
| After | encrypted bev-fw backup in 1Password ✅; old ASA off, kept 30 days |
| Decisions | Automated config backups approved: Oxidized LXC `netbackup` on pve-ai, nightly, switches + 3 OPNsense, HQ ASA excluded (`Runbooks/Plan-Network-Config-Backups.md`) |
| For HQ tomorrow | disable Dnsmasq on hq-fw-a/b before go-live (same port-67 clash) |

_Guide-only (§3). Minda generated and holds every secret (1Password vault **Fishbone IT**); Eugene never saw a value._

- **bev-fw (unit 3) on Tailscale:** `os-tailscale` plugin, single-use auth key (1Password), IP **100.84.154.117**, key expiry disabled. tailscale0 assigned as opt1 TAILSCALE; rule pass TCP 100.64.0.0/10 → This Firewall :443. webGUI verified from the phone on mobile data → bench build can be done remotely. Gotchas: "Interface (origin)" only for out-rules; `/10` dropped into Source Port.
- **New passwords (all generated in 1Password, changed on device, tested in a private window):** pve-ai root, pve-bev root, pve-nas root (+PBS :8007), Gen9 `pve` root, **Gen9 iLO** (login name is `root`, display name "Administrator"; reset in-band with `ipmitool user set password 1` → **OI-31 resolved**), bev-fw root (+ encrypted config backup attached with its own key), Fishbone AI admin (reset in the Open WebUI DB; web-shell paste added hidden codes on the first try).
- **Moved into Fishbone IT:** PBS tokens gen9-backup + pveai-backup, BT Business hub admin (were in the phone's Samsung Secure Folder).
- Gen9 iLO address corrected in the inventory: static **10.224.10.21** (not .50).
- **bev-fw bench build stages 2–6 DONE remotely over Tailscale** (lagg0 em7+em2, 6 VLAN interfaces, Kea DHCP 4 subnets + 4 reservations, 6 routes to HQ via HQ_RADIO, 7 rules + RFC1918 alias, auto source NAT, gateways BT_BUSINESS 10 / BT_RESIDENTIAL 200 / HQ_RADIO 250 + WAN_FAILOVER group). Final encrypted config backup in 1Password (template for units 1, 2, 4). Details: Plan AWT-1069c bench-build log.
- Still open: pve-ai iLO (BJL) password + pve-bev iLO setup at next on-site visit; bev-fw **swap** at Beverley (quiet window): Po1 cables → Gi0/1+Gi0/2, monitoring + gateway switching on, tests, old ASA kept 30 days.

## Afternoon (HQ) — HQ OPNsense pair built on the bench (guide-only §3; Minda did every step, holds every secret)
- **DIY VGA cable** for the 5525-X J9 header works (wiring in the install runbook).
- **Unit 2 → `hq-fw-a`** (FCH19267THV): OPNsense 26.7 ZFS on the SSD, 26.7.8_2. **Unit 1 → `hq-fw-b`** (FCH18187KX2): same; its SSD held an old install image (installer hid ada0) — fixed by SSD-out boot + `gpart destroy`/`dd`. Both roots in 1Password (`hq-fw-a`, `hq-fw-b`; b's temp password rotated).
- Both: lagg0 = em3+em7 LACP, VLANs 250/21/11/12/20/10/13, a = .252 (TRANSIT .2), b = .253 (TRANSIT .3); INSIDE + MGMT unaddressed on the bench. Bench GUI on the office net: a **10.224.11.245**, b **10.224.11.246** (OOB em8, gw 10.224.11.1).
- **Lockout lesson:** a bench box must hold no address in a subnet the admin traffic comes from — Minda's PC reaches the office net via Tailscale → PVE1 (10.224.10.10), so MGMT 10.224.10.252 swallowed the replies. Fixed from the console.
- hq-fw-a: aliases, ASA_TRANSIT gateway (disabled), 11 rules translating the ASA security levels (HQ plan §3); encrypted config backup taken.
- **HA pair:** SYNC cable Gi0/2↔Gi0/2 (10.99.250.1/.2), pfsync + XMLRPC (Aliases + Firewall Rules) a → b — **verified, b holds all 11 rules**.
- hq-fw-a ALARM LED cleared by a cold power cycle (fans OK, 35 °C).
- **Decision (Minda): DS2246 shelf + CP400e + `tank` move from the R710 to `pve-ai`** (always-on primary PBS); the R710 becomes the scheduled-power 3rd copy with a new IT-mode HBA (H200 / 9211-8i) + 6 internal disks (size TBC from the backup set) — shopping list updated.
- Open: CARP VIPs + Kea HA + 3850 port-channels + OOB VLAN 9 (go-live work); pve-ai free low-profile slot check; PBS datastore size for the R710 disk choice; confirm the hq-fw-a backup item exists in 1Password.
