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

## Recommendation recorded (for the later decision)
Push alerts **out** → Telegram (simplest). Get photos **in** → stay on email/Dext. Two-way → Telegram
(poll-based) over WhatsApp. Full matrix + the guide-and-verify setup outline in
`Runbooks/Runbook-Messaging-Channel-Options-Telegram-WhatsApp.md`.

## Also confirmed this session
- **Rachel PR [minda-ui/rachel#4](https://github.com/minda-ui/Rachel/pull/4) is MERGED** (by Minda,
  2026-10-02 20:57 UTC) — the Dext-send recipient guard is live. OI-16 stays Resolved.
- **`origin/main` (Eugene) is still stale** — ends at ledger row 62, missing the 2026-10-01/02
  switch/ASA/OI-8/OI-16 work; the authoritative branch is `claude/lucid-mayer-nsoili`. Consolidation to
  `main` remains an open housekeeping item (not forced).

## State left
No connector added. Research note filed. Open from before unchanged: OI-8 audio (RTP) + ASA
`write memory`; main consolidation.
