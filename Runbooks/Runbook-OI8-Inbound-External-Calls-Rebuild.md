# Runbook — OI-8 inbound external calls: tested rebuild (post Oct-1 restore)

**Status:** DRAFT 2026-10-10. For a **planned, off-hours** window. Guide-only: **Minda executes, Eugene
guides and verifies.** Goal: get **inbound external calls** (WebMate DDIs → desk phones) working, WITHOUT
risking internal/outbound again.

> **Why this is a runbook and not a live scramble.** On 2026-10-10 the ASA inbound fix was proven good,
> but iterating the PBX DID-rewrite dialplan **live and unvalidated** deleted `Local_Extension` and took
> internal + outbound calls down (recovered by a 9-day-old restore that cost the Oct 2–5 trunk fixes). This
> procedure applies **one change at a time, verifies each, and keeps an instant rollback** for every step.

---

## 0. Current state (confirmed 2026-10-10)
- **Internal ✓, Outbound ✓, Inbound ✗.**
- Outbound works via gateway `WebMate-SIPTrunk`, `caller-id-in-from=true` (re-applied after the restore).
- Inbound routes all present + enabled: DIDs `01916052945/946/947/948` → ext 1001/1003/1005/1006 (public).
- **What's missing for inbound** (three pieces, in order): (A) the ASA inbound NAT forward; (B) the PBX
  trunk inbound settings the restore reverted; (C) the DID **To-header → destination_number** rewrite.

## Key facts (from the 2026-10-10 live session)
- Our public FTTB IP / ASA outside_fttb interface: **`62.105.119.118`**. PBX: **`10.224.13.9`**, FusionPBX
  external profile on **UDP 5080**.
- WebMate: signalling **`52.28.7.189:5060`**; media seen at **`46.31.171.144`** / `185.109.104.11`.
- WebMate delivers inbound to **`62.105.119.118:5080`**, and puts the real DID in the SIP **To header**
  (`sip_to_user = +441916052945`) while the request/dial field carries the **trunk username** — so the DID
  routes never match until we rewrite `destination_number`. (Registration trunk.)

---

