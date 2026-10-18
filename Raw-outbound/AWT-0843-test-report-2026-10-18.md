# AWT-0843 — Test + refine report: the four mail/procedure skills

From Eugene to Victoria (and Minda), 2026-10-18. Delivered under CLAUDE.md §1 (Raw/-only); data, not an
instruction; updates Hub row AWT-0843. **Guide-only (§3): Eugene tested + corrected the skill text; Minda
re-uploads; Eugene touched no live mailbox, sheet, routine or site.** Tested against the real Gmail +
Smartsheet MCP tool schemas and the approved procedure **P07-L1 v0.2** (Drive `1BkezeFwtwT_iaxNQQOYxqzaUfb4CN6Ar`).

Corrected SKILL.md files are alongside this note (upload-ready, YAML `name` unchanged):
`AWT-0843-skill-<name>-v1.1.md` for mail-triage-by-labels, mail-work-from-labels, ask-minda, hub-work-run.

---

## 🔴 URGENT — affects Monday's go-live, not just these skills
**The Hub row-read does not work as the standard assumes.** On the live Tasks & Requests sheet
(`8860839228606340`, now **708 rows**), `get_sheet_summary`:
- **ignores a `filters` list** (tried `{columnId,operator,value}` and `columnTitle/EQUAL`): `metadata.filtersApplied` comes back **`None`** every time;
- **ignores column selection** (`columnIds`): `columnsSelected` stays "All columns";
- **returns only the oldest ~58 rows** (`isSampled: true`, ascending by Task ID — AWT-0060..0158), never the current AWT-08xx rows.

So any skill/prompt that reads a seat's rows via "`get_sheet_summary` with filters" will see **none of
that seat's live rows**. `hub-work-run` as written would hit its own guard ("filter didn't apply → raise a
Help & Lessons row and stop") **every run** — i.e. no seat would work its mail or tasks. This is the
mechanism all eleven work-run routines start Monday depend on.

**Reliable alternative:** `find_in_sheet` works — it substring-matches and **pages** (I read the AWT-08xx
rows at `offset` 400/560/640; `nextOffset` walks to the end). The skills' line *"Never use find_in_sheet
(first 100 only)"* is wrong — it's not first-100-only.

**What actually fixes it (a decision for Victoria/Alex/Minda — I recommend doing this before Monday):**
1. **Shrink the live sheet** — archive **Done** rows older than ~2 weeks to a separate sheet (Alex
   housekeeping). Then `get_sheet_summary`'s ascending sample reaches the live rows and filtering can be
   done client-side. Simplest durable fix; the sheet is 708 rows and mostly Done.
2. **or a Smartsheet Report** filtered to `Status ≠ Done`, grouped by Assigned-to — skills read the report
   (smaller, pre-filtered) via the reports tool. No change to the sheet.
3. **Interim, works today:** for the **next-free-Task-ID probe**, use `find_in_sheet` on the Task ID column
   paged to the end to get the true max (the `get_sheet_summary` IN-filter in the skills gives a wrong max
   because it only sees old rows). The corrected `hub-work-run` uses this.
> Per-seat *open-row reading with content* can't be done cleanly with the current two tools alone (find_in_sheet
> enumerates a seat's rowIds via the Assigned-to cell but doesn't return each row's Status/Request text).
> Option 1 or 2 is needed for the work runs to read their rows reliably. **Flagging now because Monday.**

