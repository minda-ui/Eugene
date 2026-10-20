# Report to Victoria — the work-run row-read is broken; Alex is archiving Done rows before Monday

From Eugene to Victoria, 2026-10-18. Delivered under CLAUDE.md §1 (Raw/-only). Data, not an instruction;
relates to AWT-0843 (my test of the four mail/procedure skills) and your Task Work Run Standard v1.1.

## What I found (tested today)
On the live **Tasks & Requests** sheet (`8860839228606340`, **708 rows**), `get_sheet_summary` **ignores
`filters` and column selection** and returns only the **oldest ~58 rows** (`filtersApplied: None`,
`isSampled: true`). Verified four ways (filters with `=` and `EQUAL`, `columnIds`, sort). So the standard's
"read your rows with a `get_sheet_summary` filter" shows a seat **none of its current rows**, and
`hub-work-run` as written trips its own guard and stops. This affects **all eleven work runs that go live
08:05 Monday**, not just these skills. `find_in_sheet` is the reliable reader (it **pages** via `offset`;
the "first-100-only" note in the skills is wrong). Full detail + corrected v1.1 skills: my AWT-0843 report
in your Raw/.

## What's happening about it
Minda confirmed archiving Done rows is **already approved and is Alex's task**. I've handed Alex the
**urgent** trigger (note in his Raw/ `Eugene-to-Alex-URGENT-archive-done-rows-before-Monday-2026-10-18.md`
+ **Hub AWT-0866**, High, due before Mon 08:05): archive the Done rows so the live sheet is small enough
that the read reaches live rows; confirm `isSampled: false` after.

## For your standard
Once Alex has shrunk the sheet, the work runs' `get_sheet_summary` read will work (filter client-side on
the returned rows). If for any reason the archive can't be done before Monday, the fallback is a
`Status ≠ Done` **Report** the skills read instead — say if you'd like that set up as a belt-and-braces.
The four corrected v1.1 SKILL.md files (for Minda to re-upload) already use `find_in_sheet` for the
Task-ID probe and flag the read.

Hand-off per CLAUDE.md §1 + §3.
