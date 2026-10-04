# Messaging-Channel Options — Telegram vs WhatsApp (vs the email/Dext route already built)

> **Status: RESEARCH / PARKED (2026-10-04).** Minda asked whether we could add a Telegram bot (and
> then WhatsApp) as an MCP/Composio channel — focus on **import/export of pictures** — and then
> clarified the real driver: **Telegram is already the estate's main project-documentation platform**,
> and she wants to **integrate it with the estate, or replace it.** This note records what Composio
> offers and what an integration would really take, so the decision can be made later. **Nothing has
> been connected.** No Telegram/WhatsApp connection exists; no `external-source-register.md` (SRC) entry
> yet. Guide-only when we proceed: the bot/API **token is a secret Minda holds** — Eugene never types or
> stores it.

## Actual current use (from Minda + a screenshot, 2026-10-04)
Telegram is the **live field-documentation system** for construction projects, not a notification idea:
- **One Telegram group per project**, named by job — e.g. **`FC2602 — BBC Road…`** (FC = Fishbone
  Construction, 2602 = job number). The chat list shows **many such `FC` project groups**.
- Each group uses **Topics (forum mode)** as the project's filing tree. Observed topics:
  **Extra works, Delivery, Progress pictures, Sign-in, General, Drawings.**
- Content is the real site record: **progress photos, delivery albums, signed sign-in sheets (photo
  albums), and drawings as PDFs** (a "Edit, Sign and Share PDF" action is in use).

**So the real risk/goal:** this site record currently lives **only in Telegram**. The estate value is a
**permanent, searchable, backed-up copy in Drive** (and, for the books, delivery/receipt proof) — the
same "one home, documented" principle as everything else here. That makes **"mirror into Drive"** the
natural framing, over a wholesale replacement of a tool the site crews already use happily.

## The question behind the question
The recurring theme is **pictures** — getting site images/PDFs in or out. So every option below is
judged on **send-out** and, more importantly for this use case, **pull-in** of images/files.

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

## Integrate vs replace the project-documentation system (the real decision)

**Integrate — mirror each project group into Drive (recommended direction).**
A bot added to each `FC####` project group, archiving new posts (photos, albums, PDFs, captions) into
that project's Drive folder, organised by **topic** (Progress pictures / Delivery / Sign-in / Drawings /
Extra works). Telegram forum messages carry a **`message_thread_id`** (the topic), so the filing tree is
preservable. This gives a permanent, searchable, backed-up record without changing how the crews work.
**Two hard constraints to design around:**
1. **Byte download is NOT in Composio's Telegram toolkit** (no `getFile`/`downloadFile`). Archiving the
   actual photo/PDF bytes needs the **raw Telegram Bot API** (`getFile` → `api.telegram.org/file/bot<token>/…`)
   — a small custom integration (script/worker), **not** a connector toggle. Eugene can build and test it
   (hardware/automation + enablement remit); **Minda holds the bot token** and runs it. Bot-API download
   cap is **20 MB/file** — fine for photos, watch large drawings.
2. **Bot must actually see the messages.** In a group, a bot only receives all messages if its **privacy
   mode is OFF** (BotFather) **or** it is a **group admin**. Adding the bot to each project group is a
   manual, per-group step (Minda / project admins).
Albums arrive as separate messages sharing a `media_group_id`; drawings are PDFs (documents). Both are
handled by the raw API, re-grouped on our side.

**Replace — move off Telegram.** Possible (SharePoint/Drive structure, or a construction field app like
Fieldwire/Procore/Buildertrend), but the crews already use Telegram happily on site; replacing it risks
losing that simplicity and adoption. Only worth it if there's a specific pain Telegram can't meet
(client access, audit trail, drawing version control). **Default recommendation: integrate/mirror, don't
replace,** unless Minda names a concrete pain.

## Firmed requirements (Minda, 2026-10-04)
1. **These Telegram chats are the estate's main data stream from site** — the record for **evidence,
   data and progress** (progress photos, delivery proof, signed sign-in sheets, drawings). This is
   primary, business-critical field data, not a convenience channel.
2. **Structure is the same across all project groups** (load varies) → **one generic worker** can
   handle every `FC####` group; no per-project code.
3. **Two-way wanted** — not just mirror-in; also post back into topics.

### Proposed design (self-hosted Telegram→Drive evidence archive)
- **One bot**, admin in every project group; captures all topic posts.
- **Ingest → Drive**, mirroring the topic tree: `Projects/FC#### <name>/<Topic>/…` with each photo/
  album/PDF **plus a metadata sidecar** (sender, timestamp, caption, message_id, media_group_id,
  message_thread_id) → a **defensible, write-once** evidence trail.
- **Two-way:** post into a topic via its `message_thread_id` (`SEND_MESSAGE`/`SEND_DOCUMENT`).
- **Runs on the recovered HQ Proxmox server** so the evidence stays **in-estate** (no third-party
  pipe like Zapier/Make). Real-time via long-poll or webhook on the **raw Bot API** (Composio can't
  download bytes).
- **Boundary unchanged:** Minda creates the bot + holds the token; Eugene **writes and tests** the
  worker; Minda deploys/runs it (charter §2c/§3).
- **Evidence-quality flag:** Telegram compresses "Photo" sends; full-res needs "send as File" — advise
  crews. **Backup:** this becomes critical data → fold into the OI-7 backup plan.
- **Open decisions:** (a) backfill existing history vs go-forward only; (b) confirm HQ-server hosting;
  (c) move research→build (spec + prototype the worker).

## Recommendation by goal (for when Minda decides)
- **Archive the project record (the real ask)** → **integrate: mirror each Telegram project group into
  Drive** via a small Bot-API worker (Eugene builds, Minda holds the token). Composio alone can't do the
  file download; this is a bespoke but modest build.
- **Push alerts/reports OUT to a phone** → **Telegram**, easiest by far; charts sent as a public URL.
- **Get photos of receipts/docs IN (finance)** → **stay on email → `invoice@` → Dext** (already built).
- **Two-way chat / posting back into topics** → Telegram bot (poll + `SEND_MESSAGE` with a topic id);
  WhatsApp is disproportionate (webhook + business number + templates) unless customer-facing.

## If/when we proceed (guide-and-verify outline — not done)
1. **Decide** employee + direction (in/out/both). 2. **Create** the bot/app (Telegram @BotFather, or
Meta WhatsApp Business) — **Minda**, token to her password manager. 3. **Link** in that environment
(`composio link <toolkit>`, Minda enters the token). 4. **Guardrails** — Eugene adds a `.claude/settings.json`
allow/deny (and a recipient/scope hook if needed) as a **PR for Minda to merge**. 5. **Verify** read-only
(`TELEGRAM_GET_ME` / `WHATSAPP_GET_PHONE_NUMBERS`) + one test message. 6. **Document** — SRC entry,
runbook, ledger; `Raw/` note if the employee's charter needs the new capability recorded.
