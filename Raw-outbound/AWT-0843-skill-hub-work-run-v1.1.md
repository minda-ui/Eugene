---
name: hub-work-run
description: How to work and close Hub rows in a work run. Use in every run: read your open rows, write DONE / PROGRESS / BLOCKED / NOT MINE lines, hand work to another employee, take a safe new Task ID, and close a row with the right columns. Extends (and is intended to supersede) hub-close-on-finish.
---

# Hub work run (mechanics only)

Rules source: Task Work Run Standard v1.1 (group Outputs, Drive `1ysdjb-vsPIQnmGlp2CXIrvyu93LT1ovN`).
This skill is mechanics only; the standard holds the rules.

## Read your rows (IMPORTANT — the live sheet is large; read it the way that works)
The Tasks & Requests sheet (`8860839228606340`) has ~700+ rows. **On this sheet `get_sheet_summary`
IGNORES filters and column selection and returns only the oldest ~58 rows** (`filtersApplied: None`,
`isSampled: true`). So do NOT trust a `get_sheet_summary` read to show your current rows, and never
conclude "nothing pending" from it.
- **Preferred:** if the estate has provided an **Open-rows source** — a Status≠Done Report, or a live
  sheet whose Done rows are archived off so it is small — read that; it returns your rows with their
  Status and Request. (See the AWT-0843 report: archiving Done rows or a Report is the durable fix.)
- **Interim (works today):** use `find_in_sheet` to enumerate your rows — `{"term":"<You>"}` paged with
  `offset` (0,100,200,… follow `nextOffset` to the end), keep hits whose `columnId` is the Assigned-to
  column (`7765459283347332`) and whose value is exactly `<You>`. Then read each row's current state from
  the Open-rows source above. `find_in_sheet` is reliable and **pages** — the old "first 100 only" note
  was wrong.

## State lines (one per row you touch, newest last)
`<You> <date> <time UK>: DONE | PROGRESS | BLOCKED | NOT MINE - ...`
- DONE: close it (below). PROGRESS: what you produced, where (file name + Drive id), what's left.
- BLOCKED: set Status Blocked; the blocker, who must act, the one thing needed, what you do when it lands.
- NOT MINE: which employee, then hand on.
Never write "received", "not started", "needs a full session". Three PROGRESS runs with no new output →
BLOCKED or NOT MINE. No row of yours goes 24 h without a dated line. The Response cell silently truncates
near 4,000 characters: at ~3,500, move older lines to a file in your KB, link it, keep the latest.

## Update a row
`update_rows`: each row uses **`id`** (the row id, NOT `rowId`); cells use `columnId` + `value`.
Column ids: Status `8891359190189956`, Response `95266167981956`, Done date `2347065981667204`, Due date
`4598865795352452`. Read the row back after; if its Response changed since your run started, re-read
before writing (one writer per row).

## Close
Status Done, Done date today, and a closing line: what was done, where it is, what happens next. Your own
rows only.

## Hand on
A Hub row for them (first line: what's wanted + the done-when; sources; due date; Requested by you) and a
Raw note in their KB's Raw/ (use the `raw-handoff-to-employee` skill). Answer anything handed to you on
your own row and in a note to the sender by your next run.

## New Task ID (collision-safe)
Do NOT rely on `get_sheet_summary` for the max (it only sees the oldest rows → wrong max). Get the true
max with **`find_in_sheet`** on the Task ID column, paged to the end: `{"term":"AWT-08"}` with `offset`
walked via `nextOffset`; the highest `AWT-####` returned is the live max; next free = max + 1.
`add_rows` with that id. **After `add_rows`, read the "⚠ Duplicate Task ID?" cell** (columnId
`838876807169924`): if non-empty, a concurrent writer took it — `update_rows` the Task ID to the next free
one. `add_rows` column ids: Task ID `3261859655976836`, Assigned to `7765459283347332`, Requested by
`2135959749134212`, Request `6639559376504708`, Priority `4387759562819460`, Status `8891359190189956`,
Source `1221166074824580`. Use plain ASCII in cells (write "s1"/"section 1", not the § sign).

## Fallback
If Smartsheet is unreachable, do not claim anything is done — write the line in your own KB log and retry
next run.
