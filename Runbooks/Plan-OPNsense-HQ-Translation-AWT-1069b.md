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
- **Each OPNsense box:** Gi0/0 + Gi0/1 → **LACP to the 3850 stack** (one leg per switch, built-in RJ45 ports, new port-channel each) carrying the moved VLANs + transit VLAN. Gi0/2 = **HA sync (pfsync)** cable box-to-box. Gi0/3–0/6 spare (Step B WANs). Gi0/7 spare. **Management port = dedicated admin interface** (changed 2026-11-05, Minda): bench = laptop on 192.168.99.1/24; in the rack = its own small **out-of-band admin network** (new VLAN 9 `oob`, 10.224.9.0/29: hq-fw-a .2, hq-fw-b .3, admin jump host/laptop .4–.6), **not** VLAN 10 — once window 3 moves VLAN 10 onto the pair, the box already has an interface in 10.224.10.0/24 and one box cannot hold two interfaces in the same subnet. Web GUI + SSH listen on OOB (and on VLAN 10 mgmt for day-to-day), never on guest/wifi/cctv/telephony.
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
Gateway group on OPNsense (**order confirmed by Minda 7 Nov**): **FTTB tier 1** (monitor 8.8.4.4) → **BT Business via the radio, VLAN 4, tier 2** → **Starlink tier 3** (monitor 1.1.1.1) → **Vodafone tier 4**; **BT** (81.143.32.194/29, 0 hits) — keep or drop (Minda). Port forwards: DocuSeal 80/443, proxy 80/443, PBX UDP 5080, IPsec 500/4500 → VM 101 (or fold its VPN into the pair). MSS clamp 1452 (ASA `sysopt connection tcpmss 1452`) on the WANs. The /29 public-IP question returns here.

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

## 10. Minda's answers (2026-11-03)
1. HQ pair = **unit 1 + unit 2** ✅
2. **Copy first, tighten (T1–T4) one week after** the last VLAN moves ✅
3. **VM 101 (OPNsense VM): Minda doesn't know what it does and doesn't use it.** → Before Step A window 2: Eugene guides a read-only look (VPN status/logs, any traffic on 10.224.17.x in the last 30 days). If unused: **power it off for 7 days** (reversible), then remove the **UDP 500/4500 forwards** to it (they expose an unused VM to the internet — added to OI-33), then archive it (never delete without Minda).
4. **Keep BT and Vodafone** for Step B ✅
5. `tmp_hack` 192.168.228.0/24: unknown → treated as a leftover. Check its hit counts on the ASA/3850 first; remove only after a week with zero use.
6. Windows: **go with the flow** — only Minda and Andrejus work at HQ, so the guest/office/CCTV/mgmt windows can be short daytime slots agreed on the day. **Telephony stays a planned phones-free window** (the PBX serves the whole company, not only HQ desks).

