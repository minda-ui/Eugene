# Change log — 2026-10-02 (evening) — OI-8 apply: external-call SIGNALING restored (calls ring + connect); audio (RTP) the one piece left. Rachel Dext task raised (blocked on session scope).

_Session change-log entry (continuation of the ASA/OI-8 workstream). **Guide-only: Minda at the ASA console
+ FusionPBX GUI; Eugene guided and verified.** No credential held by Eugene. **The OI-8 fix was applied by a
controlled failover to the Secondary** (we hold enable on it), the live firewall briefly blipped and
recovered. Resume point for tomorrow is captured at the end._

## Headline
Applied the OI-8 SIP-trunk inbound fix on the ASA + FusionPBX. **Inbound external calls now RING and
CONNECT** — the "zero CDR / nothing" problem is **solved** at the signaling level. **Audio (RTP media) is
the one remaining piece.** Config is live but **not yet `write memory`'d** (reminder left with Minda).

## How config access was obtained (OI-15)
We only have read-only on the live Primary, so to configure the pair Minda ran **`failover active`** on the
**Secondary** (from her enable session): Secondary → **Active** (`fishbone-asa/sec/act#`), Primary →
Standby. One brief all-traffic blip, recovered cleanly (internet + internal phones confirmed back). Safety
net taken first: `write memory` + `copy running-config disk0:asa-pre-oi8-2026-10-02.cfg`.
**Revert if ever needed:** `no failover active` hands Active back to the Primary.

## Diagnosis settled (all read-only, this session)
- `show run | include 93.95.124.106` → **empty** (old-IP-filter theory dead).
- `inspect sip` → **not present** (SIP ALG already off).
- `show run nat` → **no inbound static NAT for the PBX** (`10.224.13.9`); telephony NATs outbound only →
  **registration-based trunk**, no inbound path = zero CDR.
- Inbound WAN ACLs (`ACL_FTTB_IN`, `ACL_BT_IN`, …) **end with `permit ip any any`** → wide open at the ACL
  level, so the ACL was never the blocker; NAT alone gates inbound. **(Security note: these WANs aren't
  filtered inbound — flag for a future hardening pass.)**
- Default route: **FTTB primary** (`62.105.119.118`, metric 9) → BT (metric 10) → SL/VF (private gw, CGNAT,
  can't host the trunk).
- **FusionPBX external profile listens on port 5080** (internal is 5060) — critical: the NAT must translate
  the provider's 5060 ↔ the PBX's 5080.
- Provider (WebMate, ticket T02530-15072026): **SIP `52.28.7.189:5060`; RTP `46.31.171.144` +
  `185.109.104.11` UDP 20000–50000.**

## What was applied
**ASA (on the now-Active Secondary):**
```
object network PBX-SIP-FTTB
 host 10.224.13.9
 nat (telephony,outside_fttb) static interface service udp 5080 5060
object network PBX-SIP-BT
 host 10.224.13.9
 nat (telephony,outside_bt) static interface service udp 5080 5060
```
→ `show xlate` confirmed: `10.224.13.9:5080 ↔ outside_fttb:62.105.119.118:5060` and `↔ outside_bt:81.143.32.194:5060`.
So **public:5060 ↔ PBX:5080**, both WANs. (No ACL change needed — already `permit ip any any`.) **Not yet
saved with `write memory`.**

**FusionPBX (Variables → restart external profile):**
- `external_rtp_ip` = **`62.105.119.118`** (public FTTB) — so SDP advertises a reachable media IP (for audio).
- `external_sip_ip` = **`$${local_ip_v4}`** (private) — see "lesson" below.
- `WebMate-SIPTrunk` gateway = **`REGED`**; only one gateway configured (healthy).

## Test results
1. **First test (static PAT just applied; external profile still effectively private):** the DDI **rang the
   handset and connected** — inbound signaling works. **No audio (silence)** — RTP not traversing.
2. Set **both** `external_rtp_ip` + `external_sip_ip` to the public IP and reloaded → the Contact became
   `62.105.119.118:5080`; the provider then sent INVITEs to **:5080**, which our **:5060** PAT doesn't catch
   → **calls stopped ringing** (handset silent, caller hears provider ringback).
3. **Reverted `external_sip_ip` to `$${local_ip_v4}` (private), kept `external_rtp_ip` public, reloaded;
   `REGED`.** **The call test after this last change was NOT reported back** (we switched to another task) —
   so the current combo's ring/audio result is **unconfirmed; re-test first thing tomorrow.**

## Lessons (for the SIP-trunk runbook)
- The PBX external profile is on **5080**, so the static PAT must be a **port-translating** `5080↔5060`, not
  `5060↔5060`.
- Setting `external_sip_ip` to the **public** IP makes the SIP **Contact** advertise `public:5080`; the
  provider then honours it and sends to **:5080**, bypassing a `:5060`-only PAT → calls stop ringing. Keep
  `external_sip_ip` **private** (provider falls back to the REGISTER source `:5060`, which our PAT catches)
  **while keeping `external_rtp_ip` public** for audio — that's the current config.
- Capture by **destination port**, not source IP — the provider's INVITE/registration come from different
  servers than the `52.28.7.189` call IP.

## RESUME POINT (tomorrow)
Current config: **ASA static PAT `public:5060 ↔ PBX:5080` (FTTB+BT); FusionPBX `ext_rtp_ip`=public,
`ext_sip_ip`=private; trunk REGED; Secondary is ACTIVE (failed over); config NOT yet `write memory`'d.**
1. **Re-test an inbound call** — confirm it rings (expected) and check audio.
2. **If audio still missing → RTP work:** capture inbound RTP from `46.31.171.144`/`185.109.104.11` during a
   connected call (by dst port, on outside_fttb); confirm whether inbound RTP arrives and whether the ASA
   preserves the RTP port. The robust fix if PAT doesn't deliver media is a **1:1 static NAT** for the PBX on
   a **spare public IP** — so first establish whether the FTTB leased line has a /29 with spare IPs
   (check `show run interface` for the `outside_fttb` mask, or ask the ISP).
3. **`write memory`** to persist (asked Minda to do tonight regardless).
4. Decide: leave Secondary Active (fine, redundant) or `no failover active` to return the Primary to Active.
5. Then OI-8 → Resolved.

## Also raised this session — Rachel (blocked here, teed up for a Rachel-scoped session)
Minda asked (direct instruction) to **let Rachel send/forward invoices + receipts to Dext**
(`mindaugas.gaudiesius@dext.cc`, the Dext→QuickBooks inbound address) — a legitimate bookkeeping duty. Also
relayed from Rachel: her `GMAIL_DELETE_*` deny is too broad and blocks deleting her own replaced **drafts**
(Amendment 37). **Plan (robust):** a **PreToolUse hook** in `minda-ui/Rachel` that permits Gmail
send/forward **only** to the Dext address and blocks every other recipient, plus narrowing the
`GMAIL_DELETE_*` deny to the four specific ops (FILTER/LABEL/MESSAGE/THREAD) so `DELETE_DRAFT` is allowed —
delivered as a **PR for Minda to merge**. **Blocked this session:** `add_repo minda-ui/Rachel` was refused
by the auto-mode classifier (repos are fixed at session start; this one is scoped to `minda-ui/eugene`).
**Do it in a session started with `minda-ui/Rachel` in scope** (tomorrow, alongside telephony). Tracked as
**OI-16**. Eugene is not an email agent and holds no credential — this is infra config only, per §2b.
