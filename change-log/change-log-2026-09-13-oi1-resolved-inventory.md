# Change log — 2026-09-13 — OI-1 resolved; email/Workspace inventory started

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4._

## 2026-09-13 — Workspace tenant shape confirmed (OI-1 resolved), consolidation path opened (OI-4)

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Owner input.** Minda confirmed the paid Google Workspace companies are on **separate
subscriptions** — Construction, Properties, Waste and Amfa each have their own — and that
**Commercial Properties has no separate subscription**: it rides inside **Properties'** as
`commercial@fishboneproperties.co.uk`. Holdings and the SSAS remain on 1&1 Webmail. So **four paid
Workspace subscriptions cover five companies**, and two entities are on 1&1.

**Recorded.**
- New inventory `Infra-Inventory/Workspace-and-Email-Inventory.md` — the confirmed per-company
  hosting map, the consolidation implication (a domain lives in only one Workspace account, so
  consolidation is a **per-domain migration**, not a secondary-domain add), and to-confirm items
  (Amfa/Waste exact domains; per-subscription super-admin + seat counts; Gmail delegated-mailbox
  capability = OI-2).
- `open-issues.md`: **OI-1 marked Resolved 2026-09-13** with the answer; **OI-4 opened** — the
  consolidation-path choice (A full consolidation / B standardise in place / C hybrid). OI-3 note
  added that the ops-account + dedicated-`info@` work can proceed per subscription without a
  migration.
- `current-state.md` refreshed (Last session, Open issues, Next action).

**No live-system change made.** Eugene is guide-only for the Admin console; the per-subscription
super-admin and seat/edition details must be read from the console by Minda before any migration
runbook. No secret recorded.

**Next:** Minda to choose OI-4 (A/B/C), which decides the first runbook. The **Companies House egress
allowlist** runbook (resolves Peter OI-6) is independent of OI-4 and can be produced anytime.
