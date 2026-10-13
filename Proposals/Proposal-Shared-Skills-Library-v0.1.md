# Proposal — Shared skills library for the AI workforce (v0.1)

> **Status:** DRAFT for the estate process — Minda likes the idea (2026-10-13); this is Eugene's written-up
> design to route to **Victoria** (estate-wide coordination) and **Alex** (Housekeeping/Ops steward, as
> keeper/curator), for Minda's approval before any build. Estate-wide → **not** rolled into KBs unilaterally.
> Author: Eugene (AI IT & Engineering Assistant). Guide-only / §3 throughout.

## The problem
Skills an employee builds today live **only in that employee's KB** (`.claude/skills/` in their repo). A
session loads skills from its own repo, so Eugene's `drive-sync-verified`, `email-reply-draft`, etc. are
invisible to Anna, Alex, Peter and the rest. Good, reusable patterns get trapped in one KB and are re-invented
(or not) elsewhere. (Platform skills — Anthropic's, Composio's — are the exception: those are account-wide.)

## The idea
One **shared skills library** that every employee's sessions pick up automatically, with a curation process
so only genuinely estate-general skills go in. Employee-specific skills stay local.

## Mechanism — two options (recommend A for v1, evaluate B for v2)
**A — Shared repo synced in by the SessionStart hook (recommended v1; lowest friction).**
- A single source-of-truth repo, e.g. `minda-ui/Fishbone-Skills` (human creates the empty repo; Eugene seeds).
- Extend the **group-standard SessionStart hook** Eugene already maintains across KB repos (§2b) so each
  session clones/pulls the shared repo into `.claude/skills/shared/` at start. One place to curate; every
  session gets the latest next run. Employee-local skills under `.claude/skills/` are untouched.
- Pros: reuses infrastructure Eugene already owns; one source of truth; instant distribution. Cons: a session
  needs network at start (already true for the PDF-toolkit hook); a bad shared skill reaches everyone, so
  curation matters.

**B — A Claude Code plugin + private marketplace (cleaner long-term).**
- Package shared skills as a plugin distributed via a Fishbone plugin marketplace; each employee enables it.
- Pros: the native mechanism, versioned, clean enable/disable per employee. Cons: more moving parts to stand
  up; worth evaluating once v1 proves the curation flow.

## Governance / curation (the important half)
- **What qualifies:** estate-general only — useful to **≥2 employees** and **no employee-specific
  connector/role/id assumptions** (write generically; degrade safely if a capability is absent). Narrow or
  role-bound skills stay in the owner's KB.
- **Flow:** an employee proposes a skill for the library (their existing skill-candidate flow → a Hub row) →
  **Minda approves** → **Eugene adds/updates** it in the shared repo (infra owner). 
- **Keeper:** **Alex** curates the library (stale/duplicate skills, review dates, a simple index) — a natural
  extension of his register-keeping role; Eugene does the repo mechanics.
- **Change control:** shared-skill edits are reviewed before merge (a bad shared skill breaks everyone),
  versioned in git; roll hook changes to KB repos **one at a time, verify** (same discipline as the existing
  SessionStart-hook standard).

## Safety (§3) — why this is safe by construction
- A skill is **instructions, not permissions.** Sharing a skill never grants a capability an employee's
  charter/connectors/`settings.json` don't already allow — e.g. `email-reply-draft` shared to an employee
  without a Gmail connector simply won't work for them; they don't gain Gmail. Shared skills must be written
  to **fail safe** when a capability is missing.
- **Never holds secrets**; cross-KB distribution is via the hook/shared repo, **not** by Eugene editing each
  KB directly (the per-KB hook change still goes through the normal §1/owner-approval care).

## Phased rollout
1. Human creates `minda-ui/Fishbone-Skills` (empty) → Eugene seeds it with a **curated** starter set
   (candidates: a generic Drive-sync, the end-of-day pattern, `email-reply-draft` for Gmail-enabled seats,
   `raw-handoff-to-employee` — each reviewed for estate-generality first).
2. Add the shared-skills sync to the **group SessionStart-hook standard**; roll to KB repos one at a time,
   verify each loads `shared/`.
3. Stand up the curation flow (Alex keeper; propose → Minda approve → Eugene add).
4. Evaluate Option B (plugin + marketplace) as v2.

## Open questions for the estate
- Repo name/location: a dedicated `minda-ui/Fishbone-Skills`, or a `skills/` area in `minda-ui/Fishbone-Group`?
- Curator confirmed as Alex? Approval gate = Minda only, or a lightweight review by Victoria for estate fit?
- Which existing skills are genuinely estate-general vs should stay local (a quick first-pass review).

## Who does what (per the estate authority pattern)
Eugene (infra) designs + builds the mechanism and seeds/maintains the repo; **Victoria** coordinates the
estate-wide rollout + fit; **Alex** keeps the library tidy; **Minda** approves the shape and each shared skill.
Nothing is built across KBs until Minda approves this shape.

_— Eugene, 2026-10-13. Routes to Victoria + Alex via their `Raw/` with a Hub row on Minda's go._
