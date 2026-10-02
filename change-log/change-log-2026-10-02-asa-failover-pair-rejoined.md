# Change log — 2026-10-02 — ASA failover pair RE-JOINED (standby back, config synced); data-path integration parked

_Session change-log entry (same day as the switch-2 work; separate workstream, separate file). HQ Network
Core Recovery. **Guide-only throughout: Minda at the ASA console/switch SSH; Eugene guided and verified.**
No credential held by Eugene. The live (primary) ASA was never disrupted._

---

## Headline
The recovered HQ firewall (Cisco ASA 5550, the **Secondary** of the active/standby pair) was brought back
into the failover pair: the failover heartbeat link was reconnected, the unit detected the live Primary,
**pulled the production config, and settled to `Secondary – Standby Ready`** — with the live firewall
untouched. The standby's **data ports were deliberately left unplugged**; integrating the standby's data
path is parked as a planned next task (see `Runbooks/Runbook-ASA-Failover-Datapath-Integration.md` and
**OI-14**) because the switch-side ASA uplink is currently a temporary lash-up, not the production cabling.

## Context
Yesterday (2026-10-01) admin control of the server and the Catalyst 3850 stack was regained; the ASA pair
was left for later. Today, after the switch-2 / stack work, Minda asked to **get both ASAs racked and
working as a failover pair**. Hard constraints established up front:
- **Admin only on the recovered (Secondary) unit.** The live (Primary) unit is still contractor-managed —
  no admin, can't be configured. (Same gap as OI-8.)
- The **failover link was disconnected**; the live Primary is running standalone on the old config and
  carrying all company traffic — **must not be disrupted.**
- The recovered unit had been powered off with **data + power unplugged**, isolated.

## Investigation (read-only, recovered unit at console)
Powered the recovered unit with **data ports unplugged** (console + power only) and read its state:
- **`show version`:** ASA 5550, software **9.1(7)32**, ASDM 6.4(7), 4096 MB RAM, slot 1 = **ASA-SSM-4GE-INC**
  (4-port Gig module → Gi1/0–1/3), serial **JMX1425L244**.
