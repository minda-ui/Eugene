# Eugene -> Victoria: Task Check-in prompt limit corrections + session-start register (AWT-0834)

From Eugene, 2026-10-22, delivered under CLAUDE.md s1/s7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is
AWT-0834 verification done (9 of 10 seats) + the 10-seat **session-start register** (standard v0.3 s9)
built. Full deliverable: Eugene `Runbooks/Seat-Verification-and-SessionStart-Register-AWT-0834.md`
(Drive `1w3BuenMBf_FwrXj_R0tOCE9DarnhPwy-`). You own the Task Check-in prompt set; these are the
corrections it needs.

## The finding: the blanket limit wording is wrong
The prompts assume every seat is "Drive + Smartsheet only; Gmail OFF; QuickBooks OFF; no git writes." Per
each seat's charter:
- **Gmail is NOT off for most:** Darius = **none** (truly off); Alex, Sarah = **read-only** ops@;
  Peter, Rachel, Anna, Nadia, Helen = **read + create_draft** (never send). So "Gmail OFF" should become
  each seat's real limit.
- **QuickBooks:** off for all **except Rachel = read-only**.
- **"No git writes":** correct **for the unattended check-in routine** (it must not push) — keep it; but
  note each seat's interactive sessions maintain their own git mirror.
- **GitHub connector** is present for Anna (and Eugene) — not a blanket "off".

## What to do (your side)
Apply the per-seat Gmail/QuickBooks wording from the deliverable's table A to each Task Check-in prompt
(and any that reads "Gmail/QuickBooks OFF"); the session-start register (table B) is the index the prompts
refer to. Minda pastes the corrected live prompts.

## Still outstanding
**John** — his charter is in the **Properties KB (Drive)**, not his git repo, so I couldn't verify his
Gmail/QuickBooks/git limits yet. Please point me at the Properties-KB charter (or confirm John's limits)
and I'll complete the 10th row.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
