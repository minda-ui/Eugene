# Daily summary — 2026-09-26

_A single roundup of today's session, tying together the individual dated change-log entries below.
Not a replacement for them — each still stands as the full record of its own task._

## 1. AWT-0104 — Nadia's standalone KB conversion, confirmed closed

Built earlier this session (see `change-log-2026-09-26-awt0104-nadia-standalone-kb.md`). Minda asked
directly whether it was registered as Done — re-verified against the Hub itself (Rule C) rather than
answered from memory: **Status = Done, Done date = 2026-09-26, Health = Green.** The background Drive
sync for its three paperwork files (`current-state.md`, `processed-items-ledger.md`, the dated
change-log entry) also completed clean, byte-verified.

## 2. AWT-0105 — outbound mailbox identity for FC / FA / FM

New Hub task today, from Alex on Minda's instruction, resolving the Estate Outbound Send-Identity plan:
three companies — Fishbone Construction Ltd (FC), Amfa Furniture Ltd (FA), Fishbone Commercial
Properties Ltd (FM) — get a distinct outbound mailbox instead of everything going out through the shared
`ops@fishboneconstruction.co.uk`. Worked in three rounds as new information came in, rather than one pass:

- **Round 1** (`change-log-2026-09-26-awt0105-outbound-mailbox-fc-fa-fm.md`) — checked each company
  against `Infra-Inventory/` before writing anything. **FC: already done** (`info@fishboneconstruction.co.uk`
  already a real mailbox on its own domain). **FA: needed a human step** (`enquiries@amfa.uk` named in
  Nadia's earlier build but never confirmed live). **FM: genuinely blocked** — Fishbone Commercial
  Properties Ltd has no domain or Workspace subscription of its own; its mailbox
  `commercial@fishboneproperties.co.uk` sits on Properties' domain. Raised as **OI-11** rather than
  guessed at. Wrote `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md`.
- **Round 2** (`change-log-2026-09-26-oi11-resolved-fm-shared-mailbox.md`) — Minda decided OI-11: accept
  `commercial@fishboneproperties.co.uk` as FM's identity as-is, no new domain. OI-11 marked Resolved; FM
  now needs nothing further, same as FC.
- **Round 3** (`change-log-2026-09-26-awt0105-closed-enquiries-amfa-live.md`) — Minda confirmed
  `enquiries@amfa.uk` is created, with copies forwarding to `ops@fishboneconstruction.co.uk`. Checked
  that against Nadia's own `external-source-register.md` (NASRC-6/7) before accepting it — it matches
  the intake design already on record there (Peter triages the `ops@` copy, routes Amfa enquiries into
  Nadia's `Raw/`, Hub AWT-0095), not an accidental cross-company leak. **All three companies now
  confirmed. Hub `AWT-0105` closed Done.**

Two items remain open but are tracked as Nadia's own **NA-3**, not part of this task: outbound
DKIM/SPF/DMARC authentication for `enquiries@amfa.uk` (its own runbook,
`Runbook-Amfa-Email-DKIM-SPF-DMARC.md`, already existed from the AWT-0093 build) and Nadia's own Gmail
connector. A note was dropped into Nadia's `Raw/` (both git and Drive) flagging today's confirmation so
she can fold it into her own control files next session — her KB wasn't edited directly, per the
cross-KB rule.

## 3. Follow-up runbook — copying `enquiries@amfa.uk` mail to `ops@`

Minda asked directly for step-by-step instructions to forward both incoming and sent mail from
`enquiries@amfa.uk` to `ops@fishboneconstruction.co.uk`. Wrote
`Runbooks/Runbook-Amfa-Enquiries-Ops-Mail-Copy.md`: **Part 1** (incoming, mailbox-level forwarding —
appears already live per Minda's report) and **Part 2** (sent mail, an Admin-console routing rule in
Amfa's own tenant, cross-tenant Bcc to `ops@`, not yet confirmed done — mirrors the existing
"Ops routing" pattern already live for Construction's own accounts). Entirely guide-only; not yet
verified end-to-end.

## 4. Housekeeping — Drive sync duplicate cleanup

Three background Drive-sync agents ran close together during the AWT-0105 work; two of them ended up
racing on the same three files (`current-state.md`, `processed-items-ledger.md`, the AWT-0105 runbook)
and each independently uploaded a correct, byte-verified copy — leaving **two live copies of each** at
once instead of one. Found and fixed directly: kept the newer upload of each live, archived the other
(never trashed) with a note explaining it was a duplicate from a concurrent-sync race, not a real
content difference. Also found and fixed a smaller leftover from an earlier round — an already
correctly-renamed archive copy of `open-issues.md` that had never actually been moved into `Archive/` —
moved it. Net effect: no data lost, Drive now holds exactly one live copy of every control file and
runbook touched today.

## Where things stand at end of day

- **Hub:** AWT-0104 Done, AWT-0105 Done. AWT-0090 (M365 scope) unchanged, In Progress, due 2026-09-29.
  AWT-0101 (Alex's cross-login Properties audit) still parked at Minda's request — not touched today.
  AWT-0060 (Anna's SessionStart hook) still Blocked on an empty repo.
- **Open issues:** OI-11 resolved today. 6 open (OI-2, OI-3, OI-5, OI-6, OI-7 critical, OI-8 critical) +
  5 resolved, unchanged from before today except OI-11.
- **Still open, not Eugene's to chase unless asked:** Amfa's DKIM/SPF/DMARC setup and Nadia's own Gmail
  connector (Nadia's NA-3); confirming Part 2 of the mail-copy runbook (sent-mail routing rule) has
  actually been set up.
- **Items done:** 39 IT tasks logged (`processed-items-ledger.md` rows 37-39 added today).

**Files touched today:** `Runbooks/Runbook-Outbound-Mailbox-Provisioning-AWT-0105.md` (new),
`Runbooks/Runbook-Amfa-Enquiries-Ops-Mail-Copy.md` (new), `Infra-Inventory/Workspace-and-Email-Inventory.md`,
`open-issues.md` (OI-11), `current-state.md`, `processed-items-ledger.md` (rows 37-39), five dated
change-log entries plus this summary, Nadia's `Raw/` (one new note, her KB), Hub `AWT-0104` and
`AWT-0105` (both Done).
