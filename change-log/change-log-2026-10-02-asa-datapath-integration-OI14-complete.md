# Change log — 2026-10-02 — ASA data-path integration COMPLETE (OI-14): standby fully in service, pair now truly redundant

_Session change-log entry (same day, continuation of the ASA workstream — follows
`change-log-2026-10-02-asa-failover-pair-rejoined.md`). **Guide-only: Minda at the ASA console + switch
SSH; Eugene guided and verified.** No credential held by Eugene. **The live Primary ASA was never
disrupted** — its `Po1` stayed solid throughout._

## Headline
**OI-14 resolved.** The HQ ASA **Standby's data path** was brought into service: a new switch-side
port-channel was built for it, the switch VLAN-11 SVI was re-IP'd to free the ASA standby address, and the
standby's two data cables were connected and bundled — **with zero disruption to the live Primary.** The
firewall is now a **fully-redundant active/standby pair**, each unit homed to **both** switches (survives a
failure of either ASA *or* either switch).

## What was done (in order)
1. **Gathered the ASA data-uplink facts** (read-only, Standby console): `Port-channel1` "uplink to catalyst";
   members **`Gi0/0` + `Gi0/1`**, each `channel-group 1 mode active` (LACP); **`Gi0/2` is `shutdown`**
   (unused 3rd port — a 2-link design).
2. **Confirmed the production switch ports** (Minda): active ASA is on **G2** of each switch
   (`Gi1/1/2`+`Gi2/1/2` = switch `Po1`); standby goes to **G3** of each switch (`Te1/1/3`+`Te2/1/3` —
   uplink-module port 3, which carry **1G copper SFPs**, so named `Te` but run at 1G). Verified both G3
   ports were `notconnect` (free) via `show interfaces status | include /1/`.
3. **Re-IP'd the switch VLAN-11 SVI** `10.224.11.2 → 10.224.11.3` (after confirming `.3` free, ping 0/5) to
   free `10.224.11.2` for the ASA **inside standby** IP. Reconnected switch SSH at `10.224.11.3`,
   `write memory`.
4. **Built switch `Po2` (ASA-2-STANDBY)** on `Te1/1/3`+`Te2/1/3`:
   ```
   interface Port-channel2
    description ASA-2-STANDBY
    switchport trunk allowed vlan 2,3,10-13,20,21,30
    switchport mode trunk
   interface range TenGigabitEthernet1/1/3, TenGigabitEthernet2/1/3
    switchport trunk allowed vlan 2,3,10-13,20,21,30
    switchport mode trunk
    channel-group 2 mode active
   ```
   `write memory`. (Ports empty → non-disruptive to the live `Po1`.)
5. **Connected the standby's data cables ONE AT A TIME, watching `Po1`:**
   - Cable 1 → switch 1 `Te1/1/3`: `Po2(SU) Te1/1/3(P) Te2/1/3(D)` — bundled, **and live `Po1` never
     flinched** (the big risk — an LACP identity clash between the two ASAs — did not happen; they form
     clean separate port-channels).
   - Cable 2 → switch 2 `Te2/1/3`: **`Po2(SU) Te1/1/3(P) Te2/1/3(P)`** — both links bundled.

## Verified end state
- Switch: `Po1(SU) Gi1/1/2(P) Gi2/1/2(P)` (active, untouched) · **`Po2(SU) Te1/1/3(P) Te2/1/3(P)`** (standby,
  new) · `Po4(SU)` (server).
- ASA `show failover`: **`This host: Secondary – Standby Ready`**, **`Other host: Primary – Active`**
  (active ~23h), **all data interfaces `Normal`** on both units (inside, cctv, telephony, wifi, guest, dmz,
  WANs), versions `9.1(7)32` both, folink up. (`management: No Link` = OOB port not cabled, expected.)

## Topology now (production-correct, symmetric)
| Unit | ASA ports | → Switch ports | Switch Po |
|---|---|---|---|
| **Active (Primary)** | Gi0/0, Gi0/1 | `Gi1/1/2` (sw1) + `Gi2/1/2` (sw2) = **G2** | `Po1` (ASA-1) |
| **Standby (Secondary)** | Gi0/0, Gi0/1 | `Te1/1/3` (sw1) + `Te2/1/3` (sw2) = **G3** | `Po2` (ASA-2-STANDBY) |

Each ASA is dual-homed across the stack. Gi0/2 on each ASA is `shutdown` (spare).

## Follow-ups (optional, not blocking — pair is fully redundant without them)
1. **Stateful link** — `statelink Gi1/3` (10.224.0.248/30) is still down. Connecting a cable between the two
   ASAs' `Gi1/3` ports adds **stateful** failover (existing calls/sessions survive a failover instead of
   briefly dropping). **Left as a follow-up** (per Minda) — needs the stateful cable; basic failover already
   works.
2. **Label tidy-up** — the active's `Gi1/1/2`/`Gi2/1/2` are still labelled `TMP_ASA_LINK` although they're now
   the correct production ports; a one-line `description ASA-1` rename would make the switch config read
   clean. Cosmetic.
3. **Controlled-failover test** — proving the standby takes over is best done in a maintenance window (a
   failover briefly drops sessions while the stateful link is absent). Not required.

## Next
With the ASA pair fully redundant, **OI-8 (external calls)** is the next target: the new provider's SIP
signaling/media IP ranges (WebMate ticket T02530-15072026) + the **ASA inbound SIP (UDP 5060)/RTP rule** off
the old provider IP (`93.95.124.106`), checking the SIP ALG (`inspect sip`). Config goes on the **Active**
unit (replicates to standby) — needs live-Primary admin or a controlled failover to the Secondary first
(OI-8's standing blocker).
