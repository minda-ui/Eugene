# Change log — 2026-10-14 — Shared skills library LIVE via the native claude.ai Skills channel

_Guide-only / §3. No secret held. Branch `claude/lucid-mayer-nsoili`. Continues the morning's rollout
(change-log-2026-10-14-shared-skills-rollout-go.md)._

## What happened
Minda gave the GO on the rollout; we started with Alex's env using the planned **private-repo +
setup-script-clone** mechanism. It **failed on Alex's env** and, on investigation, turned out to be the
wrong approach entirely.

### Why the repo-clone approach failed (root cause)
- A fresh real Alex session's setup-script clone of `minda-ui/fishbone-skills` errored:
  `fatal: could not read Username for 'https://github.com': terminal prompts disabled` — the session has
  **no git credentials** for the private repo at setup time.
- `add_repo` run in a throwaway probe session did **not** carry over to real sessions; run in a real Alex
  session it attached the repo but the **boot-time setup script still had no creds** (and the manual clone
  was separately blocked by the auto-mode Bash classifier — a red herring).
- `claude-code-guide` research confirmed: **setup-script private-repo clone is an unsupported anti-pattern.**
  Setup scripts run as root *before* Claude Code, network secrets aren't attached, user-level skills written
  there aren't carried over, and setup-script content is readable by everyone who uses the env.

### The supported channel (now LIVE)
`~/.claude/skills/synced/` is the account skills cache — Claude Code downloads the account's enabled skills
there at session start. Since **every AI-employee environment runs under Minda's one claude.ai account**, a
skill uploaded in **Settings → Customize → Skills → `+ Add` → Upload a skill** (zip of `<name>/SKILL.md`)
syncs to **all** employees automatically — no per-env wiring, no clone, no token. (Confirmed by
`my-writing-style`, a "Created by you" skill, already being in Alex's synced set.)

### Done
1. **Uploaded** `drive-sync-verified` and `raw-handoff-to-employee` to Settings → Skills.
2. **Fixed a blocker:** the uploader rejects XML/angle-bracket tags in the SKILL.md YAML `description`
   (`raw-handoff-to-employee` had `<employee>` placeholders → "SKILL.md description cannot contain XML
   tags"). Replaced with plain text; committed to `minda-ui/Fishbone-Skills` (`main`, a43fb42) and Eugene's
   copy (parity).
3. **Verified:** a fresh Alex session shows **both** skills in `~/.claude/skills/synced/*/`. ✓
4. **Rewrote** `Runbooks/Runbook-Shared-Skills-Rollout.md` to this method (repo = source-of-truth +
   curation; upload = distribution; retired the clone approach with the root cause).
5. **AWT-0635 → Done.**

## Boundary
The claude.ai upload is a console/account action — **Minda performs it** (guide-only §3); Eugene authors +
zips the skills and verifies. No secret in any skill.

## Remaining
- **Alex (AWT-0687):** genericize the 2 seeds + keep the repo `INDEX.md`; Eugene zips the genericized
  versions → Minda **re-uploads** (same names) → cleaner versions replace everywhere, no env work.
- **Minda (optional cleanup):** remove the now-dead setup-script snippet (and `add_repo` attach) from
  Alex's and Eugene's envs.
- Curation flow for future skills unchanged: propose → Victoria estate-fit → Minda approve → Eugene add to
  repo + zip → Minda upload → Alex index.

## Artefacts
`Runbooks/Runbook-Shared-Skills-Rollout.md`, `minda-ui/Fishbone-Skills` (main a43fb42),
`.claude/skills/raw-handoff-to-employee/SKILL.md`, Hub AWT-0635 (Done) / AWT-0687 (Alex), ledger 111.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
