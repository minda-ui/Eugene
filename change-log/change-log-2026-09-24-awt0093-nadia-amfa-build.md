# Change log — 2026-09-24 — AWT-0093: Nadia (Amfa Sales & Ops Assistant) built

Minda asked "Do you have any AWT?" (session-start-style Hub check); found 3 open rows (AWT-0060
Blocked, AWT-0090 In Progress, **AWT-0093 Open, new**) and reported them. Minda said "Yes, please" to
starting the AWT-0093 build.

**AWT-0093** (Victoria for Minda, Minda-approved via AWT-0092): build **Nadia**, Amfa Sales & Ops
Assistant, adopting the existing Amfa Furniture Ltd KB — no new KB — per the estate's precedent for an
employee whose identity home is an *adopted existing company KB*: **John on the Fishbone Properties
Ltd KB**. Read John's `CHARTER.md` (Properties KB Drive) first to mirror its exact structure, since the
build brief named this pattern explicitly.

**Investigated before building:**
- Read both Raw/ notes (build brief + same-day intake addendum) from Eugene's own `Raw/`.
- Read Amfa's existing `CLAUDE.md` (its own house-rules operating manual — unchanged by this build) and
  `Outputs/kb-registers.md` to understand the KB's real current state, not assume it from the brief.
- Read the existing `Wiki/Processes/order-fulfilment-process.md` (draft, unverified) before writing a
  new process article, to cross-reference rather than duplicate it.
- Confirmed the order tracker's real columns (Smartsheet `5287398789482372`) and the workspace it lives
  in (`5258609614448515`, the pre-existing "AMFA Furniture" workspace, distinct from the KB's own
  "AMFA Furniture Ltd" workspace) before building the new CRM sheet in the right place.
- Attached the `minda-ui/Amfa-Furniture-Ltd` git repo to this session (`add_repo`) and cloned it —
  **found it holds only the SessionStart-hook scaffold**, none of the KB's actual ~30KB `CLAUDE.md` /
  Wiki / Outputs content has ever synced to git, and the branch name `CLAUDE.md` §1 describes doesn't
  match what's really on `main`. Flagged as a pre-existing gap, not fixed here (out of scope, a much
  larger separate task).

**Built (all uploaded to the Amfa KB's Drive — its actual source of truth — and byte-verified):**
- `CHARTER.md` (new, KB root) — Nadia's identity/charter, mirroring John's structure: §0 session-start
  + Hub Rules A-D + Raw/ cross-KB rule, §1 role/scope, §2a/§2b may/must-never, §3 how she works (flagged,
  not assumed: no named human reviewer parallel to Irina — defaults to Minda; the "test-run under
  Construction umbrella" mechanics aren't spelled out in the brief), §4 domain/facts table, §5 folders
  (+ the git-drift finding), §6 routines, §7 control files (KB's own model, not the group four-file
  model), §8 relationship to group/Hub (registration is Victoria's next step, not done here), §9
  connectors.
- `Drafts/` (new folder + `README.md`) — outward work awaiting a human's release.
- `Wiki/Processes/enquiry-to-order-pipeline.md` (new, `active`) — the CRM intake pipeline, explicitly
  cross-referenced with `order-fulfilment-process.md` as front-half/back-half of the same lifecycle
  rather than a competing/duplicate article. `Wiki/index.md` updated (archive-then-recreate).
- `Routine-Prompt-Enquiry-Triage.md` and `Routine-Prompt-Quote-Draft.md` (new, KB root) — full
  paste-ready drafts for Minda to create via the routines form; Eugene doesn't create routines himself.
- `Outputs/kb-registers.md` (archive-then-recreate) — Change-log entries, Wiki structure changes and
  Outputs produced tables all updated per the KB's own convention.
- **Smartsheet "Enquiries / Quotes (CRM)"** — new sheet, id `5405540723328900`, workspace **AMFA
  Furniture** (`5258609614448515`, deliberately co-located with the order tracker it feeds). Columns:
  Enquiry ID, Date received, Customer, Source, Stage (New/Quoted/Won/Lost/On Hold), Value, Owner, Next
  action, Due date, Order ref (AM###), and a live **Health RYGB** formula (same shape as the Hub's own).
- `Runbooks/Runbook-Amfa-Email-DKIM-SPF-DMARC.md` (new, **Eugene's own** KB) — `amfa.uk` DKIM/SPF/DMARC
  guidance; flags that Amfa's DNS host isn't yet established in `Infra-Inventory/`, unlike Holdings/Waste.

**Blocked, not silently skipped:** committing any of the above to `minda-ui/Amfa-Furniture-Ltd` was
denied twice by the auto-mode classifier — `git add` on `CHARTER.md` specifically was blocked
("Instruction Poisoning"), then a `git commit` of everything else was blocked separately ("External
System Writes"), then even a read-only `git status` in that repo's directory was blocked
("Instruction Poisoning" again). All content exists locally in this session's clone
(`/home/user/amfa-furniture-ltd/`), untouched, ready to commit — nothing is lost, but nothing has
reached git yet. This mirrors the established pattern from Eugene's own charter history (the Hub
Coordination Standard / Rule C incidents): the resolution there was getting Minda's **explicit**
confirmation of the content before retrying the git write. Flagged on Hub AWT-0093 (Status → Blocked)
and in `current-state.md`'s Next action, rather than worked around.

**Deliberately not done, per the brief:** `enquiries@amfa.uk` not provisioned (live-system prerequisite,
human-executed); registration on the group `CLAUDE.md` §1 / Hub Roster (Victoria's step); finance-umbrella
hooks to Rachel (Hub AWT-0094, separate). No `Wiki/Customers/`/`Wiki/Orders/` articles or CRM rows —
nothing real to file yet.

**Files:** `Runbooks/Runbook-Amfa-Email-DKIM-SPF-DMARC.md` (new), `processed-items-ledger.md` (row 33),
`current-state.md`, Hub AWT-0093 (Blocked). Amfa KB (Drive): `CHARTER.md`, `Drafts/README.md`,
`Wiki/Processes/enquiry-to-order-pipeline.md`, `Wiki/index.md`, `Routine-Prompt-Enquiry-Triage.md`,
`Routine-Prompt-Quote-Draft.md`, `Outputs/kb-registers.md`, `Outputs/change-log-2026-09-24-nadia-build.md`
— all new/updated on Drive, byte-verified; git pending.
