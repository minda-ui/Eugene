# Change log — 2026-09-13 — dedicated info@ + ops-account runbook

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Fourth dated file for 2026-09-13.)_

## 2026-09-13 — drafted the dedicated `info@` + scoped ops-account runbook

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Produced.** `Runbooks/Runbook-Dedicated-info-Inbox-and-Ops-Account.md` (v0.1) — resolves **Peter
OI-5** and gives the Companies House API key (and future workforce secrets) a home:
1. A **scoped ops/agent account** (e.g. `ops@fishboneconstruction.co.uk`) — least-privilege, no admin
   roles, 2FA on, its own mailbox — the single identity the workforce authenticates as. Minda holds
   its password; **Eugene never sees it.** One Workspace seat.
2. A **dedicated `info@` business inbox** Peter triages instead of minda@'s personal mailbox.
3. **Gated by the OI-2 test** (§2): if the Gmail connector can read a Google Group / shared mailbox,
   `info@` is a free Collaborative-Inbox Group; if it can only read the connected account's own
   mailbox, `info@` is a real mailbox or forwards into the ops account's mailbox.
4. **Repoint Peter's Gmail connector** from minda@ to the ops/`info@` inbox — the step that actually
   closes Peter OI-5.
5. §4 covers the other companies later (Holdings/SSAS/Waste read by the same ops account once in the
   Construction hub; Properties/Amfa separate — cross-domain group membership or forwarding), tied to
   Peter OI-4 (which inboxes). Start with Construction.

**Recorded.** `current-state.md` refreshed (Next action now lists all three runbooks in suggested owner
order). Peter OI-5 stays in **Peter's** KB, resolved there once the connector is repointed.

**Governance.** Guide-only; every console/connector step is Minda's; least-privilege + 2FA on the ops
account; **no password or key recorded anywhere.** No live-system change made.

**Eugene now holds three runbooks:** Workspace consolidation (pending prerequisites), Companies House
access (Peter OI-6), and this dedicated `info@`/ops account (Peter OI-5). Suggested owner order:
Companies House allowlist + key → this info@/ops account → Workspace consolidation.
