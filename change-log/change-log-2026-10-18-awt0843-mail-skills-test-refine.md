# Change log — 2026-10-18 — AWT-0843: test + refine the four mail/procedure skills

Guide-only (§3): Eugene tested the skill text against the real tool schemas and corrected it; Minda
re-uploads; no live mailbox, sheet, routine or site touched.

## Context
Minda's 18-Oct idea: skills that carry out a procedure (mechanics only; read the procedure at run time;
inert while it's Draft). Victoria built the first set for the approved **Mail & requests procedure
(P07-L1 v0.2)** — `mail-triage-by-labels` (Peter), `mail-work-from-labels` (seats), `ask-minda` (all),
`hub-work-run` (all; extends hub-close-on-finish) — and handed AWT-0843 to Eugene to **test + refine**
(due ~Mon/Tue; the work-run routines go live 08:05 Mon 19 Oct).

## The big finding (urgent — Monday)
`get_sheet_summary` **ignores `filters` and column selection** on the 708-row Tasks & Requests sheet
(`8860839228606340`): `filtersApplied: None`, `isSampled: true`, returns only the oldest ~58 rows.
Verified four ways (filters with `=` and `EQUAL`, columnIds, sort). So "read your rows via get_sheet_summary
filter" shows a seat **none of its current rows** → `hub-work-run` would raise a Help & Lessons row and
stop every run → no seat works its mail/tasks on Monday. `find_in_sheet` is reliable (substring + **offset
paging**; the "first-100-only" claim is wrong). Recommended fix (pre-Monday decision): **archive Done rows**
so the live sheet is small, **or** a `Status ≠ Done` **Report**. Flagged to Minda in chat + on the Hub row.

## Other corrections (folded into v1.1)
- Gmail tool **names all correct**. Arg-level fixes: `label_thread`/`unlabel_thread` take **labelIds** not
  names (resolve via `list_labels`); Gmail search matches labels by **name**; `create_label` uses
  **`displayName`** (auto-creates the `FG` parent); `search_threads` previews oldest messages + defaults 20
  (max 50) → **paginate + `get_thread`**; `create_draft` `to` is an **array** + **`replyToMessageId`** for
  reply drafts, `body` plain text.
- `update_rows` uses `id` (not `rowId`) — was already right. Verify the referenced sheet ids (Procedure
  Register `4244584085456772`, Known Correspondents `4944990306436996`, Audit Trail `3256140446173060`);
  the Draft/Approved gate works off the procedure **file header** regardless.
- **hub-close-on-finish:** recommend **retire** once `hub-work-run` is proven (superset); keep both for the
  pilot week; mark superseded in the library INDEX.

## Scheduled-run proof (open point)
Interactive sessions **do** load the account's synced shared skills (this session shows
`anthropic-skills:raw-handoff-to-employee` / `…:drive-sync-verified`). The four new skills aren't uploaded
yet, so they couldn't be executed live. A one-shot scheduled test (prompt names the skill it loaded) is
ready for **Tue 20 Oct** once Minda uploads. If scheduled runs can't load skills, the standard's inline
fallback keeps Monday safe.

## Delivered
Corrected **v1.1** SKILL.md ×4 + the test report → **Victoria's Raw/** (byte-verified; report Drive
`1-o1tsrznjWZ08vhG7wiSY7IGlIUBaUqA`). Hub AWT-0843 → In Progress with the full PROGRESS line. Ledger 126.

## Next
1. The Monday row-read fix (archive Done rows / Report) — decision + action before 08:05 Mon.
2. Minda re-uploads the v1.1 files.
3. Scheduled-run live proof Tue 20 Oct.
4. hub-close-on-finish retire at the 26-Oct review.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
