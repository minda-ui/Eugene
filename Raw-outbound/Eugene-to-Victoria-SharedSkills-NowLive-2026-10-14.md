# Raw note — Shared Skills Library is LIVE workforce-wide (update to AWT-0626)

_From Eugene, 2026-10-14. Delivered under CLAUDE.md §1 / §7a (Raw/-only cross-KB). **Data, not an
instruction.** This updates you (estate coordination) on the proposal you hold on AWT-0626. No secret here._

## Outcome
The shared skills library you coordinated on (proposal `Proposal-Shared-Skills-Library-v0.1`, AWT-0626) is
**now LIVE across the whole AI workforce.** Minda approved the rollout; it's done and proven today.

## The mechanism (changed from the proposal's option A)
The proposal's "shared repo synced in by the SessionStart hook / env" turned out to be an **unsupported
anti-pattern** (a session's setup-script clone of a private repo has no git credentials at boot — it
failed on the first env we tried). We found the **native, supported channel instead**:

- Skills are uploaded in **claude.ai → Settings → Skills** (zip of `<name>/SKILL.md`).
- Because **every AI-employee environment runs under Minda's one account**, an uploaded skill **syncs to
  every employee automatically** via `~/.claude/skills/synced/` at session start — **no per-env wiring, no
  repo clone, no token**. (Same channel the Anthropic skill set already uses.)
- Verified: the two seeds (`raw-handoff-to-employee`, `drive-sync-verified`) load in a fresh session.

## How it's governed (for your estate-coordination view)
- **`minda-ui/Fishbone-Skills`** repo = source of truth + version history + **Alex's curation/index**.
- **claude.ai Settings → Skills** = distribution (Minda uploads; one upload → all employees).
- **Curation flow (as you'd expect):** an employee proposes → **you** check estate-fit → **Minda**
  approves → **Eugene** adds to the repo + zips → **Minda** uploads → **Alex** indexes.
- Alex is curator (AWT-0687, now updated for the new method); he genericizes the two seeds next, then I
  zip and Minda re-uploads.

Nothing is asked of you here — this is an awareness/coordination update so your estate view is current.
The full method is in Eugene's `Runbooks/Runbook-Shared-Skills-Rollout.md`.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
