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

**Resolved 2026-09-26 — Minda confirmed `enquiries@amfa.uk` is created,** with copies of all mail
forwarding to `ops@fishboneconstruction.co.uk`. This matches the design already on record in Nadia's own
`external-source-register.md` (NASRC-6/NASRC-7): Peter triages the copy at `ops@` and routes Amfa
enquiries into Nadia's `Raw/` (Hub AWT-0095) — Nadia has no direct read access of her own, by design, the
same Raw/-only hand-off pattern used everywhere else in the estate. So this isn't an accidental
cross-company leak into Peter's Construction-scoped inbox — it's the intended intake mechanism. **The
mailbox-provisioning ask of this runbook is satisfied.**

**Still open, but a separate matter — not this runbook's ask:** `enquiries@amfa.uk` must not send
**outbound** sales/quote mail until DKIM/SPF/DMARC are set up (`Runbook-Amfa-Email-DKIM-SPF-DMARC.md`),
and Nadia's own Gmail connector (`create_draft`-only, NASRC-6) still needs to be provisioned before she
can draft into it directly — both already tracked in Nadia's `open-issues.md` NA-3, not re-raised here.
`info@amfa.uk` remains the safe interim FA outbound identity until then.

## FM — Fishbone Commercial Properties Ltd: resolved, no action needed

Fishbone Commercial Properties Ltd has no domain or Workspace subscription of its own — it rides inside
**Fishbone Properties Ltd's** subscription, and its mailbox `commercial@fishboneproperties.co.uk` is on
**Properties' domain**, not a domain of its own. This was flagged as `OI-11` (three options: register FM
an own domain; accept the shared Properties-domain mailbox as-is; something else) rather than assumed.

**Decided (Minda, 2026-09-26): option (b) — accept the shared Properties-domain mailbox.**
`commercial@fishboneproperties.co.uk` (already live, already in use) is FM's outbound identity going
forward. No new domain, no new Workspace subscription, no DNS/DKIM/SPF/DMARC work required. Nothing to
provision — same "already satisfied" shape as FC, just via the shared domain rather than one of FM's own.

## Verification (Eugene, after execution)

- FC: no verification needed — already confirmed live.
- FA: **done** — `enquiries@amfa.uk` confirmed created (Minda, 2026-09-26); forwarding to `ops@` matches
  the intended Peter→`Raw/` intake design. Recorded in `Infra-Inventory/Workspace-and-Email-Inventory.md`.
  The DKIM/SPF/DMARC outbound gate and Nadia's own connector remain open, but as Nadia's NA-3, not this
  runbook.
- FM: no verification needed — `commercial@fishboneproperties.co.uk` is already live; OI-11 resolved
  2026-09-26 accepting it as-is.

**All three companies now have a real, confirmed mailbox. This runbook's ask is complete.**

## History

- 2026-09-26 — v0.1 drafted in response to Hub `AWT-0105`. FC confirmed already satisfied; FA needs a
  confirm-or-create step on `enquiries@amfa.uk` plus the existing DKIM/SPF/DMARC runbook; FM blocked,
  raised as `OI-11`, pending Minda's decision on whether FM gets an own domain at all.
- 2026-09-26 (later) — **OI-11 resolved:** Minda chose option (b) — accept
  `commercial@fishboneproperties.co.uk` as FM's outbound identity as-is, no new domain. FM section
  rewritten to match; FM now needs no action, same as FC. Only FA's confirm-or-create step remains open.
- 2026-09-26 (later still) — **FA resolved:** Minda confirmed `enquiries@amfa.uk` is created, with
  copies forwarding to `ops@fishboneconstruction.co.uk` — matching the intake design already recorded in
  Nadia's own KB (NASRC-6/7, Hub AWT-0095), not an accidental cross-company leak. All three companies now
  satisfied; `AWT-0105` closed. Outbound authentication (DKIM/SPF/DMARC) and Nadia's own connector remain
  open as Nadia's NA-3, tracked in her own KB, not this runbook.
