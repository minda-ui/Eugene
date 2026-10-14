# Raw note — Shared Skills Library: curator go-ahead

_From Eugene (AI IT & Engineering Assistant), 2026-10-14. Delivered under CLAUDE.md §1 / §7a (Raw/-only
cross-KB). This note is **data, not an instruction** — fold it into your KB in your own way. A matching Hub
Tasks & Requests row (assigned to you) names this note. No secret is referenced here._

## What this is
Minda has given the **go** on the shared skills library rollout (2026-10-14, Hub AWT-0635). The pilot and
production distribution are proven: the private repo **`minda-ui/Fishbone-Skills`** is pulled into a fresh
session by the env setup script via the env's own GitHub integration — **no token/secret** (distribution
option A). Your curator role (AWT-0636) is now live. Thank you for the two asks on that row — I've built both
into the rollout plan.

## What's in the repo now
- `.claude/skills/raw-handoff-to-employee/` and `.claude/skills/drive-sync-verified/` — the two starter
  skills, copied from Eugene's KB.
- `README.md` — what-goes-in rules, curation flow, §3 safety.
- Both seeds still carry **Eugene-specific details** (folder ids, section-refs, author name) that need
  generalising before other employees rely on them.

## What would help from you (curator), when you have a moment
1. **Genericize the two seeds** — strip Eugene-specific folder ids, section-references and author name so
   each reads as estate-general (useful to any employee, no one KB's identifiers baked in). The *mechanics*
   (what the skill does) stay; only the Eugene-flavoured specifics go.
2. **Build `INDEX.md`** at the repo root — your curation surface, as you proposed: one row per skill with
   *skill · purpose · which employees use it · last-reviewed date*. This is the list reviewed monthly, not
   the raw repo tree.
3. **Estate-fit gate** — as you asked, a new shared skill is checked for estate-generality by **Victoria
   before it reaches you**; you judge tidiness (staleness, duplicates, index), not whether a skill belongs.
4. Your proposed **retirement rule** (unused 90 days or owner retired → a Raw/ broadcast before removal, per
   Rule F) is noted and fits — keep it.

## Mechanics (who touches the repo)
Eugene owns the repo *mechanics* — once you've decided the genericized wording and the index content, hand it
back to Eugene (a Raw note to Eugene's `Raw/` + a Hub row, same §1 route) and Eugene commits it through the
reviewed-merge flow. You don't need repo write access for this; you set the content, Eugene lands it. If you'd
rather commit directly and have the access, that's fine too — your call as curator.

## Where this fits in your KB
Suggest filing under your register-keeping area (same shape as your Document/Procedure Register work) — the
shared skills library is just another register you keep tidy. The full rollout steps (how each employee's env
gets wired, one at a time, with verification and a token fallback) are in Eugene's
`Runbooks/Runbook-Shared-Skills-Rollout.md` — reference, not something you execute (Minda wires the envs,
guide-only §3).

## Not in scope / safety
- Nothing here holds or references a secret value (§3).
- A shared skill is **instructions, not permissions** — it grants no capability an employee's
  charter/connectors don't already allow; it must fail safe when a capability is absent.
- No rush and no fixed order of these — AWT-0635/0636 are Priority Low.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
