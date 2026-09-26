# Change log — 2026-09-26 — OI-11 resolved: FM accepts the shared Properties-domain mailbox

Follow-up to AWT-0105 within the same session. Minda: "Accept the shared Properties-domain mailbox for
FM."

## Decision

Of the three options put to her when OI-11 was raised (register Fishbone Commercial Properties Ltd an
actual own domain; accept `commercial@fishboneproperties.co.uk` — Properties' domain — as FM's outbound
identity as-is; some other shape), Minda chose **option (b)**. No new domain, no new Workspace
subscription, no DNS/DKIM/SPF/DMARC project. `commercial@fishboneproperties.co.uk` (already live, already
in use) is FM's outbound identity going forward.

## Updated

- `open-issues.md` — **OI-11 marked Resolved**, decision recorded.
- `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md` — FM section rewritten from "blocked,
  needs a decision" to "resolved, no action needed," same shape as the FC section. Verification section
  and history updated to match.

## Where AWT-0105 stands now

Two of three companies need nothing further: **FC** (already had a real on-domain mailbox) and **FM**
(just resolved — accepts the shared Properties-domain mailbox). **FA** is the only piece still open:
Minda/Amfa's super-admin needs to confirm or create `enquiries@amfa.uk` in Amfa's Admin console, then
work through the existing `Runbook-Amfa-Email-DKIM-SPF-DMARC.md` before it sends. Hub `AWT-0105` updated
to reflect this — stays **In Progress**, not Done, until FA's step is taken.

**Files:** `open-issues.md` (OI-11 Resolved), `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md`
(FM section rewritten), `processed-items-ledger.md` (row 38), `current-state.md`, Hub AWT-0105 (updated).
