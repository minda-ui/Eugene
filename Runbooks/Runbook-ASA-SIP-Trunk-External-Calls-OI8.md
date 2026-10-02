# Runbook — ASA SIP-Trunk Inbound Fix (External Calls, OI-8)

> **Status: v1.0 (2026-10-02) — diagnosed, config drafted, NOT applied.** Blocked on **config access to the
> live (Primary) ASA** (OI-15). Guide-only: Minda executes; Eugene guides/verifies (charter §3). Governs the
> apply step of **OI-8**. See `change-log/change-log-2026-10-02-oi8-external-calls-diagnosis.md`.

## Problem (confirmed 2026-10-02, read-only on the Standby ASA)
External calls produce **zero CDR** — inbound INVITEs never reach the PBX (FusionPBX, `10.224.13.9`).
Diagnosis ruled out the earlier theories and found the real cause:
- **Old provider IP `93.95.124.106` is NOT in the ASA** (the "old-IP filter" theory was wrong).
- **`inspect sip` (SIP ALG) is already disabled** (not the culprit).
- **There is NO inbound static NAT for the PBX** anywhere in the NAT table. Telephony NATs **outbound only**
  (`nat (telephony,outside_bt/sl/fttb) source dynamic telephony_nat_allowed interface`). So it's a
  **registration-based trunk** (PBX registers out via PAT — that's why it shows `REGED` and internal calls
  work), but the provider's inbound signaling/media **have no static path in** → dropped.

## Provider details (WebMate / SIP Trunk Solutions, ticket T02530-15072026, reply 2026-10-02)
IPs/ports to permit inbound (public infra IPs — not secrets):
| Purpose | IP | Ports |
|---|---|---|
| SIP signaling | `52.28.7.189` | UDP 5060 |
| RTP / audio | `46.31.171.144` | UDP 20000–50000 |
| RTP / audio | `185.109.104.11` | UDP 20000–50000 |
Registrar: `sipreg.siptrunk.solutions`. DDIs: `+441916052945`–`948`. Old provider was `93.95.124.106`.
Trunk's public side is assumed **BT `outside_bt` = 81.143.32.194** (confirm which WAN the PBX registers on
before applying — could be StarLink `outside_sl`).

## Pre-work (no outage — do these first)
1. **FusionPBX NAT check** (your GUI, `10.224.13.9`): confirm the SIP profile advertises the **public IP** for
   NAT traversal — `external_sip_ip` / `external_rtp_ip` set to the public IP (or `auto-nat`/`stun`), not the
   private `10.224.13.9`. Advanced → Variables / SIP Profiles → `external_rtp_ip`, `external_sip_ip`. If these
   already point at the BT public IP, outbound-initiated RTP pinholes + the ACL below will carry audio; if
   not, set them (and reload the profile). This is what makes **audio** work after signaling connects.
2. **Confirm the inbound ACL name** on the trunk's WAN — on the (read-only) Standby run:
   ```
   show running-config access-group
   ```
   Note the `access-group <NAME> in interface outside_bt` name — the ACL lines below append to it.

## The ASA config (apply on the ACTIVE unit)
Substitute `<OUTSIDE_BT_IN>` with the real inbound ACL name from the pre-work. On ASA 9.1 (8.3+ NAT), the
ACL destination is the **real** PBX IP (`10.224.13.9`), not the public IP.
```
! Provider IPs
object-group network OG-WEBMATE-SIPTRUNK
 network-object host 52.28.7.189
 network-object host 46.31.171.144
 network-object host 185.109.104.11

! Static PAT: BT public :5060/udp  <->  PBX 10.224.13.9:5060
object network PBX-SIP-5060
 host 10.224.13.9
 nat (telephony,outside_bt) static interface service udp 5060 5060

! Inbound permits on the BT WAN ACL (destination = real IP)
access-list <OUTSIDE_BT_IN> line 1 extended permit udp object-group OG-WEBMATE-SIPTRUNK host 10.224.13.9 eq 5060
access-list <OUTSIDE_BT_IN> line 2 extended permit udp object-group OG-WEBMATE-SIPTRUNK host 10.224.13.9 range 20000 50000
```
**RTP note:** with FusionPBX advertising the correct external IP (pre-work 1), the PBX sends RTP outbound
first (opening pinholes), and the ACL permits the provider's RTP IPs inbound — audio should flow. If audio
is one-way/absent after signaling works, the fallback is a **1:1 static NAT** for the PBX on a spare public
IP (handles all RTP ports without PAT) — only if a spare public IP is available.

## Apply — requires config access to the ACTIVE ASA (OI-15)
We have **read-only Standby** access only; the live Primary's admin password is contractor-held. Two ways
to gain config access, both disruptive:
- **A — Controlled failover (preferred, least disruptive).** From the Standby's existing enable session:
  `failover active` → the Standby becomes Active (**brief all-traffic blip — no stateful link**). Paste the
  config above (replicates to the other unit). Verify, test, `write memory`. **Revert if needed:**
  `no failover active` hands control back to the Primary.
- **B — Password-recover the Primary** (console → ROMMON) — takes the Primary down (Standby takes over =
  a failover anyway), more steps; only if A isn't acceptable.
Do either in a **planned quiet window** — it interrupts live internet + phones.

## Verify
1. `show xlate | include 5060` → the static PAT present.
2. Place an **inbound external call** to a DDI → check FusionPBX **CDR** shows the call (the key test — zero
   CDR was the symptom) and the handset rings with two-way audio.
3. Place an **outbound external call**.
4. `write memory` on the active (replicates the save).

## Rollback
- Remove the added lines (`no` each) and `clear xlate` for the static PAT; `no failover active` to return to
  the Primary as active. Config changes replicate to the standby.
