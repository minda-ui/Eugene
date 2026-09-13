# Change log — 2026-09-13 — Companies House access runbook (standalone)

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4. (Third dated file for 2026-09-13.)_

## 2026-09-13 — split the Companies House allowlist into its own runbook

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

At the owner's request, split the Companies House access work out of the consolidation runbook into a
**standalone runbook** so Peter's Companies House beat can be unblocked immediately, independent of the
email migration.

**Produced.** `Runbooks/Runbook-Companies-House-Access-for-Peter.md` (v0.1) — resolves **Peter OI-6**:
1. **Allow the egress** for Peter's routine environment — the four gov.uk domains
   (`api.` / `document-api.` / `find-and-update.company-information.service.gov.uk`, + optional
   `www.gov.uk`). Set via the environment's network policy — an owner/admin change; Eugene guide-only.
2. **Issue a free Companies House REST API key** under the ops/agent account, stored as an environment
   secret the routine reads at run time. **Eugene never holds or records the key** (HTTP Basic auth,
   key as username, empty password).
3. **Point Peter's beat-2b prompt at the API** (company/officers/filing-history/charges for the six
   company numbers), web service as fallback.
Verify with a test fetch of Construction (07948220) returning JSON and a sourced record in Peter's
`Research/`.

**Recorded.** `current-state.md` refreshed (Last session + Next action now reference the standalone
runbook and mark it "do first"). Peter OI-6 stays in **Peter's** KB and is marked resolved there once
the allowlist + key are actually applied.

**Governance.** Guide-only; no live-system change; no key/secret recorded anywhere.
