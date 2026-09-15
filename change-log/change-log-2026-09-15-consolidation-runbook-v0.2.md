# Change log — 2026-09-15 — consolidation runbook bumped to v0.2

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4._

## 2026-09-15 — Runbook-Workspace-Consolidation-into-Construction updated to v0.2

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** Minda asked to reopen `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md`.
On review it was stale: §5 (dedicated `info@` + scoped ops account, resolves Peter OI-5) and §6
(Companies House egress allowlist, resolves Peter OI-6) were both still written as pending steps, but
both were actually closed later on 2026-09-13 — the same day the runbook was drafted — and are
documented in their own now-current runbooks (`Runbook-Dedicated-info-Inbox-and-Ops-Account.md` v0.2,
`Runbook-Email-Evidence-Retention-Google-Vault.md` v0.2, `Runbook-Companies-House-Access-for-Peter.md`
v0.2). §8's suggested execution order still listed §6 then §5 as the first two steps.

**Change (v0.1 → v0.2).**
- §5 marked **DONE 2026-09-13**: summarised the live `ops@`/`info@`/`invoice@` design and cross-
  referenced the two runbooks that now own that detail; added an open follow-up — decide per newly
  migrated domain (Holdings/SSAS/Waste) whether it needs its own `info@`/forward, or one
  Construction-wide `ops@` suffices.
- §6 marked **DONE 2026-09-13**: summarised the environment-API-credential resolution and cross-
  referenced the Companies House runbook.
- §8 tightened: only remaining step once §2 prerequisites are gathered is the **Holdings pilot** → SSAS
  → Waste → cancel Waste subscription. Removed the now-redundant "§6 then §5 first" ordering.
- Version header, changelog note, and prerequisite-list framing (§2 intro) updated to point at the new
  status.

**Not changed.** §1 target architecture, §2 prerequisite list itself, §3/§4 migration tracks, §7
safety/rollback — none of these needed correction; only the two already-closed sections and the
suggested order were stale.

**Governance.** Documentation-only edit to Eugene's own runbook (charter §2a/§3 — Eugene edits
code/repos/KB directly). No live-system change, no credential touched, no console step taken.

**Next.** Runbook still blocked on §2 prerequisites (super-admin access, Construction hub licence
headroom, exact Holdings/SSAS/Waste domains, DNS control, mailbox volumes) — Minda to gather from the
consoles before the Holdings pilot can start.
