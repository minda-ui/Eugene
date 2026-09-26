# Change log — 2026-09-26 — AWT-0105: outbound mailbox provisioning, FC/FA/FM

Minda picked this up right after confirming AWT-0104 was registered Done on the Hub — asked "Any other
AWT for me?", then said "AWT-0105" to start it.

## The task

From Alex, resolving the Estate Outbound Send-Identity plan (2026-09-26): three companies — Fishbone
Construction Ltd (FC), Amfa Furniture Ltd (FA), Fishbone Commercial Properties Ltd (FM) — get a distinct
outbound identity, "a real mailbox on its own domain," instead of everything going out through the shared
`ops@fishboneconstruction.co.uk`. Who sends from which mailbox stays as-is per the Authority Register
one-domain-one-owner table — only the from-address changes. No Claude connector is involved; this is
pure mailbox provisioning, guide-only for Eugene throughout (charter §3).

## Checked against the record before writing anything (Rule C)

Read `Infra-Inventory/Workspace-and-Email-Inventory.md` (last updated 2026-09-15) rather than assume any
of the three needed the same treatment. They didn't:

- **FC — already done.** Own Workspace subscription, domain `fishboneconstruction.co.uk`.
  `info@fishboneconstruction.co.uk` is a real, non-alias mailbox already live on that domain since
  2026-09-13. Nothing to provision — recommended as the outbound identity.
- **FA — a small confirm-or-create step.** Own subscription, domain `amfa.uk`. Super-admin
  `info@amfa.uk` is real and usable today. `enquiries@amfa.uk` was named during Nadia's build (AWT-0093,
  2026-09-24) as the intended sales address, but its existence as a live mailbox was never actually
  confirmed — Nadia's own `open-issues.md` NA-3 already flags exactly this gap. Needs a human check in
  Amfa's Admin console (create it if missing), then the already-drafted
  `Runbook-Amfa-Email-DKIM-SPF-DMARC.md` before it can send.
- **FM — blocked, not a provisioning task at all.** Confirmed via OI-1 (resolved 2026-09-13): Fishbone
  Commercial Properties Ltd has no domain or Workspace subscription of its own — it rides inside
  Properties' subscription, and `commercial@fishboneproperties.co.uk` is on **Properties'** domain, not
  FM's. "A real mailbox on FM's own domain" presupposes a domain that doesn't exist. Raised as a genuine
  open question rather than guessed at or worked around.

## Built

`Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md` (v0.1) — all three companies, each with its
actual status and the concrete next step (none, a console check, or a decision), plus a verification
section for Eugene once each is acted on.

## Raised

`open-issues.md` **OI-11** — FM's missing own domain, framed as three options (register FM a real domain;
accept the shared Properties-domain mailbox as-is; something else), explicitly not decided here since
it's a bigger and more expensive call than what AWT-0105 asked for.

## Hub

`AWT-0105` updated to **In Progress** (not Done) with the full three-way write-up — FC needs nothing
further, FA needs a human console step, FM needs Minda's decision on OI-11 before anything can proceed.

**Files:** `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md` (new), `open-issues.md` (OI-11),
`processed-items-ledger.md` (row 37), `current-state.md`, Hub AWT-0105 (In Progress).
