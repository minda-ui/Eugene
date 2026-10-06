# Change log — 2026-10-06 — RAMS digital signing: recommended + runbook (Google Workspace eSignature)

_Guide-only (§3): Eugene researched and produced the runbook; the admin flip + sending are Minda's/the
admin's steps; Eugene verifies. No credential held._

## Ask
Minda: Anna produces **RAMS** (Risk Assessments & Method Statements) per project and they need digital
sign-off — not just Minda but the **operatives/subbies** on each job too.

## Finding / recommendation
**Use Google Workspace eSignature** (built into Docs/Drive) — no new tool, no extra cost.
- **Legal:** RAMS sign-off is an acknowledgement; a **simple e-signature + audit trail** is valid under
  UK law (standard construction practice). No qualified/eIDAS signature needed.
- **Fit the real numbers** (from Minda): typically **1–2, sometimes 4–5 signers** — well under Google's
  **10-signer** cap; signers are **different subbies each job**, and Google eSignature lets **non-Google
  users sign from an emailed link without an account** (confirmed via Google's own release notes).
- Produces a **completed signed PDF + audit trail**, saved to the requester's Drive.

**Not chosen (parked):** self-host DocuSeal — only needed if signer counts outgrow 10 or Fishbone wants
off Google, and it needs a public HTTPS endpoint through the ASA (the inbound path currently broken by
OI-8). Kept as a documented fallback.

## One prerequisite to confirm
eSignature **sending** needs **Business Standard / Plus / Enterprise / Education Plus**. Fishbone's
companies are separate subscriptions (OI-1), so confirm the edition of whichever company holds the RAMS
(if Business **Starter**, upgrade that sub or use DocuSeal).

## Delivered
`Runbooks/Runbook-RAMS-Digital-Signing-Google-eSignature.md` — decision rationale, the one-time admin
toggle (Admin console → Apps → Google Workspace → Drive and Docs → eSignature), the send/sign flow (label
each signer, non-Gmail emails fine, phone signing), completion + filing into the project Drive/Telegram
folder, verify step, watch-outs (10-signer cap, new request per version), and the DocuSeal fallback.

## Still open for Minda (answered what she could in-chat)
- Confirm the Workspace **edition** of Anna's company + whether eSignature is already toggled on.
- Anna's RAMS output format (Google Doc vs PDF) — both work; PDF just gets uploaded to Drive first.
- Whether to auto-file signed PDFs into the project's Drive/Telegram folder (later enhancement).

## Unrelated, still live
OI-8 inbound still broken; WebMate DDI-divert ready to fire once Minda gives the mobile number (she's away
5 days). VPN test today: tunnel connects but no LAN reach (couldn't reach `10.224.13.9`) — deferred, not a
reliable path before she leaves.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
