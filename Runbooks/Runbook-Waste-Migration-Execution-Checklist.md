# Runbook — Waste migration execution checklist (v1.0)

_Eugene runbook, companion to `Runbook-Workspace-Consolidation-into-Construction.md` §4 (v0.4,
"ready to execute"). **Eugene is guide-only for live systems (charter §3): this document is the
checklist; Minda performs every Admin-console / DNS / registrar step.** No secret (password, TXT
value, token) is ever written into this file. All decisions behind this checklist were settled
2026-09-15 — see the main runbook for the reasoning; this file is the ordered "do this, then this"
version for executing it. Author: Claude for Eugene, 2026-09-15._

## What's already decided (no need to re-decide any of this)
- Archive `info@fishbonewaste.co.uk` and `sales@fishbonewaste.co.uk` before touching anything else.
- Archive lands in Waste's own KB: **`Fishbone Waste Ltd - Knowledge Base/Raw/`** (Drive folder id
  `1TlNINqtx8JU1Qe6152uqhEPZEvt7JN_C`), per the group §7a hand-off rule.
- Both mailboxes are **re-provisioned as live mailboxes under Construction** — not archived-and-retired.
- `sales@`'s super-admin role needs no separate handling — it lapses when Waste's Workspace is gone.
- Construction hub has room: Business Standard, 3 spare licences (2 needed here).
- DNS control for `fishbonewaste.co.uk`: Minda.

## One thing to check before you start, not yet confirmed

**Is `fishbonewaste.co.uk` a primary or secondary domain inside Waste's own Google Workspace
*account*?** This is a separate question from where the domain's DNS/registrar lives — **confirmed
2026-09-15: `fishbonewaste.co.uk` is registered/DNS-hosted at 1&1, not Google Domains** (same as
Holdings), so there's no registrar-transfer complication and DNS control stays with Minda at 1&1
throughout. But that doesn't settle whether the domain is registered as Waste's Workspace account's
**primary** domain in the Admin console's own domain list — a domain can sit at any registrar and
still be a Workspace account's primary domain; the two are independent. Almost certainly **primary**
here (it's Waste's own subscription, not a secondary domain added to some other tenant) — but this is
still worth confirming directly rather than assuming.

