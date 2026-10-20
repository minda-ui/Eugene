# Pilot report — Shared Skills Library (AWT-0635)

> Guide-only / §3. For Minda (and Victoria/Alex). Pilot run 2026-10-13 after Minda created
> `minda-ui/Fishbone-Skills` and approved the pilot.

## Verdict: ✅ PASS (feasibility proven) — one decision needed from Minda for automatic distribution.

## Conditions & results
1. **Dedicated repo** `minda-ui/Fishbone-Skills` — ✅ created by Minda (empty); now seeded.
2. **Prove a session can pull the shared repo with the access it has** — ✅ **PASS.** From Eugene's session
   (scoped to `minda-ui/eugene`), `add_repo minda-ui/Fishbone-Skills` **succeeded** (no secret held — authorised
   by the session's own GitHub integration) and `git clone` **succeeded**. Evidence: the session now lists 12
   repos incl. `fishbone-skills`; cloned to `/home/user/fishbone-skills`; README + 2 skills committed and
   **pushed to `main`**.
   - ⚠️ **Mechanism nuance (the important finding):** that proves **mid-session** access via `add_repo`. For
     skills to load **automatically at session start** (before the agent runs), the repo must already be
     present in the session's environment — a plain SessionStart-hook `git clone` of an *unattached* private
     repo has no credentials and would fail. **No credential was needed for `add_repo`, but automatic-at-start
     needs one of the options below**, and that's environment/secret config Eugene **cannot** do (guide-only,
     §3) — it's the one thing for Minda.
3. **Seed 2–3 estate-general skills** — ✅ seeded **2**: `raw-handoff-to-employee` and `drive-sync-verified`
   (both useful to ≥2 assistants, no narrow-connector assumptions, fail safe). README sets the what-goes-in
   rules + curation + §3 safety.
4. **No other KB/hook/charter changed** — ✅ confirmed. Only the new repo was written; no employee's
   SessionStart hook, KB or charter was touched.

## What Minda must decide/do — automatic distribution (pick one)
To get the shared skills into every employee's session automatically at start:
- **A — RECOMMENDED: attach `minda-ui/Fishbone-Skills` as an extra source to each employee's session
  environment.** No secret, no public exposure; it's present at start and its `.claude/skills/` load like the
  KB's own. Platform/environment config (Minda), one environment at a time, verified in a target session.
- **B — make the repo public.** Simplest hook clone, but the skills become world-readable. Not recommended.
- **C — a read-only deploy token/PAT as an environment secret** for a hook `git clone`. Works, but a
  credential to manage (Minda sets it; Eugene never holds it, §3).

Eugene can't do any of these (environment/secret config is §3 guide-only). **Recommend A.**

## Proposal open questions — answers
- **Repo name/location:** a **dedicated `minda-ui/Fishbone-Skills`** (done) beats a folder inside
  `Fishbone-Group` — it isolates + versions the skills and can be attached as its own source (option A).
- **Curator = Alex** (AWT-0636) — fits; he keeps the index + review dates; Eugene does the repo mechanics.
- **Which skills are estate-general?** Of Eugene's current set: genuinely estate-general = `raw-handoff-to-employee`,
  `drive-sync-verified` (seeded). Candidates after genericizing = `end-of-day-wrapup`, `composio-routine-setup`.
  **NOT estate-general today** (fail the "useful to ≥2" test) = `email-reply-draft`, `gmail-vendor-quote-draft`
  (Gmail-only), `tailscale-subnet-router` (infra-only).

## Next — on Minda's go
1. Minda picks **A/B/C**; Eugene (guide) + Minda wire it into **one** target employee's environment first,
   verify the skills load in that session, then roll the rest **one at a time**.
2. **Alex** genericizes the two seeds (strip Eugene-specific ids/§-refs/author name) + builds the index.
3. Expand the seed set (candidates above) via the curation flow (propose → Minda approve → Eugene add).

_Nothing else is built or changed until Minda chooses the distribution option._
