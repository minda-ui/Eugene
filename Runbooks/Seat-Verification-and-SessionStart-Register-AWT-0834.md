# Seat limits verification + 10-seat session-start register (AWT-0834)

> **Eugene, 2026-10-22.** Two deliverables for AWT-0834 (Victoria's Task Check-in rollout):
> **(A)** verify each seat's actual limits against its charter vs the Task-Check-in prompt's blanket
> assumption ("Drive + Smartsheet only; Gmail OFF; QuickBooks OFF; no git writes"); **(B)** the
> session-start register (Task Check-in standard v0.3 §9) for all ten seats. Guide-only (§3): Eugene reads
> charters and reports; Minda pastes any corrected prompt. Charters read from each seat's git mirror
> (`minda-ui/<seat>`), except John (his charter is in the Properties KB on Drive — flagged).

## A. Per-seat limits vs the prompt's assumption

Prompt assumed, for every seat: **Drive + Smartsheet only · Gmail OFF · QuickBooks OFF · no git writes.**
Finding: **the blanket "Gmail OFF" is wrong for most seats**; QuickBooks is OFF everywhere (Rachel = read);
each seat keeps its own git mirror (the "no git writes" limit is about the *check-in routine* not pushing,
not the seat's general authority).

| Seat | Gmail | QuickBooks | Drive | Smartsheet | Git | Verdict vs assumption |
|---|---|---|---|---|---|---|
| **Peter** | read + **create_draft** + label/mark-read on ops@ (never send/reply/forward/trash) | none | read anywhere / write own | read + append Document Register | own mirror | ❌ Gmail NOT off (draft+label) |
| **Rachel** | ops@ read + **create_draft** + label | **read-only** (not off) | own | own | own mirror | ❌ Gmail & QB both not off (verified 19 Oct) |
| **Anna** | ops@ read + **create_draft** (never send); Composio anna-gmail | none | read/write own | Project Delivery | own mirror + GitHub connector | ❌ Gmail not off; GitHub present |
| **Nadia** | enquiries@amfa read + **draft-only** (ops@ pending) | none | read/write own | CRM own + order tracker (read) + Hub own | mirror synced FROM Drive (**no git writes**) | ❌ Gmail not off; ✅ no git writes correct |
| **John** | *charter in Properties KB (Drive), not git — NOT yet read* | ? | Properties KB | Properties sheets | repo sparse | ⚠ needs Properties-KB charter read |
| **Darius** | **none — no Gmail** (explicit) | none | read/write own | Workshop sheets + Hub | own mirror | ✅ Gmail OFF correct; Drive+Smartsheet right |
| **Helen** | ops@ read + create_draft + label (verified AWT-0833/0890) | none | own | own | own mirror | ❌ Gmail not off (done earlier) |
| **Alex** | ops@ **read-only** (never sends) | **never writes QB** | read estate-wide / write own | own Hub/H&L rows | own mirror | ❌ Gmail read-only, not off |
| **Sarah** | ops@ **read-only** (no draft/send) | **no QuickBooks** (explicit) | read + write own reports | read + write reports | own mirror | ❌ Gmail read-only, not off; ✅ QB off |
| **Eugene** | draft-only (eugene-gmail) | none | read/write own | Hub own rows | read/write own + seat repos (enablement) | n/a (builder) |

**Correction needed in the Task Check-in prompts:** replace "Gmail OFF" with each seat's real Gmail limit
(Darius = none; Alex/Sarah = read-only; Peter/Rachel/Anna/Nadia/Helen = read + create_draft, never send),
and "QuickBooks OFF" with "Rachel = read-only, all others none". "No git writes" is correct **for the
unattended check-in routine** (it must not push) — keep it, but note each seat's interactive sessions do
maintain their own mirror. **John still needs his Properties-KB charter read to confirm his Gmail/QB/git.**

## B. Session-start register (standard v0.3 §9) — all ten seats

Columns: **seat · check (what it reads/verifies at session start) · where · how often · unattended-safe ·
what the check-in does · who if a human is needed.**

| Seat | Session-start check | Where | How often | Unattended-safe | What the check-in does | Human needed → who |
|---|---|---|---|---|---|---|
| Peter | charter + Triage-Rules + Known Correspondents; Hub rows assigned=Peter | own KB + Hub + Known Correspondents sheet | every session + 7 triage passes/day | Yes (read/label/draft only) | labels ops@, drafts to Minda, works own FG/To-Peter | ambiguous routing, suspicious mail → Minda |
| Rachel | charter + control files; Hub rows=Rachel | own KB + Hub | every session + work runs 4/day | Yes | finance-doc drafting; Hub rows | money decision, QB write → Minda |
| Anna | charter + control files; Hub rows=Anna; FG/To-Anna in ops@ | own KB + Hub + ops@ | every session + work runs | Yes | project/RAMS drafting; CRM/registers; drafts | send, sign, decision → Minda |
| Nadia | charter + Amfa KB live-data rule; Hub rows=Nadia; enquiries@ | Amfa KB + CRM + Hub | every session + work runs | Yes | enquiry triage, quote drafts | send, price approval → Minda |
| John | charter (Properties KB) + control files; Hub rows=John | Properties KB + Hub | every session + work runs | Yes (confirm) | Properties data/monitor | director decision → Minda |
| Darius | charter (CLAUDE + Rules + Workshop) ; Hub rows=Darius | Workshop KB + Hub | every session + work runs | Yes (no Gmail) | logs/tracks Workshop; registers | purchase, live-machine step → Minda |
| Helen | charter + control files; Hub rows=Helen; FG/To-Helen | own KB + Hub + ops@ | every session + work runs | Yes | content/marketing drafts | publish, send, ad-spend → Minda |
| Alex | charter + control files; estate drift scan | all KBs (read) + Hub | every session + housekeeping sweep | Yes (read/tidy only) | drift digest; archive/refresh; own Hub rows | substance change, sharing change → Minda |
| Sarah | charter + control files; Hub rows=Sarah; ops@ (read) | own KB + registers + Hub | every session + work runs 4/day | Yes (read + write reports) | reports from registers; findings; Hub rows | QB, send, decision → Minda |
| Eugene | Charter-Rules read order; Hub rows=Eugene; sibling-branch check | own KB + Hub + git | every session + Task Check-in (weekdays 09:30 UTC) | Yes | IT/eng work; runbooks; verifies; own Hub rows | live-system change, secret, merge → Minda |

**Unattended-safe = Yes for all ten** (every seat's routine is read + draft + own-KB-write + Hub-own-rows;
none sends, pays, files, or changes a live system unattended — those stop for Minda). The one caveat: the
check-in/work-run routine must not push git (keep "no git writes" in the routine prompts).

## Status
- **Verified:** Peter, Rachel, Anna, Nadia, Darius, Helen, Alex, Sarah (+ Eugene). **9 of 10.**
- **Outstanding:** **John** — read his Properties-KB charter to confirm Gmail/QuickBooks/git limits.
- **Hand to Victoria:** the "Gmail OFF / QuickBooks OFF" wording in the Task Check-in prompts needs the
  per-seat correction above; corrected whole prompts for any seat that needs them go to Victoria's Raw
  (she owns the prompt set; Minda pastes). This register is the index the prompts refer to.