This matters because Holdings' migration (already done) was the *easy* case — Holdings was a secondary
domain coming off 1&1's own mail hosting, with no Google Workspace account structure involved on the
source side at all. Google Workspace generally does **not** let you remove a **primary** domain from
an account the way you remove a secondary one — freeing it up typically means cancelling/deleting the
Workspace subscription itself, which can carry a data-purge/cooldown period before the domain becomes
available to verify elsewhere (this is not guaranteed to be instant). **Check this in the Admin
console (as Waste's super-admin, `sales@fishbonewaste.co.uk`) before relying on the "remove domain,
then add it to Construction" sequence below** — Account → Domains → Manage domains. If there's a
straightforward "Remove domain" option, great, follow Phase C as written. If not (because it's
primary), Phase C becomes "cancel/delete the subscription" instead, and the archive in Phase A becomes
even more important — there's no going back for more data once that's done. If the console's options
are unclear, Google Workspace support chat is the fastest way to confirm the actual mechanism for your
account rather than guessing.

---

## Phase A — Archive first (do this before anything else)

- [ ] Sign in to `admin.google.com` as `sales@fishbonewaste.co.uk` (Waste's current super-admin).
- [ ] Export both mailboxes' mail + Drive data. Two options:
  - **Google Takeout** (`takeout.google.com`), signed in as each mailbox individually — faster for
    just 2 accounts, exports Gmail (.mbox) + Drive per user. **Recommended**, given the small scope.
  - **Google Workspace Data Export tool** (Admin console → Account → Data export) — a full
    admin-initiated export of everything, but built for whole-organisation offboarding; Google's own
    documentation describes this as taking up to several days to complete, with download links
    time-limited once ready. Only worth it if Takeout turns out to miss something Data Export covers.
- [ ] Upload the exported files into **`Fishbone Waste Ltd - Knowledge Base/Raw/`**. Check that
  folder's existing files first (there's already a `2026-09-10_group-policy_document-numbering-and-
  filing-v1.3.md` and a prior hand-off example) and follow the same naming/numbering convention rather
  than inventing a new one.
- [ ] Byte-verify the upload (per the group KB convention: uploaded file size matches the local
  export, no corruption).
- [ ] Confirm with Eugene once done, so the ledger/inventory can be updated.

**Do not proceed to Phase C until this is confirmed complete** — Waste's Workspace gets cancelled
later in this sequence, and 1&1-style "still live for stragglers" isn't available the way it was for
Holdings.

## Phase B — Confirm Construction is ready to receive

- [ ] Sign in to `admin.google.com` as `info@fishboneconstruction.co.uk` (Construction's super-admin).
- [ ] Billing → Subscriptions: confirm the 3 spare Business Standard licences are still there (2 needed
  for `info@`/`sales@fishbonewaste.co.uk`).
- [ ] **Do not** add `fishbonewaste.co.uk` as a secondary domain yet — Google won't allow it while the
  domain still exists in Waste's own account (see Phase C).

## Phase C — Free the domain from Waste's Workspace

- [ ] As Waste's super-admin, check Account → Domains → Manage domains for `fishbonewaste.co.uk`'s
  status (primary or secondary — see the checkpoint above).
- [ ] **If secondary:** remove it directly from that screen.
- [ ] **If primary (likely):** this means cancelling/deleting Waste's Google Workspace subscription to
  release the domain. Before doing this:
  - [ ] Re-confirm Phase A's archive is complete and verified — this step may be irreversible.
  - [ ] Check Google's current guidance (in-console or via Workspace support) on how long a cancelled/
    deleted account's domain stays unavailable to re-verify elsewhere, so the Phase D wait isn't a
    surprise.
  - [ ] Proceed with cancellation once ready.
- [ ] **Do not proceed to Phase D until the domain is confirmed free** (Construction's "Add a domain"
  flow will simply reject it otherwise).

## Phase D — Add the domain to the Construction hub

- [ ] As Construction's super-admin: Account → Domains → Add a domain → `fishbonewaste.co.uk` →
  add as a **secondary domain**.
- [ ] Add the Google-provided verification record (TXT, or the HTML-tag alternative) at the domain's
  DNS host — the 1&1/IONOS panel for `fishbonewaste.co.uk` (Minda has registrar access, confirmed).
  Generated and entered live; not recorded in this file.
- [ ] Wait for verification to complete (DNS propagation — can take minutes to a few hours) before
  moving on.

## Phase E — Recreate the two mailboxes under Construction

- [ ] Directory → Users → Add new user: `info@fishbonewaste.co.uk`.
- [ ] Directory → Users → Add new user: `sales@fishbonewaste.co.uk`.
- [ ] Assign a Business Standard licence to each (within the 3 spare confirmed in Phase B).
- [ ] Set temporary passwords — Minda sets and rotates these; Eugene never sees them.
- [ ] Neither needs special admin rights under Construction — `sales@`'s old super-admin role doesn't
  carry over (it lapsed with Waste's own Workspace).

## Phase F — Restore archived mail into the live mailboxes (optional)

The Raw/ archive from Phase A already satisfies "don't lose the history." This step is only needed if
you also want the old mail **searchable from inside the live inbox**, not just held in the KB archive.
- [ ] If wanted: use Google Workspace's Data Migration Service (Admin console → Data migration),
  source type "Gmail"/Google Workspace, to pull the old mail into the newly created
  `info@`/`sales@fishbonewaste.co.uk` mailboxes under Construction — only possible while the source
  account is still live, so this has to happen **before** Phase C's cancellation if you want it at all.
  **If you want this, do it as part of Phase A/B, before freeing the domain — flag it now rather than
  discovering the source is already gone.**

## Phase G — Cut over MX (and fix SPF at the same time — don't repeat the Holdings gap)

- [ ] In the 1&1 DNS panel for `fishbonewaste.co.uk`: update the **MX record** to Google's current
  single-record target, matching what's already confirmed working for Holdings.
- [ ] **At the same time**, update the **SPF TXT record** to include Google
  (`include:_spf.google.com`) — Holdings' migration left this stale (tracked as OI-6); don't repeat it
  here by treating SPF as an afterthought.
- [ ] Wait for DNS propagation, then send/receive test both mailboxes from an external address.

## Phase H — Cancel Waste's Google Workspace subscription (if not already done in Phase C)

- [ ] Only once: domain fully migrated, mail confirmed flowing via Construction, archive confirmed
  saved in `Raw/`. If Phase C already required cancelling the subscription to free the domain, this
  step is already done — otherwise (e.g. if Google offered a cleaner domain-removal path that left the
  subscription itself still active with no domains on it), cancel it now for the seat/bill saving.

## Phase I — Verify (Eugene, where possible)

- [ ] MX for `fishbonewaste.co.uk` resolves to Google — Eugene's own DNS tooling was blocked all of
  2026-09-15's session (no `dig`/`nslookup`, DNS-over-HTTPS rejected by the egress proxy); this may
  need the same Minda-screenshot approach used for Holdings, or a retry once Eugene has DNS egress.
- [ ] SPF includes Google (same verification path as above).
- [ ] Send/receive test to `info@` and `sales@` succeeds, no bounces from external senders.
- [ ] Archive files present and byte-verified in `Fishbone Waste Ltd - Knowledge Base/Raw/`.
- [ ] Waste subscription shows cancelled / no active domains.
- [ ] Report back to Eugene so `Infra-Inventory/Workspace-and-Email-Inventory.md`, `open-issues.md`
  and `processed-items-ledger.md` get updated to close this out.

## Safety reminders (from the main runbook §7)

- Never cut MX before mail is staged/archived.
- No step here is taken by Eugene — Minda executes every console/DNS step; Eugene verifies afterward.
- No credential or TXT value is ever recorded in this file or anywhere in Eugene's KB.
- If Phase C's domain-removal mechanism turns out to be unclear or destructive-looking in the console,
  stop and check with Google Workspace support before proceeding — this is the one genuinely
  irreversible step in the sequence.
