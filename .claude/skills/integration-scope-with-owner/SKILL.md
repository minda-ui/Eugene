---
name: integration-scope-with-owner
description: Scope a new read-only external-system integration end-to-end BEFORE any build — HMRC, a site-chat platform (Telegram/WhatsApp), a vendor or gov API, any outside system Minda wants connected. Use whenever Minda asks "is there an API to this system?", "can we connect to X?", "I need data from Y", "can Anna/Rachel/an employee see Z?", or "build a connection to a service" — and before writing any integration plan or code. Bakes in the §3 boundary (read-only, Minda holds all creds/OAuth, never files/pays) and the discipline that bit twice: confirm the real need with the domain-owner employee FIRST (don't assume), and don't duplicate a tool the estate already has (QuickBooks etc.). Guide-only: Eugene scopes/builds/verifies; Minda does every credentialed step. Built 2026-10-28 from the HMRC VAT (Rachel, AWT-1030/1031/1032) + Telegram site-chat (Anna, RND-21) scopings.
---

# Scope a read-only external integration with its domain-owner

When Minda says "connect us to \<system X\>", the instinct is to start building. The two scopings this
skill is built from both showed why not to: **HMRC** looked redundant with QuickBooks until Rachel named
the one gap QB can't close (its VAT control doesn't tie to HMRC); **Telegram site-chat** is Anna's domain,
so Anna — not Eugene — says what's actually useful. Scoping first turns "build a thing" into "build the
*right* read-only thing, confirmed by the person who'll use it, with Minda holding the keys."

**Guide-only / §3 (non-negotiable, bake into every plan you write):**
- **Read-only.** The integration *reads*; it never files, pays, posts, writes to a system of record, or
  sends. Say this explicitly in the plan.
- **Minda holds all credentials + does the OAuth / app registration / device link.** Eugene references
  where a secret lives, never its value, never commits one.
- **Privacy/consent is Minda + the relevant steward's call** (Victoria for workforce-monitoring / personal
  data), never assumed by Eugene — flag it, don't decide it.
- Cross-KB scoping goes through the owner's **`Raw/` + a Hub row** (use `raw-handoff-to-employee`), never a
  direct edit of their KB.

## The five steps

### 1. Don't duplicate what the estate already has
Before anything, ask: does an existing tool already answer this? QuickBooks (finance), the connectors,
Smartsheet, a live routine. Name the **one genuine value-add** the new integration gives that the existing
tool can't. If there isn't one, say so to Minda and stop — that's a good outcome, not a failed one.
(HMRC: QB has the VAT numbers, but only HMRC's own figures can *reconcile* against them. That reconciliation
was the value-add; pulling raw VAT data would have duplicated QB.)

### 2. Confirm the real need with the domain-owner — don't assume
Find whose domain this is (finance = Rachel, construction = Anna, properties = John, Amfa = Nadia/Darius,
ops = Alex, index/governance = Victoria) and **ask them directly** what they need, via their `Raw/` + a Hub
row (`raw-handoff-to-employee`). Ask what's missing today, what decision/report it feeds, and the shape of a
useful output. Wait for their answer before planning. Minda may say "just build it" — gently push the one
question anyway; it's cheap and it's what separated a real HMRC need from a guessed one.

### 3. Establish the API reality (research, cite sources)
Work out, and write down with sources:
- Is there an **official read API**? (Many systems only expose *write*/send or *your-own-account* data —
  e.g. the WhatsApp Business Cloud API can't read existing group chats; HMRC has read APIs for VAT & CIS but
  **none clean for Corporation Tax**.)
- **Auth model:** OAuth scope(s), API key, user-client vs bot, mandatory headers (e.g. HMRC's Gov-Client-*
  fraud-prevention headers), token lifetimes.
- **Composio connector or custom build?** Check `composio search "<system>"`. No connector = a custom
  self-hosted build — say so.
- **Egress:** can an unattended routine even reach the host? gov.uk is **blocked for routines (OI-6)**, so a
  first build runs interactively or against a sandbox. Check the network policy.
- **ToS / risk:** is the only read path unofficial (ban risk, breaks E2EE, fragile)? Name it and steer the
  safe option (e.g. a dedicated number, a sandbox, or a behaviour change) — don't bury the risk.

### 4. Write a phased, read-only build plan
Produce `Runbooks/Plan-<System>-ReadOnly-Integration-<AWT|RND>.md` with:
- **Goal + the one value-add** (step 1) and the **owner's confirmed inputs** (step 2).
- **The API reality** (step 3), sandbox-first.
- **Output spec** exactly as the owner asked (format, where it lands, who sees it, cadence).
- **Phasing:** `P0 scope → P1 sandbox/auth → P2 recon/output → …→ expand`. Each phase small and verifiable.
- **The §3 boundary block** spelled out (read-only, Minda holds creds, never files/pays, privacy owner).
- A **build Hub row** for the work itself, **blocked on** Minda's step-1 registration.

### 5. Hand Minda the step-1 registration runbook
The first credentialed step is always Minda's. Write `Runbooks/Runbook-<System>-<Registration>-<AWT>.md`:
the exact console path to register the app / create the OAuth client / link the device / make a sandbox
test user, the redirect URI, the scopes to request, and "creds into the secret store" (never into git, never
to Eugene). This is the guide-only gate that unblocks P1.

## Output shape
Two files in `Runbooks/` (the plan + Minda's step-1 runbook), an R&D design note if it started speculative
(`R&D/<slug>/design.md`), the owner hand-off(s) via `raw-handoff-to-employee`, and a build Hub row blocked on
Minda's registration. Then the usual change-log + ledger entry.

## Worked precedents (read these if unsure)
- **HMRC VAT** (finance/Rachel): `Runbooks/Plan-HMRC-VAT-ReadOnly-Integration-AWT1030.md` +
  `Runbook-HMRC-DeveloperHub-App-Registration-AWT1030.md`. Value-add = reconciliation, not duplicating QB.
- **Telegram site-chat** (construction/Anna): `Runbooks/Plan-Telegram-Site-Chat-Pilot-Anna-RND21.md` +
  `R&D/site-chat-bridge/design.md`. Telegram clean; WhatsApp ToS/ban-caveated; privacy = Minda + Victoria.

---
_Guide-only (§3): Eugene scopes/builds/verifies; Minda does every credentialed step and holds all secrets.
Confirm the need with the owner first; don't duplicate an existing tool; read-only always. Pairs with
`raw-handoff-to-employee` (the owner scoping) and `ask-minda` (the green-light)._
