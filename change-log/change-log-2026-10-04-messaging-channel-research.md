# Change log — 2026-10-04 — Research: Telegram vs WhatsApp messaging channel (parked) + PR #4 (Rachel) confirmed merged

_Session change-log entry. Research/advisory only — no connection made, no live change. Guide-only
boundary noted for when we proceed (the bot/API token is a secret Minda holds; Eugene never types it)._

## Headline
Minda asked about adding a **Telegram bot** MCP connection, then **WhatsApp**, focused on **import/export
of pictures**. Researched both via the Composio toolkits (same Composio Connect MCP the estate uses),
wrote a capability/decision note, and **parked** it at Minda's choice ("just researching for now").

## What was found (probed via `composio ... --get-schema`, 2026-10-04)
- **Telegram:** easy to set up (@BotFather, one token). Can **send** images only by **public URL or
  `file_id`** (no local upload; base64/inline not accepted). Can **see** inbound via `GET_UPDATES`, but
  **no `getFile`/download tool** → can't pull incoming image bytes out via Composio.
- **WhatsApp (Cloud API):** better at **sending** (local `UPLOAD_MEDIA` → `SEND_MEDIA_BY_ID`), but
  **heavy** to set up (Meta Business + WhatsApp Business Account + dedicated business number + tokens),
  inbound needs a **webhook** (no poll tool), and `GET_MEDIA_INFO` only returns a **download URL** (bytes
  still need the Meta token). 24-h window + pre-approved templates constrain outbound.
- **Key finding on pictures:** *neither* toolkit cleanly pulls incoming image **bytes** into Drive/the
  books — both need the provider token to download. For getting receipts/docs **in**, the estate's
  existing **email → `invoice@` → Dext → QuickBooks** route is still the cleanest (no token, no webhook).

## Real driver (clarified mid-session, with a screenshot)
Minda then explained the actual context: **Telegram is already the estate's main project-documentation
platform.** One **group per project** (e.g. `FC2602 — BBC Road…`; many `FC####` groups), each using
**Topics/forum mode** as the filing tree — **Extra works, Delivery, Progress pictures, Sign-in, General,
Drawings** — holding site **photos, delivery/sign-in albums and drawing PDFs**. So the ask is
**integrate or replace** this system, not just "add a bot."

**Sharpened conclusion:** the natural move is **integrate — mirror each project group into Drive**
(by topic), giving a permanent, searchable, backed-up site record without changing how crews work. But
**Composio's Telegram toolkit can't download file bytes** (no `getFile`), so archiving the actual
photos/PDFs needs a **small custom Bot-API worker** (Eugene builds/tests; Minda holds the token; 20 MB
Bot-API download cap; bot needs privacy-mode-off or admin in each group). **Replacement** is possible
but discouraged — the crews use Telegram happily on site — unless a concrete pain (client access, audit,
drawing version control) names it.

## Recommendation recorded (for the later decision)
Archive the project record → **integrate/mirror Telegram→Drive via a Bot-API worker** (the real ask).
Push alerts **out** → Telegram. Photos **in** (finance) → stay on email/Dext. Two-way → Telegram over
WhatsApp. Full matrix, the integrate-vs-replace analysis and the guide-and-verify outline in
`Runbooks/Runbook-Messaging-Channel-Options-Telegram-WhatsApp.md`.

## Also confirmed this session
- **Rachel PR [minda-ui/rachel#4](https://github.com/minda-ui/Rachel/pull/4) is MERGED** (by Minda,
  2026-10-02 20:57 UTC) — the Dext-send recipient guard is live. OI-16 stays Resolved.
- **`origin/main` (Eugene) is still stale** — ends at ledger row 62, missing the 2026-10-01/02
  switch/ASA/OI-8/OI-16 work; the authoritative branch is `claude/lucid-mayer-nsoili`. Consolidation to
  `main` remains an open housekeeping item (not forced).

## Firmed requirements (Minda, later same session)
Minda confirmed: (1) these Telegram chats are the **estate's main data stream from site** — the record
for **evidence, data and progress** (business-critical, not a convenience channel); (2) **structure is
uniform** across all project groups → one generic worker; (3) **two-way** wanted. Proposed a
**self-hosted Telegram→Drive evidence archive** on the recovered HQ Proxmox server (in-estate, no
third party): one bot (admin in each group) ingesting all topic posts into `Projects/FC#### <name>/
<Topic>/` with write-once metadata sidecars, and posting back into topics via `message_thread_id`.
Raw Bot API (Composio can't download bytes); Minda holds the token, Eugene writes/tests, Minda runs
(§2c/§3). Flagged: Telegram "Photo" compression (send-as-File for full-res evidence); this becomes
critical data for the OI-7 backup plan. Open decisions put to Minda: backfill vs go-forward; confirm
HQ-server hosting; move research→build (spec + prototype). Design captured in the Runbook note.

## State left
No connector/worker built yet — still at decision point (awaiting Minda's go + the backfill/host/build
answers). Research note updated with the firmed design. Open from before unchanged: OI-8 audio (RTP) +
ASA `write memory`; main consolidation.
