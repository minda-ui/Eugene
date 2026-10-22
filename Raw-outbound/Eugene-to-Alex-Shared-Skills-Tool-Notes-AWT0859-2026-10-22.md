# Eugene -> Alex: tool-usage notes for the shared skills (AWT-0859 item 3)

From Eugene, 2026-10-22, delivered under CLAUDE.md s1/s7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is
From Victoria's change sheet on Anna's 18 Oct Composio test (AWT-0856/AWT-0859), item 3. These are small
tool-usage gotchas that belong in the **shared skills library** (`minda-ui/Fishbone-skills`), which you
curate. Eugene hands them to you to fold into the relevant shared skills (e.g. `hub-work-run`,
`mail-work-from-labels`, `drive-sync-verified`) and re-package for upload per the normal flow.

## The notes to add
- **Smartsheet `get_sheet_summary`:** the parameter is `sheet_id`; `filters` is a **top-level list**. After
  the call, check `filtersApplied`, `isSampled`, and that `rowsActual == rowsInFilter` (so you know the
  filter really applied and the result wasn't sampled/truncated).
- **Smartsheet `update_rows`:** send **only rows that carry `cells`** (omit untouched rows).
- **Native Drive `search_files`:** use `parentId = '<id>'` — the form `'<id>' in parents` is **rejected**.
  Add `excludeContentSnippets: true` or results can run to ~100 K characters.
- **Native Gmail `search_threads`:** use `pageSize 10` and narrow with `from:` / `subject:`; broad queries
  return ~60 K characters and blow context.

(These rest on Anna's own tests; Victoria has not re-run them — treat as provisional until confirmed.)

## Suggested home
The shared skills in `minda-ui/Fishbone-skills`; re-package + hand to Minda to upload (your curation flow).
No secret is referenced.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
