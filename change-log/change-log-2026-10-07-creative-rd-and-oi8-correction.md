# Change log — 2026-10-07 — OI-8 divert-declined correction; creative-mode R&D (RND-9/2/10)

_Mostly a creative-mode R&D day; per the R&D rules the detail lives in `R&D/` and nothing was graduated, so
the control files stay clean. This entry is the session record (§4). Guide-only; no live change; no secret._

## Control-file correction (morning)
Minda stood down the WebMate DDI-divert and chose to **retry telephony Friday** with console time.
Corrected `current-state.md` (OI-8 divert declined; recorded the Friday diagnosis plan: ASA `capture` on
`outside_fttb` + PBX `sngrep` to localise ASA-NAT vs FusionPBX). No other operational change today.

## Creative-mode R&D (all in `R&D/`, nothing graduated)
- **RND-9 — Estate Approvals Desk** (new, designed): one human-in-the-loop layer generalising the pattern
  that recurs ad-hoc (Helen ad-spend, Rachel sends, Anna RAMS, Eugene infra, the "Real-World Transactions"
  guardrail) — *AI proposes → Minda approves → applied → logged*. Hub "Approvals" sheet + Telegram
  tap-to-approve + a standard Action Request template; **§3 unchanged** (standardises request/approval/audit,
  not execution). Phased P0 template→P1 sheet→P2 notify→P3 tap-approve→P4 auto-raise from RND-6.
  `R&D/approvals-desk/design.md` + `action-request-template.md`. **Graduation candidate.**
- **RND-2 — P40 install checklist** (verified): the HQ DL380 Gen9 **accepts a Tesla P40 (24 GB)**, up to 2×.
  Logged the real requirements — enablement kit **719082-B21**, GPU power cable (805123-001 / 728539-B21),
  **BIOS "Above 4G Decoding"** (the #1 gotcha for the 24 GB BAR), both CPUs populated (have), passive-card
  cooling + PSU/UPS headroom beside the live PBX; Pascal sunsetting caveat. `R&D/local-models/notes.md`.
- **RND-10 — Amfa furniture arm internal ops interface** (new, designed): Minda asked for a graphic
  interface for the furniture arm and to check the business process first. Found the backbone exists but
  **draft/fragmented** (`order-fulfilment-process.md` 7-stage lifecycle + `smartcabinet`/Vitap production +
  cabinet library + live Smartsheet tracker; Nadia runs it). Minda chose **(B) internal ops**. Designed the
  interface as a **direct map of the process** — Order object through 6 views (Pipeline/Order/Production/
  Money/Schedule/Comms) with **stage gates** (contract+deposits→production; pre-delivery pay→delivery; final
  pay+review→closed) tying to RND-8 eSign + RND-9 Approvals. Phased: MVP mature the Smartsheet tracker →
  self-hosted low-code app (NocoDB/Baserow + Budibase on Proxmox). `R&D/amfa-interface/design.md`.

## Open for Minda
- **Phones (OI-8)** — Friday, with console time (the capture + sngrep test).
- **RAMS** — eSignature test on `Raw/FC2611-RAMS-rev-g.pdf`.
- **Helen** — fold the Ads docs (in her `Raw/`) into her charter; first Change Request.
- **R&D next (her pick):** graduate RND-9 P0 (ship the Action Request template) · verify the Amfa process
  plan with Nadia / wireframe the Pipeline+Order screens / scope the Smartsheet MVP · RND-2 P40 shopping-and-
  install runbook.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