## 11. Live re-check before go-live (2026-11-11, Minda at HQ console; Rule C)
- `show run interface/route/nat/dhcpd` = 1 Nov export, no drift. Prompt `fishbone-asa/sec/act` → **HQ ASA is a failover pair and the SECONDARY unit is currently active** (note; changes replicate).
- Default route in use: **FTTB 62.105.119.117** (metric 9). `outside_bt` (VLAN 4, .194 → .198, track 4) **down 5 weeks** — dead since BT Business moved direct to bev-fw; remove at Step B.
- NAT: guest_wifi PAT on vf/sl/bt/fttb (= window-1 lines). **CCTV has no NAT today (no internet)** → window 2 adds transit NAT for inside + wifi only, not cctv. ssh-gateway forward **TCP 22999** on fttb + bt (OI-33, close after the swap).
- DHCP: lease 28800, DNS 1.0.0.1 + 8.8.8.8; pools mgmt .50–.240 (+ option 43 `01040ae06e05`), inside .50–.240, cctv/telephony/wifi/guest .10–.248 — unchanged.
- **Design decision for the bench→rack phase:** OOB stays on the office net (LAN_GW default) until OOB moves to VLAN 9; moved VLANs reach the internet by **policy routing** (pass rules with gateway ASA_TRANSIT), so admin replies never go asymmetric through the ASA. The 3850 trunks to the pair carry **only VLAN 250** until each window adds its VLAN (otherwise the CARP .1 VIPs would clash with the ASA's .1).
- **Prep done (11 Nov, before window 0):** Dnsmasq disabled on both; ASA_TRANSIT gateway on both (enabled, NOT upstream, monitoring off); CARP VIPs on hq-fw-a synced to b: TRANSIT 10.224.250.4/29 VHID 250, GUEST 10.224.21.1/24 VHID 21 (password in 1Password "HQ CARP password"); GUEST rules "Guest to DMZ" + "guest to internet" policy-routed via ASA_TRANSIT (synced); Kea on hq-fw-a: subnet 10.224.21.0/24 pool .10–.248, routers 10.224.21.1, DNS 1.0.0.1/8.8.8.8, 28800 s, interface GUEST (Kea HA deferred — docs to verify; b serves no DHCP yet).
- **HQ 3850 (11 Nov):** `vlan 250 transit-opnsense`, `vlan 9 oob`; Po1 + Po2 (ASA) `allowed vlan add 250`; **Po5 = Gi1/0/42 + Gi2/0/42 → hq-fw-a**, **Po6 = Gi1/0/43 + Gi2/0/43 → hq-fw-b**, LACP active, trunk allowed **250 only**; `write memory` OK. Roll-back: `no interface Port-channel5/6`, `default interface` the 4 ports, `allowed vlan remove 250` on Po1/Po2. Side find: Gi2/0/47 "d1380 iLO" notconnect (Gen9 iLO cable?).
- **Window 0 DONE (11 Nov):** cabling corrected (3 of 4 legs first landed in wrong ports — Gi1/0/41, Gi2/0/39; moved; Po5 + Po6 SU, all members P). ASA: `interface Port-channel1.250` nameif transit, sec 100, `10.224.250.1/29 standby 10.224.250.5`, write mem OK. TRANSIT rule added on the pair: pass ICMP from 10.224.250.0/29 (synced). ASA → .2 / .3 / .4 all 5/5, ~1 ms. Lesson: a rule created on hq-fw-a needs **Apply on a**; the sync applies it on b by itself.
- **Window 1 DONE (11 Nov) — guest Wi-Fi (VLAN 21) on the OPNsense pair.** 3850: no Vlan21 SVI (checked); ASA: `no dhcpd enable guest_wifi`, Po1.21 shutdown, `route transit 10.224.21.0/24 10.224.250.4`, 4 guest NATs replaced by `nat (transit,outside_*) source dynamic guest_wifi_network interface`; 3850: VLAN 21 added to Po5/Po6. Test (Minda's phone on SSID "fishbone"): lease **10.224.21.10** from Kea on hq-fw-a ✅, internet ✅ (policy route via ASA_TRANSIT, NAT on ASA), Fishbone AI 10.224.10.31:3000 **blocked** ✅. Fault on the way: Kea had never been enabled and its interface list was empty ("Nothing selected", lifetime 4000) → KEA red, no log lines; fixed by selecting GUEST + 28800 + Enabled + Apply. Lesson: an empty Kea log + red service = settings never saved; check Settings → Interfaces first.
- After window 1: `write memory` on ASA + 3850. Roll-back (if ever): 3850 `allowed vlan remove 21` on Po5/Po6; ASA `no route transit 10.224.21.0 …`, remove 4 transit NATs, restore 4 guest NATs, Po1.21 `no shutdown`, `dhcpd enable guest_wifi`.
- **Window 2 DONE (11 Nov, ~09:45) — INSIDE (11), CCTV (12), WIFI (20) on the pair.**
  - Prep lessons: admin access moved to the **guest Wi-Fi** (rule `temp admin from guest`: GUEST → This Firewall TCP 443, top of GUEST rules) because Minda's laptop was on staff Wi-Fi (10.224.20.128) and unit 2's own WIFI .252 address swallowed the replies (same class as the 10 Nov lockout). OOB moved to **10.224.9.2/.3 /29**, LAN_GW deleted (first had to clear "IPv4 gateway rules" on OOB); unit 2 briefly had **no default route** (A1 upstream had not saved) → `route add default 10.224.250.1` on console, then ASA_TRANSIT upstream + only gateway. TRANSIT rule `ASA-side nets to pair` (alias ASA_SIDE = 10.224.10/11/17/110/111/120.0/24).
  - INSIDE .252/.253; CARP VIPs INSIDE .11.1 VHID 11, CCTV .12.1 VHID 12, WIFI .20.1 VHID 20; Kea subnets 11 (.50–.240), 12 (.10–.248), 20 (.10–.248). ⚠️ Kea "Auto collect option data" must be **off** — otherwise router/DNS = the box's own .252 (no failover). Fixed after the cut.
  - ASA: `no dhcpd enable inside/cctv/wifi`; Po1.11/.12/.20 shutdown; `route transit 10.224.11/12/20.0 → 10.224.250.4`; inside_network + wifi_network NAT moved to `(transit,outside_vf/sl/bt/fttb)`. CCTV has no NAT (as before). 3850: VLAN 11,12,20 added to Po5/Po6.
  - Tests: office PC 10.224.11.70 gw **10.224.11.1** DNS 1.0.0.1/8.8.8.8 from Kea ✅, internet ✅, staff Wi-Fi ✅, Fishbone AI 10.224.10.31 ✅, CCTV live view ✅, desk phones ✅, unit 1 all 5 VIPs **BACKUP** ✅.
  - Roll-back (until write mem): 3850 `allowed vlan remove 11,12,20` on Po5/Po6; ASA Po1.11/.12/.20 `no shutdown`, dhcpd enable ×3, remove 3 routes + 8 transit NATs, restore 8 old NATs.
  - Open: VM 101 route 10.224.17.0 via 10.224.11.11 (old ASA `route inside`) now dead — VM 101 believed unused (OI-33); add on the pair only if needed. Remove `temp admin from guest` once OOB VLAN 9 access exists.
- **Saved (11 Nov):** `write memory` [OK] on HQ ASA + 3850; hq-fw-a encrypted config backup in 1Password. **Next:** window 3 (MGMT VLAN 10 + OOB VLAN 9 admin access, remove `temp admin from guest`, Kea HA, VM 101 route) and window 4 (TELEPHONY VLAN 13, phones-free) — separate days.
- **Window 3 (MGMT VLAN 10) cut over (11 Nov).** Read-only check first: no DHCP clients on mgmt (all static) → no Kea subnet for 10 yet (option 43 not needed now); outside ACLs all end `permit ip any any` (OI-33). Prep: TRANSIT pass TCP any → DOCUSEAL 443/80, any → SSH_GW 22. ASA: `no dhcpd enable mgmt`, Po1.10 shutdown, 4 mgmt routes → `route transit` (10.224.10/110/111/120.0/24, 192.168.228.0/24 via .250.4); NAT moved to transit: DocuSeal 443/80 + ssh-gateway 22→22999 (bt, fttb) as lines 1–4, mgmt_network PAT ×4; vpn_pools identity NAT dropped (unused AnyConnect). 3850: VLAN 10 added to Po5/Po6. Pair: MGMT .252/.253, CARP 10.224.10.1 VHID 10, gateways BEV_FW 10.224.10.254 + CAT3850 10.224.10.4 (not upstream, monitoring off), routes 110/111/120 → BEV_FW, 228 → CAT3850 (both units); CARP toggle for GARP.
- Tests: Fishbone AI ✅, PVE1 :8006 ✅, DocuSeal public (sign.fishbonegroup.co.uk on mobile data) ✅, bev-fw → .10.10/.10.1/.10.252 ✅. bev-fw → PBX 10.224.13.9 first 100 % loss: the pair still had **TELEPHONY 10.224.13.252/.253** (connected route into un-trunked VLAN 13) → set TELEPHONY IPv4 None on both until window 4 → 14/14 ✅. **Rule (now baked in): an un-moved VLAN must have NO address on the pair.**
- **Window 3 DONE + saved (11 Nov):** unit 1 MGMT BACKUP ✅; `write memory` [OK] ASA + 3850; hq-fw-a encrypted backup refreshed in 1Password. **Remaining for HQ:** window 4 TELEPHONY (VLAN 13, phones-free slot: re-add .252/.253 + CARP .13.1 VHID 13 + Kea 13 subnet; ASA PBX NAT + UDP 5080 forward → transit; SIP inspection stays off; test in/out calls + Beverley ext 1006); OOB VLAN 9 admin access (3850 access port for em8 ×2 + jump host) then delete `temp admin from guest`; Kea HA (unit 1 serves no DHCP yet — clients keep leases 8 h on unit-2 failure); ASA retirement planning (WANs → pair, Step B).
- **Window 4 prepared (11 Nov, for 12:00, office empty).** Live read: PBX-HOST = telephony_nat_allowed = **10.224.13.9**; no telephony routes; **no `inspect sip`** (keep it so). NATs: inbound `(outside_fttb,telephony) source static any any destination static interface PBX-HOST service SVC_UDP_5080 SVC_UDP_5080`; PAT telephony_nat_allowed on bt/sl/fttb (not vf); object NAT PBX-SIP-FTTB / PBX-SIP-BT `static interface service udp 5080 5080`. Lines + tests + roll-back: see the 11 Nov chat / window-4 block below once executed.
- **Window 4 DONE (11 Nov ~12:15, office empty) — TELEPHONY (13) on the pair. All internal VLANs now on OPNsense.** Prep: TRANSIT pass UDP any → PBX 5080. ASA: `no dhcpd enable telephony`, Po1.13 shutdown, `route transit 10.224.13.0/24 10.224.250.4`; inbound 5080 twice-NAT → `nat (outside_fttb,transit) 5 source static any any destination static interface PBX-HOST service SVC_UDP_5080 SVC_UDP_5080`; telephony_nat_allowed PAT (bt/sl/fttb) → transit; object NAT PBX-SIP-FTTB / PBX-SIP-BT → `(transit,outside_*) static interface service udp 5080 5080`. 3850: VLAN 13 added to Po5/Po6. Pair: TELEPHONY .252/.253, CARP 10.224.13.1 VHID 13, Kea 10.224.13.0/24 pool .10–.248 routers .13.1 DNS 1.0.0.1/8.8.8.8; CARP toggle. Tests: internal ✅, out ✅, **inbound to company number ✅** (2-way audio), unit 1 all **7 VIPs BACKUP** ✅. Pending: 5-min re-test, write mem, backup; Beverley ext 1006 tonight (after re-termination).
- **ASA now carries only:** WANs (VLAN 2/3/4/6), DMZ 30, VLAN 5 ubnt_mgmt, transit 250. Step B later = WANs onto the pair, ASA retired.
- **Window 4 saved (11 Nov):** 5-min inbound re-test ✅; `write memory` ASA + 3850; hq-fw-a backup refreshed in 1Password. **Step A complete — all six internal VLANs on the OPNsense pair.**
- **Decision (Minda, 11 Nov): T1 dropped.** Staff Wi-Fi (VLAN 20) is used only by Minda and Andrejus → it keeps full access everywhere, including MGMT and the firewall GUIs. T2–T4 still open for the week-later tightening.
- **OOB VLAN 9 LIVE (11 Nov).** Everyday admin: office PC / staff Wi-Fi → https://10.224.11.252 / .253 (direct now that INSIDE/WIFI live on the pair). Emergency: 3850 Gi1/0/45 = hq-fw-a em8, Gi2/0/45 = hq-fw-b em8, **Gi1/0/46 = OOB admin jump port** (all access VLAN 9, portfast, no SVI = isolated); laptop static 10.224.9.4/29 no gateway → https://10.224.9.2 / .3 both load ✅. Next: delete `temp admin from guest` (GUEST), record OOB access in 1Password.
