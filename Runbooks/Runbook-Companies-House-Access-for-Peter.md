# Runbook — Companies House access for Peter's scheduled sessions (v0.1)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda / the environment admin
performs the egress change and issues the API key.** **No API key or other secret is ever written into
this file or anywhere in a KB** — the key is stored as an environment secret the routine reads at run
time; Eugene references only *where* it lives. Author: Claude for Eugene, 2026-09-13. Resolves **Peter
OI-6** (and unblocks Peter beat 2b — Companies House research)._

## 1. Problem

On Peter's first scheduled run (2026-09-12) every gov.uk / Companies House domain returned
`EGRESS_BLOCKED` from the routine's execution environment, so beat 2b could produce no sourced
digest — only unverified WebSearch snippets (staged in Peter's `_unverified/`). Two things are needed:
**(a)** the environment must be allowed to reach Companies House, and **(b)** Peter should use the
**free Companies House REST API** (structured JSON) rather than scraping the web page.

## 2. Domains to allow (for Peter's scheduled-session environment)

| Domain | Why |
|---|---|
| `api.company-information.service.gov.uk` | **The REST API** — structured JSON for company profile, officers, filing history, charges. Primary source. |
| `document-api.company-information.service.gov.uk` | Fetch the actual filing documents (PDF/metadata) referenced by the filing history. |
| `find-and-update.company-information.service.gov.uk` | The public web service — human-readable fallback / cross-check when the API is not enough. |
| `www.gov.uk` | Guidance pages (optional; only if a beat needs them). |

## 3. Steps

**A. Allow the egress (environment admin / Minda; Eugene guide-only).**
1. Peter's routines run in a Claude Code remote-execution environment whose **outbound network access is
   set by the environment's network policy** (chosen when the environment was created; see the Claude
   Code on the web docs). Identify which environment Peter's two routines run in.
2. Set that environment's network policy to **permit the domains in §2** (either a policy that allows
   them, or an allowlist entry per domain — whichever the environment supports). This is a
   configuration change **only the environment owner/admin can make**; Eugene documents it and cannot
   apply it.

**B. Register a Companies House API key (Minda; Eugene never holds it).**
3. Create a free developer account at `developer.company-information.service.gov.uk` and register an
   application to get an **API key**. Register it under the **ops/agent account**, not minda@'s
   personal login (see the consolidation runbook §5), so the workforce owns it.
4. Store the key as an **environment secret / connector credential** that Peter's routine can read at
   run time (e.g. an environment variable in the routine's environment). **Do not paste the key into
   any prompt, KB file, change-log, or Drive doc.** The Companies House REST API uses HTTP Basic auth
   with the **key as the username and an empty password**.

**C. Point Peter's beat 2b at the API (prompt update; drafted by Eugene, entered by Minda in the
routines form).**
5. Update Peter's "Companies House research" routine prompt to call
   `https://api.company-information.service.gov.uk/company/{company_number}` (and
   `/officers`, `/filing-history`, `/charges`) for the six registered companies, reading the key from
   the environment secret; fall back to the `find-and-update` web service only if the API is
   unavailable. Bake in the six company numbers: Holdings 10146262, Construction 07948220, Properties
   09687012, Commercial Properties 13687238, Waste 13201875, Amfa Furniture 11259604.
6. Respect the API rate limit (600 requests / 5 minutes) — trivial for six companies.

## 4. Verify
- A one-off scheduled/manual test fetch of **Construction (07948220)** returns HTTP 200 JSON with the
  company profile (name, status, accounts/confirmation-statement dates).
- Peter stages a **sourced** record in `Research/` (with the API URL + retrieved date) rather than an
  `_unverified/` snippet — confirming OI-6 is cleared.
- No `EGRESS_BLOCKED` in the run log for the §2 domains.

## 5. Boundary / notes
- Eugene documents and verifies; the egress change and the key issuance are **Minda / environment
  admin** actions. Eugene **never holds or records the API key**.
- This is **independent of the Workspace consolidation** — it can be done first, and immediately
  unblocks Peter's Companies House beat.
- Once done, mark **Peter OI-6 resolved** in Peter's own `open-issues.md` (Peter's KB owns that issue).
