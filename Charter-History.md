# Eugene — Charter History

Append-only dated log of every change to `CLAUDE.md` and `Charter-Rules.md`. Newest at top, same
convention as `change-log/`. Created 2026-09-23 when the single-file charter was split in three.

---

**2026-10-08 — §5: skill-candidate collection + "Good Night" proposal added (Minda's instruction).**
New standing habit: through the day Eugene appends repeatable workflows worth a reusable skill to
`.claude/skill-candidates.md` as `proposed` rows (he does not build them); at **"Good Night"** the
`end-of-day-wrapup` skill shows Minda the list and she chooses which to **adopt** (built next session via
skill-creator) and which to **delete** (row marked, line kept). Implemented in §5 "How Eugene runs", the
`end-of-day-wrapup` SKILL.md (new step 5), and the new `.claude/skill-candidates.md`. §3 safety unchanged;
building a skill is ordinary KB/config work (§2b). See
`change-log/change-log-2026-10-08-skill-candidate-flow.md`.

---

**2026-10-04 — §5: Creative / R&D mode added (Minda's idea).** New standing capability — an **R&D pool**
(`R&D/`) for creative/speculative work, triggered by **"Creative mode"** (ended by **"Normal mode"**)
via a `UserPromptSubmit` hook (`.claude/hooks/creative-mode.sh`). Note added to §5 "How Eugene runs".
Creative mode loosens **scope/formality only** — §3 safety is explicitly unchanged (no live changes,
no secrets, archive-never-trash, cross-KB via Raw/, irreversible actions flagged). Scope: Eugene's own
to start (estate-wide would go via Victoria/Alex); ideas become real only on Minda's approval. Built and
authorized by Minda the same session. See `R&D/README.md` and
`change-log/change-log-2026-10-04-rd-pool-creative-mode.md`.

---

**2026-09-27 — Rule F added: shared-space changes are broadcast and registered.** Owner ruling (Minda,
2026-09-27, via Alex's Raw/ hand-off): "make it as rule across estate, if someone make a changed in
shared space (Smartsheet's or similiar) need to notify everyone and register it." Added to the Hub
Coordination Standard in `Charter-Rules.md` alongside Rules A–D.

**2026-09-27 — §5 corrected: "Eugene — Task Check-in" documented as the live routine it already is.**
Alex's Raw/ proposal (Hub AWT-0133) found §5 still said Eugene "does not run unattended routines that
change systems," directly contradicted by a real routine (`trig_01Q6nS5UKzQFRfGsQnQLKiQX`, weekdays
09:30 UTC, live since 2026-09-15, its own two weeks of change-log history including a 2026-09-23
self-edit to `CLAUDE.md`). Documentation fix only — the routine's actual behaviour and boundaries
(own-row Hub writes, own-KB writes, §3 guide-only limits unchanged) don't change, §5 just now says what
was already true. Verified against this repo's own change-log entries before writing anything (Rule C).

**2026-09-27 — `main` branch corruption found and fixed (OI-12).** An automated merge of old routine
branches (`4cfb181`, landed by another process) regressed real content — see `open-issues.md` OI-12 and
`change-log/change-log-2026-09-27-main-branch-corruption-found-fixed.md` for the full write-up. Fixed by
restoring the affected files from the last known-good commit on top of the merge; history left intact,
nothing rewritten or force-pushed.

---

**2026-09-24 — OI-10 resolved: Option B (periodic branch consolidation) adopted, first run executed.**
Minda decided ("Agree, B is a way forward") to periodically consolidate Eugene's parallel-session git
branches into `main`, rather than leaving them permanently isolated. Added §5 note pointing to the new
`Runbooks/Runbook-Branch-Consolidation.md`, which documents the repeatable procedure. First run executed
the same day: reviewed all 7 sibling branches found via `git fetch --all`; six were fully superseded
single-session snapshots, one (`claude/beautiful-allen-mg6blz`) already folded in via the OI-9 correction
above. `main` fast-forwarded cleanly to this branch's tip (no conflicts — it was already a strict
ancestor); two genuinely-new `change-log/` entries with no later duplicate were pulled in as standalone
files (not full cherry-picks, to avoid regressing current control files to stale snapshots). Sibling
branches left undeleted — flagged to Minda rather than removed unilaterally, per the runbook. Owner-
decided (Minda, 2026-09-24).

**2026-09-24 — AWT-0084: two Authority Register rulings folded into §2b/§3.** Alex delivered a `Raw/`
proposal (Minda's rulings, 2026-09-23, from the estate's Authority Register audit): (1) new-employee
creation now has a named 3-step trigger — Victoria proposes/briefs, Minda approves, Eugene builds — so
Eugene no longer unilaterally decides whether/when to scaffold a new KB, only how; (2) Eugene's
Drive-write-into-a-new-KB step during approved scaffolding is named as the **one explicit exception**
to the group's Raw/-only cross-KB rule, scoped strictly to that step and nothing else. Added to §2b with
a cross-reference note in §3 so the governance boundary doesn't read as contradicting the exception.
Owner-ruled (Minda, 2026-09-23), delivered via Alex's Raw/ hand-off. Closed on the Hub (AWT-0084).

**2026-09-24 — correction: the 2026-09-23 "content-integrity anomaly" was a misdiagnosis, not an
attack.** Session-start Hub check found real Hub rows (AWT-0060/0062/0064, HL-0043/HL-0044) that
exactly matched the content the 2026-09-23 entry below calls fabricated. Investigating found the real
cause: every Claude Code session — interactive or scheduled Hub check-in — gets its own auto-generated
git branch off `minda-ui/Eugene`, and branches never auto-merge. A legitimate parallel session, on
branch `claude/beautiful-allen-mg6blz` (commit `1ac5839`, "Sync charter with Drive; fix Rule C/D
fold-in clash (AWT-0064)"), had correctly restored a real **Rule C — verify against the system of
record** (added 2026-09-21, a real owner-ruled Raw/ hand-off this branch's history never received) after
an earlier fold-in mistake had overwritten it, and relabelled the plain-brief rule **Rule D**. The
2026-09-23 session below checked only its own branch's git history and Raw/ folder, found no
corroboration there, and concluded — wrongly — that the content was unauthorised or fabricated. It
archived the real fix (intact, recoverable, never deleted) and reconstructed the charter from its own
stale knowledge, which reintroduced the exact Rule C/D clash the other session had just fixed.
**Corrected here:** the real Rule C (verify against system of record) is restored in `Charter-Rules.md`,
plain-brief is correctly Rule D, and `CLAUDE.md` §1 now carries a standing note (and `Charter-Rules.md`
Rule C itself) requiring a check of sibling branches (`git fetch --all` + `git log --all`) before any
future session treats unfamiliar Drive content as anomalous. OI-9 (`open-issues.md`) updated to record
this as resolved-by-misdiagnosis; the Hub Help & Lessons row is corrected to match. The 2026-09-22 and
2026-09-23 entries below are left exactly as originally written — an honest record of what was believed
at the time — rather than rewritten, per this file's append-only discipline.

**2026-09-23 — split into three files.** `CLAUDE.md` now holds only the stable identity/role/authority
sections (§1-§5); the session-start read order, the Hub Coordination Standard, and the OI-<n> open
questions moved out to `Charter-Rules.md` in full; this version-history footer moved out to this file.
Reason: every routine change (a new Hub rule, an OI update, a Raw/ fold-in) was requiring the whole
charter (~19KB) to be reproduced and re-uploaded to Drive — Drive's archive-then-recreate model has no
partial-edit primitive, so a one-line change cost as much as a full rewrite. Hit three times in a single
day (2026-09-22/23: Rule C, the financial-documents law, and the Raw/ convention each required a full
`CLAUDE.md` reproduction). Modelled directly on Alex's identical split of her own `CHARTER.md` earlier the
same day (`CHARTER.md`/`Charter-Rules.md`/`Charter-History.md`), itself justified by two disclosed
base64-relay corruption incidents that week on files this size — the same transcription risk applies
here. A rule or OI change now only touches `Charter-Rules.md` (~4KB) plus one line appended here; the
stable core in `CLAUDE.md` is untouched. Owner-directed (Minda, 2026-09-23, following her own review of
Alex's KB). Byte-verified on upload; old single-file `CLAUDE.md` archived intact, nothing lost.

**2026-09-23 — content-integrity anomaly found and reconciled (see `open-issues.md` OI-9).** Before
splitting, the live Drive `CLAUDE.md` was downloaded for a full byte-verified diff (per the archive-
then-recreate discipline in `CLAUDE.md` §1) and found to carry a revision entry with no corresponding
`Raw/` note or git commit: a claimed "Rule C — verify against the system of record before reporting
status" (dated 2026-09-21, citing HL-0023/AWT-0036/AWT-0050) and a claimed "Rule D — plain-brief"
(2026-09-22), plus a note that "a prior attempt at this fold-in overwrote Rule C by mistake; fixed here
2026-09-23." None of this is corroborated: the `Raw/` folder holds only the two notes already logged in
`processed-items-ledger.md` rows 23-24 (Hub Coordination Standard A/B, and Rule C plain-brief — which
`processed-items-ledger.md` row 24 and commit `fbcc2fd` already record as a *fresh* addition, not a
replacement of an existing Rule C), and no ledger row or commit records ever writing a "verify against
the system of record" rule. The Drive file's own createdTime (2026-09-23T09:43:47Z) has no matching
session action. Treated per the corollary now in `CLAUDE.md` §1: unverified content is not adopted.
Archived the anomalous copy intact (never deleted) under `Archive/` for forensics and replaced it with
the verified, ledger-corroborated content (i.e. this split). Raised as **OI-9** and as a Help & Lessons
row on the Hub — an unauthorised or fabricated write reached a governed charter file outside the `Raw/`
channel, the exact failure mode the Raw/-only convention and the self-modification safety classifier
exist to prevent. Flagged to Minda directly rather than silently resolved.

**2026-09-22 — adopted the estate's financial-documents filing law** (policy v1.4 §7b, FG-CR-0001) into
§1. Not an operational change (Eugene handles no financial documents), adopted for the record at Minda's
instruction.

**2026-09-22 — added Rule C (plain-brief)** to the Hub Coordination Standard (§2e): lead with the answer,
cut preamble/filler/hedging/restated context, prefer lists/tables over prose. Applies to every message,
charter, log, Hub row and doc. Delivered via Victoria (AI Workforce Coordinator), Raw/ hand-off.
Owner-authorised (Minda).

**2026-09-20 — added the Hub Coordination Standard** to §2e (session-start Hub check; the Hub as single
home for tasks/lessons/gaps) and recorded that cross-KB amendments — including to this file — arrive via
a `Raw/` hand-off + Hub task, never a direct edit, per an owner ruling delivered through Alex (Housekeeping
& Operations Steward), HL-0023/AWT-0036/AWT-0040. Also folded in an already-live Drive-only passage on
external binary documents (flag oversized fetches to Alex rather than relaying them). Owner-authorised
(Minda).

**2026-09-14 — added §2e** — Eugene's seat on the AI Workforce Hub (updates his own Tasks/Achievements
rows) and the shared Help & Lessons desk (raise problems / log lessons). Owner-authorised (Minda).

**2026-09-13 — §2b delivery convention added** — routine prompts and instruction sets are handed over as
complete, paste-ready replacements, never section deltas, with the canonical current prompt filed in the
employee's KB. Owner preference (Minda).

**2026-09-12 — created.** Reach set by owner to "edit code/repos/KB directly; guide-only for live
systems; never holds secrets"; absorbs the workforce plan's IT/ops slot. Owner-authorised (Minda).

**2026-10-08 — Gmail draft-only capability added (owner-authorised, Minda).** §1 "Connectors / tools"
changed from "No Gmail connector — Eugene is not an email agent" to a **draft-only Gmail** capability: a
Composio connection `eugene-gmail`, OAuth'd by Minda to **minda@fishboneconstruction.co.uk**, lets Eugene
**read and create drafts** for Minda to send herself. **§3 unchanged** — Eugene still never *sends* external
email (drafting is prepare-for-a-human, not sending); enforced belt-and-braces by a `GMAIL_SEND_*`/reply/
forward **deny-rule** in `.claude/settings.json` (deny > allow, so it overrides the broad `composio execute *`
allow). Still not an autonomous email agent. Requested and authorised by Minda, 2026-10-08.
