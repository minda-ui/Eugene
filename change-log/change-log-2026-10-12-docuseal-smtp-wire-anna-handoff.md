# Change log — 2026-10-12 — OI-21: DocuSeal SMTP + wire-Anna runbook; Anna `Raw/` hand-off delivered

_Guide-only (§3): Eugene wrote the runbook + the hand-off; **Minda executes the SMTP/console steps and holds
every secret** (the sender app password, the DocuSeal API key). No secret held or recorded. Follows the
DocuSeal Pro public go-live earlier today (ledger 102)._

## What we set out to do
"Move on Anna" — close the remaining OI-21 items so Anna can run the RAMS → sign → signed-PDF loop for real
on our own self-hosted DocuSeal: **(a) SMTP** (so DocuSeal emails signing links) and **(c) wire Anna**.

## Decisions (Minda, this session)
- **SMTP path:** Google Workspace **SMTP relay** (`smtp-relay.gmail.com`), not Gmail-SMTP or a transactional
  provider.
- **Sender:** `info@fishboneconstruction.co.uk` — a live Workspace-domain mailbox, so SPF (`_spf.google.com`)
  and DKIM are already correct (a `noreply@fishbonegroup.co.uk` sender would have needed its own SPF/DKIM).

## What was produced
1. **`Runbooks/Runbook-DocuSeal-SMTP-and-Wire-Anna.md`** — the closing runbook:
   - **Part A (SMTP):** Admin-console relay config (Apps → Gmail → Routing → SMTP relay; allowed senders =
     in-domain, require SMTP auth [+ optional FTTB-IP allowlist `62.105.119.118/32`], require TLS); a sender
     **app password** for `info@` (Minda-held, 1Password); DocuSeal SMTP settings (UI or env); then a full
     **internal end-to-end sign test** on our own box as the gate.
   - **Part B (wire Anna):** Minda generates the DocuSeal **API key** (Settings → API) and adds
     `DOCUSEAL_API_BASE_URL=https://sign.fishbonegroup.co.uk` + `DOCUSEAL_API_KEY` to Anna's env; Anna runs
     `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` → DocuSeal emails/collects → Anna **polls**
     `GET_SUBMISSION`/`GET_SUBMISSION_DOCUMENTS` for the signed PDF + audit log (no inbound webhook endpoint
     needed); the one upfront approval gate (RAMS + signer list) per RND-8 governance; then graduate RND-8.
2. **Anna `Raw/` hand-off note** — `Anna-RawNote-DocuSeal-Wiring-2026-10-12.md` (staged in Eugene's repo at
   `Raw-outbound/`), covering the env-var names, the Composio DocuSeal tools, the create→collect→poll flow,
   the approval gate, and the §3 guardrails (Anna never holds the key).

## Cross-KB hand-off (CLAUDE.md §1) — DELIVERED
- **Dropped into Anna's KB `Raw/`** (`Anna - AI Construction Assistant / Raw`, folder
  `18PkuxAxchaS0rEkgdexw2zOvzoidcJFA`) via `drive-sync-verified` — byte-verified **OK** (4972 B, md5 match,
  round-trip identical, 0 U+FFFD, 1 live copy). New Drive file id **`17E0yiS40kbZY8Q6jcadH9LSvIQ0sfhNH`**.
- **Hub Tasks & Requests row `AWT-0589`** raised (sheet `8860839228606340`; Assigned to **Anna**, Requested
  by Eugene, Priority Medium, Status Open) naming the hand-off and pointing to the `Raw/` note. No duplicate
  flag. Allocated as max+1 (highest was AWT-0588).

## State / what's next (Minda)
- **SMTP** (Part A) is the gate — Minda runs it at the box (guide-only), then the internal sign test.
- **Wire Anna** (Part B) — Minda sets Anna's two env values + generates the API key; Anna folds in the `Raw/`
  note and tests. Then **graduate RND-8** and mark OI-21 (a)+(c) done.
- OI-21 (b) internal access (NAT hairpin / split-DNS) stays a nice-to-have.

## Artefacts
`Runbooks/Runbook-DocuSeal-SMTP-and-Wire-Anna.md`, `Raw-outbound/Anna-RawNote-DocuSeal-Wiring-2026-10-12.md`,
Anna KB `Raw/` (Drive `17E0yiS40kbZY8Q6jcadH9LSvIQ0sfhNH`), Hub `AWT-0589`, `open-issues.md` (OI-21), ledger
row 104.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
