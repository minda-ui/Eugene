# Runbook: HQ network core, regain admin access (Cisco ASA 5550 pair, Catalyst stack) (v0.1)

_Eugene runbook, 2026-10-01. Guide-only (charter §3): **Minda performs every step**, Eugene guides live
and checks from her photos. Owner recovery on Fishbone's own hardware, because the contractor who built
the network is unreachable. **No password is ever written here, in chat, in Drive or in git.** New
passwords go straight into 1Password. Related: OI-7, OI-8,
`Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md`,
`change-log/change-log-2026-10-01-hq-server-access-regained.md`._

---

## 0. Before you start (do this first, even if it feels slow)

| ✔ | Item |
|---|---|
| ☐ | Laptop charged, **USB-to-RJ45 console cable**, **PuTTY** saved session: Serial, COMx, **9600**, 8N1, flow control **None** |
| ☐ | PuTTY **logging on** (Session → Logging → *All session output*) to a file **on the laptop only** (the configs it captures contain password hashes and VPN keys) |
| ☐ | **Photograph every cable** on both ASA units, front and back, close enough to read the port labels |
| ☐ | **Label each cable** with tape: unit (TOP or BOTTOM) and port name (e.g. `TOP Gi0/1`) |
| ☐ | Note which unit is **Active**: front LED *ACTIVE* **green = active** (bottom on 2026-10-01), **amber = standby** (top) |
| ☐ | Staff told: **internet off for about 10 minutes** during step A5 |
| ☐ | 1Password open, with an entry ready for *Cisco ASA enable* and *Cisco ASA admin user* |

**Stop rules:**
- If anything offers to **erase the configuration** or says *password recovery is disabled*, answer
  **NO** and stop. Send Eugene a photo.
- If the screen shows something different from this runbook, stop and send a photo. Don't guess.

---

## A. Cisco ASA 5550 failover pair

**Approach:** recover the **standby (top)** unit **while it is disconnected**, so the live (bottom) unit keeps
the internet up. Then swap it in as active. The bottom unit then rejoins and **copies the new settings
from it automatically**.

### A1. Disconnect the top (standby) unit
1. Check the photos and labels are done (§0).
2. On the **TOP** unit: unplug **every network cable**, including the failover link. Leave **power** and
   the **console cable** connected.
3. Internet and phones keep running on the bottom unit. Nothing visible changes for staff.

### A2. Get to ROMMON on the top unit
1. Plug the console cable into the TOP unit's **CONSOLE** port and open the PuTTY session.
2. Switch the TOP unit **off and on** with the **power switch on the back**.
3. Watch PuTTY. When it shows **`Use BREAK or ESC to interrupt boot`**, press **Esc** straight away.
4. You should see **`rommon #0>`**. **Photo to Eugene.**

### A3. Start it without its saved settings
At `rommon #0>` type (each line, then Enter):
```
confreg 0x41
boot
```
It starts up **ignoring its saved settings** (they are not deleted). Wait for **`ciscoasa>`**.

### A4. Load the settings back, set your own passwords
```
enable
```
At `Password:` just press **Enter** (it is blank in this mode). The prompt becomes `ciscoasa#`.

```
copy startup-config running-config
```
Press **Enter** to accept the filename. The real settings load, and the prompt changes to the firewall's
real name. **Photo to Eugene**, then:

```
show running-config username
```
**Photo to Eugene**: it lists the admin accounts (names plus scrambled passwords, safe to share). Eugene
will then tell you exactly which lines to type to:
- set a new **enable** password,
- give **your** admin account a new password (or create one),
- change or remove the **contractor's** account(s).

Then, once Eugene confirms:
```
config-register 0x1
write memory
```
`config-register 0x1` makes it use its saved settings again next time. `write memory` saves your new
passwords.

### A5. Swap it in (internet off for about 5–10 minutes)
1. Switch the **BOTTOM** (currently active) unit **off** at its power switch.
2. Plug every cable into the **TOP** unit exactly as labelled, **failover cable included**.
3. In PuTTY on the TOP unit, check it says it is **Active**:
   ```
   show failover
   ```
   **Photo to Eugene.** Internet should return within about a minute.
4. Check internet and phones from a PC.

### A6. Bring the bottom unit back as standby
1. Switch the **BOTTOM** unit back **on**.
2. It finds the active top unit, becomes **standby**, and **copies the configuration from it**,
   including your new passwords.
3. On the TOP unit run `show failover` again. You should see *This host: Active*, *Other host: Standby
   Ready*. **Photo to Eugene.**
4. Optional, after a few minutes: log in to the bottom unit's console with the **new** password, to prove
   the sync.

### A7. Save a copy of the configuration
On the active unit: `show running-config`, and let PuTTY's log capture it. The log file stays **on the
laptop only**.

