# Runbook — Workspace consolidation into the Construction hub (v0.1, draft)

_Eugene runbook. **Eugene is guide-only for live systems (charter §3): this document is the guide;
Minda performs every Admin-console / DNS / registrar / migration step.** No secret (password, TXT
value, token) is ever written into this file — those are generated and entered live. Status: draft,
pending the prerequisites in §2. Author: Claude for Eugene, 2026-09-13. Decision basis: Eugene OI-1
(resolved) + OI-4 (owner, 2026-09-13)._

## 1. Target architecture (owner-agreed 2026-09-13)

Three Google Workspace tenants:

| Tenant | Holds | Change |
|---|---|---|
| **Construction (hub)** | `fishboneconstruction.co.uk` + **Holdings** + **SSAS** (from 1&1) + **Waste** (from its own Workspace), each as a **secondary domain** | Receives three domains |
| **Properties** | `fishboneproperties.co.uk` + Commercial (`commercial@fishboneproperties.co.uk`) | **Unchanged** |
| **Amfa** | its own subscription | **Unchanged — kept standalone for sale-readiness** (group OI-13) |

**A secondary domain keeps its own addresses, website and brand** — consolidation only merges the
admin console + billing, not identity. Amfa is kept separate because it is the entity most likely to
be sold; a standalone tenant is clean to carve out later.

**Out of scope:** Properties/Commercial and Amfa are not touched.

## 2. Prerequisites — gather before any change (Minda, from the consoles; Eugene guide-only)

Record these in `Infra-Inventory/` (values only; **never** passwords/recovery codes):
1. **Super-admin** of each of the four Workspace subscriptions (Construction, Properties, Waste, Amfa)
   and the **1&1/IONOS admin** for Holdings and SSAS.
2. **Construction hub headroom:** Workspace edition and number of free user licences (each migrated
   mailbox needs one).
3. **Exact domains:** confirm Waste's domain (likely `fishbonewaste.co.uk`), Amfa's domain, and the
   Holdings and SSAS domains on 1&1.
4. **DNS control** for each domain being moved (registrar/where MX + TXT records are edited).
5. **Mailboxes + rough mail volume** per domain being moved, and whether each has Drive data to carry.
6. **Gmail connector delegated-mailbox test (Eugene OI-2)** — decides whether a dedicated `info@` can
   be a Google Group / shared mailbox the connector reads, or must be a real user mailbox forwarded to
   an ops account.

Do not start Track 1 or 2 until §2 is filled in.

## 3. Track 1 — Holdings & SSAS: 1&1 → Construction hub (secondary-domain onboarding)

For each of the two domains (do Holdings first as a pilot, then SSAS):
1. **Add the domain as a secondary domain** in the Construction Admin console and **verify** it (add
   the Google-provided TXT record at the registrar; the TXT value is generated live — not stored here).
2. **Create the users/groups** on the new domain (mirror the mailboxes that exist on 1&1). Set
   temporary passwords the owner controls; the owner rotates them — Eugene never sees them.
3. **Pre-stage mail migration** from 1&1 over **IMAP** using Google's Data Migration Service (host,
   port, per-user IMAP credentials entered live by Minda). Run while 1&1 still receives mail.
4. **Cut over MX:** once mail is staged, change the domain's **MX records** at the registrar to
   Google's. Keep 1&1 mailboxes live briefly to catch stragglers; run a final delta migration.
5. **Decommission** the 1&1 mailboxes/hosting for that domain once mail is confirmed flowing to
   Workspace and the delta is clean.
6. **Verify:** send/receive test through the new Workspace mailbox; confirm old mail is present; MX
   resolves to Google (`dig MX <domain>`); no bounce from external senders.

## 4. Track 2 — Waste: its own Workspace → Construction hub (domain move)

Harder than Track 1: **Google will not let a domain be added to a second account while it still
exists in the first.** So the domain must be **removed from Waste's Workspace before it can be added
to Construction**, and any mail/Drive must be migrated first.
1. **Inventory + export** everything worth keeping from the Waste subscription (mail via export/Takeout
   or Data Migration; any Drive files — but per the group rules, cite/keep records rather than
   duplicating what already lives in the Waste KB). Waste is dormant, so volume should be small.
2. **Migrate mail** into the destination Waste addresses **created in the Construction hub** (as in
   Track 1 steps 1–3), or, if the addresses are only being retained (not actively used), export to an
   archive and skip re-provisioning.
3. **Remove the Waste domain** from the Waste Workspace subscription (Admin console), then **add it as
   a secondary domain** in the Construction hub and verify (TXT).
4. **Cut over MX** to the Construction hub; run a final delta.
5. **Cancel the Waste Workspace subscription** once the domain is gone and mail is confirmed in the
   hub (this is the seat/bill saving).
6. **Verify** as in §3.6, plus confirm the Waste subscription shows no active domains before cancelling.

## 5. Dedicated `info@` + scoped ops/agent account (resolves Peter OI-5)

Independent of the migration order — can be done per tenant as each is ready:
1. Create a **dedicated `info@<domain>`** as a Google Group / shared mailbox (if the OI-2 test says the
   Gmail connector can read one) **or** a real user mailbox forwarded to a single ops account (if not).
2. Create a **scoped ops/agent account** for the AI workforce — least-privilege, no admin rights, its
   own mailbox — the account Peter's Gmail connector should read instead of `minda@`'s personal
   mailbox. **Eugene never holds its credentials**; Minda sets and holds them.
3. Point the relevant company's incoming business mail at `info@`, and connect Peter's Gmail connector
   to the ops/`info@` mailbox (not `minda@`). This closes Peter OI-5.

## 6. Companies House egress allowlist (resolves Peter OI-6) — independent, can go first

Not part of the email migration; unblocks Peter beat 2b. Allowlist for Peter's scheduled-session
environment: `find-and-update.company-information.service.gov.uk` and
`api.company-information.service.gov.uk` (the free Companies House API — a key can be issued to the ops
account; Eugene never holds the key). Applied by the owner / environment admin; Eugene documents and
verifies (a scheduled test fetch succeeds).

## 7. Safety / rollback

- **Never cut MX before mail is staged.** Keep the source mailboxes live until a clean delta migration.
- Do **Holdings** as the pilot; only proceed to SSAS and Waste once Holdings verifies end-to-end.
- Keep an export/backup of each source mailbox until cutover is confirmed.
- No step here is taken by Eugene; each is executed by Minda in the console/registrar and then verified.
- **No credential or TXT value is recorded in this runbook or anywhere in Eugene's KB.**

## 8. Status / next
Draft pending §2 prerequisites. Suggested execution order once §2 is in: **§6 (Companies House
allowlist)** → **§5 (info@/ops account)** for Construction → **§3 Holdings pilot** → §3 SSAS → **§4
Waste** → cancel Waste subscription. Properties and Amfa untouched throughout.
