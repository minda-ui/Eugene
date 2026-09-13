# Runbook — Dedicated `info@` inbox + scoped ops/agent account (v0.2)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda performs every
Admin-console / account / connector step.** **No password or API key is ever written into this file or
any KB.** Author: Claude for Eugene. v0.1 2026-09-13; **v0.2 2026-09-13** — ops account now created and
verified, so §1–§3 rewritten to the concrete Construction setup and the `info@` routing made specific.
Resolves **Peter OI-5**._

## Status (2026-09-13)
- ✅ **Ops account `ops@fishboneconstruction.co.uk` created** — least-privilege, 2FA on, own mailbox.
- ✅ **Peter's Gmail connector repointed to `ops@`** — verified: the ops mailbox shows only its own
  setup mail (all addressed to `ops@`), so Peter no longer reads minda@'s personal mailbox.
- ✅ **`info@` → `ops@` forwarding live and verified 2026-09-13.** `info@` is its own separate
  Workspace user/mailbox (not an alias); Minda set it to **forward incoming mail into `ops@`** (Gmail
  Forwarding; the initial attempt was inactive because forwarding was left on "Disable forwarding" —
  fixed). Verified: a test to `info@` arrived in `ops@`, and `ops@` shows no personal mail. **Peter OI-5
  is closed.** The to/cc-`info@` proxy is retired — Peter triages the `ops@` inbox directly. Note:
  forwarding is **go-forward only** — the pre-2026-09-13 `info@` backlog stays in the `info@` mailbox.
- ✅ **`minda@` → `ops@` forwarding added 2026-09-13 (owner).** `minda@` is ~95% business, so this
  gives Peter the business mail that comes to Minda directly. The ~5% personal is being migrated to
  Minda's separate personal inbox over time; meanwhile **Peter skips clearly-personal mail** (charter
  §3), so personal content is never staged or copied. Stricter option if wanted later: a business-only
  filter on the `minda@` forward instead of relying on Peter's skip.
- Cosmetic: the Workspace **org display name still reads "Fishbone Drylining Ltd"** (Construction's
  pre-2024 name) — rename in the Admin console when convenient; does not affect routing.

## 1. What this creates
1. **Scoped ops/agent account** (`ops@fishboneconstruction.co.uk`) — **done** (see Status).
2. **Dedicated `info@` business inbox** Peter triages — the remaining work (§3).

## 2. The three accounts (Construction) and the goal
- **`info@`** — its own Workspace user + mailbox: the **customer-facing business inbox** (humans log
  in / send as `info@`).
- **`ops@`** — the scoped, least-privilege agent identity the **connector authenticates as** (holds
  the CH key + future secrets). Peter reads whatever lands in `ops@`.
- **`minda@`** — Mindaugas's work mailbox (~95% business). **Also forwards into `ops@`** (owner added
  2026-09-13) so Peter sees the business mail that comes to Minda directly, not only `info@`. The ~5%
  personal is being migrated to Minda's separate personal inbox; meanwhile Peter **skips clearly-personal
  mail** (charter §3). Minda's **personal inbox** is never forwarded to `ops@`.

**Goal:** get the company's incoming business mail (from `info@` and business-`minda@`) into **`ops@`**
so Peter triages it, while `info@`/`minda@` stay normal inboxes humans use. Keeping the connector on the
locked-down `ops@` (rather than pointing it at `info@`/`minda@`, which can send as the company/owner) is
the least-privilege choice. Peter skips personal mail so it is never staged or copied.

## 3. Deliver `info@` mail into `ops@` (Minda, Construction Admin console / the info@ account)

Recommended: **A**. **B** is the simpler-to-read alternative if you'd rather Peter read `info@`
directly.

### Option A (recommended) — forward / route `info@` → `ops@`, keeping `info@`'s own copy
`info@` stays a real inbox; a copy of every incoming message also lands in `ops@`, where the connector
reads it. Two ways to set it, either is fine:
- **User-level (quickest):** sign in to the **`info@` account** → Gmail Settings → **Forwarding and
  POP/IMAP** → add forwarding address `ops@fishboneconstruction.co.uk`, confirm it, then **forward
  incoming mail and keep Gmail's copy in the Inbox**. (Optionally add a filter so only genuinely
  business mail forwards.) *(Gotcha seen 2026-09-13: adding + confirming the address is not enough —
  the radio must be switched from "Disable forwarding" to "Forward a copy…" and Saved.)*
- **Admin-level (cleaner headers, survives if someone edits the info@ account):** Admin console →
  Apps → Google Workspace → Gmail → **Routing** → add a rule that also delivers mail **to `info@`**
  onward **to `ops@`** (add recipient). Preferable because the delivered copy keeps the original
  envelope.

### Option B (alternative) — read `info@` directly
Repoint Peter's Gmail connector from `ops@` to **`info@`** and read the business inbox directly; keep
`ops@` only as the credential/identity holder (CH key). Simplest read path and cleanest search, but the
connector then authenticates as the customer-facing account (less least-privilege). Choose this only if
you'd rather avoid the forward hop.

**Do NOT** leave it with the connector on `ops@` and no routing — Peter would keep seeing an empty
inbox.

## 4. Verify (Eugene, read-only)
Send a test email to `info@fishboneconstruction.co.uk`, then Eugene checks the **`ops@`** mailbox (by
subject / `to:info@fishboneconstruction.co.uk`, since forwarding can rewrite the `deliveredto` header):
- **Pass:** the test — and any real business threads — now appear in `ops@`, so Peter will see them.
- Confirm the ops mailbox still shows **no** personal (minda@) mail.
This closes **Peter OI-5** (record it in Peter's own `open-issues.md`). **Done 2026-09-13** — see Status.

## 5. Then — Peter's routine
Once `info@` flows into `ops@`, Peter's **inbox-triage routine prompt** is updated to target the
`ops@`/`info@` inbox (Eugene drafts it; Minda enters it in the routines form). The Companies House
beat + key is the separate CH runbook.

## 6. Later — other companies (tied to Peter OI-4)
Holdings/SSAS/Waste once in the Construction hub: add their `info@` as Groups the same `ops@` reads.
Properties/Amfa stay separate tenants — cross-domain group membership or forward into `ops@`. Start
with Construction.

## 7. Boundary
Guide-only; every step is Minda's in the console. Least-privilege + 2FA on `ops@` (done). **No
password or key recorded anywhere.**