**Afterwards (later, not tonight):** these ASA 5550s are **end of support** (no security updates).
Plan their replacement as part of the rebuild.

---

## A-RESULT (2026-10-01): standby ASA recovered; swap blocked on the switch

Part A was run on the **secondary/top** ASA and worked up to the swap: new enable + admin passwords set,
admin SSH key removed, saved (`config-register 0x1`, `write memory`), verified. **But the swap could not
complete:** the ASA uplinks are an **LACP Port-channel to the Catalyst stack**, and the switch would not
bundle the top unit's ports (switches still locked), so Port-channel1 stayed **down** and the top unit
could not pass traffic. Rolled back to the bottom unit; internet restored; the top unit's new config
survived.

**Therefore the order is: Part B (switches) FIRST, then re-run Part A's swap (A5–A7).** When re-running
A5, confirm `show interface ip brief` shows **Port-channel1 up** on the top unit before trusting it.

## B. Cisco Catalyst 3850 switch stack (2x WS-C3850-48P, stack "Catalyst")

Confirmed 2026-10-01: front label "Catalyst 3850 48 PoE+", 2 switches stacked, console asks for a
username (locked). The ASA uplink Port-channel terminates on this stack, so the stack must be recovered
before the ASA swap can complete.

**Eugene does not script the 3850 recovery.** Follow **Cisco's official "Recover/Reset the Password on
Catalyst 3850 Series Switches"** procedure (cisco.com) at the console (MODE button at power-on, boot with
the startup config ignored, keep the config, set new passwords), or use a Cisco-qualified engineer.
Console port is on the back of each switch; the active switch's ACTV LED is green. Effect: wired network
off ~15-20 min. Keep the config; never erase it. After recovery, confirm the ASA uplink Port-channel is
bundled before re-running Part A's swap.

**CRITICAL stack caveat (learned 2026-10-01):** these two 3850s share **StackPower**. Powering on one
switch feeds the other through the StackPower cable, so the whole stack boots and a `copy startup-config
running-config` triggers a **stack resync reload** that undoes the recovery (confirmed 2026-10-01: got to
`Switch>` via ignore-config, but the reload reloaded the config and relocked it). **Before recovery,
physically disconnect the StackPower cable** so switch 1 boots alone; recover it, `write memory`, clear
`SWITCH_IGNORE_STARTUP_CONFIG`, then reconnect StackPower and power switch 2 on. Config is in
`flash:/nvram_config` (IOS-XE 16.x), not `config.text`.

## C. Then fix the phones (OI-8)
With ASA access: check the inbound rule and NAT for SIP (UDP 5060) and RTP. They are believed to allow
only the old provider (`93.95.124.106`). Add the new provider's ranges once known (WebMate ticket
T02530-15072026). Eugene words the exact lines with Minda at the console.

---

## D. Catalyst port map (captured 2026-10-01 ~22:00, for config reconstruction)

The live port→VLAN map was lost when the nvram was wiped; both backups (switch 1 old_wifi_config 2024,
switch 2 startup 2019) predate it. Rebuilt from live discovery (`show interfaces status`, `show cdp
neighbors detail`, `show lldp neighbors` after `lldp run`, `show mac address-table dynamic`) on both
switches while the 2024 config was loaded (so most ports read vlan 1).

**VLAN map (from switch 2 `show vlan brief`):** 2 StarLink, 3 Vodafone, 4 BT, 5 ubnt-mgmt, 6 FTTB, 10
MGMT, 11 LAN, 12 CCTV, 13 Telephony, 20 Main WLAN, 21 Guest_WLAN, 30 DMZ. **ASA trunk (Po1) carries only
2,3,10,11,20** — so the ASA routes the internet-facing VLANs; 12/13 are L2 domains (cameras↔NVR,
phones↔PBX VM 105 at 10.224.13.9), not routed by the ASA.

