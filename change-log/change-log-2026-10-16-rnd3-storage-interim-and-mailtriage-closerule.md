# Change log — 2026-10-16 — RND-3 estate storage (sourced + interim plan) & mail-triage closing-by-rule

_Guide-only / §3 throughout. Minda hands-on at HQ in the afternoon; Eugene designs/specs/drafts, holds no
secret, makes no live change. Branch `claude/lucid-mayer-nsoili`. (Written at the 2026-10-17 wrap-up for
2026-10-16 work.)_

## RND-3 — estate self-hosted storage + backup: hardware SOURCED, interim build planned
Worked the storage project end-to-end from photos Minda shared; the whole stack is now owned bar one cable,
and there's a path to start **this week** without waiting on it.
- **Stack confirmed owned:** NetApp **DS2246** shelf (24-bay, dual IOM6 = **QSFP/SFF-8436**, EMPTY) · Dell
  **R710** host (2× Xeon X5650 = 12c/24t, **24 GB ECC DDR3**, 8× 2.5" bays) · Fujitsu **PSAS CP400e** HBA
  (LSI SAS3008, external SFF-8644, needs **IT mode**) · **24 NetApp caddies**.
- **Drives bought:** **12× Seagate Savvio 10K.6 900 GB SAS** (ST900MM0006; 2 owned + 10 bought, ~£120).
  512n (no reformat). Pool = **2× 6-wide RAIDZ2 ≈ 5.8 TB usable**, 12 bays free.
- **Capacity sized** (`R&D/estate-storage/capacity-planning.md`): measured minda@ Drive (~61 GB via Composio
  `GOOGLEDRIVE_GET_ABOUT`); **all drawings live on Google Drive, no file server** → NAS is a backup copy,
  not primary store. 3-yr working set ~3.7 TB → ~5.8 TB pool is ample.
- **The cable snag:** the only buy is a **SFF-8644 → QSFP (SFF-8436)** cable (correct part = Cablexa
  CAB-8644-QSFP-1M). UK stock is scarce (2–3 wks; confirmed by live search). Ruled out IOM6→IOM12 module
  swap (IOM12 is DS224C-only; 12 G wasted on HDDs).
- **Interim plan (chosen by Minda):** build the pool in the **R710's 8 internal bays** now (8× 900 GB →
  8-wide RAIDZ2 ≈ 4.3 TB), start **PBS backups this week** (closes OI-7/OI-17), add the DS2246 as a 2nd vdev
  when the cable lands. First steps captured: R710 **bring-up (Phase 0)** — bare box, no OS — power/POST,
  BIOS (VT), **iDRAC** set-up, TrueNAS SCALE USB + boot SSD; **network wiring** (data Gb1 + iDRAC on the
  `10.224.10.x` mgmt VLAN, static `.20`/`.21`); then controller **IT-mode** check (H200/H310 crossflash vs
  H700 → cheap internal HBA) and the pool build.
- Files: `R&D/estate-storage/design.md`, `capacity-planning.md`,
  `Runbooks/Runbook-RND3-Estate-Storage-Build.md`, `Runbooks/Runbook-RND3-R710-Internal-Interim-Build.md`.
- **Open:** R710 is bare metal — next session powers it up (report controller model + iDRAC type), then
  install TrueNAS. Buy the QSFP cable in parallel for the full 24-bay capacity later.

## AWT-0765 — mail-triage "closing by rule": drafted, dry-run-tested, v0.2 FINAL, handed to Victoria
- From the 15 Oct owner note: wrote the **four-class close-by-rule prompt block** + never-close list +
  tie-breaks + **weekly closed-list** design + **shadow dry-run** procedure
  (`Runbooks/Runbook-Mail-Triage-Closing-By-Rule-AWT-0765.md`).
- **Dry-run 1** against Victoria's 28 hand-closures of 15 Oct: **23 agree / 5 rule-stricter (escalate) / 0
  over-close** — surfaced 2 policy gaps (`...-DryRun-2026-10-15.md`).
- **Minda approved refinements R1–R3** → folded into **rule v0.2** (R1 internal colleague's own
  outbound/FYI may close; R2 legal/solicitor always escalates; R3 unknown-sender closes only once a seat
  fully handled; money now explicitly incl. finance notices e.g. GoCardless). Net on the 5: 0730/0749 close,
  0745/0750/0758 escalate.
- **Handed off to Victoria** (byte-verified note in her `Raw/`, Drive `1AiSYAMDglgUpbrDZbag79D7jDoV94KNY`;
  Hub **AWT-0808**) to slot into the mail-triage routine(s) + assemble the paste-ready prompt for Minda to
  paste. AWT-0766 activates once live. Eugene's part (draft+dry-run+finalise+hand-off) done.

## AWT-0805 — invoice@ → Dext auto-forward guide (drafted)
Guide-only runbook `Runbooks/Runbook-Invoice-Mailbox-Forward-to-Dext-AWT-0805.md`: get the Dext inbound
address → verify it as a forwarding address in invoice@ Gmail (code lands in Dext) → a filter that forwards
invoices to Dext while **keeping a copy** in invoice@ → loop check → confirm Dext **auto-publish OFF** →
one-invoice test. Honours all four of Minda's checks. Hub AWT-0805 → In Progress; Minda executes + tests.

## Earlier today (already logged)
- **OI-8 RESOLVED** — inbound external calls ring with two-way audio (ledger 118, own change-log).
- **RND-2 DL380 GPU baseline** via iLO/IPMI (ledger 117, own change-log).

## §3 / safety
No live system changed by Eugene; no secret held (iLO pw + WebMate SIP pw stay with Minda). Cross-KB only
via Victoria's `Raw/` (§1). Routines/other KBs not edited.

Ledger: 117 (GPU baseline), 118 (OI-8), 119 (AWT-0765/0805), 120 (RND-3 storage + interim).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
