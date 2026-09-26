# Change log — 2026-09-26 — AWT-0105 closed: `enquiries@amfa.uk` confirmed live

Third and final follow-up to AWT-0105 within the same session. Minda: "enquiries@amfa.uk is created, and
all emails copies sending to ops@fishboneconstruction.co.uk."

## What this confirms

`enquiries@amfa.uk` now exists as a real mailbox on Amfa's own domain — satisfies the last open leg of
AWT-0105. The forwarding to `ops@fishboneconstruction.co.uk` was checked against Nadia's own
`external-source-register.md` (NASRC-6/NASRC-7) before treating it as done rather than assumed: it
matches the intake design already on record there — Peter triages the `ops@` copy and routes Amfa
enquiries into Nadia's `Raw/` (Hub AWT-0095), since Nadia has no direct mailbox read access of her own by
design. **Not an accidental cross-company leak into Peter's Construction-scoped inbox — the intended
mechanism.**

## What's still open, but separately tracked

Two items remain, both already tracked as Nadia's own **NA-3** (not re-raised here, not this runbook's
ask):
- **Outbound authentication** — `enquiries@amfa.uk` must not send until DKIM/SPF/DMARC are set up
  (`Runbooks/Runbook-Amfa-Email-DKIM-SPF-DMARC.md`, already drafted).
- **Nadia's own Gmail connector** (`create_draft`-only) still needs provisioning before she can draft
  into the mailbox directly.

## Updated

- `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md` — FA section marked resolved; runbook
  concludes all three companies (FC/FA/FM) now have a confirmed real mailbox.
- `Infra-Inventory/Workspace-and-Email-Inventory.md` — Amfa row updated to record `enquiries@amfa.uk` as
  live, with the forwarding purpose and the still-open outbound gate noted.
- Hub `AWT-0105` — closed **Done**.

**Not edited directly** (cross-KB rule, §1): Nadia's own `open-issues.md`/`external-source-register.md`.
Instead dropped a note into Nadia's `Raw/` (`minda-ui/Nadia` git + her Drive `Raw/` folder) so she can
fold the confirmation into her own NA-3/NASRC-6 next session, rather than editing her KB directly.

**Files:** `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md`, `Infra-Inventory/Workspace-and-Email-Inventory.md`,
`processed-items-ledger.md` (row 39), `current-state.md`, Hub AWT-0105 (Done), Nadia `Raw/` (new note,
her KB).
