# Runbook — `amfa.uk` DKIM / SPF / DMARC before outbound sales email (v0.1)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda (or whoever holds DNS
access for `amfa.uk`) performs every DNS record change.** No credential is ever written into this file.
Author: Claude for Eugene. v0.1 2026-09-24. Build prerequisite for **Nadia** (Amfa Sales & Ops
Assistant, Hub AWT-0093) — `enquiries@amfa.uk` should not send outbound sales/quote email until this is
in place, per the build brief._

## Why this matters

Once a human starts sending quotes/replies from `enquiries@amfa.uk` (drafted by Nadia, sent by a
human — she never sends herself), that mail needs to **authenticate cleanly** at the receiving end or it
risks landing in spam or being rejected outright. Three DNS records do this:

- **SPF** — declares which mail servers are allowed to send as `amfa.uk`.
- **DKIM** — a cryptographic signature proving the message wasn't altered in transit and really came
  from an authorized sender.
- **DMARC** — tells receiving mail servers what to do if SPF/DKIM fail (and where to send failure
  reports), and is what most modern spam filters actually key off.

This is the same category of gap already tracked for Holdings (**OI-6** — SPF still points at IONOS, not
Google) — worth getting right from the start here rather than retrofitting it later.

## 1. Confirm the mail platform first

Check which platform actually sends `amfa.uk` mail before writing any record — the exact values below
depend on it:

- **If `amfa.uk` is on Google Workspace** (per `Infra-Inventory/Workspace-and-Email-Inventory.md`, Amfa
  Furniture Ltd has its own paid Google Workspace subscription, domain confirmed `amfa.uk`) — this is
  the expected case, and the steps below assume it. Confirm in the Google Admin console
  (`admin.google.com` → Apps → Google Workspace → Gmail → Authenticate email) before proceeding, since a
  wrong assumption here produces records that don't match the real sending infrastructure.
- If a different platform is actually sending this mail (e.g. a marketing tool sending on Amfa's behalf
  later), the SPF include and DKIM selector will differ from what's below — check the real platform's
  own setup guide at that point instead.

## 2. SPF

In the DNS panel for `amfa.uk` (wherever that domain's DNS is actually hosted — confirm with Minda; not
established in `Infra-Inventory/` yet, unlike Holdings/Waste which are documented there):

- Add or update the domain's **TXT** record at the apex (`amfa.uk`, not a subdomain) to include Google:
  `v=spf1 include:_spf.google.com ~all`
- If a TXT record already exists (e.g. from a previous host or a verification record), **merge** the
  `include`, don't add a second `v=spf1` record — multiple SPF records is itself a common cause of SPF
  failing. Check what's there first.

## 3. DKIM

1. In the Google Admin console: **Apps → Google Workspace → Gmail → Authenticate email**, select the
   `amfa.uk` domain.
2. Generate a new DKIM key (2048-bit if offered — stronger, still widely supported).
3. Google gives a **TXT record name** (something like `google._domainkey`) and a **value** (the public
   key) — add that exact TXT record in `amfa.uk`'s DNS panel.
4. Back in the Admin console, click **Start authentication** once the DNS record is live (DNS
   propagation can take a few hours — don't start authentication immediately after adding the record if
   it fails the first check, just retry after propagation).

## 4. DMARC

Add a **TXT** record at `_dmarc.amfa.uk`:

- **Start conservative, monitor-only, while this is new:**
  `v=DMARC1; p=none; rua=mailto:<an address Minda can read>; fo=1`
  This doesn't reject or quarantine anything yet — it just starts collecting aggregate reports so you
  can see what's passing/failing before tightening the policy. `rua=` should be an address someone
  actually reads (e.g. `info@fishboneconstruction.co.uk` or a dedicated mailbox), not left as a
  placeholder.
- **Once SPF/DKIM are confirmed passing** (check the DMARC reports after a week or two of real mail, or
  use a tool like Google's own Postmaster Tools / mail-tester.com on a test send), **tighten** to:
  `v=DMARC1; p=quarantine; rua=mailto:<address>; pct=100`
  and eventually `p=reject` once confident — the same staged approach used for any new domain's DMARC
  rollout, not specific to Amfa.

## 5. Verification

- Send a test email from `enquiries@amfa.uk` to an external mailbox you control (e.g. Gmail) and check
  the message's authentication headers (in Gmail: "Show original") for `SPF: PASS`, `DKIM: PASS`,
  `DMARC: PASS`.
- Or use `mail-tester.com`: send a test message to the address it gives, then check the score/report —
  flags SPF/DKIM/DMARC issues directly.
- Re-check after any DNS change — propagation delay means a record that looks right in the panel may not
  be live everywhere yet.

## 6. Open items

- **`amfa.uk`'s current DNS host is not yet established in `Infra-Inventory/`** — unlike Holdings (1&1,
  nameservers redirected to WordPress) and Waste (1&1, nameservers at WordPress), Amfa's DNS location
  hasn't been confirmed in Eugene's own records. Confirm before starting §2-4, since the exact panel/UI
  depends on it.
- This runbook covers **email authentication only** — it does not cover `enquiries@amfa.uk`'s own
  provisioning (a separate live-system step, tracked in Nadia's `CHARTER.md` §9 as a build prerequisite,
  not yet done).
