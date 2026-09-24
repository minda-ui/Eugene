# Runbook — Git branch consolidation for `minda-ui/Eugene` (v0.1)

_Eugene runbook. Resolves **OI-10** (Option B, owner-decided 2026-09-24: "Agree, B is a way forward").
No live-system change, no credential ever involved — this is entirely within Eugene's direct-edit reach
(charter §3: branch and push to repos he owns/works in). Author: Claude for Eugene. v0.1 2026-09-24._

## Why this exists

Every Claude Code session working in `minda-ui/Eugene` — interactive or a scheduled Hub check-in — gets
its own auto-generated git branch. Branches never auto-merge into `main` or into each other (`CLAUDE.md`
§1, "Eugene runs as many parallel sessions on isolated git branches"). Left unaddressed, this produces:

- **Duplicate work** — two sessions independently doing the same Hub task on different branches (seen
  2026-09-24: AWT-0062 done twice, harmlessly, on different branches).
- **False anomaly alarms** — a session finding Drive content with no corroborating commit *on its own
  branch* and wrongly concluding it's unauthorised or fabricated (OI-9, 2026-09-23 — a real, serious
  misdiagnosis that archived a legitimate fix and reintroduced a bug it had already fixed).

`Charter-Rules.md` Rule C now requires checking sibling branches before treating Drive content as
anomalous — that's the *detection* fix. This runbook is the *structural* fix: periodically fold sibling
branches' real content back into `main` so history stops fragmenting indefinitely.

## When to run this

- **Periodically** — at a natural session-start Hub check (Rule A) when `git fetch --all` shows sibling
  branches have accumulated since the last consolidation, or roughly every 1–2 weeks of active use,
  whichever comes first. Not a scheduled routine of its own (§5 — Eugene doesn't run unattended
  system-changing routines); folded into ordinary session-start housekeeping.
- **On demand** — if a session hits an OI-9-style situation (unfamiliar Drive content, no local
  corroboration) and confirms via `git fetch --all` + `git log --all` that the real commit is sitting on
  an unmerged sibling branch, consolidating immediately closes the gap for every future session.

## Procedure

1. **Fetch everything and enumerate branches.**
   ```
   git fetch --all --prune
   git branch -r
   git log --all --oneline --graph
   ```

2. **Confirm the fast-forward path.** Identify the branch with the most current, fullest history (usually
   whichever session is running the consolidation, if its branch already contains `main`'s tip as an
   ancestor):
   ```
   git merge-base --is-ancestor origin/main <candidate-branch> && echo "fast-forward possible"
   ```
   If true, `main` can be moved forward with zero conflicts — no merge commit needed.

3. **Inspect every sibling branch's unique commits before touching anything.** For each branch not yet
   an ancestor of the candidate:
   ```
   git log <candidate-branch>..<sibling-branch> --oneline
   git show <commit> --stat
   git show <commit>          # read the actual diff, not just the message
   ```
   Classify each commit:
   - **Already superseded** — a later commit (on any branch, including the candidate) achieved the same
     or a more current result. No action needed beyond noting it was reviewed.
   - **Genuinely new** — content with no later duplicate (typically a `change-log/` entry recording a
     session's real work that nothing since has repeated or overwritten).
   - **Stale control-file state** — the commit also touches `current-state.md`, `open-issues.md`,
     `processed-items-ledger.md`, `CLAUDE.md`, etc. with content older than the candidate branch's own
     versions of those files. **Never bring these in via a full cherry-pick** — it would silently regress
     the current control files to a stale snapshot.

4. **Fast-forward `main`.**
   ```
   git push origin <candidate-branch>:main
   ```
   (A genuine fast-forward push — Git refuses it outright if it isn't one, so this is safe by
   construction; no `--force` is ever used here.)

5. **Bring in genuinely-new content as standalone files, not full cherry-picks.** Extract just the new
   file(s) from the sibling commit rather than cherry-picking the whole commit:
   ```
   git show <commit>:<path/to/file> > <path/to/file>
   ```
   This preserves the historical record (e.g. a change-log entry documenting a real past session) without
   overwriting current control files with that commit's older snapshot of them.

6. **Do not delete sibling branches as part of this step.** Their content is now redundant on `main`, but
   deleting a remote branch is a less-reversible action on shared state (charter's general caution on
   hard-to-reverse git/Drive operations). Flag reviewed-and-now-redundant branches to Minda explicitly and
   let her confirm deletion, rather than deleting unilaterally. (First run, 2026-09-24: all 7 sibling
   branches reviewed and folded in; none deleted yet — flagged for Minda's call.)

7. **Standard paperwork.** Update `open-issues.md` (if this run was triggered by or resolves an OI),
   `processed-items-ledger.md`, `current-state.md`, and a new dated `change-log/` entry describing exactly
   which branches were reviewed, what was classified as superseded vs. new, and what was pulled in. Commit
   and push. Sync all touched control files to Drive with byte verification per the archive-then-recreate
   discipline.

## What this does *not* solve

This is a periodic manual step, not automation — it doesn't stop branches fragmenting between runs, and
it relies on a session choosing to run it. It also doesn't change how Claude Code allocates branches
(Option C from OI-10 — not something Eugene can control from inside a session). It reduces the drift
between consolidations; Rule C remains the safety net for whatever drift exists at any given moment.
