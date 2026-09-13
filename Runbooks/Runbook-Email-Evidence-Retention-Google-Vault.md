# Runbook — Email evidence retention with Google Vault (v0.2)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda performs every Admin
console / Vault step.** No secret is written into this file. Author: Claude for Eugene, 2026-09-13.
Purpose: keep an accurate, tamper-proof record of the group's **sent and received** business email
(evidence-grade), closing the gap that the `ops@` forwards capture inbound mail only._

## 1. The problem this solves

The `ops@` design forwards a copy of **incoming** mail from `minda@`, `info@` and `invoice@` into
`ops@` for Peter to triage. Gmail's "forward a copy" does **not** forward **sent** mail — so outbound
replies (often the evidence: "we quoted / we notified / we disputed") are not captured centrally, and a
forwarded copy is deletable/alterable anyway. **Google Vault** is the correct tool: it retains all mail
domain-wide, immutable, independent of what a user deletes, with search, legal hold and legal-format
export.

## 2. Key principle — a Vault licence ≠ retention

A Vault **licence** only makes a user's data *eligible* for Vault. Data is **preserved against
deletion only when a retention rule (or a hold) covers it.** With no rule, a message a user deletes and
purges is gone (~30 days). **The action that creates the evidence guarantee is switching on a retention
rule.** Do not treat "we have Vault" as "we are covered."

## 3. Scope (confirmed 2026-09-13, owner)

- **Vault licences held:** `minda@fishboneconstruction.co.uk`, `info@fishboneconstruction.co.uk`,
  `invoice@fishboneconstruction.co.uk`. These hold the **originals** of every sent/received message, so
  they are the complete evidence set.
- **`ops@` needs no Vault licence:** it holds only forwarded *copies* (originals already retained on the
  three above) plus Peter's unsent drafts (not evidence). Licence it later only if desired.

## 4. Steps (Minda, in the Admin console / vault.google.com; Eugene guide-only)

**A. Confirm the edition/licences.** Admin console → Billing/Subscriptions confirms the edition includes
Vault (Business Standard/Plus or Enterprise); the three accounts above are licensed. **Done 2026-09-13.**

**B. Set a Gmail retention rule (the essential step). ✅ DONE 2026-09-13.** In vault.google.com →
**Retention** → **Default rules** tab, open the **Gmail** row and set the duration. **Applied
2026-09-13:** Gmail default retention = **Indefinitely** / Action after expiry = **No expiry**.
- A **default** Gmail rule covers **all licensed accounts automatically** (`minda@`, `info@`, `invoice@`
  — and any future licensed user), which is simpler and more robust than a per-OU custom rule.
- **Indefinitely** chosen for maximum evidence protection: nothing is ever purged and it survives user
  deletion. **UK guidance for later:** company accounting records must be kept **6 years** (Companies
  Act 2006 s.388), many keep **7** — if the accountant/RMT prefers a fixed period, change this same
  Gmail row then (indefinite is the safe default; leaving it loses nothing).
- (A **Custom rule** — Retention → **Custom rules** → target an OU/accounts or specific terms/dates — is
  available for narrower or matter-specific retention; not needed here.)

**C. Legal hold when a dispute arises (as needed).** vault.google.com → **Matters** → create a matter →
**Holds** → hold the relevant account(s) (Gmail). A hold preserves everything indefinitely regardless
of the retention rule, until released. Use it the moment a claim/dispute/investigation is foreseeable.

**D. Verify.** vault.google.com → **Search** → Gmail → account `invoice@` → run a search for a recent
known message and confirm it appears. (Optional stronger test: delete a disposable test message from the
mailbox, empty trash, then confirm it is still findable in Vault — proves the retention rule works.)

## 5. Boundary / notes

- **Admin-level:** every step is Minda's in the Admin console / Vault. Eugene documents and can help
  verify (read-only), but does not administer Vault.
- **Vault is the evidence store — Peter never reads it** (nor should any agent). Peter keeps doing
  operational triage on the `ops@` inbound copies. Evidence retention and day-to-day triage stay
  separate systems.
- **No secret is stored here.** Vault access is governed by Admin/Vault privileges, not credentials in a
  KB.
- Retention is **domain/account-level and automatic** once the rule is on — no per-message action, and
  it captures **sent** mail too, which closes the original gap.

## 6. Change history
- v0.2 2026-09-13 — **retention rule applied.** Owner set the **Gmail default retention rule** to
  **Indefinitely / No expiry** (Retention → Default rules → Gmail). Evidence retention is now **live**
  for all licensed accounts (`minda@`, `info@`, `invoice@`); §4B marked done. Legal hold (§4C) remains
  the on-demand tool for specific disputes.
- v0.1 2026-09-13 — created. Chosen over per-mailbox outbound-forwarding because Vault is tamper-proof,
  deletion-proof, captures sent mail domain-wide, and exports in evidence format. Owner holds Vault
  licences for the three source mailboxes; the outstanding action is the retention rule (§4B).
