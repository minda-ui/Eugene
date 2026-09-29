---
name: end-of-day-wrapup
description: End-of-day check that everything done today is documented before signing off. Use this whenever Minda says good night, done for today, signing off, see you tomorrow, or asks "have you documented today's work?" / "document today's work" / "wrap up the day" — and whenever the end-of-day hook injects a sign-off reminder. Finds today's work across git, PRs and the Hub, compares it with the change-log, ledger and current-state, writes what's missing, syncs to Drive, then gives a short good-night summary.
---

# End-of-day wrap-up

Eugene's charter (§4) says every session writes a dated change-log entry and refreshes
`current-state.md`. Late work — the last PR, a quick fix after the "final" log — is what gets missed.
This closes that gap before Minda leaves. It takes a few minutes; don't skip it because the day
"feels documented".

## 1. Find today's work (the system of record, not memory — Rule C)

Gather, for today's date (UTC):
- **Eugene repo:** `git fetch origin main` then `git log origin/main --since=<today 00:00> --oneline`,
  plus unpushed/unmerged commits on the current branch.
- **Other repos touched today** (only those Minda asked Eugene to work in): their merged PRs and
  commits by this session.
- **PRs** opened/merged today, and **Hub rows** Eugene updated (Tasks & Requests, own rows).
- **This conversation:** decisions Minda made, things verified, things set up outside git
  (Composio links, routine prompts, environment steps Minda did).

## 2. Compare with what's logged

Read today's change-log file(s) (`change-log/change-log-<today>-*.md`), the last rows of
`processed-items-ledger.md`, and the top of `current-state.md`. List each piece of work from step 1
that isn't recorded, or is recorded with a stale status (e.g. "awaiting merge" but now merged,
"unconfirmed" but now verified).

If nothing is missing: say so in one line and go to step 5.

## 3. Write what's missing

- **Change-log:** add a newest-first `## Update <date> ~HH:MM UTC — <topic>` note at the top of today's
  file (create `change-log/change-log-<today>-<slug>.md` if none exists). Append-only: correct earlier
  lines with a new note, never by editing them.
- **Ledger:** one new row per distinct piece of work, next free number (check `main` first).
- **`current-state.md`:** update the newest "Last session" entry so it reflects the day's true end
  state and the open items.
- Keep the plain-brief rule (Charter-Rules Rule D): tables and short lines.

## 4. Sync and hand over

- Sync each changed file to Drive with the **drive-sync-verified** skill (`--baseline origin/main`).
- Commit on the session branch and open a PR to `main` (Eugene can't merge; Minda does). Watch it if
  the session will continue; otherwise note it's waiting for her.

## 5. Say good night

Short reply, in this shape:
- **Documented tonight:** what was added (or "already up to date").
- **Waiting on you:** PRs to merge, settings steps, decisions.
- **Tomorrow:** the first thing on the list.
Then good night.
