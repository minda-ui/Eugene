# Runbook — Dedicated `info@` inbox + scoped ops/agent account (v0.1)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda performs every
Admin-console / account / connector step.** **No password or API key is ever written into this file or
any KB** — the owner sets and holds them; Eugene references only *where* a secret lives. Author: Claude
for Eugene, 2026-09-13. Resolves **Peter OI-5** (the Gmail connector currently reaches minda@'s own
personal mailbox, not a dedicated business inbox) and gives the Companies House API key (CH runbook)
and every future workforce credential a home. Gated by **Eugene OI-2** — run the §2 test first._

## 1. What this creates

Two things, per Workspace tenant, starting with **Construction**:
1. **A scoped ops/agent account** — one real Workspace user (e.g. `ops@fishboneconstruction.co.uk`),
   **least-privilege (no admin roles), 2FA on**, its own mailbox. This is the single identity the AI
   workforce authenticates as: Peter's Gmail connector connects here (not to minda@), and it owns the
   Companies House API key and any future workforce secrets. **Costs one Workspace seat.**
2. **A dedicated `info@<domain>` business inbox** — the inbox Peter triages, wired so Peter reads
   *business* mail only, never Minda's personal correspondence.

## 2. Decide the `info@` wiring — run the OI-2 test first (5 minutes)

The Gmail connector connects to **one account** and reads mailboxes it can see. Whether `info@` can be
a free Google Group / shared mailbox or must be a real user depends on a capability we have not yet
confirmed (**Eugene OI-2**). Test it:
- With the Gmail connector pointed at the **ops account**, make `info@` a **Google Group
  (Collaborative Inbox)** with the ops account as a member, send a test mail to `info@`, and check
  whether the connector can **read the Group's messages**.

**Outcome A — connector can read the Group / a delegated mailbox:**
`info@` = a **Google Group (Collaborative Inbox)** (or a delegated shared mailbox). **No extra seat.**
The ops account is a member; Peter reads the Group. Cleanest and cheapest.

**Outcome B — connector reads only the connected account's own primary mailbox:**
`info@` = either a **real user mailbox** (costs a seat) that the connector connects to directly, **or**
keep `info@` as a Group/alias but **auto-forward** its mail into the **ops account's own mailbox**, and
Peter reads the ops account. Forwarding into the ops mailbox avoids a second seat.

Record the outcome in `Infra-Inventory/` and, if it settles OI-2, mark OI-2 resolved.

## 3. Steps — Construction (the tenant Peter's inbox already lives in)

**A. Create the ops/agent account (Minda, Construction Admin console).**
1. Create user `ops@fishboneconstruction.co.uk` (or an agreed name). **No admin roles.** Turn on
   **2-step verification**. Minda sets and holds the password; **Eugene never sees it.**
2. Give it only what the workforce needs: its own mailbox + Drive; membership of the `info@` Group
   (step B). Nothing else.

**B. Stand up / redirect `info@` (Minda, Admin console).**
3. Per the §2 outcome: make `info@fishboneconstruction.co.uk` a **Collaborative Inbox Group** (A) or a
   real mailbox / forwarding target (B), with the ops account as member/owner.
4. **Redirect the real business mail.** Today `info@` effectively lands in minda@'s mailbox; route
   incoming `info@` mail to the dedicated Group/mailbox so it no longer mixes with Minda's personal
   mail. Keep a copy to Minda during a short bedding-in period if wanted.

**C. Reconnect Peter (Minda, in the routines/connector setup).**
5. **Repoint Peter's Gmail connector from minda@ to the ops/`info@` inbox.** This is the change that
   actually closes **Peter OI-5** — Peter then reads a scoped business inbox, not Minda's personal
   mailbox. Update Peter's inbox-triage routine prompt if the mailbox address it targets changes.

**D. Park the workforce secrets on the ops account (Minda).**
6. Register the **Companies House API key** (CH runbook) under the ops account and store it as the
   routine's environment secret. Future workforce credentials live here too — **one scoped identity,
   never Minda's personal login, and never recorded in a KB.**

## 4. Later — the other companies (tied to OI-4 consolidation)

- **Holdings, SSAS, Waste** move into the **Construction hub** (consolidation runbook). Once there,
  each `info@<domain>` can be a Group the **same ops account** reads — no new ops account needed.
- **Properties (+ Commercial)** and **Amfa** stay separate tenants. For those, either add the ops
  account as a **cross-domain member** of their `info@` Group (where the connector allows) or **forward**
  their business mail into the hub ops mailbox. Decide per company alongside Peter OI-4 ("which
  inboxes"). Start with Construction; expand only when a company's inbox is actually in scope.

## 5. Verify
- Peter's connector, reconnected, sees the **business** threads (a `deliveredto:info@fishboneconstruction.co.uk`
  search returns them) and **not** Minda's personal mail.
- A test message to `info@` appears to Peter; a draft reply can be created (never sent).
- The ops account has **no admin roles** and **2FA on**; the CH key works from the ops account.

## 6. Boundary / notes
- Every step is Minda's to perform in the console/connector; Eugene documents and verifies.
- **Least-privilege + 2FA** on the ops account; it is not an admin.
- **No password or API key is recorded in this runbook, any KB, any change-log, or any prompt.**
- Closing Peter OI-5 is recorded in **Peter's** own `open-issues.md` once the connector is repointed.
