# Change log — 2026-09-13 — Email architecture: invoice@ AP inbox, Dext, Vault evidence retention

_Append-only. Newest notes at the top. See `CLAUDE.md` §4._

## Accounts-payable inbox `invoice@`, Dext bookkeeping, and Google Vault evidence retention

Three linked changes to the Construction email architecture, all owner-driven, all guide-only for
Eugene (Minda executes every console step).

**1. `invoice@` accounts-payable inbox added to Peter's sources.**
- Address confirmed **`invoice@fishboneconstruction.co.uk`** (singular "invoice"); its alias
  **`invoice@fishbonedrylining.co.uk`** (the tenant's secondary domain — org display name is still
  "Fishbone Drylining Ltd") reaches the same mailbox. Owner originally described it as
  "invoices@fishboneconstruction.co.uk"; the Gmail "Send mail as" identity + a live test settled the
  exact address.
- **Forwarding into `ops@` verified two ways 2026-09-13:** the mailbox's "You are forwarding your emails
  to ops@fishboneconstruction.co.uk" banner, and a test to `invoice@` landing in `ops@`.
- Peter's inbox-triage routine prompt → **v2026-09-13b**: added `invoice@` as a third forwarded source
  and an explicit **INVOICES block** — capture supplier / amount / invoice no. / **due date**, flag the
  deadline, and **never pay, approve, schedule, or act on payment or supplier bank-detail changes**
  (human-only; a "we've changed our bank account" request is flagged as a fraud vector). Eugene's email
  inventory identity table updated.

**2. Dext bookkeeping — forward at the mailbox, NOT via Peter (governance).**
- Owner wants invoices forwarded to **`mindaugas.gaudiesius@dext.cc`** (Dext extracts invoice detail and
  posts to QuickBooks). **Flagged:** making **Peter** forward would breach his hard boundary (charter §3
  / group §6a: never send/forward email, never write to a system of record — and Dext auto-posts to
  QuickBooks). **Resolution:** do the forward at the **mailbox level** (a Gmail filter/forward rule on
  `invoice@` → Dext), owner-set, no agent in the loop. Every invoice then reaches **both** Dext
  (bookkeeping → QuickBooks) **and** `ops@` (Peter tracks/flags, read-only). Peter becomes an
  independent control check on what Dext posts, without ever touching payment or the ledger. Owner
  agreed this approach; the mailbox filter is hers to set.

**3. Google Vault — the evidence/retention store (closes the "sent mail" gap).**
- Owner asked whether sent items are captured — the `ops@` forwards are **inbound only**, so outbound
  replies (often the evidence) were not centrally captured, and forwarded copies are deletable.
- Chosen tool: **Google Vault** — retains all mail domain-wide, immutable, deletion-proof, with search /
  legal hold / evidence-format export. **Vault licences held for `minda@`, `info@`, `invoice@`** (the
  originals of every sent/received message; `ops@` needs none — copies only + unsent drafts).
- **Key point recorded:** a Vault licence ≠ retention. The evidence guarantee comes from switching on a
  **Gmail retention rule** (and a hold for live disputes) — the outstanding owner action.
- New runbook: `Runbooks/Runbook-Email-Evidence-Retention-Google-Vault.md` (v0.1) — steps for the
  retention rule (UK guidance: accounting records 6 yrs / commonly 7 — confirm with the accountant),
  legal hold, and verify. **Vault is the evidence store — Peter never reads it**; evidence retention and
  day-to-day triage stay separate systems.

**Boundary.** No live-system change by Eugene; guide + verification (read-only) only. The Dext mailbox
filter, the Vault retention rule and the invoice@ forward are all Minda's console actions. No secret
recorded.

**Outstanding owner actions:** (a) set the `invoice@` → Dext mailbox filter; (b) paste Peter's
inbox-triage prompt v2026-09-13b into the routine; (c) set the Vault Gmail retention rule (§4B of the
runbook), period confirmed with the accountant.