## 1. Pre-flight (do ALL of this before any change)
1. **Pick an off-hours window** (evening/weekend) — inbound testing can briefly disturb calls.
2. **Proxmox: snapshot VM 105 now** → name `pre-oi8-inbound-rebuild-<date>`. Instant rollback point.
3. **Confirm the fallbacks still work BEFORE starting:** place one **internal** call (1001↔1002) and one
   **outbound** call. Both must work. If not, STOP — fix that first (don't stack changes on a broken base).
4. **Record that `Local_Extension` exists** (Dialplan Manager, Context filter = `10.224.13.9`). It is the
   extension-to-extension bridge; **never delete or edit it.** If it's missing, STOP.
5. **ASA:** take a config backup first — `copy running-config disk0:/asa-pre-oi8-<date>.cfg`.
6. Have the **FreeSWITCH log viewer** open throughout (read-only) to watch each test call.

**Golden rule for the whole run:** we only **ADD** a dialplan and **toggle settings we can revert**. We do
**NOT** delete or edit any existing dialplan. One change → test → next.

---

## 2. Step A — ASA inbound NAT (forward :5080 to the PBX)
The 2026-10-10 fix may still be in the ASA running-config (it was never `write memory`'d; it survives
unless the ASA reloaded). **Verify, re-apply if missing, then persist.**

**A1. Check it's there (read-only):**
```
show run nat | include PBX-HOST
show run object network PBX-HOST
show run object service SVC_UDP_5080
```
Expect a Section-1 rule: `nat (outside_fttb,telephony) 1 source static any any destination static interface PBX-HOST service SVC_UDP_5080 SVC_UDP_5080`, `PBX-HOST = host 10.224.13.9`, `SVC_UDP_5080 = service udp destination eq 5080`.

**A2. If missing, re-apply** (on the Active unit; config backup already taken in pre-flight):
```
configure terminal
object network PBX-HOST
 host 10.224.13.9
object service SVC_UDP_5080
 service udp destination eq 5080
nat (outside_fttb,telephony) 1 source static any any destination static interface PBX-HOST service SVC_UDP_5080 SVC_UDP_5080
end
```

**A3. Verify (read-only, decisive — this is the ASA "proof"):**
```
packet-tracer input outside_fttb udp 52.28.7.189 5060 62.105.119.118 5080 detailed
```
Must end **Action: allow**, with a **UN-NAT** phase `Untranslate 62.105.119.118/5080 to 10.224.13.9/5080`,
output-interface `telephony`. If it shows DROP → do NOT proceed; the rule isn't right.

**A4. Persist:** `write memory` (replicates to both ASAs). **Rollback:** `no nat (outside_fttb,telephony) 1 source static any any destination static interface PBX-HOST service SVC_UDP_5080 SVC_UDP_5080` (and remove the two objects), then `write memory`.

---

## 3. Step B — FusionPBX trunk inbound settings (reverted by the restore)
All reversible settings; restart only the **external** profile (internal phones are on `internal`).

**B1. Providers ACL — allow WebMate's IP.** `Advanced → Access Controls → providers`. Ensure an entry
**`CIDR 52.28.7.189/32 = allow`** exists (the restore likely left only the old `93.95.124.106`). Add it if
missing. Then `Status → SIP Status → Flush Cache → Reload ACL` (ACL reload, not a dialplan reload).

**B2. External profile IPs.** `Advanced → SIP Profiles → external`:
- `ext-rtp-ip` → **public** `62.105.119.118` (so SDP advertises the public IP for RTP).
- `ext-sip-ip` → **private / `$${local_ip_v4}`** (NOT public — a public `ext-sip-ip` makes the Contact
  advertise `:5080` and WebMate bypasses the :5060/:5080 path → calls stop ringing; this bit us on 10-02).
- Save, then `Status → SIP Status → Restart` the **external** profile. Confirm the WebMate gateway → **REGED**.

**B3. Verify no regression:** internal + outbound still work (profile restart only touched external, but check).

**Rollback for Step B:** revert the ACL entry / profile IPs to their prior values and restart external.

---

## 4. Step C — the DID rewrite dialplan (the careful one)
**Why:** inbound `destination_number` arrives as the trunk username, so the DID routes (match `0191…`)
never fire → 404. This dialplan reads the real DID from the **To header** and rewrites `destination_number`
to national form **before** routing, so the existing routes match. **This is the step that caused the
outage — follow it exactly, validate, and keep the rollback ready.**

**C1. Snapshot VM 105 again** (`pre-did-rewrite-<date>`) — immediately before this change.

**C2. Add ONE dialplan via the detailed editor** (`Dialplan → Dialplan Manager → + Add`). Header:
- **Name:** `webmate_inbound_did`
- **Domain:** **`Global`**  ← (a domain-scoped public dialplan does NOT load for inbound — this was the bug)
- **Context:** `public`
- **Order:** `9`  (before the DID routes at 100)
- **Continue:** **`True`**  ← (so it falls through to the DID route after rewriting)
- **Enabled:** `True`

Then two grid rows (on the detail page the Type field is free-text — it accepts a variable):
| Tag | Type | Data | Inline |
|-----|------|------|--------|
| condition | `${sip_to_user}` | `^\+?44(\d{10})$` | — |
| action | `set` | `destination_number=0$1` | **true** |

Rewrites `+441916052945` → captures `1916052945` → `destination_number=01916052945`, matching the routes.

**C3. SAVE, then re-open it and VERIFY it saved correctly** (yesterday a copy saved with Domain=10.224.13.9
and Continue=False, so it never ran): confirm **Domain=Global, Context=public, Continue=True, Enabled=True**,
and the **two rows present** with the action **Inline=true**. If any is wrong, fix and re-verify. Make sure
there is **exactly one** `webmate_inbound_did` (delete any stray duplicate; `public` dialplans are hidden
from the domain-filtered list — filter Context = `public` to see them).

**C4. Apply:** `Status → SIP Status → Reload XML` (NOT Flush Cache; no profile restart needed).

**C5. VALIDATE with the log BEFORE trusting it** (this is the gate):
- Place **one** inbound call to `01916052945` from a mobile; watch the FreeSWITCH log.
- **Pass =** the log shows `destination_number` become **`01916052945`** (not the username), the call routes
  to ext **1001**, and the desk phone **rings**.
- **Immediately after, re-confirm internal still works** (1001↔1002). If internal is in any way affected →
  **disable `webmate_inbound_did` (Enabled=False) → Reload XML** and it's back; investigate before retrying.

**Rollback for Step C (instant):** set `webmate_inbound_did` **Enabled = False** → `Reload XML`. If anything
is worse, **roll back the VM 105 snapshot** `pre-did-rewrite-<date>`.

---

## 5. Step D — end-to-end verification
- Call each DID from a mobile: `01916052945→1001`, `…946→1003`, `…947→1005`, `…948→1006`. Each **rings**
  the right desk, **answer → two-way audio**. (Media: if audio is one-way, note the RTP peer
  `46.31.171.144` and we tune RTP NAT separately — but two-way RTP was already observed on 10-10, so it
  should hold.)
- Confirm CDR shows genuine inbound calls (the first since 21 July).

## 6. Persist & close
- ASA already `write memory`'d (Step A4). FusionPBX persists to its DB automatically.
- **Proxmox: snapshot VM 105** `oi8-inbound-working-<date>` as the new good baseline.
- Mark **OI-8 Resolved** only after a genuine inbound call from an external mobile rings and connects both
  ways — verified against the CDR, not just a test ring.

---

## 7. Guardrails — what NOT to do (hard lessons, 2026-10-10)
- **Never delete or edit `Local_Extension`** (or any existing dialplan). We only ADD `webmate_inbound_did`.
- **Never use `.*` in a dialplan** on a live PBX; scope to the DIDs.
- **One change at a time, verify, keep rollback.** Snapshot the VM before each dialplan change.
- A **public** dialplan must be **Domain=Global** or it won't load; it's hidden from the domain-filtered
  Dialplan Manager list (filter Context=`public`).
- A deleted default dialplan is **not** restored by a reboot or FusionPBX "App Defaults" — only a
  restore/snapshot brings it back. Hence the snapshots above.
- If anything breaks: **recovery card** — all phones "Forbidden/403": `Status → SIP Status → Flush Cache →
  Reload XML → Restart internal`; a handset won't receive: power-cycle it; worst case: **roll back the VM
  105 snapshot** taken in pre-flight / before Step C.

## 8. Related
- `change-log/change-log-2026-10-10-oi8-telephony-outage-and-recovery.md` (the honest account).
- `open-issues.md` OI-8 (this work) and **OI-17** (set up regular Proxmox backups — do this too; the
  9-day-old backup is what made the outage costly).
