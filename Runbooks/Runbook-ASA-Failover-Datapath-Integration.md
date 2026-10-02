# Runbook — ASA Failover Data-Path Integration (HQ)

> **Status: v1.0 (2026-10-02) — ready to plan, not yet executed.** Guide-only: Minda executes at the
> console/SSH/rack; Eugene guides and verifies (charter §3). Governs **OI-14**. Follows the 2026-10-02
> ASA failover re-join (`change-log/change-log-2026-10-02-asa-failover-pair-rejoined.md`).

## Goal
Bring the HQ ASA **Secondary (Standby)** unit's **data path** into service so the active/standby pair is a
true hot standby (the standby can actually forward traffic on a failover), and restore the proper
production ASA↔switch cabling — **without disrupting the live firewall.**

## Where we are now (end of 2026-10-02)
- **Failover pair re-formed:** Secondary = `Standby Ready`, folink (`Gi0/3`) up, config synced from the live
  Primary. **Data ports unplugged** (no data path yet).
- **Switch side is temporary:** the Active ASA reaches the Catalyst stack via `Po1 (ASA-1)` = `Gi1/1/2` +
  `Gi2/1/2`, both labelled **`TMP_ASA_LINK`** (a recovery stopgap on the SFP uplink ports). **No
  port-channel exists for the Standby ASA.**
- **Admin only on the Secondary.** The live Primary is still contractor-managed (no admin) — same gap as
  OI-8. Config changes on the pair are made on the **Active** (replicate to standby); since we only have
  the Secondary, plan changes for when it is active, or make switch-only + standby-only changes.

## Reference facts (from 2026-10-02 investigation)
- 2× ASA 5550, IOS-XE **9.1(7)32**, **Active/Standby**, single context. Secondary serial `JMX1425L244`.
- Failover: **folink = `Gi0/3`** (10.224.0.252/30), **statelink = `Gi1/3`** (10.224.0.248/30),
  `failover replication http`.
- ASA data uplink = **`Port-channel1`**, subinterfaces trunking VLANs **2,3,10,11,12,13,20,21,30**
  (StarLink/Vodafone/BT/FTTB WANs on 2/3/4/6, ubnt-mgmt 5, mgmt 10, inside 11, cctv 12, telephony 13,
  wifi 20, guest 21, dmz 30). Interface IPs: inside 10.224.11.1 / standby .2; mgmt 10.224.10.1 / standby .2;
  telephony 10.224.13.1; etc.
- Switch `Po1 (ASA-1)` trunk allowed vlan `2,3,10-13,20,21,30`.
- Standby ASA data cables are labelled e.g. **`TOP G0/0`, `TOP G0/1`** (+ a 3rd) — "3 cables from each ASA".

## Prerequisites to gather first (read-only, next session)
1. **Minda's pre-disconnect photos** of the ASA↔switch cabling (which ASA port → which switch port, for
   **both** units) + the **Fishbone Network diagram**. This is the authoritative source for the production
   topology — do not guess.
2. On the **Secondary ASA** (has the synced config), capture the data-uplink member config so the switch
   side can be matched exactly:
   ```
   show running-config interface GigabitEthernet0/0
   show running-config interface GigabitEthernet0/1
   show running-config interface GigabitEthernet0/2
   show running-config interface Port-channel1
   ```
   Note the `channel-group 1 mode <active|passive|on>` (LACP vs static) and which physical ports are the
   Po1 members — the switch port-channel must match (LACP active ↔ active).

## Step 1 — Re-IP the switch VLAN-11 SVI off 10.224.11.2 (REQUIRED before standby data ports go live)
The switch's VLAN-11 management SVI = `10.224.11.2` = the ASA **inside standby** IP. When the standby's
inside interface comes up it will claim `.2` → duplicate IP. On the **switch** (SSH), move it:
```
configure terminal
interface vlan 11
 ip address 10.224.11.3 255.255.255.0      ! confirm .3 is free first (show ip arp 10.224.11.3 / ping)
end
write memory
```
(Your switch SSH session will drop and reconnect at `10.224.11.3`. Alternatively, drop the VLAN-11 SVI and
manage the switch via its VLAN-10 mgmt `10.224.10.4` once inter-VLAN routing via the ASA is confirmed.)

