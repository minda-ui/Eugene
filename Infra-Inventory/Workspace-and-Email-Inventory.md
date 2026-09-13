# Infra Inventory — Email & Google Workspace (Fishbone Group)

_Eugene's living inventory of where email/identity lives. Cite, never copy secrets (charter §3). Confirmed facts carry a date + source; anything unconfirmed is flagged. Last updated 2026-09-13._

## Confirmed 2026-09-13 (owner, Minda) — Google Workspace tenant shape (resolves Eugene OI-1)

The paid Google Workspace companies are on **separate subscriptions**, **not** one tenant with
multiple domains. Commercial Properties does **not** have its own subscription — it rides inside
**Properties'** subscription (its mailbox is `commercial@fishboneproperties.co.uk`).

| Company | Email hosting | Subscription / tenant | Notes |
|---|---|---|---|
| Fishbone Construction Ltd | Google Workspace (paid) | **Own subscription** | Domain `fishboneconstruction.co.uk`. Carries `info@` + `minda@` (the connected Gmail account). |
| Fishbone Properties Ltd | Google Workspace (paid) | **Own subscription** | Domain `fishboneproperties.co.uk`. **Also carries Fishbone Commercial Properties** as a user/alias `commercial@fishboneproperties.co.uk`. |
| Fishbone Commercial Properties Ltd | Google Workspace (paid) | **Inside Properties' subscription** | No separate subscription; `commercial@fishboneproperties.co.uk`. |
| Fishbone Waste Ltd | Google Workspace (paid) | **Own subscription** | Domain (to confirm — likely `fishbonewaste.co.uk`; `lana@fishbonewaste.co.uk` seen as a Collaboration Space owner). |
| Amfa Furniture Ltd | Google Workspace (paid) | **Own subscription** | Domain to confirm (company renamed from Furniture by Fishbone 13/07/2026 — check whether the Workspace domain was also renamed). |
| Fishbone Holdings Ltd | **1&1 (IONOS) Webmail** | — | Candidate to move to Workspace. |
| Fishbone SSAS | **1&1 (IONOS) Webmail** | — | A scheme, not a company; candidate to move to Workspace. |

**So:** **four** separate paid Google Workspace subscriptions (Construction, Properties, Waste, Amfa)
covering **five** companies (Commercial rides Properties); **two** entities on 1&1 (Holdings, SSAS).

## What this means for consolidation

A domain can live in **only one** Google Workspace account at a time. Because the Workspaces are
**separate subscriptions**, "put everything under one of the companies" is **not** the easy
"add a secondary domain to an existing tenant" — it is a **per-domain migration** (offboard the
domain from its current subscription, add it as a secondary domain to the chosen target, migrate
users / mailboxes / Drive). That is a real, staged project, not a settings change. (This retires the
hope in the 2026-09-12 owner note that Workspace multi-domain would make it a one-step change.)

Three realistic paths (decision pending — see Eugene `open-issues.md` OI-4):
- **A — Full consolidation:** migrate all domains into one chosen subscription (e.g. Construction) as
  secondary domains. One bill, one admin console; largest migration effort/risk.
- **B — Standardise in place:** keep the four separate subscriptions; just add the dedicated `info@`
  group/shared mailbox + a scoped ops/agent account **within each** where the workforce needs it.
  Fastest; unblocks Peter OI-5 now; more bills/consoles long-term.
- **C — Hybrid:** move only the two **1&1** entities (Holdings, SSAS) into an existing Workspace
  subscription as secondary domains (gets them off 1&1), leave the four Workspace subscriptions as
  they are for now. Middle effort.

## To confirm next
- Amfa's and Waste's exact Workspace domains (and whether Amfa's domain was renamed with the company).
- Per-subscription edition/seat counts and who the super-admin is on each (needed before any migration
  runbook; **read from the Admin console by Minda** — Eugene is guide-only for the console, charter §3).
- Whether the Gmail connector can read a Google Group / delegated mailbox (Eugene OI-2) — decides how
  the dedicated `info@` is wired (group membership vs a forwarded ops mailbox).
