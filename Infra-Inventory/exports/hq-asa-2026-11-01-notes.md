# HQ ASA — export notes (2026-11-01, Minda at console, read-only)

## show version (from photos)
| Item | Value |
|---|---|
| Prompt | `fishbone-asa/sec/act` → **the SECONDARY unit is currently ACTIVE** (primary is standby) |
| Model | **ASA 5550**, 4096 MB RAM, Pentium 4 3.0 GHz, 256 MB CF |
| Software | ASA **9.1(7)32**, ASDM 6.4(7), image `disk0:/asa917-32-k8.bin` (compiled Sep 2018) |
| Uptime | 29 d 23 h; failover cluster up 30 d 21 h |
| Interfaces | Gi0/0–0/3 (copper), **Gi1/0–1/3** (4-port module), Management0/0 |
| Licence | **VPN Premium**, perpetual; failover Active/Active; 5000 AnyConnect Premium; 10 security contexts (20 cluster) |
| Serial | JMX1425L244 |
| ⚠️ Clock | config "last modified … **Wed Mar 24 2004**" → **clock wrong, no NTP** (fix with AWT-1060 SNTP work) |
Activation key: not recorded (licence data, kept off the repo).

## Full export (masked) → `hq-asa-2026-11-01-export-MASKED.txt`
Password hashes, activation key and SSH key fingerprint replaced with `*****` before commit.

## Key facts
| Item | Value |
|---|---|
| WAN — **Wavenet FTTB** | `outside_fttb` vlan 6, **62.105.119.118/30** (gw .117) → **one usable public IP**. Default route (metric 9, tracked). |
| WAN — BT (from Beverley, over radio) | `outside_bt` vlan 4, **81.143.32.194/29** (gw .198) — **0 hits** (line not carrying traffic). |
| WAN — Starlink | `outside_sl` vlan 2, 192.168.1.254/24 (gw .1), metric 20 — carries a lot of inside traffic (180k xlates). |
| WAN — **Vodafone** (not in our records before) | `outside_vf` vlan 3, 192.168.3.254/24 (gw .1), metric 254 — light use. |
| VLANs | 10 mgmt (sec 100) · 11 inside (100) · 12 cctv (70) · 13 telephony (50) · 20 wifi (**100**) · 21 guest_wifi (40) · 30 dmz (30) · 5 ubnt_mgmt (0) |
| DHCP pools | mgmt .50–.240 · inside .50–.240 · cctv/telephony/wifi/guest .10–.248 · DNS 1.0.0.1, 8.8.8.8 · option 43 → UniFi 10.224.110.5 |
| Static hosts | ASA .1/.2 · 3850 `10.224.10.4` · ssh-gw `.9` · PVE1 (Gen9) `.10` · DocuSeal `.60` (**inside the DHCP pool — conflict risk**) · old iLO object `.78` (iLO is now `.50`) · proxy `10.224.30.30` · OPNsense VM wan `10.224.30.11` / lan `10.224.11.11` · PBX `10.224.13.9` |
| Beverley routes | 10.224.110/111/120.0/24 via `10.224.10.254` |
| Failover | Gi0/3 folink, Gi1/3 statelink (**down**) — stateful replication link down |
| Odd/leftover | `tmp_hack` 192.168.228.0/24 NAT + route via 3850; host route `10.224.17.0/32` via OPNsense VM (probably meant /24); `logging monitor debugging`; no NTP, no syslog; same-security inter-interface permitted |

## 🔴 SECURITY FINDING (2026-11-01)
Every outside ACL ends in **`permit ip any any`**. The `admin_access` lines (2 admin IPs) have **0 hits**; the final any-any has
**260,579 hits** on FTTB. So the admin port-forwards are **open to the whole internet**, not just the admin IPs:
| Forward on 62.105.119.118 | Target | Hits |
|---|---|---|
| TCP 22024 → SSH | **Proxmox Gen9 (PVE1)** | **24,579** |
| TCP 35392 → 8006 | **Proxmox web GUI** | 1,392 |
| TCP 16078 → 443 | Gen9 iLO (old .78 — now dead target) | 109 |
| TCP 22999 → SSH | ssh-gateway | 148 |
| TCP 22023 → SSH | 3850 switch | 11 |
Intended public services (keep): DocuSeal 80/443, PBX UDP 5080, proxy 80/443, OPNsense VM IPsec 500/4500.
Also: **wifi VLAN is security 100 = same as mgmt/inside**, with same-security traffic permitted → Wi-Fi clients can reach the management network.
