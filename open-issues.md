# Open Issues — Eugene (AI IT & Engineering Assistant)

_The `OI-<n>` table. A resolved issue gets a `Resolved` line, never a deletion. See `CLAUDE.md` §4 and §6._

| OI | Opened | Status | Issue |
|---|---|---|---|
| OI-1 | 2026-09-12 | Open | **Google Workspace tenant shape.** The paid Google Workspace companies (Fishbone Construction, Properties, Commercial Properties, Waste, **Amfa Furniture**) — are they in **one tenant with multiple domains**, or **separate subscriptions/tenants**? Fishbone Holdings and the SSAS are on 1&1 Webmail. This decides whether consolidating the 1&1 domains is "add secondary domains to the existing tenant" (simple) or "consolidate tenants first" (larger). It is the first fact Eugene needs before writing the Workspace runbook. Decision/info: Minda (Eugene will produce the check steps; Minda reads the Admin console). |
| OI-2 | 2026-09-12 | Open | **Gmail connector delegated-mailbox capability.** Confirm whether the Gmail connector can read a Google Group / delegated / shared mailbox, or only the connected account's own primary mailbox. Decides whether per-company `info@` works via group membership or must be forwarded into one ops mailbox. Directly relates to **Peter OI-5** (the connector currently reaches minda@'s own mailbox, not a dedicated info@). A ~5-minute test in Phase 0. Decision/test: Minda + Eugene. |
| OI-3 | 2026-09-12 | Open | **First-runbooks priority.** Proposed order: (a) Workspace multi-domain + ops account (unblocks dedicated agent accounts group-wide), (b) Companies House egress allowlist (resolves Peter OI-6, unblocks Peter beat 2b), (c) dedicated `info@` groups (resolves Peter OI-5). Confirm or reorder. Decision: Minda. |
