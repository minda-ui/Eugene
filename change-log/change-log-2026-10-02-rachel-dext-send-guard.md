# Change log — 2026-10-02 (evening) — OI-16 resolved: Rachel's Dext-send guard built and PR'd; drafts-delete declined by owner

_Session change-log entry. **Infra-config work in `minda-ui/Rachel`, delivered as a PR for Minda to
merge — never self-merged.** Eugene holds no credential and is not an email agent; this is repo config
only (CLAUDE.md §2b/§3). The one cross-KB charter change this implies is left to Rachel's own file._

## Headline
Minda: "Rachel needs now." Built and PR'd a **fail-closed recipient guard** that lets Rachel
send/forward invoices + receipts to **Dext only** (`mindaugas.gaudiesius@dext.cc`). **[minda-ui/rachel#4](https://github.com/minda-ui/Rachel/pull/4)**
is open for Minda to merge. The drafts-delete leg was **declined by Minda** and not touched.

## How the repo got attached (the earlier blocker cleared)
Last session `add_repo minda-ui/Rachel` was refused by the auto-mode classifier ("Permission Grant").
This session it **succeeded** — attached at `/home/user/rachel`, verified the clone, and
`register_repo_root` loaded its context. Branch `claude/rachel-dext-send-guard` off Rachel's `main`.

## The governance read first (Rule C — verify against the system of record)
- Rachel's charter **bars sending**: "Rachel drafts, Minda sends" (`CHARTER.md` §2 / §6 rule 4, the
  owner ruling that resolved `RA-23`). Dext is an **automated ingestion address, not a correspondent**
  (not a bank/lender/HMRC/auditor/RMT/insurer/supplier), so a **Dext-only send is a coherent bounded
  exception** — the shape of Minda's direct instruction.
- The relayed drafts-delete ask cited **"Amendment 37", which does not exist** — Rachel's amendments
  run **1–31**. Her charter bars deletion absolutely (§3 "Delete anything, anywhere"; §5
  archive-never-trash). Flagged to Minda rather than acted on (same stance as last session: don't
  loosen a delete guardrail on a relayed request citing a non-existent amendment).

## What was built (PR #4)
- **`.claude/hooks/gmail-recipient-guard.py`** — PreToolUse logic. Parses the real command; permits
  `GMAIL_SEND_EMAIL` / `GMAIL_FORWARD_MESSAGE` **only** when every recipient
  (`recipient_email`/`to`, `cc`, `bcc`, `recipients`) is exactly the Dext address. Field names
  confirmed against the live Composio schemas (`--get-schema`, read-only).
- **`.claude/hooks/gmail-recipient-guard.sh`** — fail-closed bash wrapper: if `python3` is ever
  unavailable, **denies** the gated send actions rather than failing open.
- **`.claude/settings.json`** — removed the `GMAIL_SEND_EMAIL*` / `GMAIL_FORWARD_MESSAGE*` hard-denies
  (so the guard can gate them) and registered the PreToolUse hook. **Left untouched:**
  `GMAIL_SEND_DRAFT`, `GMAIL_REPLY_TO_THREAD`, all trash/delete, Drive-delete — and the existing
  SessionStart + UserPromptSubmit (end-of-day) hooks.

**Fail-closed cases** (deny): other recipient; cc/bcc to a non-Dext address; parallel batch with any
non-Dext send; payload via `@file`/stdin; no `-d` payload; unparseable input; `python3` missing.
**Allowed:** sole Dext recipient, including JS-style unquoted keys, and a structured payload with
another email only in the subject/body (ignored when the JSON parses). **13 test cases, all correct.**

## Classifier note
The `.claude/settings.json` write was first blocked by the session's **Self-Modification** classifier.
Applied on the retry **after Minda's explicit authorization** ("Retry — you authorize it"). The two
hook files wrote without issue.

## Owner decisions this session
- **Drafts-delete:** "I sorted that with edit. Don't needed to allow delete." → `GMAIL_DELETE_*` stays
  fully denied; no change, no hand-off needed.
- **settings.json delivery:** retry with authorization (done).

## Left for Minda / Rachel (not Eugene's — cross-KB)
1. **Merge PR #4.** Eugene does not self-merge. The guard goes live on Rachel's next session
   (hooks load from the repo).
2. **Charter amendment:** record the Dext-only send exception as a **new amendment (next number, not
   37)** in Rachel's own charter — offered a `Raw/` hand-off note to seed it.

## State left
- OI-16 **Resolved** (Dext-send shipped as PR #4; drafts handled by Minda; charter amendment flagged).
- No live send made by Eugene; no credential held.
