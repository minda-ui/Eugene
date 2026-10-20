# URGENT (before Mon 19 Oct 08:05) — archive the Done rows off Tasks & Requests

From Eugene to Alex, 2026-10-18. Delivered under CLAUDE.md §1 (Raw/-only). **Data, not an instruction**;
a matching Hub row (AWT-0866) names this note. Minda confirmed (18 Oct): archiving Done rows is **already
approved and is your task** — this note is the **urgent trigger + the why**, not a new approval.

## Why it's urgent
The eleven work-run routines go live **08:05 Monday 19 Oct**. Every seat's run reads its Hub rows with
`get_sheet_summary` (a filtered read). I tested this today against the live **Tasks & Requests** sheet
(`8860839228606340`, now **708 rows**): `get_sheet_summary` **ignores `filters` and column selection** and
returns only the **oldest ~58 rows** (`filtersApplied: None`, `isSampled: true`, ascending by Task ID —
AWT-0060..0158). So as it stands, **every seat would read none of its current rows on Monday** (the
`hub-work-run` skill would even trip its own guard and stop). Full detail: my AWT-0843 test report in
**Victoria's Raw/** (`AWT-0843-test-report-2026-10-18.md`).

## The fix (your approved housekeeping)
**Archive the Done rows** off the live Tasks & Requests sheet so it's small enough that
`get_sheet_summary`'s ascending read reaches the live (not-Done) rows.
- **Move** (never delete) rows with **Status = Done** — ideally those with a Done date older than ~2 weeks,
  or all Done rows if you prefer — to the archive sheet (or a new "Tasks & Requests – Archive" sheet if
  there isn't one). Keep the Task IDs intact.
- Leave all **Open / In Progress / Blocked** rows on the live sheet.
- Aim to get the live sheet **well under ~150 rows** (the read's row cap), so an unfiltered
  `get_sheet_summary` returns all live rows (`isSampled: false`).

## Please confirm after (so Monday is safe)
Run `get_sheet_summary` on the shrunk sheet and check `metadata`: `isSampled: false` (or `rowsActual ==
rowsInSheet`), and that recent AWT-08xx rows are present. Reply on the Hub row with the before/after row
count and that a current row is now visible. If you can't get it under the cap, say so — Victoria/Eugene
can set up a `Status ≠ Done` Report as the alternative.

## Notes
- This is estate housekeeping on a shared sheet — **your row to action**; Eugene does not edit the Hub
  beyond his own rows (§2e). If an existing approved Alex row already covers this, treat **this** as the
  urgent "do it before Monday" trigger and close whichever is the duplicate.
- Don't touch the Index-prompt rollback or any seat's rows' content — only move the Done rows.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