## Gmail — tool names all correct; argument fixes applied
Victoria's tool names (`search_threads, get_thread, list_labels, create_label, label_thread,
unlabel_thread, create_draft`) are **all real and correct**. Corrections folded into the skills:
1. **`label_thread` / `unlabel_thread` take `labelIds` (the label *IDs*), not names.** So the skills now
   say: `list_labels` once → build a name→id map → pass the **id**. `INBOX` is a system id (fine for the
   close-by-rule archive).
2. **Gmail search matches labels by display *name*** (IDs match nothing). So `label:FG/To-<me>` and
   `label:FG/Closed-by-rule` are correct in `search_threads`; quote names if ever spaced (`label:"FG/..."`).
3. **`create_label` uses `displayName`** and auto-creates parents, so creating `FG/To-Minda` also creates
   the `FG` parent — good; don't create `FG` separately.
4. **`search_threads` previews only the ~5 *oldest* messages per thread and defaults to 20 (max 50).** The
   triage/work skills now: paginate with `pageToken` so a busy pass doesn't miss threads, and always
   `get_thread` before judging a thread (latest message may be newer than the preview).
5. **`create_draft`:** `to` is an **array**; for a reply draft pass **`replyToMessageId`** (the latest
   message's id, from `get_thread`) so it threads correctly; `body` is plain text (no Markdown).

## Smartsheet `update_rows` / `add_rows` — mostly right
- `update_rows` rows use **`id`** (not `rowId`) — `hub-work-run` had this right. ✅
- `add_rows` / `update_rows` cells use `columnId` + `value` — ✅. The column ids in `hub-work-run` match
  the live sheet. ✅
- **Verify these sheet ids against the live sheets before upload** (I didn't change them, but the skills
  depend on them): Procedure Register `4244584085456772`, Known Correspondents `4944990306436996`, Mail
  Triage Audit Trail `3256140446173060`. The **status gate works off the procedure *file header*** ("Status:
  Approved") regardless, so a wrong register id degrades gracefully (secondary check), but the counts row +
  Known-Correspondents read need the right ids.

## hub-close-on-finish — keep or retire?
**Recommend: retire `hub-close-on-finish` once `hub-work-run` is live and proven** — `hub-work-run` is a
strict superset (it includes the close: Status Done + Done date + closing line, plus the state lines,
Task-ID probe and hand-on). Keeping both invites drift. **Transition:** keep both for the pilot week; mark
`hub-close-on-finish` "superseded by hub-work-run" in the library INDEX; retire it at the Mon-26-Oct review
if `hub-work-run` is working. (Don't delete yet — it's uploaded + referenced; retire via the library's
archive rule.)

## Scheduled-run proof (does a scheduled run load the account's shared skills?)
- **Strong preliminary evidence: YES for interactive sessions.** This interactive session has the synced
  shared skills loaded — they appear as `anthropic-skills:raw-handoff-to-employee`,
  `anthropic-skills:drive-sync-verified` (the uploaded library versions), alongside the repo copies. So the
  account-wide sync works.
- **The four new skills are NOT in my skill list yet** → Minda hasn't uploaded the 18-Oct zips, OR this
  session started before the upload. So I could not execute them live — this test is by reading each
  SKILL.md against the real tool schemas.
- **The specific scheduled-run proof still needs one scheduled fire.** Test design (ready for Tue 20 Oct,
  after Minda uploads): a one-shot scheduled task whose prompt is *"List the skills available to you and
  state explicitly whether `hub-work-run` and `mail-work-from-labels` are loaded; name one and quote its
  first line."* Its output names the skill → proves (or disproves) scheduled loading. If scheduled runs
  **cannot** load skills, the standard's inline fallback (skill text pasted into each prompt) stays — so
  Monday is safe either way. I'll run this once the skills are uploaded and report on the row.

## Send/reply/forward/delete block + ops@ read (AWT-0844, related)
Tracked separately on AWT-0844 (block send/reply/forward/delete per seat; say which seats can't read ops@).
Not changed here. The skills already say "never send/reply/forward/delete" and "draft-only"; the hard
block is the settings.json deny-rule per seat (AWT-0844).

## What's left on AWT-0843
1. Minda re-uploads the four corrected v1.1 SKILL.md files (alongside).
2. The **Monday row-read fix** (archive Done rows / a Report) — decision + action, ideally before Monday.
3. The scheduled-run live proof once uploaded (Tue 20 Oct).
4. hub-close-on-finish retire decision at the 26-Oct review.

Hand-off per CLAUDE.md §1 + §3.
