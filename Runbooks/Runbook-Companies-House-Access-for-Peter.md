# Runbook — Companies House access for Peter's scheduled sessions (v0.2)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda performs the console /
environment / key steps.** **No API key or other secret is ever written into this file or anywhere in a
KB** — the key is stored as a write-only environment API credential; Eugene references only *where* it
lives, never its value. Author: Claude for Eugene. v0.1 2026-09-13; **v0.2 2026-09-13 — RESOLVED.**
Resolves **Peter OI-6** (unblocks Peter beat 2b — Companies House research)._

## Status (2026-09-13) — DONE, one environment to mirror

- ✅ **Method proven and verified.** Companies House REST API reachable; all six registered companies
  returned **HTTP 200** live (test from the "Fishbone Group" environment).
- ⬜ **One config step left:** add the same credential to the **"Minda"** cloud environment (the one
  Peter's routines run in). See §3C and §4.

## 1. Problem (as first seen 2026-09-12)

On Peter's first scheduled run every gov.uk / Companies House domain returned `EGRESS_BLOCKED`, so
beat 2b could produce no sourced digest. **Investigation 2026-09-13:** the block is the
**organisation's network egress policy** (a proxy 403/407-class denial) — it applies even to an
interactive session, is **not** exposed as a per-routine/per-connector setting, and the routine editor
has **no domain-allowlist control**. So the v0.1 plan ("allowlist the four gov.uk domains") was not a
lever the user actually had. Per environment policy we do **not** route around an egress denial — we
use a supported mechanism instead.

## 2. The mechanism that works — an environment API credential

Claude Code cloud environments expose **API credentials** (Edit cloud environment → API credentials).
The platform describes them exactly: *"The proxy attaches each credential to requests for that
credential's hosts, and those hosts become reachable even when Network access wouldn't otherwise allow
them. Values can't be viewed after saving and never reach the session as environment variables or
files."* This solves **both** of our problems at once:

- **Egress:** adding a Companies House credential makes `api.company-information.service.gov.uk`
  reachable, with Network access left on **Trusted** (no org-policy change needed).
- **Secret handling (charter §3):** the key is **write-only** — it never reaches the session, so Peter
  uses it without ever holding or seeing it. Strictly better than a plain environment secret/variable.

Only the **REST API** host is opened (structured JSON: profile, officers, filing history, charges).
The human-readable web service (`find-and-update…`) and the filing-document API (`document-api…`) are
**not** opened; if a future beat needs filing PDFs, add `document-api.company-information.service.gov.uk`
as a second allowed website on the same credential.

## 3. Steps

**A. Register a free Companies House REST API key (Minda; Eugene never holds it).**
1. At `developer.company-information.service.gov.uk`: sign in / register (free), **create an
   application — choose "Live"** (not Test, which returns dummy data).
2. In the application, **create an API client of type "API key"** (not stream key, not OAuth). Copy the
   key somewhere safe for a moment. Register it under the **ops/agent account** where practical so the
   workforce owns it. **Never paste the key into any prompt, KB file, change-log or Drive doc.**

**B. Add it as an API credential on the environment (Minda; Eugene guide-only).**
3. Open **Edit cloud environment** for the target environment → **API credentials → Add credential**:
   - **Name:** `Companies House API`
   - **Credential type:** **Basic** (Companies House uses HTTP Basic auth, *not* Bearer)
   - **Allowed websites:** `api.company-information.service.gov.uk`
   - **Username:** the API key   ·   **Password:** *blank*
   - **Connect.** The value is stored write-only.
4. Companies House Basic auth = **key as username, empty password**. The proxy attaches it
   automatically, so Peter's code must **add no Authorization header of its own** — just plain GET
   requests.

**C. Do it on the environment Peter's routines actually run in.**
5. Peter's routines ("Peter — Companies House research", "Peter — inbox triage + capture") run in the
   cloud environment named **"Minda"** (confirmed 2026-09-13 from the routine's Cloud-environment
   indicator) — **not** the "Fishbone Group" environment this interactive session uses. The credential
   was first added to "Fishbone Group" (where it was verified). **Repeat §3B on the "Minda"
   environment** so Peter's routine can reach the API. (Having the credential on both environments is
   fine; each stores its own write-only copy.)

**D. Point Peter's beat 2b at the API (prompt update; drafted by Eugene, entered by Minda).**
6. Peter's routine prompt (`Peter - AI Data Assistant/Routine-Prompt-Companies-House.md`, v2026-09-13b)
   calls `https://api.company-information.service.gov.uk/company/{number}` (+ `/officers`,
   `/filing-history`, `/charges`) for the six numbers (Holdings 10146262, Construction 07948220,
   Properties 09687012, Commercial Properties 13687238, Waste 13201875, Amfa 11259604), makes plain
   requests, and stages a sourced digest — or, on `EGRESS_BLOCKED`/401, stages nothing and re-raises
   OI-6. Rate limit 600 req / 5 min — trivial for six companies. Paste it into the routine's
   Instructions.

## 4. Verify
- A live `GET /company/07948220` returns **HTTP 200 JSON** (name, status, accounts/confirmation dates).
  **Done 2026-09-13** from "Fishbone Group": all six companies HTTP 200.
- After §3C, a **manual test-run** of the "Peter — Companies House research" routine (which runs in
  "Minda") stages a **sourced** record in `Research/` with no `EGRESS_BLOCKED` in the log → confirms
  OI-6 fully closed for the routine.

## 5. Boundary / notes
- Eugene documents and verifies; the key issuance and the credential entry are **Minda** actions.
  Eugene **never holds or records the API key**.
- Independent of the Workspace consolidation — done first, unblocks Peter's Companies House beat now.
- Hygiene: if the key ever appears on screen (e.g. a setup screenshot), regenerate it on the CH
  developer site and update the credential's Username; it is a read-only public-data key (low risk).
- On done, **Peter OI-6 marked resolved** in Peter's own `open-issues.md` (Peter's KB owns that issue).

## 6. Change history
- v0.2 2026-09-13 — **resolved.** Rewritten from the (unavailable) domain-allowlist approach to the
  **environment API credential** mechanism; verified live for all six companies; added §3C (the
  "Minda" environment) and the Basic-auth specifics. Supersedes v0.1.
- v0.1 2026-09-13 — first draft (allowlist four gov.uk domains + store key as environment secret).
