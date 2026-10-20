# Runbook — Sarah (compliance officer) connector setup: Drive + Smartsheet, read-only

> **Purpose:** give Sarah the access her charter allows and **nothing more** — read Drive + Smartsheet to
> check the workforce's work, add her own Hub finding rows, drop Raw hand-off notes — with **no Gmail and
> no QuickBooks**. One of the four remaining go-live steps for Sarah (AWT-0520; her `current-state.md`).
>
> **Guide-only (§3):** Eugene wrote this; **Minda executes every connector/sharing step** (Eugene can't
> provision connectors or change Drive/Smartsheet sharing — charter §3). Alex owns the Roster + Authority
> Register side (AWT-0521). No secret held.
>
> **Status:** READY 2026-10-12.

## What Sarah's access must be (from her charter §5 "May / May not")
**May:** *read* Drive + Smartsheet (Project Register, Document Register, the procedure/link/terms registers,
the Hub, the Authority Register, procedures + method statements); **add Hub rows** for findings; **write Raw
hand-off notes** into the `Raw/` of the assistant concerned; keep **her own** Drive home (control files,
`findings-log.md`, change-log). **May not:** QuickBooks, Gmail (no send/draft), pay/file, share or change
sharing, **edit another assistant's file/row/sheet**, change a procedure/method statement, hold secrets.

So she is **read-only on everything she audits**, with exactly four narrow writes: (1) her **own** Drive
home, (2) other assistants' **`Raw/`** folders, (3) **Hub** finding rows, (4) the **Link Register Status
column** (charter-enforced only — AWT-0530 decided no hard column-lock).

## ⚠️ Pre-flight decision (Minda) — which identity does Sarah's seat run as?
This decides how "read-only" is actually enforced. Pick one:
- **A — Sarah's own Google + Smartsheet identity (RECOMMENDED for a compliance checker).** Least privilege:
  what she can't change is enforced by *sharing* (she's a **Viewer** on everything she audits), not just by
  the charter. Right for an auditor — she literally cannot alter the work she's checking. Needs a login for
  Sarah (a dedicated Google account / Workspace user, and a Smartsheet user on that email).
- **B — runs under `minda@` like Eugene.** No new login, but Sarah would technically hold full write
  everywhere; read-only is then **behavioural only** (charter + the settings.json deny below). Weaker for an
  auditor. Use only if you don't want a separate identity yet.

The steps below assume **A**; where B differs it's noted. **‹CONFIRM A or B›** before starting.

## Step 1 — Google Drive connector (read-only on audited content)
1. Attach the **Google Drive** connector to Sarah's seat. **Do NOT attach Gmail.**
2. **Sharing (path A — the real enforcement):** from `minda@`, share to Sarah's login:
   - **Viewer** on everything she reads: the group KB, the other employees' KBs, project folders, the
     Document Register's files — so she can read but cannot edit others' files.
   - **Editor** on **her own** Drive home `My Drive / Sarah - Fishbone Group compliance officer` (to keep her
     control files, `findings-log.md`, change-log).
   - **Editor/Contributor on the target `Raw/` folders only** (each assistant's `Raw/`), so she can drop
     hand-off notes there and nowhere else in their KB. (Mirrors the estate `Raw/`-only cross-KB rule.)
   - **Path B:** she inherits `minda@`'s write everywhere — rely on the charter + Step 4 deny; still attach
     **no Gmail**.
3. **Not shared / not attached:** the Financial Archive (she never files financial docs), Gmail, anything she
   has no charter reason to read.

## Step 2 — Smartsheet connector (read, + her own finding rows)
1. Attach the **Smartsheet** connector to Sarah's seat.
2. **Sharing (path A):** from the sheet owners, share to Sarah's Smartsheet user:
   - **Viewer** on the sheets she audits: **Project Register** (`5250912102778756`), the **Document
     Register**, the **Procedure / Link / Shared-Terms registers** (AWT-0529), the **Authority Register**,
     the **Roster**, and the **Hub Achievements/Roster** sheets.
   - **Editor on the Hub "Tasks & Requests"** (`8860839228606340`) **only** — so she can **add** her finding
     rows (assigned to Minda + the assistant concerned) and close **only her own** rows. This is the "Hub
     login for adding rows" go-live item.
   - **Editor on the Link Register** for the **Status column** write her charter allows (A1, AWT-0530) —
     column restriction is charter-enforced, not a Smartsheet column-lock.
   - **Path B:** inherits `minda@` write; rely on the charter + Step 4.
3. **No QuickBooks** — do not attach it; her charter forbids any accounting system.

## Step 3 — Confirm the excluded connectors are absent
On Sarah's seat, the connector list should show **only Google Drive + Smartsheet**. Explicitly **absent:**
**Gmail**, **QuickBooks**, any payments/accounting tool. Absent-capability is the strongest control.

## Step 4 — Belt-and-braces deny rule (both paths; essential for B)
Add a `.claude/settings.json` deny block on Sarah's seat/repo so a write/send path can't fire even if a
connector is mis-scoped — the estate pattern (cf. Eugene's `GMAIL_SEND*` deny, Rachel's recipient guard):
- **Deny** all Gmail send/draft/reply/forward tools and all QuickBooks/accounting tools.
- **Deny** Drive/Smartsheet **share/permission-change** and **delete/trash** operations.
- **Allow** the specific writes she needs: add-rows to the Hub, update the Link Register Status column, and
  file writes into her own Drive home + other assistants' `Raw/`.
Eugene can draft this `settings.json` block (it's config, §2b) once the identity (A/B) is fixed — say the
word and I'll write it to match Sarah's exact toolset.

## Step 5 — Verify (the gate)
From a Sarah seat/session:
- [ ] Can **read** the Project Register, Document Register, the procedure registers, a sample KB file.
- [ ] Can **add** a test finding row to the Hub, and **cannot edit** another assistant's existing row/file
      (path A: blocked by Viewer sharing; path B: blocked by the Step 4 deny).
- [ ] **No Gmail** and **no QuickBooks** tool is callable.
- [ ] Can write to her **own** Drive home and to a target **`Raw/`**, nowhere else in another KB.
Then this go-live item is done; remaining = Roster/Authority picklist add (AWT-0521, waits on the Hub login)
+ Minda opening the seat.

## Related
Sarah `CHARTER.md` §5, `current-state.md` (pending steps), `open-issues.md` SA-2; Hub AWT-0520 (scaffold),
AWT-0521 (Alex: Roster + Authority grant), AWT-0530 (Link Register Status-column amendment A1).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
