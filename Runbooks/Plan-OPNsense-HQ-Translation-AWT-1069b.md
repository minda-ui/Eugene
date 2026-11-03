# Plan — HQ ASA 5550 config → OPNsense (Step A, inside first) — v0.1

**Hub:** AWT-1069 part (b). **Date:** 2026-11-03. **Author:** Eugene. **Status:** draft for Minda; nothing changes on any live box until she approves each window.
**Source:** HQ ASA export 1 Nov (`Infra-Inventory/exports/hq-asa-2026-11-01-export-MASKED.txt`, secrets masked) + notes; 3850 notes; OPNsense plan v2 (`R&D/estate-compute-split/opnsense-firewall-plan.md`).
**Hardware:** 2× ASA 5525-X reflashed to OPNsense 26.7 (`hq-fw-a`, `hq-fw-b`, CARP pair). Install: `Runbooks/Runbook-OPNsense-Install-ASA5525X.md`.
**Guide-only (§3):** Minda runs every live step in an agreed window; Eugene writes the exact lines and checks the results. No secrets here.

---

## 1. What stays on the ASA in Step A, what moves
| VLAN | Name (ASA nameif, sec level) | Subnet | DHCP pool (ASA) | Step A |
|---|---|---|---|---|
| 21 | guest_wifi (40) | 10.224.21.0/24 | .10–.248 | **Moves first (rehearsal)** |
| 11 | inside (100) | 10.224.11.0/24 | .50–.240 | Moves (2nd window) |
| 12 | cctv (70) | 10.224.12.0/24 | .10–.248 | Moves (2nd window) |
| 20 | wifi (100) | 10.224.20.0/24 | .10–.248 | Moves (2nd window) |
| 10 | mgmt (100) | 10.224.10.0/24 | .50–.240 (+ option 43 → UniFi 10.224.110.5) | Moves (3rd window, console ready) |
| 13 | telephony (50) | 10.224.13.0/24 | .10–.248 | **Moves last** (phones-free window) |
| 30 | dmz (30) | 10.224.30.0/24 | — | **Stays on ASA** (public forwards) |
| 2 / 3 / 4 / 6 | outside_sl / outside_vf / outside_bt / outside_fttb | WANs | — | **Stay on ASA** |
| 5 | ubnt_mgmt (0) | 192.168.5.0/24 | — | Stays on ASA (AP/airFiber native VLAN mgmt) |

## 2. Physical + addressing
- **Each OPNsense box:** Gi0/0 + Gi0/1 → **LACP to the 3850 stack** (one leg per switch, built-in RJ45 ports, new port-channel each) carrying the moved VLANs + transit VLAN. Gi0/2 = **HA sync (pfsync)** cable box-to-box. Gi0/3–0/6 spare (Step B WANs). Gi0/7 = bench/admin.
- **Transit VLAN 250** (new): `10.224.250.0/29` — ASA `.1` (new sub-interface `Port-channel1.250`, nameif `transit`, security 100), hq-fw-a `.2`, hq-fw-b `.3`, **CARP VIP `.4`**.
- **Per moved VLAN:** CARP VIP **`.1`** (same gateway as today → no client changes), hq-fw-a **`.252`**, hq-fw-b **`.253`** (outside every DHCP pool). ASA's `.2` standby addresses on VLAN 10/11 disappear with the sub-interface.
- **Default route on OPNsense:** `0.0.0.0/0 → 10.224.250.1` (ASA). ASA keeps internet, NAT, DMZ and all public forwards.

## 3. Firewall policy — faithful translation of today's ASA behaviour
The ASA has **no inside ACLs** — behaviour comes from security levels + `same-security-traffic permit inter-interface`:
- equal levels talk freely: **mgmt ↔ inside ↔ wifi (all 100)**;
- higher → lower allowed (stateful replies only back): 100 → cctv(70) → telephony(50) → guest(40) → dmz(30);
- lower → higher blocked.

OPNsense rule set that reproduces this (interface rules, "in" direction, stateful):
| Interface | Allow to | Block |
|---|---|---|
| MGMT, LAN(inside), WIFI | any (incl. each other, CCTV, TELEPHONY, GUEST, DMZ, internet) | — |
| CCTV | TELEPHONY, GUEST, DMZ, internet | MGMT, LAN, WIFI |
| TELEPHONY | GUEST, DMZ, internet (only PBX 10.224.13.9 actually gets internet — ASA NAT, see §5) | MGMT, LAN, WIFI, CCTV |
| GUEST | DMZ, internet | all other internal VLANs |
Each interface ends with an explicit **block + log**. Aliases mirror the ASA objects (PVE1 10.224.10.10, PBX 10.224.13.9, DocuSeal 10.224.10.60, proxy 10.224.30.30, ssh-gateway 10.224.10.9, Cat3850 10.224.10.4, UniFi 10.224.110.5).

### ⚠️ Tighten while we move (Minda decides — OI-33)
| # | Today | Recommended at migration |
|---|---|---|
| T1 | **Wi-Fi (staff) can reach MGMT** (same level 100) | WIFI → MGMT **blocked**, except named admin laptops if needed |
| T2 | **CCTV can reach telephony, guest, DMZ** | CCTV → internet/NVR only |
| T3 | Guest → DMZ allowed | Guest → internet only |
| T4 | DocuSeal `.60` sits **inside** the mgmt DHCP pool | DHCP **reservation** for its MAC, or move it to `.30` (outside pool) |
Default proposal: **replicate exactly in Step A** (no surprises), apply T1–T4 one at a time a week later. Minda may choose to apply them on day one.

