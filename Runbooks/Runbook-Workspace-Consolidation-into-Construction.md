# Runbook — Workspace consolidation into the Construction hub (v0.3, draft)

_Eugene runbook. **Eugene is guide-only for live systems (charter §3): this document is the guide;
Minda performs every Admin-console / DNS / registrar / migration step.** No secret (password, TXT
value, token) is ever written into this file — those are generated and entered live. Status: draft;
Waste is the only track still open — see §8. Author: Claude for Eugene, 2026-09-13; updated
2026-09-15 (v0.2), 2026-09-15 (v0.3). Decision basis: Eugene OI-1 (resolved) + OI-4 (owner,
2026-09-13). **v0.3 change (owner-reported 2026-09-15):** Holdings is **already migrated** under
Construction — Track 1's Holdings half is done, pending Eugene DNS verification (blocked, see §3a).
SSAS turns out to have **no domain or Workspace of its own** — it drops out of the plan entirely,
nothing to migrate. Super-admin identities recorded (§2.1) — each subscription's super-admin login is
a shared business mailbox (`info@`/`sales@`), not a named personal account; flagged as **Eugene OI-5**
(advisory, not blocking). Waste is now the only remaining migration track. **v0.3 addendum (same day):** DNS control confirmed —
Minda holds registrar access for both `fishboneholdings.co.uk` and `fishbonewaste.co.uk`. Only §2.5
(Waste's mailbox count/mail volume) is still outstanding before §4 can start._

## 1. Target architecture (owner-agreed 2026-09-13; updated 2026-09-15)

Two Google Workspace tenants change; two don't:

| Tenant | Holds | Change |
|---|---|---|
| **Construction (hub)** | `fishboneconstruction.co.uk` + **Holdings** (secondary domain, **already added — owner-reported 2026-09-15**) + **Waste** (still to migrate) | Receives Waste; Holdings done |
| **Properties** | `fishboneproperties.co.uk` + Commercial (`commercial@fishboneproperties.co.uk`) | **Unchanged** |
| **Amfa** | its own subscription | **Unchanged — kept standalone for sale-readiness** (group OI-13) |

**SSAS is out of scope** — it has no domain or Workspace of its own (owner-reported 2026-09-15), so
there is nothing to consolidate. Removed from the target architecture and from Track 1 below.

**A secondary domain keeps its own addresses, website and brand** — consolidation only merges the
admin console + billing, not identity. Amfa is kept separate because it is the entity most likely to
be sold; a standalone tenant is clean to carve out later.

**Out of scope:** Properties/Commercial and Amfa are not touched. SSAS is not touched (nothing to move).

## 2. Prerequisites — gather before any change (Minda, from the consoles; Eugene guide-only)

Record these in `Infra-Inventory/` (values only; **never** passwords/recovery codes):
1. **Super-admin** of each Workspace subscription — **owner-reported 2026-09-15:** Construction =
   `info@fishboneconstruction.co.uk`, Properties = `info@fishboneproperties.co.uk`, Waste =
   `sales@` (domain tbc), Amfa = `info@` (domain tbc). Each is the shared business mailbox itself,
   not a separate named admin account — see **OI-5** in `open-issues.md`. Holdings' 1&1 admin is now
   moot (already off 1&1, see §1); SSAS has no admin to record (no domain/Workspace).
2. **Construction hub headroom — owner-reported 2026-09-15:** **Business Standard**, 0 free seats
   currently, but **up to 3 more licences can be added**. Waste is dormant so its mailbox count should
   be small — confirm it fits within 3 before starting §4 (if not, buy headroom first).
3. **Exact domains — owner-reported 2026-09-15:** Holdings = `fishboneholdings.co.uk` (migration
   reported done, DNS unverified by Eugene — see §3.6); Waste = `fishbonewaste.co.uk`; Amfa = `amfa.uk`
   (for the inventory record only, not migrating). SSAS — confirmed n/a, no domain exists.
4. **DNS control — owner-reported 2026-09-15:** Minda controls DNS for both `fishboneholdings.co.uk`
   and `fishbonewaste.co.uk` (registrar access confirmed for the two domains still relevant; SSAS n/a).
5. **Mailboxes + rough mail volume** for `fishbonewaste.co.uk`, and whether it has Drive data to
   carry — **still needed** (expect near-zero; Waste is dormant).
6. **Gmail connector delegated-mailbox test (Eugene OI-2)** — not blocking; the live `info@`→`ops@`
   forwarding pattern already covers the need without a Group. Only revisit if a future company
   specifically wants a shared-mailbox `info@`.

Do not start §4 (Waste) until items 2, 3 (Waste's domain), 4 and 5 above are filled in.

## 3. Track 1 — Holdings: 1&1 → Construction hub — **reported done 2026-09-15, pending Eugene verification**

SSAS dropped from this track entirely (§1) — no domain or Workspace exists for it, nothing to migrate.

Minda reports Holdings is **already** a secondary domain under Construction. The steps below are kept
as the record of what should have happened, now used as a **verification checklist** rather than a
forward plan:
1. ~~Add the domain as a secondary domain~~ in the Construction Admin console, verified (TXT record).
2. ~~Create the users/mailboxes~~ on the domain (mirroring what existed on 1&1).
3. ~~Pre-stage mail migration~~ from 1&1 over IMAP (Google Data Migration Service).
4. ~~Cut over MX~~ to Google.
5. ~~Decommission~~ the 1&1 mailboxes/hosting for Holdings.
6. **Verify (Eugene, outstanding — blocked):** send/receive test through the new Workspace mailbox;
   confirm old mail is present; MX resolves to Google (`dig MX <Holdings domain>`); no bounce from
   external senders. Domain confirmed: **`fishboneholdings.co.uk`**. **Eugene could not run this check
   2026-09-15** — tried a plain DNS lookup (no `dig`/`nslookup` installed), then a DNS-over-HTTPS
   fallback (`dns.google`), which the session's egress proxy rejected (organisation policy — the same
   restriction that originally blocked Peter's Companies House access, see
   `Runbook-Companies-House-Access-for-Peter.md`). Either Minda runs `dig MX fishboneholdings.co.uk`
   herself and reports the result, or Eugene retries this check once an environment with DNS egress is
   available.

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

## 5. Dedicated `info@` + scoped ops/agent account (resolves Peter OI-5) — **DONE 2026-09-13**

Completed the same day this runbook was drafted, for the Construction tenant, ahead of the migration
order below. Live design: `ops@fishboneconstruction.co.uk` (least-privilege, 2FA, no admin rights) is
the account Peter's Gmail connector reads; `info@` (its own mailbox) and `invoice@` (AP inbox) both
forward into `ops@`, plus a routing rule copies minda@/info@/invoice@ outbound mail into `ops@` so
Peter sees both sides of a thread. Full detail: `Runbooks/Runbook-Dedicated-info-Inbox-and-Ops-Account.md`
(v0.2) and `Runbooks/Runbook-Email-Evidence-Retention-Google-Vault.md` (v0.2, the Vault evidence-retention
companion). Peter OI-5 closed 2026-09-13. **Still to do when Holdings/SSAS/Waste land in the hub:**
confirm whether each newly-added domain needs its own `info@`/forward-to-`ops@`, or whether one
Construction-wide `ops@` covers all four domains — decide per domain as each migrates.

## 6. Companies House egress allowlist (resolves Peter OI-6) — **DONE 2026-09-13**

Not part of the email migration; unblocked Peter beat 2b. Resolved via an **environment API credential**
(not a network allowlist toggle) — a Basic credential ("Companies House API", allowed website
`api.company-information.service.gov.uk`, free CH REST API key as username) added to the Fishbone Group
and Minda environments; Peter's weekly beat-2b run succeeded (all six companies + trustee watch, HTTP
200). Eugene never held the key. Full detail: `Runbooks/Runbook-Companies-House-Access-for-Peter.md`
(v0.2). Peter OI-6 closed 2026-09-13.

