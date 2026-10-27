# Plan — Read-only HMRC VAT (MTD) integration for Finance (scoping)

> **Eugene, 2026-10-27 (guide-only, §3).** Scoping the read-only HMRC connection Rachel confirmed a real
> need for (AWT-1030). **Read-only, VAT first**, then PAYE/CIS; **not Corporation Tax** (adviser's).
> Eugene builds + verifies the plumbing; **Minda registers the HMRC app, does the OAuth and holds every
> credential**; **nothing files or pays**. Finance ownership stays Rachel's — this feeds her work, it
> doesn't replace it._

## Why (Rachel's three concrete uses — AWT-1030)
1. **Tax calendar** — open obligations + due dates (AWT-0804 item 3).
2. **Reconciliation** — tie **QuickBooks VAT control balances to HMRC's own figures**. A 22 Oct draft found
   they **don't currently tie** — this is the core driver; QuickBooks structurally can't show HMRC's side.
3. **13-week cashflow forecast** — amount due now (incl. penalties/interest/part-payments) + payments.
Cadence: **weekly, Mondays, not live.** Fallback today: Minda exports HMRC statements monthly (manual).

## Scope + boundaries
- **In:** read-only HMRC **VAT** data (phase 1); **PAYE, CIS** later (phase 5). **Out:** Corporation Tax
  (no clean read API; adviser's), and **any write/submit/file/pay** — never (§3).
- **Credentials:** HMRC Developer Hub `client_id`/`client_secret`, the Government Gateway login, and the
  OAuth tokens are **all Minda's** — held in 1Password / the environment secret store. **Eugene never
  holds a value**; the code reads them from the secret store by reference.
- **Outward/credentialed actions are Minda's:** registering the HMRC app, OAuth consent, production
  approval. Eugene does the build + sandbox + verification guide-only.

## How it works (the HMRC VAT MTD API)
- **No managed connector** (Composio has no HMRC toolkit) → a **small custom integration** (OAuth 2.0 +
  REST), a scheduled job in a capped LXC/routine. (Mature open libs exist to crib from.)
- **Auth:** OAuth 2.0 **user-restricted**, scope **`read:vat`**. The business authorises via Government
  Gateway (Minda) → the app gets an **access token (~4 h)** + **refresh token (~18 months)**. The weekly
  job refreshes the access token; **Minda re-consents when the refresh token expires**.
- **Mandatory fraud-prevention headers** (`Gov-Client-*` / `Gov-Vendor-*`) on **every** call — they
  describe the originating connection/server. HMRC rejects or flags calls that get these wrong, so this is
  the fiddliest part; we validate with HMRC's **"Test Fraud Prevention Headers" API** before go-live.
- **Endpoints (read-only):** per VAT-registered entity (its **VRN**):
  - `GET …/organisations/vat/{vrn}/obligations` → open/fulfilled obligations + due dates (→ calendar).
  - `GET …/organisations/vat/{vrn}/liabilities` → what's owed incl. penalties/interest (→ reconcile + forecast).
  - `GET …/organisations/vat/{vrn}/payments` → payments HMRC has received (→ reconcile + forecast).
  - `GET …/organisations/vat/{vrn}/returns/{periodKey}` → a submitted return (reconcile a specific period).
  - (VAT **Penalties** API, separate, for penalty points — later if wanted.)
- **Sandbox first:** build + prove against `test-api.service.hmrc.gov.uk` with HMRC test users; only then
  production `api.service.hmrc.gov.uk` (needs HMRC app approval).
- **Egress:** add `api.service.hmrc.gov.uk` (+ sandbox) to the routine egress allowlist (OI-6 / SRC-6 —
  gov.uk is blocked for scheduled sessions today). Guide-only, env admin (Minda).

## Who does what
| Who | Does |
|---|---|
| **Minda** | Register the HMRC Developer Hub app; OAuth-consent per entity (Gateway); hold `client_id`/`secret`/tokens in the secret store; approve production; apply the egress allowlist. The outward/credentialed steps. |
| **Eugene** (§2a/2b) | Build the OAuth + read-job + fraud-headers; sandbox-test; the weekly scheduled pull; output the data in the shape Rachel specifies; verify; write the ops runbook. Holds no secret. |
| **Rachel** (finance owner) | Specify the exact fields + the reconciliation mapping (which QuickBooks control accounts tie to which HMRC figures), the tax-calendar fields, the 13-week-forecast inputs, which entities/VRNs are in scope, and validate the output is useful. Consumes the data. |

## Phasing
- **P0 — scope (now):** Rachel confirms the open questions below; Minda gives go/no-go on building vs the
  monthly-manual fallback.
- **P1 — app + sandbox:** Minda registers the Developer Hub app; Eugene builds the OAuth + a sandbox read
  of obligations/liabilities/payments with valid fraud headers; prove the flow end-to-end on test users.
- **P2 — production auth:** HMRC approves the app; Minda OAuth-consents the real entity/entities; tokens
  stored.
- **P3 — weekly read job:** the Monday pull of obligations/liabilities/payments per VRN → a structured
  output (CSV/sheet/JSON, Rachel's choice) in Finance's space.
- **P4 — Rachel's consumption:** reconcile to the QuickBooks control accounts (close the 22 Oct gap), feed
  the tax calendar + the 13-week forecast.
- **P5 — extend:** PAYE + CIS read (same pattern, different APIs/scopes) once VAT is proven.

## Open questions for Rachel (drive the build)
1. **Entities/VRNs** — which VAT-registered companies are in scope (Construction / Properties / … )? One
   OAuth consent + one pull per VRN.
2. **Reconciliation mapping** — which **QuickBooks control accounts** should tie to which HMRC figures
   (VAT liability / payments)? (This is what didn't tie on 22 Oct — the mapping is the heart of it.)
3. **Tax-calendar fields** — exactly what AWT-0804 item 3 wants populated (obligation period, due date,
   amount, status?).
4. **13-week forecast inputs** — which HMRC figures feed it, keyed how (by due date)?
5. **Output format + location** — CSV / a Smartsheet / JSON, and where in Finance's space it should land
   for her Monday run.

## Open items for Minda (the credentialed/outward steps)
- Go/no-go: **build it**, or stick with the monthly manual export for now?
- If go: register the HMRC Developer Hub app; be ready to OAuth-consent per entity; decide where secrets
  live; approve the egress allowlist change.

---
_Guide-only; read-only; Minda holds all HMRC credentials + does the OAuth; nothing files/pays (§3).
Finance owned by Rachel (cross-KB via her Raw). Sources: HMRC Developer Hub VAT (MTD) API; fraud-prevention
headers guidance. AWT-1030._