## 4. DHCP (moves with each VLAN)
- Same pools, lease 8 h, DNS **1.0.0.1, 8.8.8.8** (as today). Later option: OPNsense Unbound as resolver.
- **HA:** DHCP served by the pair in failover (Kea HA hot-standby, or dnsmasq on the CARP master — choose at build; Eugene recommends Kea).
- **MGMT VLAN:** keep **option 43 = `01040ae06e05`** (UniFi controller 10.224.110.5).
- **Reservations by MAC** (new, fixes AWT-1060/1062 natively): iLO Gen9 (now static 10.224.10.21, outside pool — keep), DocuSeal (T4), any printer/Loxone-style devices found at HQ. Eugene fills the MAC list from `show dhcpd binding` before window 3.

## 5. ASA change lines per window (Minda applies; Eugene re-checks the live config the same day)
**Window 0 — transit only (no traffic moves):**
```
interface Port-channel1.250
 description transit to OPNsense
 vlan 250
 nameif transit
 security-level 100
 ip address 10.224.250.1 255.255.255.248
```
+ on the 3850: `vlan 250`, allow 250 on the ASA and OPNsense port-channels.

**Window 1 — VLAN 21 guest (rehearsal):**
```
no nat (guest_wifi,outside_vf) source dynamic guest_wifi_network interface
no nat (guest_wifi,outside_sl) source dynamic guest_wifi_network interface
no nat (guest_wifi,outside_bt) source dynamic guest_wifi_network interface
no nat (guest_wifi,outside_fttb) source dynamic guest_wifi_network interface
no dhcpd enable guest_wifi
interface Port-channel1.21
 shutdown
route transit 10.224.21.0 255.255.255.0 10.224.250.4
nat (transit,outside_vf) source dynamic guest_wifi_network interface
nat (transit,outside_sl) source dynamic guest_wifi_network interface
nat (transit,outside_bt) source dynamic guest_wifi_network interface
nat (transit,outside_fttb) source dynamic guest_wifi_network interface
```
Then on OPNsense: VLAN 21 on the LACP, CARP `.1`, DHCP pool, GUEST rules. Test: phone on guest SSID → IP, internet, cannot reach 10.224.10.x.
**Roll-back (minutes):** `no shutdown` the sub-interface, `dhcpd enable guest_wifi`, restore the four NAT lines, remove the route + transit NATs; disable VLAN 21 on OPNsense.
(`no interface Port-channel1.21` only after 7 days stable — saved lines kept in the change-log.)

**Windows 2–4** follow the same pattern for 11+12+20, then 10, then 13 — Eugene writes the exact lines per window from the live config on the day (the ASA may have changed by then; Rule C). Extra items to carry:
- **Window 3 (mgmt):** the Beverley routes `10.224.110/111/120.0/24 via 10.224.10.254` move to OPNsense (ASA keeps a route to them via `10.224.250.4`); the **DocuSeal 80/443 forward** (`nat (mgmt,outside_fttb) source static DOCUSEAL …`) changes to `(transit,outside_fttb)`; the ASA's own SSH-from-mgmt rule follows.
- **Window 4 (telephony):** PBX `10.224.13.9` NAT + **UDP 5080** forward on FTTB/BT change to `(transit,…)`; **SIP inspection stays OFF** on the ASA (it is off today — keep it so). Test inbound/outbound calls, both directions, before the window closes (OI-8 lessons).
- **Window 2 (inside):** the route `10.224.17.0/32 via 10.224.11.11` (the OPNsense **VM 101** — IPsec on 500/4500 via DMZ) moves to the new pair as `10.224.17.0/24 via 10.224.11.11` (the /32 looks like a typo — confirm).

## 6. Step B preview (later; not in this plan's windows)
Gateway group on OPNsense = today's ASA tracked routes: **FTTB tier 1** (monitor 8.8.4.4) → **Starlink tier 2** (monitor 1.1.1.1) → **Vodafone tier 3**; **BT** (81.143.32.194/29, 0 hits) — keep or drop (Minda). Port forwards: DocuSeal 80/443, proxy 80/443, PBX UDP 5080, IPsec 500/4500 → VM 101 (or fold its VPN into the pair). MSS clamp 1452 (ASA `sysopt connection tcpmss 1452`) on the WANs. The /29 public-IP question returns here.

## 7. Dropped / not carried over (confirm)
- Admin port-forwards (removed 1 Nov) and the `permit ip any any` lines — **not** recreated.
- AnyConnect: not enabled on any interface; local users `vpn2`, `vpn-user-1`, pool 10.224.16.0/24 — leftovers → not migrated (3850 also has a typo route for 10.224.16.0/24 via 10.225.10.1).
- `tmp_hack` 192.168.228.0/24 (NAT + route via 3850; 3850 Vlan3 secondary .228.1) — leftover → remove later (Minda confirm).
- `logging monitor debugging` → OPNsense: normal logging + remote syslog later; **NTP added** (the ASA clock reads 2004).

## 8. Questions for Minda (answer before window 0)
1. HQ pair = **unit 1 + unit 2**? (both arrived for HQ)
2. Tighten **T1–T4 on day one**, or replicate first and tighten a week later (Eugene's default)?
3. **VM 101 (OPNsense VM)** — what does it serve (IPsec road-warrior on 10.224.17.0/24?). Keep it in Step A?
4. **BT line** (0 hits) and **Vodafone** — still wanted for Step B?
5. `tmp_hack` 192.168.228.0/24 — anything still using it?
6. Preferred window days/times (guest first: any evening; telephony: phones-free).

## 9. Done when (Step A)
All six VLANs gatewayed by the OPNsense pair; CARP failover tested (pull hq-fw-a power → hq-fw-b takes over, calls stay up); DHCP serving from the pair; ASA carries only WANs + DMZ + transit; every window logged in a change-log with its roll-back lines.