- Boot banner showed **`Enabling failover`** and prompt **`fishbone-asa/sec/act`** → the unit **kept its
  failover config** and is the **Secondary**, currently **Active-in-isolation** (normal: a secondary that
  can't see its mate takes over to avoid an outage). **This is the split-brain state** — which is exactly
  why its data ports had to stay unplugged until synced back to standby.
- **`show failover` / `show running-config failover`:**
  ```
  failover
  failover lan unit secondary
  failover lan interface folink    GigabitEthernet0/3
  failover link      statelink     GigabitEthernet1/3
  failover interface ip folink    10.224.0.253 255.255.255.252 standby 10.224.0.254
  failover interface ip statelink 10.224.0.249 255.255.255.252 standby 10.224.0.250
  failover replication http
  ```
  Mode = **Active/Standby**, single context. **folink = Gi0/3**, **statelink = Gi1/3**.
- **`show interface ip brief`** confirmed the full production config is present on this unit — data uplink
  `Port-channel1` with subinterfaces carrying every VLAN gateway: `Po1.10=10.224.10.1` (mgmt),
  `.11=10.224.11.1` (inside/LAN), `.12=10.224.12.1` (cctv), **`.13=10.224.13.1` (telephony)**, `.20/.21`
  (wifi/guest), `.30` (dmz), plus WAN subinterfaces `.2–.6` (StarLink/Vodafone/BT/ubnt/FTTB, incl. public
  IPs 81.143.32.194 / 62.105.119.118). Interface names: management, outside_sl/vf/bt/fttb, ubnt_mgmt, mgmt,
  inside, cctv, telephony, wifi, guest_wifi, dmz.

## The re-join (done)
1. Confirmed failover config intact → a **clean re-join path** exists (no live-unit admin needed): reconnect
   the folink, the Secondary detects the active Primary, drops to Standby, and pulls config. One-way sync
   (active→standby) → **zero disruption to the live Primary.**
2. Minda found the failover cable (**labelled "FAILOVER"**) already in the live unit's `Gi0/3` with a free
   end. **Connected it: live `Gi0/3` ↔ recovered `Gi0/3` (folink).** Data ports stayed unplugged. (No
   separate stateful cable was found — the statelink/`Gi1/3` is still down; basic failover forms on the
   folink alone.)
3. Console showed: *"State check detected an Active mate / Beginning configuration replication… Receiving
   from mate / End Configuration Replication (STB)"*, prompt flipped to **`fishbone-asa/sec/stby`**.
4. **`show failover` verified:** `folink Gi0/3 (up)`; **`Version: Ours 9.1(7)32, Mate 9.1(7)32`** (versions
   match); **`This host: Secondary – Standby Ready`**; standby IPs in place (mgmt 10.224.10.2, inside
   10.224.11.2); all data interfaces `No Link` (ports unplugged, as intended).

Replication-time warnings seen and judged benign: *"No memory for DHCP interface '' extension creation"*
(×12 — cosmetic, replication completed to STB), *"Failover enabled but standby IP not configured"* (×10 —
the WAN/outside interfaces, which don't carry a standby IP), *"Link status Down on interface management"*
(Management0/0 not cabled). To verify DHCP post-integration.

## Why the data path was parked (switch side is temporary)
Before connecting the standby's data cables, checked the switch side (SSH 10.224.11.2):
```
show etherchannel summary  → Po1(SU) LACP  Gi1/1/2(P) Gi2/1/2(P)   ;  Po4(SU) = SERVER-DL380
show interfaces status | include ASA → Gi1/1/2 TMP_ASA_LINK trunk ; Gi2/1/2 TMP_ASA_LINK trunk ; Po1 ASA-1 trunk
show run interface Port-channel1 → description ASA-1 ; switchport trunk allowed vlan 2,3,10-13,20,21,30 ; mode trunk
```
Findings:
- The live (Active) ASA reaches the stack via **`Po1 (ASA-1)` = `Gi1/1/2` + `Gi2/1/2`**, both labelled
  **`TMP_ASA_LINK`** — a **temporary** recovery lash-up on the SFP uplink ports, **not** the original
  production cabling (Minda's "3 cables from each ASA").
- **There is no switch-side port-channel for the Standby ASA at all.**
So plugging the standby's data cables (`TOP G0/0/1`, …) into free ports now would land them in default
VLAN 1 and form nothing — the same trap seen on the switch-2 ports earlier today. The clean fix is a
planned re-cabling using Minda's **pre-disconnect photos + the network diagram**, building proper
port-channels for both units. Deferred to **OI-14** / the integration runbook.

## IP-conflict flagged (prerequisite for the data-path step)
The switch's **VLAN-11 management SVI is `10.224.11.2`** (set during round-2 SSH recovery) — which equals the
**ASA inside standby IP**. **No conflict now** (the standby's inside interface is down, data unplugged), but
the SVI **must be re-IP'd off `10.224.11.2`** before the standby's data ports go live. Recorded as step 1 of
the integration runbook. (Left as-is today so our switch SSH session stayed up.)

## State left at end of session
- **Failover pair re-formed:** Secondary = **Standby Ready**, config synced from the live Primary; the
  production firewall config is now also mirrored onto the second box (a backup benefit).
- **FAILOVER (folink) cable left connected** — the pair stays formed and stable indefinitely on the
  heartbeat; data ports unplugged, so no data-plane risk.
- Live Primary untouched throughout — internet/phones/server unaffected.

## Next (planned, not urgent)
See `Runbooks/Runbook-ASA-Failover-Datapath-Integration.md` (OI-14):
1. Re-IP the switch VLAN-11 SVI off 10.224.11.2.
2. From Minda's photos + diagram, map the production ASA↔switch cabling for both units.
3. Build the switch-side port-channels (Active + Standby), matching the ASA's `Port-channel1` (LACP).
4. Connect the standby's data cables; verify its interfaces come up and failover health is all-green.
5. (Optional) connect the stateful link (`Gi1/3`↔`Gi1/3`) for stateful failover; verify DHCP.
6. Then **OI-8 (external calls)** can be tackled on the now-redundant ASA (new provider SIP IP ranges +
   ASA inbound SIP/RTP rule) — still needs live-Primary admin or a controlled failover to the Secondary.
