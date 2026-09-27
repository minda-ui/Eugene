# Daily summary — 2026-09-27

_A single roundup of today's work, tying together the individual dated change-log entries. Not a
replacement for them — each still stands as the full record of its own task._

## At a glance

| # | Work | Hub / OI | Outcome |
|---|---|---|---|
| 1 | Git mirror resynced to Drive; `main` corruption found and fixed | OI-12 | Resolved |
| 2 | Rule F folded in; Task Check-in routine documented in `CLAUDE.md` §5 | AWT-0133 | Done |
| 3 | `Charter-Rules.md` adopted (Rule F confirmed live everywhere) | AWT-0145 | Done |
| 4 | Composio rollout: CLI, login, Drive link, two write tests | AWT-0155 | Done |
| 5 | SessionStart hook auto-installs Composio; PR #1 merged | AWT-0155 | Merged |
| 6 | Branch consolidation; session log merged in PR #2; all side branches gone | OI-10 duty | Done |

## 1. Git mirror resync and `main` corruption (OI-12)

- An automated merge (`4cfb181`) folded 10 stray Task Check-in branches into `main`, then a follow-up
  commit (`cd246b9`) resynced the git mirror from the live Drive KB.
- A later session cross-checked a Raw/ note against the repo (Rule C) and found the merge had
  **regressed** real content: consolidation runbook v0.4 → v0.1, SRC-9–12 lost, typos in `CLAUDE.md`
  and `Infra-Inventory/`, three change-log entries mistyped or truncated.
- Fixed forward: restored the seven files from the last known-good commit, history left intact.
  Kept the good new content (Minda's `.claude/settings.json` Composio permissions, `e31f34c`).
- Full record: `change-log-2026-09-27-main-branch-corruption-found-fixed.md`.

## 2. Rule F and the Task Check-in routine (AWT-0133)

- **Rule F** (Minda, estate-wide): any change to a shared space must be registered on the Hub and
  broadcast via `Raw/` to everyone it affects. Added to `Charter-Rules.md`.
- `CLAUDE.md` §5 corrected: it claimed Eugene runs no unattended system-changing routine; the live
  "Eugene — Task Check-in" (`trig_01Q6nS5UKzQFRfGsQnQLKiQX`, weekdays 09:30 UTC) contradicted that.
  Documentation fix only. Hub AWT-0133 closed Done.
- Recorded in `Charter-History.md` and ledger row 41.

## 3. `Charter-Rules.md` adopted (AWT-0145)

- Minda: "adopt Charter-rules.md." Checked first: Drive, branch and `main` already byte-identical
  (`Charter-Rules.md` 6135 B, `Charter-History.md` 10476 B, `CLAUDE.md` 20645 B). Nothing to edit.
- Hub AWT-0145 (Alex: fold Rule F in + read the Hub-changes broadcast) closed Done.
- Rule A Hub check run; open rows listed under "Still open" below.

## 4–5. Composio rollout (AWT-0155)

Source: Alex's `Raw/2026-09-27_Proposal_Composio-Rollout.md`, Minda-approved. Every step at Minda's
explicit instruction.

- CLI installed, pinned `@composio/cli@0.4.1`; login authorised by Minda; verified as
  minda@fishboneconstruction.co.uk / org `minda_workspace` / human account.
- Linked **`eugene-googledrive` only** — Gmail left out (charter §1: Eugene is not an email agent).
- Proved with a read and two real writes through Composio (`external-source-register.md` + SRC-13;
  `current-state.md`), archive-then-recreate, Drive md5 = local md5, download round-trip identical.
- SessionStart hook now installs the pinned CLI on every web session —
  [minda-ui/Eugene#1](https://github.com/minda-ui/Eugene/pull/1), merged (`61055ca`). Login and link
  still need Minda's browser approval per new container; no credential in the repo.
- Hub AWT-0155 closed Done. Full record: `change-log-2026-09-27-composio-rollout.md`, ledger row 42.

## 6. Branch consolidation (`Runbooks/Runbook-Branch-Consolidation.md`)

- Minda: "prepare all branches to merge with main." `git fetch --all --prune` found 11 side branches;
  10 were already fully contained in `main` (checked with `git merge-base --is-ancestor`).
- The one branch ahead (this session's log commit) went up as
  [minda-ui/Eugene#2](https://github.com/minda-ui/Eugene/pull/2) — merged (`10bd16f`).
- Afterwards all 11 side branches were deleted from `origin`; only `main` remains. Nothing was lost —
  each was confirmed contained in `main` before removal.

## Still open (carried forward)

| Item | Priority | Needs |
|---|---|---|
| AWT-0121 — M365 cancellation impact check | High | Eugene (next) |
| AWT-0090 — revoke Rachel's M365 scopes in Entra ID | High, due 09-29 | Tenant admin |
| AWT-0118 — group KB Drive ↔ git reconcile (add Nadia) | Medium | Eugene |
| AWT-0132 — Google Ads + GTM access for Helen | Medium | Eugene + Minda |
| AWT-0135 — Composio for the group KB seat | Medium | Fresh session on group repo `main` |
| AWT-0060 / AWT-0101 | Medium | Blocked (empty Anna repo; Minda's tests) |
| OI-7 / OI-8 — phone system backup; SIP trunk outage | Critical | Contractor + WebMate replies |
| SRC-13 wording ("unless added to the SessionStart hook" — now it is) | Low | Next write of that file |
| Expired unaliased Composio Drive connection `googledrive_tute-sassy` | Low | Minda's own terminal |
