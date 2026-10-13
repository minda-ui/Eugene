# Change log — 2026-10-13 — new skill `email-reply-draft`; shared-skills-library proposal routed

_Guide-only / §3. Same live session as the DocuSeal SMTP + OI-8 work. No secret held._

## Skill built — `email-reply-draft` (SC-4, Minda-adopted)
From today's three WebMate OI-8 ticket replies (technical reply + whitelist + thank-you), Eugene proposed and
Minda **adopted** a general skill: **draft a reply into an existing Gmail thread, draft-only** (find the LATEST
inbound message — ticket systems like WebMate/macace send each update as a *separate* thread, so you must
search the sender for the newest, not reply to the first — read it, create a reply-threaded plain-text draft,
leave it in minda@'s Drafts, never send). Built at `.claude/skills/email-reply-draft/`; skill-candidate SC-4 →
adopted. Complements `gmail-vendor-quote-draft` (new outbound enquiries).

## Shared skills library — proposal drafted + routed to the estate
**Minda's query → idea:** skills Eugene builds live only in his own KB; each employee's sessions load only
their own `.claude/skills/`, so good patterns are trapped in one KB. Minda liked the idea of a **workforce-wide
shared skills library**.
- **Wrote** `Proposals/Proposal-Shared-Skills-Library-v0.1.md` — a shared skills repo synced into every
  session via the **group SessionStart hook** Eugene already maintains (v1) / a Claude Code **plugin
  marketplace** (v2); **estate-general skills only**; curation = propose → **Minda approve** → **Eugene add**,
  kept tidy by **Alex**; **§3-safe by construction** (a skill is instructions, not permissions — it grants no
  capability an employee's charter/connectors don't already allow; must fail safe when a capability is absent).
  Distribution via the hook/shared repo, never by Eugene editing each KB directly.
- **Routed (§1 Raw/ hand-off — first real use of the new `raw-handoff-to-employee` skill):** proposal uploaded
  byte-verified to **Victoria's `Raw/`** (Drive `1JyfiSFbjqKJOSXmXaGn58Y6ZM57BSgwR`) + Hub **AWT-0626**
  (coordinate the estate rollout + fit), and **Alex's `Raw/`** (Drive `1fvo23c0gJ-MR94kx1MXoJA7y28cFdtN3`) +
  Hub **AWT-0627** (proposed curator). Priority Low; no duplicate-guard flags.
- **Nothing is built across KBs until Minda approves the shape.** Open questions for the estate: repo
  name/location (`minda-ui/Fishbone-Skills` vs a `skills/` area in `minda-ui/Fishbone-Group`); Alex as curator;
  which existing skills are genuinely estate-general.

## Artefacts
`.claude/skills/email-reply-draft/SKILL.md`, `Proposals/Proposal-Shared-Skills-Library-v0.1.md`,
`.claude/skill-candidates.md` (SC-4 adopted), Victoria/Alex `Raw/` (Drive ids above), Hub AWT-0626/0627,
ledger 107.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c

## Update ~12:40 — shared skills library PILOT run (AWT-0635) = PASS
Minda approved the pilot and created `minda-ui/Fishbone-Skills`. Eugene ran the feasibility test:
- **Access PROVEN** — from Eugene's session (scoped to `minda-ui/eugene`) `add_repo minda-ui/Fishbone-Skills`
  + `git clone` succeeded with **no secret held**; seeded README + 2 estate-general skills
  (`raw-handoff-to-employee`, `drive-sync-verified`) and pushed to `main`.
- **Finding:** that's MID-SESSION access via `add_repo`; **automatic-at-start** needs the repo present in the
  environment before the agent runs → one decision for Minda (A attach as an env source [recommended] / B
  public / C env-secret token). Eugene can't configure environments/secrets (§3).
- **No other KB/hook/charter changed.** Report: `Proposals/Report-Shared-Skills-Library-Pilot-2026-10-13.md`;
  AWT-0635 → In Progress, awaiting Minda's A/B/C. Ledger 108.

## Update ~13:15 — shared skills library: PRODUCTION DISTRIBUTION PROVEN (option A, no token)
Minda chose option B (public) to test, then we hardened to private:
- Public test: made the repo public (sanitized to a smoke-test skill only — no ids ever exposed), added the
  clone+stage snippet to the env setup script → a fresh session loaded the skill. Mechanism proven.
- Hardened to **private**: Minda flipped the repo private (verified via GitHub API — caught one attempt that
  hadn't saved); Eugene restored the 2 real skills + kept the smoke-test as a load-marker.
- **Production test = PASS:** a fresh session with the repo **PRIVATE** still loaded the shared skill — the
  env's GitHub integration served the private clone, **no token/secret needed** = distribution **option A**
  works cleanly (private, no secret, loads at session start).
- Tidied: removed the smoke-test marker; the library now holds `raw-handoff-to-employee` + `drive-sync-verified`.
- **Remaining:** Alex (AWT-0636) genericizes the 2 seeds; roll the setup-script snippet to other employees'
  envs one at a time, verifying each can reach the private repo (a read-only token env-secret only if one
  can't). Eugene's env is wired + verified. AWT-0635 updated.
