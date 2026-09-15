# Runbook — Workspace consolidation into the Construction hub (v0.4, ready to execute)

_Eugene runbook. **Eugene is guide-only for live systems (charter §3): this document is the guide;
Minda performs every Admin-console / DNS / registrar / migration step.** No secret (password, TXT
value, token) is ever written into this file — those are generated and entered live. Author: Claude
for Eugene, 2026-09-13; updated 2026-09-15 (v0.2, v0.3, v0.4). Decision basis: Eugene OI-1 (resolved)
+ OI-4 (owner, 2026-09-13).

**Status as of v0.4 (2026-09-15): Holdings done and MX-verified; SSAS out of scope; §4 (Waste) fully
decided and ready for Minda to execute — see §4 and §8.** Summary of how it got here: Holdings was
already migrated under Construction by the time this runbook was drafted (§3), later MX-verified via
Minda's own 1&1 DNS-panel check since Eugene's DNS tooling stayed network-blocked all session (a stale
Holdings SPF record was found in the process — tracked as **OI-6**, low urgency). SSAS turned out to
have no domain or Workspace of its own, dropping it from the plan entirely. Waste's §2 prerequisites
(super-admin identities — flagged advisory as **OI-5**; hub licence headroom; exact domains; DNS
control; 2 mailboxes with an archive-first precaution) were answered through the session, and its two
open execution decisions — whether `info@`/`sales@` stay live post-migration (yes) and where the
pre-migration archive lives (Waste's own KB `Raw/` folder, per the group §7a hand-off rule) — are both
settled. `sales@fishbonewaste.co.uk`'s super-admin role resolves itself at cancellation (step 5) rather
than needing a decision._

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

## 3. Track 1 — Holdings: 1&1 → Construction hub — **MX verified 2026-09-15; one loose end found**

SSAS dropped from this track entirely (§1) — no domain or Workspace exists for it, nothing to migrate.

Minda reports Holdings is **already** a secondary domain under Construction. The steps below are kept
as the record of what should have happened, used as a **verification checklist**:
1. ~~Add the domain as a secondary domain~~ in the Construction Admin console, verified (TXT record) —
   consistent with the Google site-verification TXT record Minda's screenshot showed present.
2. ~~Create the users/mailboxes~~ on the domain (mirroring what existed on 1&1).
3. ~~Pre-stage mail migration~~ from 1&1 over IMAP (Google Data Migration Service).
4. ~~Cut over MX~~ to Google.
5. **Decommission — clarified 2026-09-15:** "off 1&1" means off 1&1's *mail hosting*, not off 1&1 as
   registrar/DNS host. `fishboneholdings.co.uk`'s DNS is still managed in the 1&1/IONOS panel — that's
   normal; a Workspace secondary domain only needs the right MX/TXT records there, not a registrar move.
6. **Verify — MX confirmed 2026-09-15 (Minda, via the 1&1 DNS panel):** the domain's **MX record now
   points to `smtp.google.com`** (Google Workspace's current single-record MX target) — mail genuinely
   routes to Google. This closes the verification Eugene couldn't run itself (no working DNS egress in
   this environment — no `dig`/`nslookup`, and a DNS-over-HTTPS fallback via `dns.google` was rejected
   by the session's proxy, organisation policy, the same restriction that originally blocked Peter's
   Companies House access).
   **Loose end found in the same screenshot, tracked as OI-6 (`open-issues.md`):** the domain's **SPF
   TXT record still references IONOS's mail servers** (the 1&1 SPF include), not Google's. MX governs
   incoming mail (fixed); SPF governs whether *outgoing* mail sent through Google's servers is
   authenticated — left as-is, mail sent from this domain via Google Workspace risks failing SPF
   checks at the receiving end (spam-folder risk, or rejection by strict recipients). Not urgent (only
   matters once this domain actively sends mail through Google), but worth fixing: update the SPF TXT
   record to include Google's SPF mechanism (`include:_spf.google.com`) alongside or instead of the
   1&1 include, per Google's own SPF-migration guidance. Minda to action in the 1&1 DNS panel; Eugene
   can't verify this one either without DNS egress, same as above.

## 4. Track 2 — Waste: its own Workspace → Construction hub (domain move)

**Standalone execution checklist:** `Runbooks/Runbook-Waste-Migration-Execution-Checklist.md` (v1.0) —
this section is the reasoning/reference; that file is the ordered step-by-step to actually run through
the consoles. It also flags one genuine open question the sections below don't resolve: whether
`fishbonewaste.co.uk` is a primary or secondary domain inside Waste's own Workspace, which decides
whether Phase C below is a simple domain removal or a full subscription cancellation.

**§2 fully answered 2026-09-15 — nothing left blocking this track.** Waste has **2 mailboxes**:
`info@fishbonewaste.co.uk` and `sales@fishbonewaste.co.uk` (the latter is also Waste's super-admin
login, OI-5). Owner's explicit precaution (2026-09-15): **archive the historical mail/Drive data
before migrating, don't just re-point and move on** — this is now the required approach for step 1
below, not an optional nice-to-have. Owner also decided (2026-09-15): **both mailboxes stay live under
Construction after migrating** (step 2) — the archive is a historical safeguard, not a replacement for
keeping the addresses active. **§4 is now fully decided — archive location confirmed 2026-09-15**
(step 1): Waste has its own KB, `Fishbone Waste Ltd - Knowledge Base` (Drive folder id
`1LMVTPw4YFw9OmW7GcTjaDEfXqCIjp1ZJ`), with the standard group KB shape — `CLAUDE.md`, `README.md`,
`Archive/`, `Outputs/`, `Wiki/`, `Raw/`. The archive goes in its **`Raw/`** folder (id
`1TlNINqtx8JU1Qe6152uqhEPZEvt7JN_C`), per the group §7a hand-off rule (Eugene charter §3: may add to
another KB's `Raw/`, never edit/move/delete elsewhere in it) — `Raw/` already holds a precedent hand-off
(`2026-09-10_handoff_group-to-waste_...`) and the group's own document-numbering/filing policy, so
follow that existing convention for naming the archive files rather than inventing a new one.

Harder than Track 1: **Google will not let a domain be added to a second account while it still
exists in the first.** So the domain must be **removed from Waste's Workspace before it can be added
to Construction**, and any mail/Drive must be archived first.
1. **Archive both mailboxes before touching anything else** (owner precaution, 2026-09-15): export
   `info@` and `sales@` in full — Google Workspace Data Export (admin-initiated, whole-account) or a
   per-mailbox Google Takeout, plus any Drive files either account owns. **Destination — decided
   2026-09-15:** `Fishbone Waste Ltd - Knowledge Base/Raw/` (Drive folder id
   `1TlNINqtx8JU1Qe6152uqhEPZEvt7JN_C`) — Waste's own KB, per the group §7a hand-off rule. Treat it as
   the durable historical record: this account is about to move, and 1&1-style "still live for
   stragglers" isn't available here the way it was for Holdings' 1&1 migration — Waste's own Workspace
   gets **cancelled** at the end of this track (step 5), so anything not archived or re-provisioned by
   then is gone.
2. **Migrate mail — decided 2026-09-15 (Minda): both stay live.** `info@fishbonewaste.co.uk` and
   `sales@fishbonewaste.co.uk` are **re-provisioned as live mailboxes under Construction** (as in
   Track 1 steps 1–3), in addition to the archive from step 1, not instead of it — Waste is dormant but
   its two inboxes keep receiving mail going forward. **Resolved 2026-09-15:** `sales@fishbonewaste.co.uk`
   is also Waste's current super-admin login (OI-5), but once step 5 cancels Waste's own Workspace
   subscription, that role has nothing left to be super-admin *of* — `sales@` migrates as an ordinary
   Construction mailbox, no admin role to carry over or reassign.
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
§5 and §6 are done (2026-09-13). **§3 Holdings (`fishboneholdings.co.uk`) is done and MX-verified
(2026-09-15)** — Minda checked the 1&1 DNS panel directly, MX points to `smtp.google.com`. One loose
end found there, not yet fixed, now tracked as **OI-6**: the **SPF TXT record still references
IONOS**, not Google — a deliverability risk for outbound mail sent via Google Workspace, worth
updating in the 1&1 panel when convenient (§3.6). SSAS is closed — out of scope, nothing to migrate. Construction hub headroom confirmed: Business Standard, 3
spare licences available (§2.2). **§2 is now fully answered for Waste** (`fishbonewaste.co.uk`, 2
mailboxes: `info@` + `sales@`, DNS control Minda) — **nothing left blocking §4 from a prerequisites
standpoint.** Decided 2026-09-15: **both mailboxes stay live under Construction after migrating** (§4
step 2) — the archive is a historical safeguard, not instead of re-provisioning. **§4 is now fully
decided end-to-end — nothing left open.** Archive destination: `Fishbone Waste Ltd - Knowledge
Base/Raw/` (§4 step 1). **§4 is ready for Minda to execute** — see §4 for the full sequence: archive
→ re-provision `info@`/`sales@` under Construction → remove domain from Waste's Workspace → add as
secondary domain to Construction → cut MX → cancel Waste subscription → verify. Properties and Amfa
(`amfa.uk`) untouched throughout. `sales@fishbonewaste.co.uk`'s super-admin role (OI-5) **resolves
itself at step 5**: once Waste's own Workspace subscription is cancelled, there's no longer a separate
Workspace for it to be super-admin *of* — it migrates as an ordinary mailbox under Construction, no
role to carry over (owner-confirmed 2026-09-15). Advisory still open, not blocking: **OI-5** — the
*other* subscriptions' super-admin logins remain shared business mailboxes, not dedicated named admin
accounts (§2.1). **OI-6** — Holdings' SPF record still points at IONOS, low-urgency fix.
