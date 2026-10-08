# Change log — 2026-10-08 — Gmail draft-only capability for Eugene (owner-authorised) + P40 parts quote draft

_Not R&D — a real capability/charter change, so it's in the control files (§4). Guide-only for the
credentialed step (Minda authorised the OAuth); Eugene holds no secret._

## What Minda asked
"Be connected to minda@fishboneconstruction.co.uk via Composio; able to create drafts for me to send."
(Arose from the server-parts thread — she first asked me to find the server-purchase email and draft a
quote to the vendor.)

## Server-purchase email — not found
Searched the connected inbox (3 passes: model/vendor terms, order/invoice terms, big server resellers) —
**no server-purchase email.** Likely because the HQ DL380 was **set up by the contractor** (OI-7), so there
may be no Fishbone-side purchase email/vendor for it. Flagged to Minda; proceeded to draft a fresh quote
request to a server-parts vendor instead.

## Gmail draft-only capability added
- Created a **Composio Gmail connection `eugene-gmail`** (`composio link gmail --alias eugene-gmail`); Minda
  completed the **OAuth** authorising it to **minda@fishboneconstruction.co.uk**. Verified ACTIVE with a
  read (`GMAIL_FETCH_EMAILS`), confirmed it's her inbox.
- **Charter (§1)** changed from "No Gmail connector — not an email agent" to a **draft-only Gmail**
  capability: Eugene reads + creates drafts for Minda to send herself; **§3 unchanged — Eugene never sends**.
  Logged in `Charter-History.md` (2026-10-08). CLAUDE.md + Charter-History synced to Drive (archive-then-
  recreate, byte-verified).
- **Never-send guard** in `.claude/settings.json` `permissions.deny`: `GMAIL_SEND*`, `GMAIL_REPLY*`,
  `GMAIL_FORWARD*` (Composio CLI) + `mcp__Gmail__send_message/reply/forward` — **deny > allow**, so it
  overrides the broad `composio execute *` allow. Only drafting is possible.
- OAuth-scope honesty: Google has **no "draft-only" scope**, so not-sending is enforced by §3 + this guard,
  not by Google.

## P40 quote draft created
Created a draft in **minda@'s Gmail drafts** via `eugene-gmail` (`GMAIL_CREATE_EMAIL_DRAFT`): quote request
for the **Tesla P40 GPU upgrade** (card ×1/×2, enablement kit 719082-B21, power cable 805123-001/728539-B21,
cooling, PSU-adequacy check) with the server's exact details (DL380 Gen9, 2× E5-2695 v4, 128 GB, S/N
CZJ64905NP). **Recipient left blank** — Minda adds the vendor (Bargain Hardware / ETB / ITInstock) and sends.
(An earlier copy was made in the pre-existing ops@ mailbox before this connection — superseded by this one.)

## Techbuyer found — P40 draft re-addressed to the real vendor
Minda: "Look for Techbuyer — we bought all IT from them." Searched the connected inbox
(`GMAIL_FETCH_EMAILS`, query `Techbuyer`; results offloaded to `outputFilePath`, parsed from
`/tmp/composio/.../GMAIL_FETCH_EMAILS_OUTPUT_*.json`) — **30 Techbuyer emails**. So the
"server-purchase email not found" above is corrected: the kit **was** bought from **Techbuyer**, the
earlier passes just didn't hit the vendor name. Extracted:
- **Account managers:** Garrick Eckard (`g.eckard@techbuyer.com`, ×10 — handled the original order) and
  **Liam Freebairn** (`l.freebairn@techbuyer.com`, current AM per 2026 check-ins).
- **Orders** SO483746 (2024), SO510630 (2025); **invoices** I2757387, I2781156; account registered under
  **Fishbone Drylining Ltd**.

**Re-addressed the P40 quote draft** (new draft `r4461050835829063460`, via `GMAIL_CREATE_EMAIL_DRAFT`):
To **Liam Freebairn**, CC **Garrick Eckard**, subject "Quote request – DL380 Gen9 (S/N CZJ64905NP):
Tesla P40 GPU upgrade parts", body references the existing account and asks them to look the server up by
serial **CZJ64905NP** / order **SO483746** to match guaranteed-fit parts (P40 ×1/×2, kit 719082-B21,
power cable 805123-001/728539-B21, passive cooling, PSU-headroom check). **Deleted the earlier
blank-recipient draft** (`r-6135796713194806801`) so there's no wrong-recipient copy. Still draft-only —
**Minda reviews and sends**; Eugene never sends (§3).

## Boundary note
Eugene is still **not an autonomous email agent** (inbox triage = Peter; bookkeeping mail = Rachel). This is
a narrow draft-and-read capability for Minda's convenience; the send always stays with her.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
