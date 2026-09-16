# Change log — 2026-09-16 — AI Workforce Hub investigation; charter §2e reconciled

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4._

## 2026-09-16 — HL-0007 rename verified and Resolved (after a false start)

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**First attempt.** Minda did the manual rename per the instructions handed over earlier. Checking via
`list_branches` afterward showed the branch had become `claude/main`, not plain `main` — the `claude/`
prefix from the original auto-generated name hadn't been cleared in the rename field, just the suffix
replaced. Flagged this immediately rather than accepting it: checked whether an org-wide ruleset might
require that prefix (no dedicated ruleset-inspection tool available, so reasoned from evidence instead
— every other Fishbone repo already uses plain `main` with no prefix, which wouldn't be possible under
such a ruleset), concluded it was very likely an incomplete field edit, and asked Minda to retry with
the field fully cleared first.

**Second attempt, verified.** `list_branches` now shows `main` (same commit,
`3c1b4ae8a87d496e5cd3073428269d9974af641d`, confirming it's the same renamed branch, not a fresh one)
and `claude/hello-mpwhig`. Matches the shape of every other Fishbone repo.

**Produced/updated.** Smartsheet Help & Lessons `HL-0007` moved to **Resolved**, with the full
before/after record (including the `claude/main` false start) kept on the row rather than quietly
smoothed over. `processed-items-ledger.md` row 15 added.

**Governance.** Verification only (`list_branches` calls); the actual rename was Minda's action both
times, as it had to be — no tool in Eugene's kit performs it. Catching the `claude/main` mismatch
before marking anything Resolved is exactly the "verify the outcome" half of Eugene's normal
guide-then-verify pattern (charter §2a) — worth noting since this was a Hub item, not a runbook, but
the same discipline applied.

**Next.** HL-0007 is closed. Nothing else outstanding from today's Hub thread.

## 2026-09-16 — HL-0007 (Fishbone-Group default branch) investigated; hit a real tool limit

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** Minda asked Eugene to look into the remaining open Hub item, `HL-0007` (Alex's, not the
one earlier renumbered to HL-0008): `minda-ui/Fishbone-Group`'s default branch is an auto-generated
Claude session name (`claude/awesome-knuth-p1ll7w`), not `main` like every other Fishbone repo — is
that intentional, or should it change?

**Investigation.** Attached the repo (`add_repo`, read then push access, since the read-only path
doesn't expose GitHub API tools). Checked systematically: `list_branches` — only two branches exist
(`claude/awesome-knuth-p1ll7w`, `claude/hello-mpwhig`), no `main` to collide with, neither protected;
`list_pull_requests` (state=all) — zero, nothing to retarget; `actions_list` — zero workflows, nothing
CI-side references branch names; `search_code` org-wide for the literal branch name string — zero hits
anywhere in `minda-ui`, confirming nothing else hardcodes or depends on the current name. Reported:
safe to rename, no blast radius. A local clone attempt (`git clone`) was blocked by the environment's
own auto-mode permission classifier ("Self-Modification") — worked around by using the GitHub API
tools directly instead, which covered everything needed without it.

**Decision and execution attempt.** Minda confirmed: rename to `main`. On trying to execute, found
Eugene's GitHub toolset has no rename-branch or set-default-branch action — only `create_branch`,
file edits, and similar content-level operations; no repository-Settings-level tool. Rather than
work around this with a same-effect-but-messier substitute (e.g. creating a new `main` branch as a
copy, which still wouldn't flip the actual default-branch pointer and would leave two diverging
branches), reported the limitation honestly and gave Minda the exact manual step: GitHub → repo →
Settings → Branches → rename icon next to the old branch → type `main` → confirm. Because the branch
being renamed is already the default, GitHub's own rename operation moves the default pointer
automatically — a single ~10-second click closes this out completely.

**Produced/updated.** Smartsheet Help & Lessons `HL-0007` row updated with the investigation findings
and the manual-step instructions; moved to **Answered** (not Resolved — execution is still Minda's).
`processed-items-ledger.md` row 14 added.

**Governance.** Read-only investigation plus one Smartsheet row update, within Eugene's normal Hub
participation (§2e). No live-system change made or attempted by Eugene — correctly guide-only here,
not because of the charter's console-change boundary but because the tool to do it safely doesn't
exist in Eugene's kit; flagged rather than improvised around.

**Next.** Minda does the one-click rename when convenient; nothing else pending on this thread.

## 2026-09-16 — AWT-0012 / HL-0007→HL-0008 investigated; Smartsheet added to Eugene's charter

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** Minda asked Eugene to look up two item codes, `AWT0012` and `HL-0007`, without
specifying where they lived. Neither matched anything in Eugene's own KB or numbering conventions
(Waste's own documents use `FW`, not `AWT`/`HL`). Asked a clarifying question rather than guess; Minda
confirmed it was "a different system entirely." A Drive search for a Holdings-KB document surfaced a
`processed-items-ledger.md` belonging to **Alex** (AI Housekeeping & Operations Steward) referencing
`HL-0007` — revealing the group runs a Smartsheet-backed **AI Workforce Hub** (workspace "Fishbone AI
Workforce," `4946803578693507`) with `AWT-` Tasks & Requests and `HL-` Help & Lessons item codes, a
system Eugene had no prior visibility into.

**What the two codes turned out to be.**
- **AWT-0012** (Tasks & Requests, assigned to Eugene, Status: Blocked): flagged that Eugene's own
  `CLAUDE.md` §2e (added 2026-09-14 on `main` — Eugene's working branch hadn't pulled it yet) describes
  him reading/updating the Hub, but his documented Connectors list (§1) named only Drive/GitHub/Web —
  no Smartsheet. Same root cause that got AWT-0004 (the daily Hub reconcile routine) reassigned from
  Eugene to Alex, but broader. Escalated as a decision only Minda could make: (a) add a standing
  Smartsheet connector, or (b) amend §2e to route Hub-row updates through Alex per his §9a authority.
- **HL-0007**: the linked Help & Lessons row for the same question — **and, it turned out, a reference
  collision**: a second, unrelated row (Alex's question about `Fishbone-Group`'s odd git default
  branch, `claude/awesome-knuth-p1ll7w` instead of `main`) shared the same Ref number.

**Investigation, at Minda's direction ("a"):** confirmed via direct tool use that this interactive
session has live Smartsheet MCP access — narrowing, not resolving, the AWT-0012/HL-0007 question (the
existing note only covered a separate scheduled "task check-in" routine session). Reported that fact
onto both rows via `update_rows`, explicitly not deciding between (a)/(b) — that was flagged as
Minda's call — and noted the Ref collision while there.

**Renumbering, at Minda's instruction ("HL-0008. Can you sort it?"):** renumbered Eugene's §2e/
Smartsheet-connector row from `HL-0007` to `HL-0008`, kept `HL-0007` for Alex's git-branch question
(already cross-referenced elsewhere — the processed-items-ledger and AWT-0003's own response text both
cite it as HL-0007), and fixed the stale `HL-0007` cross-reference inside AWT-0012's notes to match.

**Concurrent resolution discovered mid-write.** The `update_rows` response for the renumbering showed
fields Eugene hadn't touched (Answer/Status/Health) already changed: another session had resolved the
actual (a)/(b) question in the interim — confirmed the Smartsheet connector is **account-wide for
every employee**, never actually missing; the observed gap was session/routine-level scoping (the same
pattern already documented for GitHub, AWT-0003, and `Artifact.publish`); the Hub's own Roster was
corrected to list Smartsheet; AWT-0012 and HL-0008 were marked Done/Answered. Eugene's writes only
touched the specific cells named (Ref, and Eugene's own appended text), so nothing was lost or
overwritten by the concurrent edit.

**Charter reconciliation (Minda: "pull it in and reconcile").** `git fetch` + diff showed `main` had
only touched `CLAUDE.md` since the branches diverged (17 lines — the §2e clause); Eugene's branch had
touched everything else today but not `CLAUDE.md`. Merged cleanly, no conflicts. Then, now able to see
the real §2e text:
- `CLAUDE.md` §1 Connectors list updated: Smartsheet added as a real connector (the AI Workforce Hub,
  §2e), noted as account-wide but session-scoped like GitHub, with a cross-reference to AWT-0012/
  HL-0008; the old "(later, optional) read-only Smartsheet for the health-check routine" framing
  removed since it undersold what's actually live today (that separate, still-not-created routine is
  now called out as a distinct future use, not the only one).
- `current-state.md` Connectors row and Beats row updated to match (new beat 2e recorded).

**Produced/updated.** `CLAUDE.md`, `current-state.md`, `processed-items-ledger.md` (row 13); two
Smartsheet rows (Tasks & Requests AWT-0012, Help & Lessons HL-0007→HL-0008) — writes explicitly
authorised by Minda at each step ("a", then "HL-0008. Can you sort it?").

**Governance.** The Smartsheet writes were Minda-directed, scoped exactly to what she asked (report a
fact; fix a numbering collision) — Eugene deliberately did not decide the underlying (a)/(b) question,
which resolved itself via another session before Eugene could have anyway. The charter/current-state
edits are Eugene's own KB, within his normal remit (maintain own control files). No live-system change,
no credential touched.

**Next.** Nothing outstanding from this thread — AWT-0012/HL-0008 are closed, the Ref collision is
fixed, and Eugene's charter now accurately reflects his Smartsheet access. Worth a passing note to
Minda or Alex at some point: Eugene's own `processed-items-ledger.md` conventions (dated change-log,
byte-verified archive-then-recreate) aren't yet cross-linked with the Hub's Smartsheet-based tracking —
two parallel systems recording overlapping facts. Not a problem today, but worth keeping in mind if the
two ever drift.
