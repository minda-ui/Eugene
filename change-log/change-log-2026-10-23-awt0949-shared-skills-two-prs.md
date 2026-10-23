# Change log — 2026-10-23 — AWT-0949 shared-skills landing (two PRs) + rezip/upload

## Summary
Closed **AWT-0949**: landed the shared-skills tool notes (from Alex's AWT-0945 hand-off,
Victoria's AWT-0969 estate-fit sign-off) into `minda-ui/Fishbone-skills`, got all five
skills onto `main`, and handed Minda the three rezipped skills, which she uploaded
workforce-wide via the native claude.ai Skills channel.

## The judgement call — a split across two PRs (why `main` looked wrong)
A previous session's "Merged PR1" left `main` with only 3 skills, and a `git clone` of the
just-merged private repo showed the two new baselines missing. Rather than assume a stale
clone, I verified directly against the GitHub API:

- **PR #1** (head `eugene/dsv-mcp-fallback-awt0949` @ `1a602484`, merged 2026-10-22 21:06) —
  its diff was **one file**, `drive-sync-verified/SKILL.md` (+28, the MCP-fallback section).
  That is all that was committed when Minda merged it.
- The `hub-work-run` + `mail-work-from-labels` baselines and the INDEX rows were pushed to the
  **same branch at 18:00–18:01 on 2026-10-23 — after PR #1 had already merged**. So they sat
  on the branch tip (`f392baf0`) and never reached `main`. The clone was accurate.

A merged PR cannot carry later commits, so I opened a **fresh PR #2** from the branch into
`main` — clean/mergeable, 3 files, +64: the two new skill folders (added) + 2 INDEX rows.
Minda merged it; `main` is now at `ea7c9c06` and holds all five skills
(drive-sync-verified, hub-close-on-finish, hub-work-run, mail-work-from-labels,
raw-handoff-to-employee).

## Content landed
- **drive-sync-verified** — MCP-fallback section + Alex parentId note (C1) — via PR #1.
- **hub-work-run** (new baseline, exported from the live native-upload copy) — Alex A1
  `sheet_id`/`filters`, A2 `update_rows` cells-only, A3 Drive-search section (all provisional).
- **mail-work-from-labels** (new baseline) — Alex B1 pageSize/narrow (provisional); Victoria B2
  (Gmail: "draft only where your own charter allows", not naming seats); Victoria B3 (no
  hard-coded procedure version — read the status line; live v0.5).
- **INDEX.md** — two new skill rows; last-reviewed 2026-10-23 on the three touched skills.

## Zips + upload
Built three upload zips in the session scratchpad and verified each: YAML descriptions carry no
angle-bracket/XML tags (the native upload rejects them); the drive-sync-verified SKILL.md and
scripts/sync.sh are byte-identical to `main`; each has the correct `<name>/` top-level folder.
Minda uploaded all three in claude.ai **Settings → Skills** (one account → syncs to every seat).

## Guardrails
Guide-only throughout; no secret held; no other KB edited (cross-KB only via Raw/). The GitHub
writes were to Eugene's own working repos via the managed GitHub integration (Minda merges).

## Next (not Eugene's)
Victoria drafts the library reconcile plan for the remaining live-but-unsourced skills.
