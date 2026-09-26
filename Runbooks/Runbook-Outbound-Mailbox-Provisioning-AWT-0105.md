# Runbook — Outbound mailbox provisioning: FC / FA / FM (AWT-0105) (v0.1)

**Guide-only throughout — Eugene has no Admin console access to any of these three Workspace
subscriptions (charter §3). Every step below is for Minda (or the relevant super-admin) to execute;
Eugene's role is this runbook plus verifying the outcome against `Infra-Inventory/` afterwards.**

## Background

Hub `AWT-0105` (from Alex, resolving the Estate Outbound Send-Identity plan, 2026-09-26): three
companies — Fishbone Construction Ltd (FC), Amfa Furniture Ltd (FA), Fishbone Commercial Properties Ltd
(FM) — are to get a distinct outbound identity: "a real mailbox on its own domain," so mail no longer
goes out looking like it's from the shared `ops@fishboneconstruction.co.uk` address regardless of which
company it's actually for. Who sends from which mailbox follows the existing Authority Register
one-domain-one-owner table unchanged — only the from-address changes.

Checked against `Infra-Inventory/Workspace-and-Email-Inventory.md` (last updated 2026-09-15) before
writing anything here, per Rule C. Findings differ sharply by company — one is already done, one needs a
small confirm-or-create step, and one can't proceed as scoped without a prior decision.

## FC — Fishbone Construction Ltd: already satisfied, no action needed

FC has its own Workspace subscription, domain `fishboneconstruction.co.uk`. Real (non-alias) Workspace
user mailboxes already live on that domain: `info@fishboneconstruction.co.uk` (customer-facing business
inbox, live since 2026-09-13) and `minda@fishboneconstruction.co.uk`. Either already is "a real mailbox
on FC's own domain" — nothing to provision. **Recommend `info@fishboneconstruction.co.uk`** as FC's
outbound identity (it's the customer-facing inbox already, vs. `minda@`/`ops@` which have other roles).
No console step required.

## FA — Amfa Furniture Ltd: confirm-or-create, then the existing DKIM/SPF/DMARC runbook

FA has its own Workspace subscription, domain `amfa.uk` (confirmed 2026-09-15). Super-admin login
`info@amfa.uk` is a real mailbox on that domain — usable today as an interim outbound identity with no
further step.

**Open item, not yet confirmed either way:** `enquiries@amfa.uk` was named during Nadia's build (Hub
AWT-0093, 2026-09-24) as the intended sales/enquiry address, but whether it exists as a live Workspace
mailbox has never actually been checked — Nadia's own `open-issues.md` (NA-3) already flags it as "not
yet connected." Eugene has no connector into Amfa's Workspace to check this directly.

**Steps for Minda (or Amfa's super-admin):**
1. In Amfa's Admin console (signed in as `info@amfa.uk`) → Users: check whether `enquiries@amfa.uk`
   already exists as a user/mailbox.
2. If it doesn't: **Add new user** with that address (Directory → Users → Add new user), or add it as an
   alias of an existing user if a shared inbox is preferred over a dedicated seat — Minda's call, no
   technical reason to prefer one over the other from what's on record.
3. Either way (existing or newly created), **`enquiries@amfa.uk` must not send outbound sales/quote mail
   until DKIM/SPF/DMARC are set up** — this was already flagged and the runbook already exists:
   `Runbooks/Runbook-Amfa-Email-DKIM-SPF-DMARC.md`. Work through that runbook before Nadia (or anyone)
   starts sending from this address.
4. Until both are done, `info@amfa.uk` remains the safe interim FA outbound identity.

## FM — Fishbone Commercial Properties Ltd: blocked, needs a decision before anything else

**This one can't be executed as scoped.** Per `Infra-Inventory/Workspace-and-Email-Inventory.md`
(OI-1, resolved 2026-09-13): Fishbone Commercial Properties Ltd has **no domain and no Workspace
subscription of its own** — it rides inside **Fishbone Properties Ltd's** subscription, and its mailbox
`commercial@fishboneproperties.co.uk` is on **Properties' domain** (`fishboneproperties.co.uk`), not a
domain of its own. "Provision a real mailbox on FM's own domain" presupposes a domain that doesn't
currently exist.

Giving FM an actual own-domain mailbox is not a mailbox-provisioning step — it would mean first deciding
whether to register a new domain for FM, then either standing up a fourth Workspace subscription or
adding it as a secondary domain under an existing tenant, then DNS, then DKIM/SPF/DMARC (same shape as
the Amfa runbook) — a materially bigger and more expensive undertaking than what's been asked for FC/FA,
and one Eugene shouldn't assume the answer to.

**Flagged as `OI-11` rather than guessed at. Needs Minda's decision:**
- **(a)** Register FM an actual own domain (cost/DNS/hosting decision, then a build similar in shape to
  this runbook's FA section), or
- **(b)** Accept `commercial@fishboneproperties.co.uk` as FM's outbound identity as-is — since Commercial
  Properties has always shared Properties' domain space, this may already be "good enough" and the
  distinct-identity goal may not require a literal separate domain for this one company, or
- **(c)** Some other shape not yet on the table.

No mailbox work proceeds for FM until this is decided.

## Verification (Eugene, after execution)

- FC: no verification needed — already confirmed live.
- FA: once `enquiries@amfa.uk` exists, Eugene re-checks `Infra-Inventory/Workspace-and-Email-Inventory.md`
  is updated to record it, and confirms with Minda that the DKIM/SPF/DMARC runbook has been worked
  through before treating the address as ready to send.
- FM: no verification possible until OI-11 is resolved and a path is chosen.

## History

- 2026-09-26 — v0.1 drafted in response to Hub `AWT-0105`. FC confirmed already satisfied; FA needs a
  confirm-or-create step on `enquiries@amfa.uk` plus the existing DKIM/SPF/DMARC runbook; FM blocked,
  raised as `OI-11`, pending Minda's decision on whether FM gets an own domain at all.
