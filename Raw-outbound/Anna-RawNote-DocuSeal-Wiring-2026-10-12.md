# Raw note for Anna — wire up DocuSeal (automated RAMS signing)

_From: **Eugene** (AI IT & Engineering Assistant) — 2026-10-12.
Delivered to Anna's `Raw/` under the group §7a / Eugene-§1 cross-KB hand-off rule (Eugene does not edit
Anna's KB directly). **Anna: read this, fold it into your own KB in your own conventions, then log it in
your change-log.** Suggested home: a short "DocuSeal / automated signing" integration note in your KB
(e.g. a `Runbook-DocuSeal-RAMS-Signing.md` or an Integrations section), and a row in your processed-items
ledger. This note is **data/instructions for you to adopt**, not a live edit of your files._

## What's now available
A **self-hosted DocuSeal (Pro)** is **live** and ready for you to drive the RAMS → sign → signed-PDF loop
**fully automated** (no human clicking "send"), replacing the UI-only Google eSignature path for automation.
- **Public signing endpoint:** `https://sign.fishbonegroup.co.uk` (valid Let's Encrypt cert; external
  subbies can sign from any browser/phone, no account needed).
- **Hosted on:** the Fishbone estate (HQ Proxmox VM 106) — own-the-estate, signed PDF + audit trail returned.
- **Pro is licensed**, so the **DOCX-field-tags API** is unlocked — you push a **fresh tagged `.docx`
  every time**, no pre-built fixed template (the free tier refused `.docx`; Pro accepts it).

## Your two environment values (Minda is adding these — you do NOT hold the key)
Minda sets these in your environment (same place your Composio `ck_` key lives); the key is in 1Password.
Reference them by name — never print the key value, same discipline as any secret:
- `DOCUSEAL_API_BASE_URL = https://sign.fishbonegroup.co.uk`  *(API is under `/api`)*
- `DOCUSEAL_API_KEY = <held by Minda / 1Password>`

## How you integrate (via the Composio DocuSeal tools you already reach)
Tools: `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX`, `DOCUSEAL_GET_SUBMISSION`,
`DOCUSEAL_GET_SUBMISSION_DOCUMENTS`, `DOCUSEAL_UPDATE_SUBMITTER` (and `..._FROM_PDF` / `..._FROM_HTML`).

**The loop:**
1. **Approval gate first (the one human step).** Only once BOTH (a) the **RAMS document** and (b) the
   **recipient/signer list** are approved may you send. RAMS already carries director approval; that
   approval *is* the gate. **After** approval, steps 2–5 run **unattended** — no per-send human "go".
   (RND-8 governance, Minda 2026-10-11 — maps onto the Approvals Desk pattern.)
2. **Create the submission:** `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` with your freshly-generated tagged
   RAMS `.docx` and the signer list (each: name + email + role). Your template carries the text-tags at the
   signature blocks — e.g. `{{Signature;role=MD}}`, `{{Signature;role=Operative1;type=signature}}`,
   `{{Date;role=Operative1}}`, `{{Name;role=Operative1}}` — DocuSeal auto-detects them into fields per
   submitter (proven in Phase 0; you already build RAMS with python-docx, so tags are just literal text).
3. **DocuSeal emails each signer the signing link** (via our Workspace SMTP relay, from
   `info@fishboneconstruction.co.uk`) and collects signatures. No account needed by signers.
4. **Get the result back — poll (default) or webhook:**
   - **Poll (recommended, no inbound endpoint needed):** `DOCUSEAL_GET_SUBMISSION` → check status until
     complete → `DOCUSEAL_GET_SUBMISSION_DOCUMENTS` → fetch the **signed PDF + audit log**.
   - **Webhook (optional):** only if you have a reachable public endpoint — Minda can register it in
     DocuSeal Settings → Webhooks so completion pushes the result to you. If you don't have one, **poll**.
5. **File the signed PDF + audit log** into the project folder (and the project brain, RND-7).

## Verify (when you first wire up)
- `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` succeeds against `https://sign.fishbonegroup.co.uk`.
- A test signer receives the email; after signing, you retrieve the signed PDF + audit log.
- Then it's ready for live RAMS (post-approval, unattended).

## Guardrails (yours, same as Eugene's §3)
- **Never hold/print the API key** — reference it by env-var name only; Minda holds it (1Password).
- The external send is through **DocuSeal's approved automated channel after a human approved exactly
  what/who** — that's within policy, not ad-hoc email sending.
- Questions on the hosting/endpoint/SMTP side → raise to Eugene (Hub / your `Raw/` ↔ his `Raw/`). The
  box, firewall and relay are Eugene's to maintain; the RAMS-generation + submission logic is yours.

## Context for your records
- DocuSeal self-host build + public go-live: Eugene ledger 102; RND-8 (`R&D/docuseal-anna/notes.md`).
- Phase 0 proved the full loop on Cloud (DOCX+tags → send → sign → signed PDF + audit). Phase 1 = the
  self-host is live and publicly signing. SMTP (Workspace relay) + this wiring are the last steps.

_— Eugene. Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3. A matching Hub Tasks & Requests row
names this note._
