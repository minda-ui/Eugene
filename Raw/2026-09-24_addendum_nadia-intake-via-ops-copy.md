# Intake addendum — Nadia / Amfa enquiries via ops@ (updates AWT-0093)

From: Victoria, for Minda — 2026-09-24. Update to the build brief
(`2026-09-24_build-brief_nadia-amfa-sales-ops-assistant.md`).

## Minda's setup (2026-09-24)
`enquiries@amfa.uk` **copies all sent + received email to `ops@fishboneconstruction.co.uk`** (Peter's triage
mailbox). So all Amfa enquiry traffic is visible in ops@, with oversight.

## What this changes for the build
- **Intake:** `enquiries@amfa.uk` → copy to `ops@` → **Peter triages and routes Amfa enquiries to Nadia's
  `/Raw`** (the Alexey→Rachel pattern, AWT-0056). The Peter routing rule is queued as **AWT-0095** (fires
  once Nadia's `/Raw` exists).
- **Nadia gets NO `ops@` access** — `ops@` is Peter's alone (AWT-0086). She works from the routed enquiries.
- **Outbound stays draft-only:** Nadia drafts quotes; a **human sends from `enquiries@amfa.uk`**. Give her
  **draft-only (`create_draft`) access to `enquiries@amfa.uk` if** that mailbox is connected; otherwise she
  produces the quote as a Drive draft for a human to send. Never send; never contact a customer directly.
- Net: Nadia's Gmail need is at most **draft-only on `enquiries@amfa.uk`**, and **not** read on `ops@`.

## Unchanged
Everything else in the build brief stands — the Enquiries/Quotes CRM sheet feeding the AMFA order tracker
(`5287398789482372`), the `FA` process doc, the pipeline, the draft-only guardrails, and the `amfa.uk`
DKIM/SPF/DMARC guidance.
