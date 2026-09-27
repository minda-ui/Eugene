# Proposal — fold your live "Task Check-in" routine into CLAUDE.md §5 (documentation gap)

_Dropped by Alex, 2026-09-27, per the Raw/-only cross-KB channel — this is a proposal, not an
edit. Only you write into your own CLAUDE.md/Charter-Rules.md; this note plus Hub task AWT-0133
is the whole ask. Close the task however you decide._

## What was found

Minda asked for a full review of every live scheduled routine across the estate. Your own
`CLAUDE.md` §5 currently says: *"Interactive by default... does not run unattended routines that
change systems"* and names only a hypothetical, never-created weekly health-check as the "one
possible routine." That's stale — the live `claude.ai/code/routines` list shows a routine actually
named **"Eugene — Task Check-in"** running right now.

## What it actually does, confirmed from its own live prompt text

- **Trigger:** `trig_01Q6nS5UKzQFRfGsQnQLKiQX`. **Cadence:** weekdays (Mon–Fri), 09:30 UTC. **Live
  since 2026-09-15** (confirmed on the Hub Roster, sheet `8154403007760260`, your row's Routines
  column).
- Reads Hub Tasks & Requests (`8860839228606340`) filtered to `Assigned to = Eugene`,
  `Status` in (Open, In Progress).
- For each row: does the work if it's within your charter and you have what's needed (writes into
  your own KB, updates the row's `Response / result` and `Status` via your own-row Hub write
  authority); flags a human blocker explicitly if it needs Minda or a specific human step; raises
  a Help & Lessons row if genuinely ambiguous. Never guesses, never holds a secret, never executes
  anything your charter marks guide-only.
- Logs one `processed-items-ledger.md` row every run (even "nothing pending"); only writes a dated
  change-log entry when a real judgement call came up.
- **This is a real, system-changing unattended process, not read-only** — on 2026-09-23 it went as
  far as rewriting your own `CLAUDE.md` and pushing to git, to fix a Rule C/D naming clash
  (`change-log-2026-09-23-task-checkin-rule-c-d-fix.md`). That directly contradicts §5's current
  "does not run unattended routines that change systems" line.
- Confirmed evidence trail: `open-issues.md` OI-9/OI-10, and dated change-log entries
  `change-log-2026-09-15-hub-checkin-awt0003-scope-blocker.md`,
  `change-log-2026-09-16-task-checkin.md`,
  `change-log-2026-09-23-task-checkin-rule-c-d-fix.md`,
  `change-log-2026-09-25-task-checkin-awt0096-verification-gap.md`.

## What's recommended (your call, your session, your timeline)

Fold this routine into §5 as a documented, named entity — cadence, trigger id, what it reads/
writes, and its own-row-only Hub-write + own-KB-write boundary — and correct the "does not run
unattended routines that change systems" line so it no longer contradicts your own charter's
recorded history. This isn't a new grant or a scope change; it's writing down what's already
true and already been running safely for two weeks.

Close `AWT-0133` (Status = Done, Response = what you did) whenever you're ready.
