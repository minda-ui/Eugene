# Change log — 2026-09-26 — AWT-0104: Nadia converted to a standalone employee KB

Session-start Hub check (Rule A) found 4 open rows: AWT-0060 (carryover, Blocked), AWT-0090
(carryover, In Progress), AWT-0101 (carryover, Blocked/parked), and **AWT-0104** (new) — a reversal of
yesterday's Nadia decision. Minda said "Yes, please" to starting it.

## The reversal

AWT-0093 (2026-09-24) built Nadia adopting the existing Amfa Furniture Ltd KB — no home of her own,
identity living at that KB's root, mirroring John's relationship to the Fishbone Properties Ltd KB.
**Minda decided 2026-09-26 (Hub AWT-0104, Victoria's build brief) to reverse this:** Nadia gets her own
standalone employee KB instead, on the **Peter/Eugene/Anna model**. The Amfa Furniture Ltd KB itself is
unaffected — still one of the seven company KBs — Nadia just operates it and its Smartsheet workspace
from her own home now, rather than living inside it.

## Built

**Charter rewritten end to end** onto the core/rules/history split (`CHARTER.md`/`Charter-Rules.md`/
`Charter-History.md`) — split from the start, since this KB has no single-file predecessor to migrate
away from (unlike Eugene, Alex, Rachel, who split later once edits got expensive). Content carried over
from the 2026-09-24 charter: reach, connectors, guardrails all unchanged (draft-only outward, finance
stays Rachel's, group `CLAUDE.md` §6a bars stand) — only the "where she lives" and "relationship to the
Amfa KB" framing changed, from "adopts/governs nothing of her own" to "operates the Amfa KB from her own
home, same as John/Properties."

**Four standard control files added:**
- `current-state.md` — present snapshot.
- `open-issues.md` — new `NA-<n>` numbering. Carried over, unresolved, the three open questions flagged
  at the 2026-09-24 build (NA-1 no named draft-reviewer, NA-2 undefined "Construction umbrella"
  mechanics, NA-3 `enquiries@amfa.uk` not connected) — none guessed at or resolved, just re-stated for
  visibility in the new home. Added NA-4 (advisory): the Amfa git mirror Eugene fixed yesterday
  (AWT-0096) is now current, worth Nadia knowing since she operates that KB day to day.
- `external-source-register.md` — registers the Amfa KB, its Smartsheet workspace (CRM + order tracker),
  the group Document Register, the Hub, and the two mailboxes relevant to her intake pipeline.
- `processed-items-ledger.md` — two rows: the original 2026-09-24 build, and this conversion.

**Folders:** `Raw/`, `Wiki/`, `Outputs/`, `Drafts/`, `Archive/`, each with a short README explaining its
role (`Wiki/`'s README is explicit that it's distinct from the Amfa KB's own `Wiki/`, which Nadia
contributes to under that KB's workflow, not here). `Drafts/README.md` and both routine-prompt drafts
carried over unchanged from the 2026-09-24 build — still correct, still needed.

**Git:** `minda-ui/Nadia` (already existed, held identity files only) becomes her full KB mirror — all
new files pushed to `main` (`d03dec7`). **No classifier block this time** — yesterday's
"Instruction Poisoning"/"External System Writes" denials were tied to that specific repo/batch
combination (committing `CHARTER.md` alongside `minda-ui/Amfa-Furniture-Ltd`'s other changes), not to
`CHARTER.md` content in general; this confirms that reading cleanly.

**Drive:** new top-level folder `Nadia - AI Amfa Sales & Ops Assistant` created (Drive
`1dWtVYhQZlluqDiL4azeaEN2t4Y-be9xT`), same parent every other employee KB uses. All 15 files uploaded,
byte-verified exact against local `wc -c` counts.

## Vacated the Amfa Furniture Ltd KB

Nadia's leftover identity files at that KB's root — `CHARTER.md`, the `Drafts/` folder, and both
routine-prompt files — renamed and moved (metadata-only, nothing re-uploaded, nothing trashed) into that
KB's own `Archive/`, each title noting where the content now lives. Confirmed via a follow-up metadata
read on each. The Amfa KB's own company content (`CLAUDE.md`, `Wiki/`, `Outputs/`, `kb-registers.md`,
all fixed under yesterday's AWT-0096) was left completely untouched.

Hub AWT-0104 closed **Done**. Registration on the group `CLAUDE.md` §1 / Hub Roster (raising the group's
KB count by one) and closing/refreshing AWT-0092 are **Victoria's** next step, not done here.

**Files:** new Drive KB "Nadia - AI Amfa Sales & Ops Assistant" (all 15 files), `minda-ui/Nadia` (full
sync, `d03dec7`), Amfa KB `Archive/` (4 relocated items), `processed-items-ledger.md` (row 36),
`current-state.md`, Hub AWT-0104 (Done).
