# Change log — 2026-10-04 — R&D pool + "Creative mode" trigger built (Minda's idea)

_Eugene's own KB/infra build, within §2b/§3 remit. settings.json + charter edits done with Minda's
explicit authorization ("Build it now"). No live-system change; safety boundary deliberately unchanged._

## Headline
Minda: "can we create R&D pool… when I tell you 'Creative mode' it will trigger our R&D world." Built it:
a **creative/R&D pool** (`R&D/`) plus a reliable **"Creative mode" trigger** (a `UserPromptSubmit`
hook). Scope: **Eugene's own, to start.** Decisions taken via AskUserQuestion: Eugene-only; build now;
trigger words "Creative mode" / "Normal mode".

## What was built
- **`R&D/README.md`** — what the pool is, how Creative mode works, the folder map, the graduation flow,
  and the hard safety line.
- **`R&D/ideas-log.md`** — `RND-<n>` rows, status `spark→exploring→prototyped→graduated/parked/dropped`
  (seeded RND-1 = the pool itself).
- **`R&D/graduation-register.md`** — ideas that became real + Minda's approval.
- **`.claude/hooks/creative-mode.sh`** — `UserPromptSubmit` hook: "Creative mode" / "R&D mode" injects
  the R&D posture; "Normal mode" / "exit creative" returns to standard. Plain-stdout style, matches
  `end-of-day.sh`; never blocks a message (exit 0). Tested enter/exit/no-match/empty — all correct.
- **`.claude/settings.json`** — registered the hook as a second `UserPromptSubmit` entry (alongside
  end-of-day). JSON validated; 2 entries.
- **`CLAUDE.md` §5** + **`Charter-History.md`** — recorded the capability.

## The safety invariant (explicit, by design)
Creative mode loosens **scope and formality only** — bolder ideas, quick prototypes, work kept in `R&D/`
and out of the control files until it graduates. **§3 is unchanged:** no live-system changes, never hold
secrets, archive-never-trash, cross-KB only via `Raw/`, anything irreversible flagged for a human. Stated
in the hook output, the README and the charter note so it can't drift. Ideas become real only on Minda's
approval.

## Notes
- The `.claude/settings.json` and `CLAUDE.md` edits (usually self-modification-flagged) went through this
  time on Minda's explicit "build it now" authorization.
- Git is the primary home for `R&D/`; a Drive `R&D/` mirror was created and the three files synced.

## State left
Live from the next session (hooks load from the repo on `main`; on this branch they're active now).
Open from before unchanged: OI-8 audio (RTP) + ASA `write memory`; Telegram evidence-archive (parked,
research); `main` consolidation.
