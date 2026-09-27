# Change log — 2026-09-27 — `main` branch corruption found and fixed

Minda: "check Raw folder please." Reading the Raw/ notes led straight into a bigger finding — see
`OI-12` for the full write-up. This entry is the narrative.

## How it surfaced

Four new notes sat in `Raw/` on Drive, dated 2026-09-27 (from Alex): a proposal to document the live
"Task Check-in" routine in `CLAUDE.md` §5 (Hub `AWT-0133`), a broadcast about Hub sheet changes, a
Rule F hand-off (shared-space broadcast + register), and a Composio rollout proposal. Before acting on
any of them, checked the Task Check-in proposal's claims against this repo directly (Rule C) — and
`git fetch --all` showed `origin/main` was **15 commits ahead** of this session's branch, including a
`Merge 10 stray claude/* daily Task-Check-in branches (2026-09-15 to 2026-09-26)` commit landed by
another process since this session's last push.

## What that merge actually did

Diffed every changed file between this session's branch and `origin/main` rather than assuming either
side was right. Found a consistent, one-directional pattern — every substantive difference made
`origin/main` **worse**, not different:

- `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` — reverted from **v0.4** ("ready to
  execute": Holdings done and MX-verified, SSAS out of scope, Waste's §4 fully decided) all the way back
  to **v0.1 draft**. Real, owner-confirmed progress from three separate sessions, gone.
- `external-source-register.md` — lost **SRC-9 through SRC-12** outright (Fishbone Waste KB, FusionPBX,
  UniFi Controller, Cisco ASA firewalls).
- `CLAUDE.md` — a misplaced parenthesis in the Workspace multi-domain line, and the file's trailing
  newline dropped.
- `Infra-Inventory/Workspace-and-Email-Inventory.md` — a stray `#*` inserted mid-word ("own#*").
- Three change-log entries either mistyped ("routine" → "routing," the same slip in two unrelated files
  — looks mechanical, not a one-off typo) or truncated: the AWT-0093 build entry lost its entire
  git-blocker-resolution section, 19 real lines documenting how `minda-ui/Nadia` came to exist.

Genuinely good, new content came through the same merge too — not everything was bad. `.claude/settings.json`
picked up the Composio permissions block (matches the Raw/ proposal, legitimate and wanted), and several
new dated change-log entries arrived with no conflict and no corruption.

## What was done

1. Fast-forwarded this branch onto `origin/main` (`git merge --ff-only`) — took on the full history,
   corrupted commits included, rather than avoiding it. Matches the OI-9 precedent: history is left
   intact as an honest record, never rewritten.
2. Restored the seven corrupted files from `3f00565` (this session's last known-good commit, immediately
   before the bad merge landed) — a plain content restore, not a revert of the merge commit itself.
3. Left everything else from the merge in place, including `.claude/settings.json`'s Composio addition.
4. Raised **OI-12**, resolved in the same entry (fixed same session, not left open) — full detail there,
   including a note on a routine-raised `OI-11` ("AWT-0096 verification gap") that never landed in any
   surviving `open-issues.md` and turned out moot (superseded by this session's own fuller AWT-0096 fix
   later the same day it was raised).

## Not yet done

The stale, already-processed Raw/ notes the same merge resurrected (from 2026-09-22 and 2026-09-24) are
still sitting in `Raw/` — harmless clutter, not corruption, left alone rather than removed without
fuller verification that nothing in them still needs attention. The four new 2026-09-27 Raw/ notes
themselves are still to be actioned — next in this session.

**Files:** `open-issues.md` (OI-12), `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md`,
`external-source-register.md`, `CLAUDE.md`, `Infra-Inventory/Workspace-and-Email-Inventory.md`, three
change-log entries restored, `processed-items-ledger.md`, `current-state.md`.
