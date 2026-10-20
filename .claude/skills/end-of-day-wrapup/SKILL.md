---
name: end-of-day-wrapup
description: End-of-day check that everything done today is documented before signing off. Use this whenever Minda says good night, done for today, signing off, see you tomorrow, or asks "have you documented today's work?" / "document today's work" / "wrap up the day" — and whenever the end-of-day hook injects a sign-off reminder. Finds today's work across git, PRs and the Hub, compares it with the change-log, ledger and current-state, writes what's missing, syncs to Drive, proposes the day's skill candidates for Minda to adopt or delete, then gives a short good-night summary.
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

- Sync each changed file to Drive with the **drive-sync-verified** skill. Use `--baseline origin/main`
  normally; if that guard fails only because `main` is stale (the live Drive copy is this branch's own
  earlier snapshot), verify by diff that the Drive copy is a strict subset of local before overwriting,
  then re-run without the baseline — never overwrite Drive content you haven't accounted for (Rule C).
- Commit everything on the session branch and **push** it (`git push -u origin <branch>`, retry on
  network error).
- **Always open — or update — a PR to `main` and hand Minda the link to merge. This is a required step,
  not optional; a day's work that only lives on a session branch is not handed over.** Eugene **cannot
  merge** (and never self-approves) — Minda does.
  - Load the GitHub MCP tools if needed (`ToolSearch`), then `mcp__github__create_pull_request`
    (`owner: minda-ui`, `repo: Eugene`, `head: <session branch>`, `base: main`).
  - If a PR from this branch is already open, don't open a second one — reuse it (its commits update
    automatically on push) and just re-surface its link.
  - **Title:** `Good night <date> — <short summary of the day>`. **Body:** what the day changed
    (ledger rows, change-log, current-state, Drive sync, Hub), plus the attribution footer the session
    requires. End the body with the PR attribution lines (`🤖 Generated with Claude Code` + session
    link) per the session's standing instruction.
  - Capture the PR number and URL; carry it into step 6.
  - If the push or PR call is **blocked or fails** (e.g. the cloud guard on a settings-bearing diff, or
    a network error that survives retries), say so plainly in step 6 with the exact blocker — never
    report a PR as open when it isn't.

## 5. Propose the day's skill candidates (Minda chooses)

Eugene collects **skill candidates** through the day in `.claude/skill-candidates.md` — repeatable
workflows worth turning into a reusable skill (the way `drive-sync-verified` or this skill came to be).
Here, at Good Night, he hands the list to Minda to decide.

- Read `.claude/skill-candidates.md`. Also sweep today's work (step 1) for any repeatable pattern not
  yet captured and **append** it as a new `proposed` row first, so the list is complete.
- Present **every `proposed` row** as a short numbered list: candidate name — one line on what it would
  automate — why it recurs. Keep it brief (Rule D).
- Ask Minda, per candidate, to **adopt** or **delete**. **Do not build anything yet** — she chooses.
  - **Adopt** → next session, build it with the **skill-creator** skill; mark the row `adopted → <skill name>`.
  - **Delete** → mark the row `deleted — <one-line reason>`. Never remove the line (keep the record).
- Write her decisions back into `.claude/skill-candidates.md` this session (it syncs with the rest in
  step 4 ordering — if you reach this step after syncing, sync this file too).
- If there are no `proposed` candidates, say "no skill candidates today" in one line and move on.

## 6. Say good night

Short reply, in this shape:
- **Documented tonight:** what was added (or "already up to date").
- **Skill candidates:** the numbered list for her to adopt/delete (or "none today").
- **Waiting on you:** **lead with the PR to merge — its number and URL** (or the exact blocker if it
  couldn't be opened), then any settings steps or decisions.
- **Tomorrow:** the first thing on the list.
Then good night.
