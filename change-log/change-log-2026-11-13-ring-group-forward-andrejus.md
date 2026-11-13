# 2026-11-13 — HQ office calls forwarded to Andrejus's mobile

**Session:** attended, Minda (guide-only; Minda made every change in FusionPBX).

## Result
Office number 01916052945 (ring group **Boss**, ext 1001, members 1001+1002) forwards to Andrejus's mobile. **Works** (tested 13 Nov ~11:05).

## What fixed it
| Setting (Applications → Ring Groups → Boss) | Value |
|---|---|
| Ring Group Forward | Enabled → Andrejus's mobile in +44 form |
| **Caller ID Number** | **441916052945** (no "+") |
| Caller ID Name | Fishbone |

## Why it failed first (log 10:50:42)
- The ring-group forward ran, but with Caller ID Number empty it reused the **caller's** number (Minda's mobile) as caller ID.
- Outbound route Fishbone.d12 sets `effective_caller_id_number=${outbound_caller_id_number}` → WebMate answered **403** (CALL_REJECTED): anti-spoofing, a CLI we don't own. Caller heard "number not recognised".
- A forward set on the Yealink itself fails the same way. Eugene's interim theories (toll allow; extension/ring-group number clash 1001) were wrong — the log disproved them.
- Source check: FusionPBX `ring_groups/index.lua` forward block uses `ring_group_caller_id_number` when set.

## Notes
- Andrejus sees the **office number**, not the real caller (provider rule).
- To stop: Ring Group Forward → **Disabled** → Save (Caller ID fields can stay; they only affect forwarded/external legs).
- Yealink Always Forward on 1001 should be **Off**.
- Desk phone clock showed 2 Nov 18:45 — NTP to fix later.
