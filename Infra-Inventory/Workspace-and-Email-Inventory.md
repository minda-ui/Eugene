# Infra Inventory — Email & Google Workspace (Fishbone Group)

_Eugene's living inventory of where email/identity lives. Cite, never copy secrets (charter §3). Confirmed facts carry a date + source; anything unconfirmed is flagged. Last updated 2026-09-15._

## Confirmed 2026-09-13 (owner, Minda) — Google Workspace tenant shape (resolves Eugene OI-1)

The paid Google Workspace companies are on **separate subscriptions**, **not** one tenant with
multiple domains. Commercial Properties does **not** have its own subscription — it rides inside
**Properties'** subscription (its mailbox is `commercial@fishboneproperties.co.uk`).

| Company | Email hosting | Subscription / tenant | Notes |
|---|---|---|---|
| Fishbone Construction Ltd | Google Workspace (paid) | **Own subscription** | Domain `fishboneconstruction.co.uk`. Users incl. `minda@`, `info@` and `ops@` (the workforce agent identity — the currently connected Gmail account). See the identity table below. |
| Fishbone Properties Ltd | Google Workspace (paid) | **Own subscription** | Domain `fishboneproperties.co.uk`. **Also carries Fishbone Commercial Properties** as a user/alias `commercial@fishboneproperties.co.uk`. |
| Fishbone Commercial Properties Ltd | Google Workspace (paid) | **Inside Properties' subscription** | No separate subscription; `commercial@fishboneproperties.co.uk`. |
| Fishbone Waste Ltd | Google Workspace (paid) | **Own subscription** | Domain confirmed 2026-09-15: **`fishbonewaste.co.uk`** (`lana@fishbonewaste.co.uk` seen as a Collaboration Space owner). Super-admin login: `sales@fishbonewaste.co.uk` (owner-reported; see OI-5). DNS control: **Minda** (registrar access confirmed 2026-09-15). **2 mailboxes confirmed 2026-09-15: `info@` + `sales@`.** Owner precaution: archive both mailboxes' historical mail/Drive data before migrating — see `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` §4 (open decisions: archive storage location; whether both stay live post-migration). |
| Amfa Furniture Ltd | Google Workspace (paid) | **Own subscription** | Domain confirmed 2026-09-15: **`amfa.uk`** (company renamed from Furniture by Fishbone 13/07/2026; Workspace domain uses the short form). Super-admin login: `info@amfa.uk` (owner-reported; see OI-5). |
| Fishbone Holdings Ltd | **Google Workspace, secondary domain under Construction** (owner-reported 2026-09-15) | **Inside Construction's subscription** | Migrated off 1&1's mail hosting (DNS itself is still managed in the 1&1/IONOS panel — normal for a secondary domain, no registrar move needed). Domain: **`fishboneholdings.co.uk`**. **MX verified 2026-09-15** (Minda, via the 1&1 DNS panel — Eugene's own DNS tooling stayed blocked all session, no `dig`/`nslookup`, DoH fallback rejected by the proxy): MX points to `smtp.google.com`, confirming mail routes to Google. **Tracked as OI-6, not urgent:** the domain's SPF TXT record still references IONOS's mail servers, not Google's — an outbound-deliverability risk once this domain sends mail via Google Workspace; fix by adding `include:_spf.google.com` to the SPF record in the 1&1 panel. DNS control: **Minda** (registrar access confirmed 2026-09-15). |
| Fishbone SSAS | **No domain or Workspace of its own** (owner-reported 2026-09-15) | — | Not a consolidation target — nothing to migrate. Removed from the Track 1 plan (`Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` v0.3). |

**So (updated 2026-09-15):** **four** separate paid Google Workspace subscriptions (Construction,
Properties, Waste, Amfa) covering **five** companies (Commercial rides Properties). **Holdings** has
moved off 1&1 and is now a secondary domain under Construction (owner-reported 2026-09-15, pending
Eugene DNS verification). **SSAS has no domain or Workspace of its own** — not a consolidation target.

## What this means for consolidation

A domain can live in **only one** Google Workspace account at a time. Because the Workspaces are
**separate subscriptions**, "put everything under one of the companies" is **not** the easy
"add a secondary domain to an existing tenant" — it is a **per-domain migration** (offboard the
domain from its current subscription, add it as a secondary domain to the chosen target, migrate
users / mailboxes / Drive). That is a real, staged project, not a settings change. (This retires the
hope in the 2026-09-12 owner note that Workspace multi-domain would make it a one-step change.)

### Decided target architecture (owner, 2026-09-13; OI-4 resolved; updated 2026-09-15)

- **Construction = hub** → **Holdings already folded in** (secondary domain, owner-reported
  2026-09-15) + **Waste** (dormant, its own Workspace — still to migrate). **SSAS dropped** — no
  domain/Workspace exists for it.
- **Properties (+ Commercial)** → **stays its own tenant** (separate legal company; keeps the clean
  governance line; already carries Commercial).
- **Amfa** → **stays standalone**, kept sale-ready (group OI-13) — a standalone tenant is clean to
  carve out on a future sale. (The separate website was **not** the reason — a secondary domain keeps
  its own email/website/brand; consolidation only merges admin + billing.)

Procedure in `Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` (v0.3). **Only remaining
track: Waste Workspace → Construction** (domain must be removed from Waste's account before it can be
added to the hub; then cancel the Waste subscription). Properties, Amfa and (now) SSAS untouched.
Construction hub headroom confirmed 2026-09-15: **Business Standard**, 0 free seats, up to **3 more
licences** can be added.

### Super-admin identities (owner-reported 2026-09-15)

| Subscription | Super-admin login |
|---|---|
| Construction | `info@fishboneconstruction.co.uk` |
| Properties | `info@fishboneproperties.co.uk` |
| Waste | `sales@fishbonewaste.co.uk` |
| Amfa | `info@amfa.uk` |

Each super-admin login is the subscription's **shared business mailbox itself**, not a separate named
admin account — flagged as **OI-5** (advisory, not blocking): anyone reading that inbox has full
Workspace admin rights, with no distinct break-glass identity. Owner's call whether to change.

## Identity / workforce accounts — Construction (as at 2026-09-13)

| Account | Type | Role | Status |
|---|---|---|---|
| `ops@fishboneconstruction.co.uk` | Workspace user | **Scoped agent identity** — least-privilege, no admin, 2FA; the account Peter's Gmail connector authenticates as; home for the Companies House API key + future workforce secrets. **Never sends mail** (its Sent folder is empty by design — Peter reads only). | **Live 2026-09-13**; connector repointed here (verified: mailbox reads `ops@`, not minda@) |
| `info@fishboneconstruction.co.uk` | **Workspace user** (its own mailbox/seat — **not** an alias) | Customer-facing business inbox | **Forwards a copy of incoming mail into `ops@`** — live & verified 2026-09-13 |
| `minda@fishboneconstruction.co.uk` | Workspace user | Mindaugas's work mailbox — **~95% business** (clients/suppliers/counterparties), ~5% personal | **Also forwards into `ops@`** (owner added 2026-09-13) so Peter gets the business mail that comes to Minda directly. Personal mail is being **migrated to Minda's separate personal inbox over time**; until then Peter **skips clearly-personal mail** (charter §3). |
| `invoice@fishboneconstruction.co.uk` | Workspace user (mailbox); alias `invoice@fishbonedrylining.co.uk` reaches the same mailbox | **Accounts-payable inbox** — where suppliers send invoices for payment | **Forwards into `ops@`** (owner added 2026-09-13) — verified 2026-09-13 by the mailbox's "forwarding to ops@" banner **and** a live test landing in `ops@`. Peter captures invoice supplier/amount/number/**due date** and flags the deadline; **never pays, approves, or acts on payment or bank-detail changes** (human-only; bank-change requests flagged as fraud risk). |
| (Minda's personal inbox) | External / personal | Mindaugas's personal correspondence | The destination for personal mail migrating off `minda@`; **not** forwarded to `ops@`, never read by Peter |

**Inbox design (settled 2026-09-13; invoice@ added 2026-09-13):** `ops@` = the single business inbox
Peter reads = forwarded copies of `info@` **+** business `minda@` **+** `invoice@` (accounts payable)
**+ copies of OUTBOUND mail sent from all three** (routing rule below). Peter triages business only and
**skips personal** (never stages/copies it). As personal mail drains from `minda@` to Minda's personal
inbox, the residual personal share of `ops@` trends to zero. Forwarding is go-forward only (no backlog).
Stricter option if ever wanted: a business-only *filter* on the `minda@` forward instead of relying on
Peter to skip. **Accounts-payable boundary:** invoices are captured and their due dates flagged for a
human — Peter **never pays, approves, schedules, or acts on a supplier bank-detail change** (those are
human-only, and bank-change requests are treated as a fraud vector to verify out-of-band), inheriting
group `CLAUDE.md` §6a (no payments) and Peter charter §3.

## Mail processing & evidence retention (added 2026-09-13)

- **Dext bookkeeping (accounts payable).** `invoice@` also auto-forwards to **`mindaugas.gaudiesius@dext.cc`**
  at the **mailbox level** (a Gmail filter/forward rule, owner-set) — Dext extracts invoice detail and
  posts to **QuickBooks**. This is deliberately **not** done by Peter: forwarding + writing to a system
  of record breaches Peter's boundary (charter §3 / group §6a), and Dext auto-posts. So every invoice
  reaches **both** Dext (→ QuickBooks) and `ops@` (Peter tracks/flags, read-only) — Peter is an
  independent control check, never the payment/ledger path.
- **Sent-mail copies to `ops@` (Peter thread context).** Gmail's "forward a copy" is inbound-only, so an
  **Admin console routing rule** ("Ops routing", Gmail → Routing) copies **outbound + internal-sending**
  mail from `minda@`/`info@`/`invoice@` (envelope-sender pattern) to `ops@` — **live & verified
  2026-09-13** (a test from `minda@` to an external address appeared in `ops@`). Peter now sees **both
  sides** of a thread; his prompt (v2026-09-13c) treats our own sent mail as context/record only —
  **never drafts a reply to it or stages it as inbound.** This is for Peter's operational context, not
  evidence (Vault below is the evidence store). The copies land in ops@'s **Inbox** (received copies);
  ops@'s own **Sent** folder stays empty (ops@ never sends).
- **Google Vault (evidence retention).** The `ops@` forwards are **inbound only**, so **sent** mail
  (often the evidence) is captured by **Google Vault**, not by forwarding. Vault licences held for
  **`minda@`, `info@`, `invoice@`** (the originals of all sent/received mail; `ops@` needs none). A
  licence alone does not preserve — the guarantee is a **Gmail retention rule**, now **applied
  2026-09-13**: Gmail **default retention = Indefinitely / No expiry** (never purged, survives user
  deletion). A **legal hold** (Vault → Matters) is the on-demand tool for live disputes. **Vault is the
  evidence store — Peter never reads it.** Guide:
  `Runbooks/Runbook-Email-Evidence-Retention-Google-Vault.md` (v0.2).

Cosmetic: the Construction Workspace **org display name still reads "Fishbone Drylining Ltd"** (the
pre-2024 name) — rename in the Admin console when convenient; no routing impact.

## To confirm next
- **§2 prerequisites for Waste are now fully answered — nothing left blocking §4 from a
  prerequisites standpoint.** Two open decisions before Minda executes it: where the pre-migration
  archive of `info@`/`sales@` should live, and whether both mailboxes stay live under Construction
  after migrating or the archive alone is sufficient. See runbook §4.
- Holdings' SPF TXT record — still references IONOS, not Google; low-urgency fix (`include:_spf.google.com`)
  for outbound-mail deliverability once the domain actively sends via Google Workspace. Tracked as **OI-6**.
- OI-5 (super-admin-as-shared-mailbox) — advisory only, no action required unless the owner decides
  otherwise.