## Step 2 — Map the production cabling
From the photos + diagram, write down, for **each** ASA, which data ports (`Gi0/0`, `Gi0/1`, `Gi0/2`, …) go
to which **switch** ports (which stack member + port). Confirm whether the design is:
- one port-channel per ASA (Active-Po and Standby-Po, both trunking the same VLANs), cross-stack or not; and
- whether the `TMP_ASA_LINK` (`Gi1/1/2`+`Gi2/1/2`) is a stopgap that should be retired once proper cabling
  is restored.

## Step 3 — Build the switch-side port-channel for the STANDBY ASA (non-disruptive)
Adding the standby's uplink does **not** touch the Active's path, so this is safe while live. On the switch,
create a new port-channel (e.g. `Po2`, "ASA-2-STANDBY") on the designated standby ports, matching the Active's:
```
configure terminal
interface Port-channel2
 description ASA-2-STANDBY
 switchport mode trunk
 switchport trunk allowed vlan 2,3,10-13,20,21,30
interface range <standby ASA's switch ports>
 switchport mode trunk
 switchport trunk allowed vlan 2,3,10-13,20,21,30
 channel-group 2 mode active        ! match the ASA Po1 LACP mode confirmed in prereq 2
end
write memory
```
Then **connect the standby ASA's data cables** to those switch ports. Verify:
- Switch: `show etherchannel 2 summary` → `Po2(SU)` with members `(P)` bundled.
- Standby ASA: `show failover` → the data interfaces move from `No Link` to monitored/up on the standby;
  `This host: Secondary – Standby Ready` stays green. (`show interface ip brief` shows the subinterfaces up.)

## Step 4 — (Optional) stateful link + DHCP check
- Connect the stateful link **`Gi1/3` ↔ `Gi1/3`** (statelink) for stateful failover; `show failover` should
  show the stateful link `up` and state replication counters moving.
- Verify DHCP works (the "No memory for DHCP" replication warnings were judged cosmetic — confirm a client
  on inside/telephony still gets a lease).

## Step 5 — (Optional, careful) retire the TMP link / restore the Active's proper cabling
The Active is currently on the temporary `Gi1/1/2`+`Gi2/1/2` link. To restore the full production topology
without downtime: once the Standby is fully functional (Step 3 verified), do a **controlled failover** so the
Standby becomes Active, then re-cable the now-standby (old Active) onto its proper production switch ports,
and retire the `TMP_ASA_LINK`. A failover needs the **Active** unit (`failover active` from its CLI) — which
needs live-Primary admin, or is triggered from the Secondary with `failover active` once we're confident.
**Do this in a maintenance window** — a failover briefly interrupts stateful sessions if the stateful link
isn't up. Not required for basic redundancy; sequence it deliberately.

## Step 6 — Then OI-8 (external calls)
With the ASA pair fully redundant, tackle external calls: new provider's SIP signaling/media IP ranges
(WebMate ticket **T02530-15072026**) + the **ASA inbound SIP (UDP 5060)/RTP rule** off the old provider IP
(`93.95.124.106`), and check the SIP ALG (`inspect sip`). Config goes on the **Active** unit (replicates to
standby). Needs live-Primary admin or a controlled failover to the Secondary first.

## Rollback / safety
- The failover **folink cable** stays connected throughout — pulling it reverts to today's safe state
  (Secondary goes Active-isolated with data unplugged = harmless).
- Any bad switch port-channel for the standby: `no` the `channel-group`/`interface Port-channel2` and
  unplug the standby data cables — the Active path is untouched.
- Never configure the pair from the Standby in a way that would be lost on the next active→standby sync;
  make pair-wide changes on the Active.
