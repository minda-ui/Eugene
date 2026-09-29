---
name: drive-sync-verified
description: Write a file from Eugene's git repo to Google Drive the safe way — archive-then-recreate with byte verification, via the Composio CLI. Use this whenever you need to put a new or changed file on Drive (control files like current-state.md, processed-items-ledger.md, open-issues.md, external-source-register.md, change-log entries, runbooks, CLAUDE.md / Charter files), when syncing git to Drive after a merge or branch consolidation, or when someone asks to "update Drive", "sync to Drive", "upload the log" or "byte-verify" a file — even if they don't mention Composio or archiving.
---

# Drive sync, verified

Eugene's charter (§1, §4) requires every Drive replacement to be **archive-then-recreate** (old copy
renamed "(archived …, superseded by …)" and moved to `Archive/`, never trashed) and **byte-verified**
(Drive size/md5 = local, no U+FFFD, special characters preserved). The native Google Drive connector
has silently truncated large files (~31 KB+), so writes go through the Composio CLI, which uploads
from a local file path. `scripts/sync.sh` does the whole sequence and refuses to proceed when
something looks wrong.

## When it applies

- Any write of a KB file to Drive, new or replacement.
- Interactive sessions with the Composio **CLI signed in** (`composio whoami` shows minda@). Routine
  runs that only have a `ck_` key can't sign the CLI in — by design they leave Drive sync to the
  next consolidation (Task Check-in prompt v2, step 7).

## How to use

1. Commit-ready local file first (the git copy is the source for the upload).
2. Look up the target Drive folder id — `CLAUDE.md` §1 lists them. Common ones:
   | Folder | id |
   |---|---|
   | KB root (control files, CLAUDE.md, Charter-*) | `1o4MBRcckZBspw-uT6qM2V-74H6OsRK9T` |
   | `change-log/` | `1YHo0ogm9zrI_8d5Bx3-MAgKloIV3dZn0` |
   | `Runbooks/` | `1PLOjWw_768-PqMws2lS4zbzEUhSne3wJ` |
   | `Infra-Inventory/` | `1AWjsIymQNPMT8IeMUL2XHlsaGeoo1AcG` |
   | `Archive/` (default archive target) | `1yw-FuDwvPc6Soi0xXArMCavb-N4eiP9z` |
3. Dry-run, then run:
   ```bash
   S=.claude/skills/drive-sync-verified/scripts/sync.sh
   bash $S current-state.md 1o4MBRcckZBspw-uT6qM2V-74H6OsRK9T --baseline origin/main --reason "2026-09-30 session log" --dry-run
   bash $S current-state.md 1o4MBRcckZBspw-uT6qM2V-74H6OsRK9T --baseline origin/main --reason "2026-09-30 session log"
   ```
   Several files: run the script once per file (each is independently archived and verified).

**`--baseline origin/main`** is the Rule C guard: it refuses if the live Drive copy differs from
`main`'s version, which means someone (another session, a routine, a human) wrote it since. Use it for
every replacement of a file that also lives in git. Omit it only for files that aren't in `main` yet,
or when you've deliberately checked the difference.

## Reading the result

The script prints each check and ends with one `RESULT:` line.

| Exit | Meaning | What to do |
|---|---|---|
| 0 | Synced and verified, or Drive already identical | Report it with the checks |
| 1 | Usage error | Fix the command |
| 2 | Precondition failed — **nothing changed** | Read the FAIL line: duplicate copies, baseline mismatch, CLI not signed in, U+FFFD in the local file |
| 3 | Failure **after** a change | See below — don't retry blindly |

### If verification fails (exit 3)

- Upload failed after archiving: the folder has no live copy. Move the archived file back from
  `Archive/` and rename it to its original title (the script prints its id), then investigate.
- Upload succeeded but a check failed: the new copy is suspect and the old one is safe in `Archive/`.
  Report both ids; don't delete either (charter: never trash). Diagnose (encoding? size?) before retrying.

### Duplicate live copies (exit 2)

Two uploads raced (seen 2026-09-26). Download both, compare with git, keep the one matching `main` as
live, archive the other with reason "duplicate of <id>", then re-run.

## Reporting

Report per file: live copy archived (title), new size, md5 match, round-trip identical, U+FFFD 0, one
live copy. Log the sync in the session's change-log / ledger as usual — the script doesn't write logs.
