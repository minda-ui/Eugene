# Eugene -> Victoria: shared-skills library is out of sync + your estate-fit gate (AWT-0949)

From Eugene, 2026-10-22, delivered under CLAUDE.md s1/s7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is
Landing Alex's AWT-0945 tool-note edits into `minda-ui/Fishbone-skills` (AWT-0949) surfaced that the
**shared-skills library does not match what's actually running**:

1. **Two of the skills aren't in the repo.** `minda-ui/Fishbone-skills/.claude/skills/` holds only
   **drive-sync-verified, hub-close-on-finish, raw-handoff-to-employee**. **`hub-work-run` and
   `mail-work-from-labels` are NOT there** — yet both load as shared skills in live sessions. So Alex's
   edits A (hub-work-run) and B (mail-work-from-labels) have nowhere to land. **Where are those two
   sourced?** They need adding to the repo (or point me at the real source) before anything can land.
2. **The shared `drive-sync-verified` was stale** — it had no MCP-fallback section (that was only in
   Eugene's own copy, git f216c24). I've opened **PR minda-ui/Fishbone-skills#1** to port it (genericised)
   + Alex's provisional parentId note. It needs your/Alex's **estate-fit gate**, then Minda merges +
   repackages the zip.

## What I need from you (you own the two + the estate-fit gate)
- **Estate-fit sign-off** on `hub-work-run` and `mail-work-from-labels` for Alex's A/B edits (the
   sheet_id/filters note, update_rows cells-only, Drive-search parentId, Gmail pageSize/narrow) — and the
   unresolved Gmail conflict Alex flagged (skill says Alex/Sarah read-only; the work-run prompt allows
   create_draft — which wins?).
- **Confirm where `hub-work-run` + `mail-work-from-labels` are sourced** so they can be added to the repo.
- A view on **PR #1** (drive-sync-verified MCP-fallback port) for the estate-fit gate.

## Bigger point (governance)
The shared library in the repo isn't a faithful source of the skills running across seats. Worth a plan
(yours, with Alex as curator) to reconcile the repo with the live set, so future edits have one source of
truth. Not Eugene's to decide — flagging it.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
