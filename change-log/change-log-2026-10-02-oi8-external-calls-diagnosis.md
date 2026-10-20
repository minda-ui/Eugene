# Change log — 2026-10-02 — OI-8 external calls: ROOT CAUSE found + provider IPs in hand; fix drafted (apply blocked on live-ASA access, OI-15)

_Session change-log entry (same day, continuation of the ASA workstream, after OI-14). **Guide-only: Minda
at the ASA console + FusionPBX/email; Eugene guided and verified — all ASA work this entry was read-only.**
No credential held by Eugene._

## Headline
Diagnosed OI-8 (external calls down since 2026-09-17) to a **confirmed root cause**, obtained the **new
provider's whitelist IPs**, and drafted the exact ASA fix (`Runbooks/Runbook-ASA-SIP-Trunk-External-Calls-OI8.md`).
**Not applied** — applying needs config on the **live (Primary) ASA**, which is still contractor-held
(raised as **OI-15**). Next: apply via a controlled failover (planned).

## Diagnosis (read-only on the Standby ASA — has the full synced production config)
Ruled out every earlier theory and found the real cause:
- **`show run | include 93.95.124.106` → empty.** The old provider IP is **not referenced anywhere** in the
  ASA — the long-standing "ASA inbound rule locked to the old provider IP" theory is **wrong**.
- **`show run | include sip` → only `timeout sip …`; no `inspect sip`.** The **SIP ALG is already disabled**
  (good practice) — not the culprit.
- **`show run nat` → no inbound static NAT for the PBX (`10.224.13.9`) / port 5060 anywhere.** Telephony NATs
  **outbound only** (`nat (telephony,outside_bt/sl/fttb) source dynamic telephony_nat_allowed interface`).
- **Conclusion: registration-based SIP trunk.** The PBX registers *out* via PAT (hence `REGED` + working
  internal calls), but the provider's inbound signaling/media have **no static path in** → dropped → **zero
  CDR**. (Also noted: a leftover `object network tmp_hack` dynamic NAT on mgmt/StarLink — flag for cleanup,
  unrelated.)

## Provider whitelist (WebMate / SIP Trunk Solutions, ticket T02530-15072026, reply from Lewis Camps 2026-10-02)
Public infra IPs to permit inbound (not secrets):
| Purpose | IP | Ports |
|---|---|---|
| SIP signaling | `52.28.7.189` | UDP 5060 |
| RTP / audio | `46.31.171.144` | UDP 20000–50000 |
| RTP / audio | `185.109.104.11` | UDP 20000–50000 |
(Minda retrieved these from the ticket herself — Eugene is not an email agent, charter §1.)

## Fix (drafted, in the runbook — NOT applied)
On the Active ASA, BT WAN (`outside_bt` = 81.143.32.194, the trunk's public side — confirm before applying):
object-group of the 3 provider IPs; **static PAT** `outside_bt:5060/udp ↔ 10.224.13.9:5060`; **inbound ACL**
permitting those IPs → `10.224.13.9` on UDP 5060 + 20000–50000. Plus a **FusionPBX** check that it advertises
the public IP for NAT (`external_sip_ip`/`external_rtp_ip`) so audio flows. Full config + verify + rollback in
`Runbooks/Runbook-ASA-SIP-Trunk-External-Calls-OI8.md`.

## The blocker — OI-15 (live-ASA access)
The fix must be configured on the **Active** unit. We have **read-only Standby** access only; the live
**Primary**'s admin password is still contractor-held (the original OI-8 gap, now its own standing issue
**OI-15**). The only ways in, both disruptive: **A** controlled failover (make the Standby active from our
enable session — brief all-traffic blip, no stateful link; revert with `no failover active`), or **B**
password-recover the Primary via console (reboot → outage). To be done in a planned window.

## State left
- OI-8: **root cause confirmed + provider IPs obtained + fix drafted**; apply pending (OI-15).
- No live changes made this entry — ASA investigation was entirely read-only; live Primary untouched.