| Port | Device (CDP/LLDP) | MAC | Target config |
|---|---|---|---|
| Gi1/1/1 | StarLink terminal | 7424.9f20.76b2 | access vlan 2 (StarLink WAN) — already correct |
| Gi1/1/2 (+Gi2/1/2) = **Po1 "ASA-1"** | ASA 5550 | 5475.d0e3.da56 | trunk allowed 2,3,10,11,20 — already correct |
| Gi1/0/21 | Yealink **SIP-T48S** phone | 805e.c007.a71d | `switchport access vlan 11` + `voice vlan 13` |
| Gi1/0/22 | Yealink **SIP-T48S** phone | 805e.c007.a6ab | `switchport access vlan 11` + `voice vlan 13` |
| Gi1/0/47 | Ubiquiti **U7-Outdoor** AP | 2870.4ee4.88d3 | trunk, native/mgmt vlan 5, allowed 5,20,21 (confirm UniFi scheme) |
| Gi1/0/48 | Ubiquiti **U7-Pro-XG** AP | 8c30.6686.7b7c | trunk, native/mgmt vlan 5, allowed 5,20,21 (now wrongly access vlan 10) |
| Gi2/0/46 (sw2) | **Daisy FTTB** router Cisco C1111-8P `fishbone-48316010-gw.cust.daisygroup.net` 62.105.119.117 (native vlan 100) | — | FTTB WAN, vlan 6 (ASA outside_fttb is .118) |
| Te1/1/4 + Te2/1/4 | 10G device `48df.37b7.f780/.f788`, LLDP id `3533343B-3635-SA43-4…` | — | **TBD** — likely the Ubiquiti gateway or a server; Te1/1/4 is a routed L3 port. Confirm. |
| Gi1/0/1,11,13; Gi2/0/1,4,6,8,16,35,41; Gi2/1/1 | MACs `0403.124c.*`, `0403.1257.*`, `e8a0.ed80.*`, `3c1b.f836.*`, `001f.f010.*`, `e84d.ec07.*`, `76ac.b96f.*` (near-sequential — a device fleet) | — | **TBD — likely CCTV cameras (vlan 12) or office PCs (vlan 11). Confirm with Minda.** |

**Answered by Minda 2026-10-01 ~22:30:**
1. The `0403.124c.*` cluster = **CCTV cameras** → VLAN 12.
2. **UniFi controller lives at Beverley Place** (remote site) — APs reach it over the OPNsense
   site-to-site tunnel, not locally. APs keep serving wifi on their adopted config while the controller
   is unreachable, so wifi can be restored from the switch side alone.
3. **Te1/1/4 + Te2/1/4 (10G) = the server** (dual-homed Proxmox) — a **trunk** carrying the VM VLANs
   (OPNsense routing, PBX voice 13, etc.), not the "routed" the stale 2024 config shows.

**Still to confirm tomorrow (cross-check against the ASA / OPNsense / Proxmox configs we own):**
- Exact **VLAN list on the server 10G trunk** (so vlan 5 ubnt-mgmt, 11 LAN, 12 CCTV, 13 voice, 20/21 WLAN
  reach OPNsense → Beverley Place). Read it from Proxmox VM NIC config + the OPNsense config backup.
- **Vodafone (3) / BT (4)** WAN ports (Te1/1/3 is notconnect vlan 3 — likely Vodafone) and **DMZ (30)**.
- The several **connected-but-unmapped** access ports (Gi1/0/16,17,20,33,39,41; sw2 Gi2/0/16,35,41,Gi2/1/1)
  — more cameras or PCs; confirm per-port before assigning.

## E. Draft edge-port config (switch 1) — review before applying

Restores **wifi + phones + CCTV** on switch 1's known edge ports. Apply in ignore-config boot after
loading `old_wifi_config`, then EEM-save. **The AP VLAN-5-native assumption and the server trunk are not
yet confirmed** — verify first.

```
! Yealink T48S phones (Gi1/0/21-22): data VLAN 11, voice VLAN 13
interface range GigabitEthernet1/0/21-22
 switchport mode access
 switchport access vlan 11
 switchport voice vlan 13
 spanning-tree portfast
!
! Ubiquiti APs (Gi1/0/47-48): trunk, mgmt VLAN 5 untagged for adoption, SSIDs 20/21 tagged  [CONFIRM scheme]
interface range GigabitEthernet1/0/47-48
 switchport mode trunk
 switchport trunk native vlan 5
 switchport trunk allowed vlan 5,20,21
 spanning-tree portfast trunk
!
! CCTV cameras (Gi1/0/1,11,13): access VLAN 12
interface range GigabitEthernet1/0/1,GigabitEthernet1/0/11,GigabitEthernet1/0/13
 switchport mode access
 switchport access vlan 12
 spanning-tree portfast
```
Switch-2 equivalents (cameras Gi2/0/1,4,6,8; FTTB Gi2/0/46 → vlan 6; ASA Gi2/1/2 → Po1) apply once the
stack is rebuilt. **The server 10G trunk and WAN ports (Vodafone/BT/FTTB) must be set before internet is
fully back** — hence the cross-check above is the first task tomorrow.

Temporary diagnostic change made 2026-10-01: `lldp run` enabled on switch 1 (harmless, left on; the EEM
auto-save persisted it). The `SAVECFG` EEM applet is still auto-saving every 150 s — remove it over SSH
to 10.224.10.4 once the rebuild is done.

---

## Version history
- **v0.2 (2026-10-01):** Switch 1 recovered (admin access regained); Part D port map added from live
  discovery; VLAN map recovered. Config reconstruction pending Minda's answers to the open questions.
- **v0.1 (2026-10-01):** ASA section written (model confirmed: ASA 5550 pair, bottom active). Catalyst
  section pending the model label.
