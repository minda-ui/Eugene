# Change log — 2026-10-05 — OI-8: telephony largely RESTORED (fibre primary, internal, outbound, inbound-to-PBX); one step left (inbound ring)

_Guide-only: Minda at the ASA serial console (`fishbone-asa/sec/act#`), the Catalyst switch (`Catalyst#`, as
`recovery`) and the FusionPBX GUI. Eugene read every screenshot and guided; no credential held or written
down (the WebMate gateway password stayed masked and unrecorded; the ASA/switch `recovery` password is
Minda's, in 1Password). All live changes executed by Minda._

## Headline
A long live session turned a **dead external phone system + whole office stuck on StarLink** into:
**1Gb fibre restored as the primary WAN, internal calls, outbound calls (clean two-way audio), and inbound
calls reaching the PBX and routing to the handset — all fixed and saved (`write memory` on both switch and
ASA; FusionPBX changes persist in its DB).** The **one** remaining item is the handset not *ringing* on
inbound (WebMate's Oracle SBC early media), fixed by a single variable — deferred to Minda's night shift.

This corrects this morning's "external down both ways" entry: the real root cause was far deeper than SIP
config — the fibre WAN had been offline to the Active ASA since the 2026-10-02 failover.

## Root-cause chain (what was actually wrong)
1. **The whole office was running on StarLink (the *backup* WAN, which is CGNAT — no public inbound).**
   `show track` on the ASA: `track 1` (StarLink) **Up**, `track 4` (BT) **Down**, `track 6` (FTTB fibre)
   **Down** — both BT and fibre down for **2d22h**, i.e. since the **2026-10-02 controlled failover** to the
   recovered Secondary ASA. The ASA's SLA failover had correctly demoted the two "dead" WANs to StarLink.
2. **Why the fibre looked dead:** two leftovers from the 10-02 recovery, exactly like the VLAN-13 telephony
   gap fixed that day — but on the WAN side:
   - The **ASA-uplink trunks** (`Po1` = ASA-1 / Primary, `Po12` = ASA-2-STANDBY / **now Active**) allowed
     only VLANs `2,3,10-13,20,21,30` — **missing the WAN VLANs `4` (BT) and `6` (FTTB)**, and `5`
     (ubnt-mgmt). StarLink is VLAN 2 (in the list) → it worked; fibre/BT (4,6) were cut off from the Active ASA.
   - The **fibre circuit itself was stranded in VLAN 1**: the Daisy/Wavenet fibre router (`C1111-8P`,
     `fishbone-48316010-gw.cust.daisygroup.net`) is on switch port **`Gi2/0/46`**, left on the default VLAN 1
     during the recovery (this is **OI-13**). VLAN 6 (FTTB) had **no port** at all.
3. Because SIP egressed StarLink (CGNAT), WebMate had no reachable public address → **no inbound could ever
   arrive**, and outbound only worked as an outbound-initiated flow.
4. Even once inbound could reach us, FusionPBX's **"providers" ACL** (applied as `apply-inbound-acl` on the
   external profile) was **default-deny with only the OLD provider `93.95.124.106`** — so WebMate's INVITEs
   (from `52.28.7.189`) were rejected at the PBX.

## What was changed (all guide-only, Minda executing) — and SAVED
- **Switch (`Catalyst`):** added WAN VLANs to both ASA uplinks —
  `interface Po12 / switchport trunk allowed vlan add 4,5,6` and the same on `Po1`. Then moved the fibre
  circuit onto its VLAN: `interface Gi2/0/46 / switchport mode access / switchport access vlan 6`.
  `show interface Gi2/0/46 status` → `connected / vlan 6 / 1000`. **`write memory` done.**
- **ASA:** no new config needed here for the WAN fix (the metric-9 FTTB default route + SLA `track 6`
  recovered on their own once VLAN 6 reached the Active ASA). Earlier in the session the OI-8 object NAT was
  left at `service udp 5080 5080` on both WANs and `external_sip_ip` set public — both now consistent with
  inbound hitting `62.105.119.118:5080`. **`write memory` done.**
- **FusionPBX:**
  - `external_sip_ip` = `62.105.119.118` (public FTTB) so the trunk Contact advertises the public IP;
    external profile restarted → trunk **REGED** from the fibre.
  - **Gateway `caller-id-in-from` = True** (earlier in session) → fixed **outbound** (WebMate was 403-ing the
    default From); outbound now connects with clean two-way audio.
  - **"providers" ACL:** added **`52.28.7.189/32` (allow)** alongside the old `93.95.124.106`; Reload ACL +
    external restart. Inbound INVITEs from WebMate now pass the ACL.

## Proof it works
- **Fibre up:** `ping outside_fttb 62.105.119.117` → 4/5, 1ms; `ping outside_fttb 8.8.4.4` → 5/5, 10-20ms;
  `show track` → **track 6 Up**. **Speedtest: 561↓ / 153↑ Mbps, public IP `62.105.119.118` (Wavenet).**
  Office is on the 1Gb fibre, off StarLink.
- **Outbound:** 1001 → mobile connects, **audio both ways** (Minda confirmed).
- **Inbound reaches us:** ASA capture on `outside_fttb` during an inbound call → **581 packets
  `52.28.7.189.5060 > 62.105.119.118.5080`** (WebMate's Oracle vSBC sending our DDI calls to the fibre).
- **Inbound routes correctly:** FreeSWITCH log — call passes the ACL, matches DID `01916052945` → Destination
  `1001 Boss` ring group → originates to `sofia/internal/1001` → RTP to the handset `10.224.13.10`.

## The one thing left: inbound RING (deferred, night shift)
The handset does **not ring**. Cause (from the FS log): WebMate's **Oracle vSBC sends early media**;
FreeSWITCH goes `Callstate RINGING -> EARLY` and **pre-answers** the extension, handing it early media instead
of a ring — so the phone gets *audio*, not an *alert*, and the caller eventually cancels (`487 /
ORIGINATOR_CANCEL`). **Fix = `ignore_early_media=true` on the inbound route** (small Dialplan Manager edit).
See `Runbooks/Runbook-OI8-Inbound-Ring-and-Cleanup.md`.

## Cleanup / follow-ups (in the runbook)
- **`ignore_early_media=true`** on the inbound DID route → the handset rings. (Primary remaining step.)
- **Extension 1001 caller ID is `+441916052945` (with `+`)** — WebMate rejects the `+` on any external leg;
  change Effective/Outbound Caller ID Number to `441916052945` (no `+`).
- **Revert the DID destination** `01916052945` back to **`1001 Boss`** (it was temporarily pointed at `1002`
  for an isolation test).
- **BT backup WAN still down** — VLAN 4 has no port (`Gi1/0/46` is `notconnect`); the BT circuit isn't
  plugged in. Separate, non-urgent (fibre is primary, StarLink is reserve).
- **OI-13** (fibre modem on the WiFi-AP port `Gi2/0/46`) is now *functionally* resolved (port set to VLAN 6
  and carrying the fibre); the physical "wrong designed slot" tidy can still happen later.

## Infra facts captured (for Infra-Inventory)
- **FTTB fibre** = Wavenet/Daisy, router `C1111-8P` (`fishbone-48316010-gw.cust.daisygroup.net`), gateway
  `62.105.119.117`, our IP `62.105.119.118`, switch port **`Gi2/0/46` → VLAN 6**, ~561/153 Mbps.
- **WAN↔VLAN map:** vlan2 StarLink (`Gi1/1/1`), vlan3 Vodafone (`Gi2/1/1`), vlan4 BT (no port — unplugged),
  vlan6 FTTB (`Gi2/0/46`). ubnt-mgmt = vlan5.
- **ASA WAN defaults (SLA-tracked):** FTTB `62.105.119.117` metric **9** (primary, `track6`→`sla6` ping
  `8.8.4.4`); BT `81.143.32.198` metric 10 (`track4`→`sla4` ping `1.0.0.1`); StarLink `192.168.1.1` metric 20
  (`track1`→`sla2` ping `1.1.1.1`); Vodafone `192.168.3.1` metric 254.
- **ASA uplink port-channels:** `Po1` = ASA-1 (Primary), `Po12` = ASA-2-STANDBY (Active now); both now allow
  vlans `2-6,10-13,20,21,30`.
- **WebMate trunk:** signalling `52.28.7.189:5060`, media (RTP) `46.31.171.144` (+`185.109.104.11`), user
  `CUP4127366SIP1`, proxy/realm/from-domain `sipreg.siptrunk.solutions`, external profile :5080.
- **FusionPBX "providers" ACL:** now allows `52.28.7.189/32` + `93.95.124.106/32` (default deny).

## State
- **OI-8:** external telephony now **~95% restored** — outbound fully working; inbound reaches the PBX and
  routes to the phone; only the handset *ring* remains (`ignore_early_media`). Fibre primary; all saved.
- No credential held. Internet, internal and outbound all confirmed working at sign-off.
