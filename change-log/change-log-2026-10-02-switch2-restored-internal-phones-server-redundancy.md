# Change log — 2026-10-02 — Switch 2 restored (stack rejoin + port rebuild); internal phones back; server dual-homed

_Session change-log entry. Newest note at the top. HQ Network Core Recovery, day 2 (round 2) — follows
`change-log-2026-10-01-hq-server-access-regained.md`. Guide-only throughout: **Minda executed every
console/SSH command; Eugene guided and verified.** No credential held by Eugene (the `recovery` account
password lives in Minda's 1Password; only its 3-char prefix was ever referenced). Switch 1 stayed live and
master the whole session._

---

## Headline

HQ Catalyst 3850 **stack is whole again** and switch 2 is fully rebuilt to the site's network diagram:

- **Switch 2 rejoined the stack** as member 2 → **redundant SSO pair restored** (switch 1 Active/master,
  switch 2 Standby, both `Ready`, both on IOS-XE 16.09.05 install mode).
- **Office WiFi restored** (switch 2's AP port fixed) — Minda's phone has wifi again.
- **Internal phones restored** (earlier in the day — ASA trunk VLANs expanded) — dial tone + internal call
  confirmed. *External* calls still blocked (OI-8, deferred).
- **Server dual-homed** — second 10G link bundled into Po4, one link to each switch (survives a switch
  failure).
- **Switch 2 ports rebuilt** per the scanned "Fishbone Network diagram" (CCTV→vlan12, iLo→vlan10,
  telephony→vlan11+voice13, PCs→vlan11, AP ports→trunk) — cameras and PCs back on their VLANs.

Everything saved (`write memory`). A safety backup of switch 1's good config sits on flash
(`flash:switch1-good-2026-10-02.cfg`, 20924 B).

---

## Part A — Earlier in the day (round 2 morning): clean SSH, EEM removed, server + internal phones

Done before the stack work, documented here for the record (first 2026-10-02 change-log).

### A1. Clean SSH access to switch 1 (escape the console flood)
Switch 1's console still floods from the faulty StackWise adapter (bug CSCvj49423, see 10-01 log), so we
moved off the serial console onto SSH:
```
ip ssh version 2
interface vlan 11
 ip address 10.224.11.2 255.255.255.0
 no shutdown
line vty 0 15
 transport input ssh
crypto key generate rsa label SSH-KEY modulus 2048
ip ssh rsa keypair-name SSH-KEY
```
SSH now reaches switch 1 at **10.224.11.2** (user `recovery`) — a clean session, flood-free.

### A2. EEM auto-save applet removed
The flood-immune `SAVECFG` EEM timer (the 10-01 workaround) is no longer needed now saves run cleanly over
SSH — and an armed auto-save is itself a hazard (it wiped nvram once on 10-01). Removed:
```
no event manager applet SAVECFG
```

### A3. Server restored — Port-channel4 (LACP) to the DL380
`Te1/1/4` to the server was a bare `routed` port, then a plain trunk — neither passed traffic. Root cause:
the Proxmox host's two 10G NICs (`ens3f0np0`+`ens3f1np1`) are an **OVS LACP bond** (`bond_mode=balance-tcp`,
`lacp=active`, MTU 9100) — read directly from `/etc/network/interfaces` on Proxmox (read-only). So the switch
side must be an **LACP port-channel**, not a plain trunk, and mgmt (`mgmt0` = 10.224.10.10/24, gw .1) is
**tagged vlan 10**, not native. Built:
```
interface TenGigabitEthernet1/1/4
 channel-group 4 mode active
interface Port-channel4
 description SERVER-DL380
 switchport mode trunk
 switchport trunk allowed vlan 5,6,10-13,20,21,30
```
Result: `Po4(SU)`, `Te1/1/4(P)` bundled; Proxmox reachable at 10.224.10.10, all VMs running.

### A4. Internal phones restored — ASA uplink (Po1) allowed VLANs expanded
Phones were on vlan 13 correctly (CDP/LLDP voice VLAN) but had no DHCP/gateway: the ASA serves the vlan
gateways/DHCP (Po1.2–Po1.30, telephony gw 10.224.13.1), but switch 1's **Po1 trunk to the ASA only allowed
vlan 2,3,10,11,20** — so vlan 13 never reached the ASA. Expanded:
```
interface Port-channel1
 switchport trunk allowed vlan 2,3,10,11,12,13,20,21,30
```
(added 12 CCTV, 13 Telephony, 21 Guest_WLAN, 30 DMZ). ASA then served vlan 13 → phones got DHCP and
registered to the PBX (FusionPBX VM 105, 10.224.13.9). **Dial tone + an internal call confirmed by Minda.**
External calls remain down — that's the SIP-trunk/ASA-inbound work under **OI-8** (deferred this session).

---

## Part B — Switch 2 stack rejoin (this session)

**Decision (Minda): "Stack rejoin now".** Bring switch 2 back into the stack so it inherits switch 1's good
config automatically, restoring switch-2 APs, cameras, phones and server redundancy — with switch 1 staying
powered and master so its config is pushed to switch 2 (switch 2's stale Jan-2019 config is overwritten,
which is desired).

1. **Safety net first** — on switch 1: `write memory`, then
   `copy running-config flash:switch1-good-2026-10-02.cfg` (20924 B). Instant restore if the stack misbehaves.
2. **Vetted switch 2 at its `switch:` bootloader** (console, standalone, stack cables off): `set` showed
   `BOOT=flash:cat3k_caa-universalk9.16.09.05.SPA.conf` (**install mode, 16.09.05 — exact match to switch 1**),
   `MANUAL_BOOT=no`, `SWITCH_NUMBER=2`, `SWITCH_IGNORE_STARTUP_CFG=1`. `dir flash:` confirmed a complete,
   healthy 16.09.05 image. **No boot-variable changes needed** — `IGNORE_STARTUP_CFG=1` is the safe setting
   for a joining member (boots blank, master provides config; if cabling failed it'd come up recoverable,
   not stuck on the locked 2019 config).
3. **Baseline on switch 1 (SSH):** `*1 Active dcce.c10e.e500 pri15 Ready`, `2 Member 0000.0000.0000
   Provisioned` — switch 1 already held a provisioned seat for member 2.
4. **Physical rejoin:** powered switch 2 OFF → connected the two **StackWise-480 DATA cables** in a crossover
   ring (SW1-STACK1↔SW2-STACK2, SW1-STACK2↔SW2-STACK1) while switch 1 stayed live → powered switch 2 ON.
   The live master survived the ring coming up on its faulty adapter (the one real risk). Internet/phones/
   server never dropped.
5. **Join confirmed:** `show switch` went `2 Standby … HA sync in progress` → **`2 Standby dcce.c1e4.fe80
   pri1 V05 Ready`**. **Redundant SSO pair restored**, switch 1 still Active/master (a joining member never
   preempts a running master).

---

## Part C — Office WiFi, server redundancy, switch-2 port rebuild (this session)

### C1. Office WiFi restored (Gi2/0/48)
Switch 2's AP port was on `access vlan 10` (wrong), so the AP couldn't reach its UniFi mgmt (vlan 5) or carry
the WLANs. Reconfigured to match switch 1's AP ports:
```
interface GigabitEthernet2/0/48
 switchport mode trunk
 switchport trunk native vlan 5
 switchport trunk allowed vlan 5,20,21
```
**WiFi back on Minda's phone.** `write memory`.

### C2. Server dual-homing (Te2/1/4 → Po4)
`Te2/1/4` (switch 2's link to the server) was a bare `routed` port — the server's second NIC wasn't bundled.
Mirrored the working member `Te1/1/4` exactly and added it to Po4:
```
interface TenGigabitEthernet2/1/4
 switchport
 switchport trunk allowed vlan 5,6,10-13,20,21,30
 switchport mode trunk
 spanning-tree portfast trunk
 channel-group 4 mode active
```
`show etherchannel 4 summary`: **`Po4(SU) LACP  Te1/1/4(P)  Te2/1/4(P)`** — both bundled. Server now
dual-homed: one 10G link to each switch; survives a switch failure. `write memory`.

### C3. Switch-2 port rebuild per the scanned diagram
After the stack rebuild, switch 2's access ports came up in **default vlan 1** (their per-port config was
never restored — only switch 1's was rebuilt on 10-01), so the CCTV cameras and PCs on them were stranded.
**Minda scanned the site's "Fishbone Network diagram" into `Raw/` (`Scanned_20261002-0922.pdf`, 08:22)** — the
authoritative port plan, confirming switch 2 = switch 1 layout. Applied it to switch 2:
```
interface range GigabitEthernet2/0/1-16   → switchport mode access / switchport access vlan 12   (CCTV + recorder)
interface GigabitEthernet2/0/17           → switchport mode access / switchport access vlan 10   (iLo)
interface range GigabitEthernet2/0/18-24  → switchport mode access / access vlan 11 / voice vlan 13 (telephony)
interface range GigabitEthernet2/0/25-45  → switchport mode access / switchport access vlan 11   (computers/printers)
interface GigabitEthernet2/0/47           → trunk native vlan 5 / allowed 5,20,21                (WiFi AP; 48 done in C1)
```
CCTV cameras (OUI `0403.12xx` cluster on 1/4/6/8/16) back on vlan 12 → recorder can see them; PCs back on
vlan 11. `write memory`.

**Two real-world exceptions to the diagram (verified, not guessed):**
- **Gi2/0/46 — leased fibre.** The diagram's plan says 46–48 = WiFi AP, but port 46 actually carries the
  **1 Gb/1 Gb symmetric leased-fibre line** via a Cisco C1111 modem (`fishbone-48316010-gw.cust.daisygroup.net`).
  **Left completely untouched** (plain default, vlan 1, running) — blindly applying "46–48 = AP trunk" would
  have knocked out the leased line. Repositioning the modem to its proper slot is a separate project — raised
  as **OI-13**.
- **Gi2/0/47 — stale label.** Carried a leftover `description d1380 iLO` + `access vlan 10`. The real server
  iLo is live on switch 1 `Gi1/0/17` (per the diagram, port 17 = iLo). Minda confirmed port 47 is an empty,
  AP-designed port. Cleaned the stale label (`no description`, `no switchport access vlan 10`) → clean AP
  trunk ready for a future AP.

---

## Switch-2 final state (all per diagram, saved)
| Ports | Role | VLAN | Status |
|---|---|---|---|
| Gi2/0/1–16 | CCTV + recorder | 12 | ✅ |
| Gi2/0/17 | iLo | 10 | ✅ |
| Gi2/0/18–24 | IP telephony | 11 + voice 13 | ✅ |
| Gi2/0/25–45 | Computers/printers | 11 | ✅ |
| Gi2/0/46 | **Leased fibre (Cisco modem)** | 1 (untouched) | ⚠ OI-13 reposition |
| Gi2/0/47 | WiFi AP (empty) | trunk 5/20/21 | ✅ cleaned |
| Gi2/0/48 | WiFi AP (office) | trunk 5/20/21 | ✅ wifi up |
| Te2/1/4 | Server (Po4) | trunk | ✅ bundled |

---

## Lesson (for Help & Lessons / future diagram-driven rebuilds)
A network diagram is the *intended* plan, not the live truth. Before applying a diagram's port plan to a live
switch, **verify what's physically on each port first** (CDP / MAC OUI / interface description). Here the
diagram said 46–48 = WiFi AP, but 46 had the 1 Gb leased-fibre modem and 47 had a stale iLo label — applying
the plan blindly would have cut the leased line. Check, then configure.

---

## Still open / next
- **OI-8 — external phone calls** (deferred): SIP trunk status + new provider's SIP IP ranges (WebMate ticket
  T02530-15072026) + ASA inbound SIP(UDP 5060)/RTP rule. Internal calling now works; external is the remaining leg.
- **OI-13 (new) — reposition the leased-fibre modem** off Gi2/0/46 into its proper slot (separate project).
- Replace switch 1's **faulty StackWise adapter** (CSCvj49423) — still the live fault flooding switch 1's console.
- Proper **off-box backup target + schedule** for the Proxmox VMs (OI-7); support/replace decision on the DL380.
- Strip the **defunct Cisco wireless config** from the recovered `old_wifi_config` (cosmetic).
