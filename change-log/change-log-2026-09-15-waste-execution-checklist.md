# Change log — 2026-09-15 — standalone Waste migration execution checklist produced

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Fourth dated file for 2026-09-15.)_

## 2026-09-15 — `Runbook-Waste-Migration-Execution-Checklist.md` (v1.0) produced

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** With `Runbook-Workspace-Consolidation-into-Construction.md` §4 fully decided (v0.4,
"ready to execute"), Minda asked for §4 laid out as a standalone checklist and step-by-step
instructions, rather than having to work the reasoning-heavy main runbook section directly.

**Produced.** `Runbooks/Runbook-Waste-Migration-Execution-Checklist.md` (v1.0) — nine ordered phases:
- **Phase A** — archive `info@`/`sales@fishbonewaste.co.uk` (Takeout recommended over the slower
  whole-org Data Export tool, given only 2 mailboxes) into `Fishbone Waste Ltd - Knowledge
  Base/Raw/`, following that folder's existing naming convention.
- **Phase B** — confirm Construction's licence headroom before touching the domain.
- **Phase C** — free the domain from Waste's Workspace. **Flagged a genuine open question** not
  resolved by the main runbook: whether `fishbonewaste.co.uk` is a *primary* or *secondary* domain in
  Waste's own account. Holdings' migration (already done) was the easy case — a secondary domain
  coming off 1&1, not a Google Workspace primary-domain move. Google generally does not allow a
  primary domain to simply be "removed"; freeing it usually means cancelling/deleting the whole
  subscription, which can carry a data-purge/cooldown delay before the domain is available to verify
  elsewhere. Presented as a checkpoint for Minda to verify in the Admin console before proceeding,
  not asserted as fact — genuine uncertainty, flagged rather than guessed past.
- **Phase D** — add the domain to Construction as a secondary domain, verify via TXT.
- **Phase E** — recreate both mailboxes under Construction with licences.
- **Phase F** (optional) — restore archived mail into the live mailboxes via Data Migration Service,
  flagged as needing to happen *before* Phase C's cancellation if wanted at all, since the source
  account won't be there afterward.
- **Phase G** — cut MX **and fix SPF in the same DNS session** — explicitly called out not to repeat
  the Holdings gap (OI-6, stale SPF left for a separate later fix).
- **Phase H** — cancel Waste's subscription, if not already forced by Phase C.
- **Phase I** — verification checklist, noting Eugene's own DNS tooling stayed blocked all session
  (same limitation hit verifying Holdings) so this may again need a Minda-supplied check.

Cross-referenced from the main runbook §4, which now points to this file as the actual thing to work
through and flags the same Phase C uncertainty.

**Governance.** Documentation-only; no live-system change, no credential referenced. Consistent with
charter §2b's delivery convention — a complete, paste-ready document rather than a delta — though this
is an execution checklist rather than a routine prompt, the same "hand over the whole thing" principle
applied.

**Next.** Minda works through the checklist at her own pace; report back after each phase (especially
Phase C's actual mechanism, once seen in the console) so the ledger/inventory/open-issues can be kept
current as the migration progresses.

## 2026-09-15 — Phase C: DNS-host location confirmed, separate from the account-structure question

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

Minda reported `fishbonewaste.co.uk` is DNS-hosted/registered at 1&1, not Google Domains — same
pattern as Holdings. Useful and worth recording, but it answers a **different** question from the
checklist's Phase C checkpoint: DNS/registrar location says nothing about whether the domain is
registered as Waste's Google Workspace account's **primary** or **secondary** domain (a Workspace
account-structure setting, independent of where DNS lives). Rather than let the two get conflated,
updated the checklist's Phase C checkpoint to record the DNS-host fact explicitly (no registrar-
transfer complication, same as Holdings) while keeping the primary-vs-secondary question open — still
needs a direct check in Waste's Admin console (Account → Domains → Manage domains) before relying on
"remove the domain" as a simple step.

**Produced/updated.** `Runbooks/Runbook-Waste-Migration-Execution-Checklist.md` Phase C checkpoint
rewritten to separate the two facts clearly. `processed-items-ledger.md` row 10 added.

**Governance.** Documentation-only; no console step taken by Eugene.

**Next.** Same as above — Minda checks Waste's Admin console for the primary/secondary status when
she's ready for Phase C, and reports back.

## 2026-09-15 — Phase D/G finding: domain's real DNS is at WordPress, not IONOS

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

Minda shared a screenshot of `fishbonewaste.co.uk`'s DNS settings in the IONOS panel. The panel itself
states the domain's **nameservers are pointed at WordPress** (its external website host) — any record
edited in the IONOS panel **does not take effect** unless the nameservers are reset back to IONOS's
defaults first. This explains why the panel shows apparently-correct Google MX records (`alt1-4.
aspmx.l.google.com`) even though it's inactive: it's a stored-but-not-authoritative mirror; the real,
live DNS — the one actually serving mail today — is at WordPress.

**Practical consequence.** The checklist's Phase D (adding Google's verification TXT record so
Construction can claim the domain as a secondary domain) and Phase G (cutting MX to Google's current
single-record target and fixing SPF) both need those records entered in **WordPress's own DNS
dashboard**, not the IONOS panel — editing IONOS's copy would silently do nothing. Rewrote both phases
accordingly, and added an explicit "don't reset nameservers back to IONOS as a shortcut" warning,
since that would put the live website's hosting at risk for no good reason (WordPress's own dashboard
should be able to handle the DNS record changes needed).

**Produced/updated.** `Runbooks/Runbook-Waste-Migration-Execution-Checklist.md` Phases D and G
rewritten with the WordPress-DNS redirect and the nameserver-reset warning.
`Infra-Inventory/Workspace-and-Email-Inventory.md` Waste row updated with the same finding.
`processed-items-ledger.md` row 11 added.

**Governance.** Documentation-only; no DNS or console step taken by Eugene — this was reading a
screenshot Minda provided and updating the guidance accordingly.

**Next.** When Minda reaches Phase D, she'll need to locate WordPress's DNS/domain management for
this site (wherever that account/dashboard lives) and confirm it exposes TXT/MX editing before
proceeding — flagged in the checklist as a check-before-you-act item, same treatment as the Phase C
primary/secondary question.
