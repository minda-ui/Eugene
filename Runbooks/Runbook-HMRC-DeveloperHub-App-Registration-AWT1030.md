# Runbook — Register the HMRC Developer Hub app (Minda) — step 1 of the VAT integration

> **Eugene, 2026-10-27 (guide-only, §3).** The **credentialed/outward** first step of the read-only HMRC
> VAT build (plan: `Plan-HMRC-VAT-ReadOnly-Integration-AWT1030.md`). **Minda does this** — it creates the
> developer account + sandbox app and the credentials that unblock Eugene's P1 build. **Eugene never holds
> the credentials**; they go into the secret store and the code references them. Read-only; nothing files.

## What you'll have at the end
A **sandbox** HMRC application subscribed to **VAT (MTD)**, with a **client ID + client secret + redirect
URI**, and a **test user (test VAT organisation)** — everything Eugene needs to build and prove the read
flow safely before anything touches the real companies.

## Step 1 — Create a developer account (2 min)
1. Go to **https://developer.service.hmrc.gov.uk**.
2. **Register** for a developer account (your email + a strong password → **store it in 1Password**). This
   is a *developer* account — **separate** from the company's Government Gateway / Business Tax Account.
3. Verify the email, sign in.

## Step 2 — Create a sandbox application (2 min)
1. **Applications → Add an application to the sandbox.**
2. Name it clearly, e.g. **`Fishbone VAT read-only`**. Description: "Read-only weekly pull of VAT
   obligations/liabilities/payments for reconciliation."

## Step 3 — Subscribe the app to the APIs (2 min)
On the application's **API subscriptions**, subscribe to:
- **VAT (MTD)** — the one we need (scope `read:vat`).
- **Create Test User** and **Test Fraud Prevention Headers** — helpers Eugene uses to test.
(You can add PAYE/CIS later for phase 5.)

## Step 4 — Get the credentials (and hand them over safely) (3 min)
1. On the app page, copy the **Client ID**.
2. **Generate a client secret** → copy it **once** (it's shown once).
3. Set a **Redirect URI** — use **`http://localhost:8631/callback`** for now (Eugene uses this for the
   one-time OAuth consent capture; we can change it later). Add it in the app's redirect URIs.
4. **Put the Client ID + Client secret + Redirect URI into the secret store** (1Password entry
   "HMRC Developer Hub – Fishbone VAT", and/or the environment secret the routine will read). **Do not
   paste the secret into chat, a Hub cell, or git** — tell Eugene only *where it lives*, never the value.

## Step 5 — Create a sandbox test user (2 min)
So Eugene can test without touching real data:
1. On the Developer Hub, use **Create Test User** (API or the "Test users" UI) to create a **test
   Organisation** with a **VAT enrolment** → it gives a **test VRN + test Government Gateway sign-in**.
2. Note the **test VRN** and the test credentials (into the secret store) — Eugene uses these to prove the
   obligations/liabilities/payments read end-to-end in the sandbox.

## Step 6 — Tell Eugene it's ready
Reply on the build Hub row (AWT-###, see below) with: **"sandbox app created, creds in <where>, test VRN
<x>"** — **no secret values**, just that it's done and where the creds live. Eugene then builds P1 (the
sandbox read flow with fraud headers) and shows you it working before we go near production.

## Later (NOT now) — production
Production is a **separate** application + credentials on the Developer Hub, and HMRC reviews it (you must
pass the fraud-prevention-headers check, which Eugene will have green from the sandbox). We do that at **P2**
— after the sandbox flow is proven and you OAuth-consent the 3 real VRNs (Construction 190175216, Waste
408853087, Commercial Properties 438278661).

## Guardrails (unchanged)
Read-only (`read:vat`). **You hold every credential**; Eugene references them from the secret store and
never holds a value. **Nothing files or pays.** Sandbox before production. Egress: Eugene will need
`test-api.service.hmrc.gov.uk` (sandbox) then `api.service.hmrc.gov.uk` (prod) on the allowlist — a
separate guide-only step.

---
_Guide-only; Minda executes; creds to the secret store, never to Eugene/chat/git. Unblocks P1 of
`Plan-HMRC-VAT-ReadOnly-Integration-AWT1030.md`. AWT-1030._
