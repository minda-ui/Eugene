# Change log — 2026-09-13 — OI-4 resolved; Workspace consolidation runbook drafted

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Second dated file for 2026-09-13; the first covered OI-1 + the inventory.)_

## 2026-09-13 — consolidation path chosen (OI-4 resolved), first runbook drafted

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Advice given.** The owner leaned toward full consolidation but wanted Amfa kept separate "because
it has its own website." Corrected the reasoning: a **secondary domain keeps its own email addresses,
website and public brand** — consolidation only merges the admin console + billing — so the separate
website is not a reason to keep a subscription separate. The **real** reason to keep Amfa standalone is
**sale-readiness** (group OI-13: workshop/machinery being realigned to Amfa ahead of a possible sale);
a standalone tenant is clean to carve out, whereas pulling a domain back out of a consolidated tenant
later is the painful path. Owner agreed.

**Decision (OI-4 resolved, owner 2026-09-13) — three-tenant target:**
- **Construction = hub:** fold in **Holdings + SSAS** (off 1&1) and **Waste** (dormant, own Workspace)
  as secondary domains.
- **Properties (+ Commercial):** stays its own tenant (separate legal company; governance line).
- **Amfa:** stays standalone (sale-ready).

**Produced.** `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` (v0.1, draft): target
architecture; §2 prerequisites Minda must read from the consoles; **Track 1** (1&1 → Construction for
Holdings then SSAS — secondary-domain onboarding + IMAP mail migration + MX cutover + 1&1
decommission); **Track 2** (Waste Workspace → Construction — remove the domain from Waste's account,
add to the hub, then cancel the Waste subscription); §5 dedicated `info@` + scoped ops/agent account
(resolves Peter OI-5); §6 Companies House egress allowlist (resolves Peter OI-6, independent); §7
safety/rollback; §8 suggested order.

**Recorded.** `open-issues.md` OI-4 Resolved; `Infra-Inventory/Workspace-and-Email-Inventory.md`
updated with the decided architecture; `current-state.md` refreshed.

**Governance.** Runbook is guide-only — every console/DNS/registrar/migration step is Minda's to
execute; Eugene verifies. **No credential or TXT value recorded anywhere.** No live-system change made.

**Next:** Minda gathers the §2 prerequisites and runs the OI-2 Gmail delegated-mailbox test; the
Companies House allowlist (runbook §6) can be actioned first, independent of the migration.
