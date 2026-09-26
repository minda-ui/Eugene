# Runbook — Copy `enquiries@amfa.uk` mail (incoming + sent) to `ops@fishboneconstruction.co.uk` (v0.1)

**Guide-only — Eugene has no Admin console access to either Workspace subscription (charter §3). Every
step below is for Minda or the relevant super-admin to execute; Eugene verifies afterwards.**

## Why this exists

Peter's existing intake design (Nadia's own `external-source-register.md`, NASRC-6/7; Hub AWT-0095):
`enquiries@amfa.uk` copies land in `ops@fishboneconstruction.co.uk`, Peter triages them, and routes Amfa
enquiries into Nadia's `Raw/`. `enquiries@amfa.uk` and `ops@fishboneconstruction.co.uk` are on **two
separate Google Workspace subscriptions** (Amfa's own tenant, domain `amfa.uk`; Construction's own
tenant, domain `fishboneconstruction.co.uk`) — not secondary domains of one tenant — so this is
cross-tenant mail copying, not a same-tenant routing rule like the one already live for Construction's
own `info@`/`minda@`/`invoice@` → `ops@`.

Two separate mechanisms are needed — one per direction.

## Part 1 — Incoming mail (mailbox-level forwarding)

1. **Prerequisite check (Amfa super-admin, `info@amfa.uk`):** Admin console → Apps → Google Workspace →
   Gmail → **End User Access** → confirm "Allow users to forward incoming email to another address" is
   **On**. If it's off, forwarding won't be offered to the user at all — turn it on and Save first.
2. Sign in to Gmail as `enquiries@amfa.uk` (or have the Amfa super-admin open that mailbox's Gmail
   settings directly via the Admin console's "Manage this user's Gmail settings" if a direct login isn't
   practical).
3. Settings (gear icon) → **See all settings** → **Forwarding and POP/IMAP** tab.
4. **Add a forwarding address** → enter `ops@fishboneconstruction.co.uk` → Next → Proceed → OK.
5. Google emails a confirmation link/code **to `ops@fishboneconstruction.co.uk`**. Whoever reads that
   mailbox (Minda, or Peter's owner) opens it and clicks **Confirm**, or copies the code back into step 6.
6. Back in `enquiries@amfa.uk`'s Forwarding settings: select the now-verified address, choose **"Forward
   a copy of incoming mail to ops@fishboneconstruction.co.uk"**, and — recommended, matches the existing
   `info@`/`minda@` pattern — **"keep Amfa's copy in the Inbox"** rather than archiving/deleting it, since
   Nadia's own drafting workflow will eventually need the original in `enquiries@amfa.uk` too.
7. **Save Changes.**

*(Per Minda's 2026-09-26 report, incoming forwarding already appears to be live — this section is here
as the documented, repeatable procedure, in case it ever needs re-doing or verifying step by step.)*

## Part 2 — Sent mail (Admin console routing rule, Amfa's own tenant)

This mirrors the "Ops routing" rule already live in Construction's own tenant for `minda@`/`info@`/
`invoice@` → `ops@` (`Infra-Inventory/Workspace-and-Email-Inventory.md`), adapted for a cross-tenant
external recipient.

1. Sign in to `admin.google.com` as the **Amfa super-admin** (`info@amfa.uk`) — this rule must be created
   in **Amfa's** Admin console, not Construction's, since it acts on mail Amfa's own tenant sends.
2. Apps → Google Workspace → **Gmail** → **Routing**.
3. Under "Routing," click **Add another rule** (or **Configure** if starting fresh). Name it e.g. "Amfa
   enquiries — outbound copy to ops@".
4. **Messages to affect:** tick **Outbound** (and, only if internal-to-internal Amfa mail from this
   address should also be copied, **Internal - sending** too — Construction's rule does both; for a
   sales-enquiry address that mostly emails external customers, Outbound alone is likely enough).
5. **Add more recipients:** enable, then **Configure** → **Add address** → `ops@fishboneconstruction.co.uk`
   → recipient type **Bcc** (keeps it invisible to the external recipient) → leave "Change envelope
   sender" unchanged.
6. **Scope this rule to `enquiries@amfa.uk` only** (not all of Amfa's outbound mail) — use the rule's
   envelope/sender filter (**Only affect specific envelope senders**, or an "Envelope filter" matching
   sender = `enquiries@amfa.uk`, depending on which the current Admin console UI offers) rather than
   leaving it unscoped.
7. **Account types to affect:** leave as Users (default) unless a narrower org-unit scope is wanted.
8. **Save.**
9. **Test:** send a message from `enquiries@amfa.uk` to any external address and confirm a Bcc copy
   lands in `ops@fishboneconstruction.co.uk` shortly after.

**Flag, not yet verified:** Eugene has no Admin console access to either tenant, so this has not been
walked through directly. Adding an address in a **different Workspace tenant** as an "Add more
recipients" target is a standard, supported pattern (the same mechanism used to Bcc outbound mail to an
external compliance/archiving service) — but if the current Admin console UI restricts that field to
addresses within the same tenant, report back and Eugene will look for an alternative (e.g. a Google Apps
Script-based Bcc, or accepting incoming-only copies as sufficient for Peter's triage purpose).

## Verification (Eugene, once done)

- Part 1: a test email sent to `enquiries@amfa.uk` from an external address should also land in
  `ops@fishboneconstruction.co.uk` within a minute or two.
- Part 2: a test email sent *from* `enquiries@amfa.uk` should Bcc a copy to
  `ops@fishboneconstruction.co.uk`.
- Report results back and Eugene will update `Infra-Inventory/Workspace-and-Email-Inventory.md` and
  Nadia's `Raw/` accordingly.

## History

- 2026-09-26 — v0.1 drafted at Minda's request, following on from `AWT-0105`'s closure (`enquiries@amfa.uk`
  confirmed live, incoming copies already reaching `ops@`). Part 1 documents the already-apparent incoming
  setup for repeatability; Part 2 is new — the outbound/sent-mail leg, not yet confirmed done.
