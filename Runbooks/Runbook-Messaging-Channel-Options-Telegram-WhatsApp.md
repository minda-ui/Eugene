# Messaging-Channel Options — Telegram vs WhatsApp (vs the email/Dext route already built)

> **Status: RESEARCH / PARKED (2026-10-04).** Minda asked whether we could add a Telegram bot (and
> then WhatsApp) as an MCP/Composio channel — focus on **import/export of pictures**. This note records
> what Composio actually offers today so the decision can be made later. **Nothing has been connected.**
> No Telegram/WhatsApp connection exists; no `external-source-register.md` (SRC) entry yet. Guide-only
> when we do proceed: the bot/API **token is a secret Minda holds** — Eugene never types or stores it.

## The question behind the question
The recurring theme is **pictures** — getting images (receipts/invoices/site photos) in or out. So every
option below is judged on **send-out** and **pull-in** of images first, convenience second.

## How this reaches us
Both Telegram and WhatsApp are **Composio toolkits**, reached through the **same Composio Connect MCP
server** the estate already uses (`.mcp.json`, `ck_` key). So "add a Telegram/WhatsApp MCP connection"
= **link a connected account in that toolkit**; the tools then appear automatically. No new MCP server.

## Capability comparison (probed 2026-10-04 via `composio execute <slug> --get-schema`)

| | **Telegram** | **WhatsApp (Cloud API)** | **Email → Dext (already live)** |
|---|---|---|---|
| **Send a picture OUT** | by **public HTTPS URL** or Telegram **`file_id`** only — no local upload | **local upload** (`UPLOAD_MEDIA`→`SEND_MEDIA_BY_ID`) **or** public URL | attach to an email |
| **See INCOMING messages** | `GET_UPDATES` polling + `GET_CHAT_HISTORY` (gives `file_id`) | **no poll/get-messages tool** — inbound needs a Meta **webhook** | arrives in `invoice@`/`ops@` |
| **Download incoming image BYTES** | ❌ no `getFile`/download tool | ⚠️ `GET_MEDIA_INFO` returns a **download URL**, but fetching bytes needs the Meta token (no byte tool) | ✅ Dext ingests the attachment to QuickBooks; Peter sees the copy |
| **Setup weight** | **trivial** — @BotFather, one token, minutes | **heavy** — Meta Business + WhatsApp Business Account + a **dedicated business number** (not a personal WhatsApp) + tokens | **zero** — already built |
| **Outbound freedom** | message anyone who started the bot / any chat it's added to | **24-h window + pre-approved templates** outside it (business→customer) | normal email |

### Confirmed Composio tools today
- **Telegram (present):** `GET_ME`, `GET_CHAT`, `GET_CHAT_MEMBER`, `GET_CHAT_ADMINISTRATORS`,
  `SEND_MESSAGE`, `EDIT_MESSAGE`, `DELETE_MESSAGE`, `SEND_PHOTO`, `SEND_DOCUMENT`, `GET_UPDATES`,
  `GET_CHAT_HISTORY`, `FORWARD_MESSAGE`.
  **Absent:** `GET_FILE`, `DOWNLOAD_FILE`, `UPLOAD_FILE`, `SEND_MEDIA_GROUP`, `SEND_AUDIO`,
  `SEND_VIDEO`, `EDIT_MESSAGE_MEDIA`, `COPY_MESSAGE`, `SEND_DOCUMENT_FILE`.
  (`SEND_PHOTO.photo` is a **string**: file_id / public HTTPS URL; "base64 and inline bytes are not
  accepted".)
- **WhatsApp (present):** `SEND_MESSAGE`, `SEND_REPLY`, `SEND_TEMPLATE_MESSAGE`, `SEND_MEDIA`,
  `SEND_MEDIA_BY_ID`, `UPLOAD_MEDIA`, `GET_MEDIA_INFO`, `GET_PHONE_NUMBERS`.
  **Absent:** `GET_MEDIA`/`DOWNLOAD_MEDIA` (byte download), `LIST_MESSAGES`/`GET_MESSAGES` (inbound poll).
- _Caveat: this is Composio's catalogue on 2026-10-04; it changes — re-probe before building._

## The key finding on pictures
- **Sending out:** WhatsApp wins (uploads a local file); Telegram needs a public URL or an existing
  `file_id`. For our own **charts/reports**, hosting at a public URL is easy, so Telegram is fine there.
- **Pulling in (to save to Drive / the books):** **neither toolkit does it cleanly** — both hand back a
  URL that still needs the provider's **token** to download the actual bytes, and there's no
  byte-returning tool. That is the real limitation for a "photo of a receipt lands in the books" flow.

## Recommendation by goal (for when Minda decides)
- **Push alerts/reports OUT to a phone** → **Telegram**, easiest by far; charts sent as a public URL.
- **Get photos of receipts/docs IN** → **stay on email → `invoice@` → Dext** (already built, no token,
  no webhook, no 24-h rules). A chat app would need the raw provider API + token to fetch bytes — more
  moving parts, a secret to handle, for no gain over email.
- **Two-way chat with the workforce** → **Telegram** (poll-based) is workable; WhatsApp needs a webhook,
  a business number and message templates — disproportionate unless there's a customer-facing reason.

## If/when we proceed (guide-and-verify outline — not done)
1. **Decide** employee + direction (in/out/both). 2. **Create** the bot/app (Telegram @BotFather, or
Meta WhatsApp Business) — **Minda**, token to her password manager. 3. **Link** in that environment
(`composio link <toolkit>`, Minda enters the token). 4. **Guardrails** — Eugene adds a `.claude/settings.json`
allow/deny (and a recipient/scope hook if needed) as a **PR for Minda to merge**. 5. **Verify** read-only
(`TELEGRAM_GET_ME` / `WHATSAPP_GET_PHONE_NUMBERS`) + one test message. 6. **Document** — SRC entry,
runbook, ledger; `Raw/` note if the employee's charter needs the new capability recorded.
