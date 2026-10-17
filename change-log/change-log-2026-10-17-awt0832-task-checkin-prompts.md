# Change log — 2026-10-17 (late) — AWT-0832: Task Check-in prompts for Eugene + Helen

_Guide-only (charter §3): Eugene assembled the prompts only; Minda pastes them + sets the cron and
notifications in the routines form after approving the standard; Eugene changed no routine. No secret held._

## What
AWT-0832 (Eugene; Requested by Victoria for Minda; due Fri 23 Oct): assemble the paste-ready Task Check-in
prompts for **Eugene + Helen** from Victoria's draft standard (`2026-10-17_Draft_Task-Check-in-Standard_
v0.md`, Hub AWT-0831) for the new cadence Minda set — **four runs/day, every day of the week** ("All days
please"). Pilot = the two seats that already have a check-in; Rachel/Anna/Nadia/Darius follow.

## Done
- Read the current routines live: **Eugene** `trig_01Q6nS5UKzQFRfGsQnQLKiQX` = `30 9 * * 1-5`; **Helen**
  `trig_01AJ2vd3rxuishiThgSJ38sT` = `0 10 * * 1-5` (once per weekday) — and reported what each does.
- Wrote **whole** paste-ready prompts (current prompt + standard, not a delta) for both seats, keeping
  each seat's charter limit (Eugene guide-only on live systems; Helen draft-only outward).
- **Cron** (every day, DOW `*`, staggered to avoid concurrent Hub writes):
  | Seat | BST (until Sat 24 Oct) | GMT (from Sun 25 Oct) |
  |---|---|---|
  | Eugene | `5 7,10,13,16 * * *` | `5 8,11,14,17 * * *` |
  | Helen | `15 7,10,13,16 * * *` | `15 8,11,14,17 * * *` |
- Flagged **7 safety/clarity points** on the standard (full list in the runbook). The material ones:
  1. **Filter can silently miss rows** — `get_sheet_summary` ignored a filter I passed today and returned
     a low-numbered sample (`filtersApplied: None`). A check-in could then log a false "nothing pending".
     Both prompts now **verify `metadata.filtersApplied` and fail safe** instead of trusting an empty read.
  2. **"Never find_in_sheet" breaks max-Task-ID lookup** — sampling gives the wrong max; added a carve-out
     to use `find_in_sheet` on the Task ID column for new-row allocation (as `raw-handoff-to-employee` does).
  3. **Notification spam** — 4×/day × 7 × 2 seats ≈ 56 completion pushes/wk; recommend push OFF/email-only.
  4. **"Don't log empty runs"** is a change from today's log-every-run; adopted, noted.
  5. **Weekends** need no extra rule beyond the existing "nothing outward/money/sharing" boundary.

## Filed + handed off
- Runbook `Runbooks/Runbook-Task-Checkin-Prompts-Eugene-Helen-AWT-0832.md` (committed + Drive-synced).
- **Copied to Victoria's Raw/** (`1rzRlNRLdg-qZnXU4MTHCnn3H2b1Z5L6G`; file
  `1jJuvClxNAFAb7iBwnBk7mUyTPx_IuQdP`). No new Hub row.
- **Hub AWT-0832 → Done** (own-row), 6 days ahead of the 23 Oct due date.

## Next (not Eugene's to do)
Minda approves the standard (AWT-0831), then pastes the two prompts + cron + sets notifications in the
routines form; Alex refreshes the Roster's Routines/Last-run/Next-run cells once pasted. Measure the pilot
week's run cost before rolling to Rachel/Anna/Nadia/Darius.

Ledger 124.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