## 7. Safety / rollback

- **Never cut MX before mail is staged.** Keep the source mailboxes live until a clean delta migration.
- Holdings was done as the pilot; treat Waste's cutover with the same caution even though it's now the
  only track left (SSAS dropped — no domain/Workspace to migrate, §1).
- Keep an export/backup of each source mailbox until cutover is confirmed.
- No step here is taken by Eugene; each is executed by Minda in the console/registrar and then verified.
- **No credential or TXT value is recorded in this runbook or anywhere in Eugene's KB.**

## 8. Status / next
§5 and §6 are done (2026-09-13). §3 Holdings (`fishboneholdings.co.uk`) is reported done (2026-09-15)
but **unverified by Eugene** — this session has no working DNS egress at all (no `dig`/`nslookup`
installed, and the DNS-over-HTTPS fallback was rejected by the egress proxy). Outstanding: Minda
confirms `dig MX fishboneholdings.co.uk` herself, or Eugene retries when it has DNS egress. SSAS is
closed — out of scope, nothing to migrate. Construction hub headroom confirmed: Business Standard, 3
spare licences available (§2.2). **Only remaining work is §4 Waste** (`fishbonewaste.co.uk`), now
blocked on just one item — its mailbox count/mail volume (§2.5); DNS control is confirmed (Minda,
§2.4). Properties and Amfa (`amfa.uk`) untouched throughout. Advisory raised, not blocking: **OI-5** —
each subscription's super-admin login is a shared business mailbox (`info@`/`sales@`), not a dedicated
named admin account (§2.1).
