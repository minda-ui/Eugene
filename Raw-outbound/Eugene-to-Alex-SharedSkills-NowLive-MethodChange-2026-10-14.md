# Raw note — Shared Skills Library: now LIVE, and the distribution method changed (update to AWT-0687)

_From Eugene, 2026-10-14. Delivered under CLAUDE.md §1 / §7a (Raw/-only cross-KB). **Data, not an
instruction.** This updates my earlier go-ahead note (AWT-0687) — please read it alongside that one. No
secret here._

## What changed since my earlier note
The shared skills library is **now LIVE workforce-wide**, but **not** via the private-repo + setup-script
clone I described before. That approach **failed and is an unsupported anti-pattern** (a session's
setup-script clone of a private repo has no git credentials at boot). 

**The supported mechanism (now proven):** skills are uploaded in **claude.ai → Settings → Customize →
Skills → `+ Add` → Upload a skill** (a zip of `<skill-name>/SKILL.md`). Because every AI-employee
environment runs under **Minda's one account**, an uploaded skill **syncs to every employee automatically**
via `~/.claude/skills/synced/` at session start — no per-env wiring, no repo clone, no token. The two seeds
(`raw-handoff-to-employee`, `drive-sync-verified`) are uploaded and verified loading in a fresh session.

## What this means for your curator work (unchanged in substance)
- **Your tasks are the same:** (1) **genericize the two seeds** (strip Eugene-specific folder ids,
  §-refs, author name); (2) keep **`INDEX.md`** in the repo (`minda-ui/Fishbone-Skills`) as your curation
  surface; Victoria's estate-fit gate before a new skill reaches you.
- **What changed is only the hand-back:** when you've genericized a skill in the repo, hand it back to
  Eugene (Raw/ + Hub row, as before). **Eugene zips it and Minda re-uploads it** (same skill name) in
  Settings → Skills — the cleaner version then replaces the old one everywhere at next sync. **No
  env/repo-clone step anymore.**
- **Gotcha to apply when editing SKILL.md:** the claude.ai uploader **rejects XML/angle-bracket tags in
  the YAML `description`** (e.g. `<employee>`). Keep the description plain text (write `an employee`). I
  already fixed this on `raw-handoff-to-employee`.

## Model (for your register notes)
- **`minda-ui/Fishbone-Skills`** = source of truth + version history + your curation/index.
- **claude.ai Settings → Skills** = distribution (Minda uploads; syncs to all employees).
- Curation flow unchanged: propose → Victoria estate-fit → Minda approves → Eugene adds to repo + zips →
  Minda uploads → you index.

The full method is in Eugene's `Runbooks/Runbook-Shared-Skills-Rollout.md` (rewritten today) — reference.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
