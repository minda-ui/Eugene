# Runbook — OI-8 last mile: make inbound calls RING the desk (stop the early-media pre-answer)

**Status:** DRAFT 2026-10-10. For a **planned, off-hours** window. Guide-only: **Minda executes, Eugene
guides and verifies.** Prereq: the 2026-10-10 inbound rebuild is in place (ASA NAT `write memory`'d;
`webmate_inbound_did` dialplan active; inbound reaches extension 1001). This runbook fixes the **one
remaining symptom**: the desk phone doesn't audibly ring on inbound — the call pre-answers (early media)
and goes to voicemail.

> **Do NOT iterate live.** Snapshot VM 105 before each change, make **one** change, test **one** call with
> fs_cli watching, and keep the instant rollback (revert the change → Reload XML, or snapshot rollback).
> This is the exact discipline that avoided an outage on the 2026-10-10 rebuild.

---

## 0. The symptom and the cause (confirmed 2026-10-10)
- Inbound WebMate call reaches the PBX and routes to `sofia/internal/1001`, **but the 1001 leg
  pre-answers**: FreeSWITCH log shows `Callstate Change RINGING → EARLY`, `[NOTICE] Pre-Answer
  sofia/internal/1001`, `switch_ivr_originate … Sending early media`. So the desk never rings; caller gets
  ~6 rings of ringback then voicemail.
- **Cause:** WebMate's Oracle vSBC sends **early media** on the inbound leg (183 Session Progress w/ SDP,
  likely with 100rel/PRACK). FreeSWITCH pre-answers the destination to establish the media path, which
  suppresses the normal ring.
- **Ruled out:** not the handset (internal `1002→1001` rings + two-way audio); not the inbound-route
  ringback (`local_stream://default → ${us-ring}` made no difference); not a forward (all of 1001's
  forward/follow-me/DND are disabled; the DID route transfers to plain `1001 XML`).

## 1. Pre-flight
1. Off-hours window. Confirm internal + outbound still work.
2. **Proxmox snapshot VM 105** `pre-earlymedia-fix-<date>`.
3. Have **fs_cli** ready for a clean live trace — needs OS/SSH access (**OI-18**; set that up first).
   In fs_cli: `/log info`, then `Ctrl+L` before each test call. (The web Log Viewer works too but the
   `freeswitch.log` is multi-GB and painful — set Display small + Sort Descending if you must use it.)
4. Confirm `local_extension` (global, order 890) is present. **Never delete/edit it.**

## 2. Candidate fixes — try ONE at a time, test, roll back if no good
Order of preference (least invasive first). After each: Reload XML (or restart the named profile),
place **one** inbound call from a mobile, watch fs_cli for whether `sofia/internal/1001` now goes
`RINGING` (not `Pre-Answer`/`EARLY`) and the **desk physically rings**. If no change, **revert** and move
to the next.

**C1 — Force a ringback-ready/no-pre-answer on the inbound leg (dialplan, reversible).**
In `webmate_inbound_did` (our Order-5 rule) or the DID route, before the transfer, add (one at a time):
- `set ignore_early_media=ring_ready`  (ring_ready, not `true` — makes FS send 180 and ring rather than
  pre-answer for early media), **or**
- `set sip_ignore_183nosdp=true`, **or**
- `set bypass_media=false` + `set instant_ringback=true` + `set ringback=${us-ring}`.
Reload XML → test. Revert the added line if no change.

**C2 — External profile: PRACK / 100rel (profile-level, affects the whole external profile).**
`Advanced → SIP Profiles → external`: set **`enable-100rel` = false** (currently true). This stops
PRACK, which the vSBC may be using to drive reliable early media. Save → `Status → SIP Status → Restart`
the **external** profile only → confirm gateway REGED and internal/outbound unaffected → test one inbound
call. **Revert to true** if it doesn't help or disturbs anything.
Related profile knobs to consider (one at a time): `disable-rtp-auto-adjust`, `inbound-late-negotiation`.

**C3 — Early-media / SDP handling.**
If the vSBC uses delayed-offer or 183-without-SDP, try `set sip_ignore_183nosdp=true` (C1) and/or on the
external profile `inbound-late-negotiation=true`. Test.

## 3. Verify (the gate)
- fs_cli on one inbound call shows `sofia/internal/1001` reaching **`CS_RINGING`** and **sending 180**
  (not `Pre-Answer` / `EARLY`), and the **desk handset physically rings**.
- Answer → two-way audio. Re-confirm internal + outbound still work.
- Only then keep the change.

## 4. Persist & close
- FusionPBX persists to its DB; **snapshot VM 105** `oi8-inbound-ringing-<date>`.
- Mark **OI-8 Resolved** only after a genuine external inbound call **rings the desk and connects both
  ways**, verified against the CDR (needs **OI-19** fixed first so calls are logged).

## 5. Guardrails
- One change at a time; snapshot before each; revert anything that doesn't help.
- Never delete/edit `local_extension` or any existing dialplan; we only ADD/override.
- Never `.*` on a live PBX. Recovery card if anything breaks: `Status → SIP Status → Flush Cache →
  Reload XML → Restart internal`; worst case roll back the VM snapshot.
- Restart only the **external** profile (internal phones are on `internal`).

## 6. Related
- `change-log/change-log-2026-10-10-oi8-inbound-rebuild-executed.md` (how we got here).
- `Runbooks/Runbook-OI8-Inbound-External-Calls-Rebuild.md` (the rebuild that preceded this).
- `open-issues.md`: **OI-8** (this is its last mile), **OI-18** (PBX OS/SSH access — needed for fs_cli),
  **OI-19** (CDR logging), **OI-17** (automated backups). WebMate ticket T02530-15072026 for the
  separate "other networks' calls fail before the trunk" item.
