# Runbook — Digitally signing RAMS with Google Workspace eSignature

**Guide-only: the Workspace admin flips one switch; Anna/Minda send and sign. Eugene produces this
runbook and verifies. No credential held (charter §3).**

_Created 2026-10-06 at Minda's request: Anna produces RAMS (Risk Assessments & Method Statements) per
project, and they need digital sign-off — by Minda and by the operatives/subbies on each job._

---

## Decision (why Google eSignature, not a paid tool or a self-host)
- **Legal bar:** RAMS sign-off is an **acknowledgement** ("I've read and understood the method & risks").
  Under UK law a **simple electronic signature with an audit trail** (who signed, when, which version) is
  valid and is standard practice in construction — no "qualified"/eIDAS-advanced signature needed.
- **Fit:** Fishbone is already on paid Google Workspace, so eSignature is **£0 extra**. Typical RAMS here
  are signed by **1–5 people** (well under Google's 10-signer limit), and signers are **different
  subbies each job** who **do not need a Google account** — they sign from an emailed link on a phone.
- **Rejected for now:** self-hosting DocuSeal (open-source, unlimited signers) — only worth it if signer
  counts outgrow 10 or Fishbone wants off Google; and it needs a public HTTPS endpoint through the HQ ASA,
  which is the exact inbound path currently broken (OI-8). Revisit when that's settled.

## Prerequisite to confirm (ONE thing) — the Workspace edition
Google eSignature **sending** requires **Business Standard, Business Plus, Enterprise, or Education Plus**.
- If Anna's company is on one of those → good, proceed.
- If it's on **Business Starter** → eSignature sending isn't included; either upgrade that one subscription,
  or fall back to DocuSeal later. **Confirm the edition first** (Admin console → Billing / Subscriptions),
  since Fishbone's companies are separate subscriptions (OI-1) and may differ.

---

## Step 1 — Admin: turn eSignature on (one-time, per subscription)
Done by the Workspace **super-admin** of the company whose Drive holds the RAMS (note OI-5: each
subscription's super-admin is the shared business inbox, e.g. `info@fishboneconstruction.co.uk`).
1. **admin.google.com** → **Apps → Google Workspace → Drive and Docs**.
2. Open **eSignature** settings → **turn eSignature ON** for the organisation (or the relevant OU).
3. Save. (Allow a short while to propagate.)

Ref: Google's admin help — "Turn eSignature on or off for users"
(https://knowledge.workspace.google.com/admin/drive/turn-esignature-on-or-off-for-users).

## Step 2 — Anna/Minda: send a RAMS for signature
Works on a **Google Doc** or on a **PDF stored in Drive** (if Anna exports RAMS as PDF, upload it to the
project's Drive folder first).
1. Open the RAMS in **Google Docs**, or right-click the **PDF in Drive**.
2. Choose **File → eSignature** (Docs) / **eSignature** (Drive PDF).
3. In **Manage signers**, add each signer and give them a **label** (e.g. "Operative 1", "Site foreman").
   Enter each person's **email** — a non-Gmail/subbie address is fine.
4. Drag the fields each signer must complete onto the document — **Signature**, plus **Date signed** and
   **Name** as needed — and assign each field to the right signer label.
5. **Request signature.** Each signer gets an email with a link; they open it (phone is fine) and sign.
   With multiple signers the request completes only when **all** have signed.

## Step 3 — on completion
- When everyone has signed, Google emails all signers + the requester, saves a **completed, signed PDF**
  with an **audit trail** to the requester's Drive, and locks the document.
- **File it:** move/copy the signed PDF into the **project's Drive folder**, and (per the project's Telegram
  group convention) post it into the relevant topic (e.g. "Sign-in"/"Drawings"). For now this is a manual
  copy; auto-filing into Drive/Telegram can be added later if wanted.

## Verify (Eugene / Minda)
- A test request to one internal + one external (non-Google) address completes and produces a signed PDF
  with an audit trail; the external signer can sign without a Google login.

## Watch-outs
- **10 signers per request** is the hard cap — fine for RAMS here; if a single RAMS ever needs more, split
  it or move to DocuSeal.
- **One signed PDF per version:** if the RAMS text changes after signing, it's a **new** request — keep the
  signed version on file against the project (don't edit a signed doc).
- Keep the completed signed PDFs filed per project — that audit trail is the point.

## If the edition blocks it (fallback, not now)
Self-host **DocuSeal** (Docker, on the Proxmox box): unlimited signers each with their own no-account link,
audit-trail PDF, drag-drop fields. Eugene builds + tests; Minda deploys. Needs a public HTTPS endpoint
through the ASA — defer until OI-8/inbound is resolved.

---
*Guide-only. Admin enables; Anna/Minda operate; Eugene verifies. No credential held (charter §3).*
