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

## Addendum (same day) — reviewed Anna's first real RAMS + wrote Anna's instruction
Minda: "I will ask Anna to send you ready RAMS… you will do instruction for Anna how to use it." Anna
dropped the RAMS into Eugene's `Raw/` with a §7a hand-off note (Hub AWT-0352): **FC2611 — Goldsmiths
Bullring, Breitling & Rolex CPO, rev g** (a `.docx`, Minda-reviewed, still headed DRAFT, unsigned).
**Reviewed it for signing-readiness** (read-only; not mirrored to git per the hand-off — it carries
operatives' names + site contacts). Verdict: **content-ready** — clear signature blocks (Issued By / MD,
"person completing", and the Induction/RAMS Briefing Sign-off Sheet for the operatives); ~4 signers, under
the 10 cap. **Two prep steps flagged to Minda before it can be sent:** (1) it's a `.docx` — eSignature needs
a **PDF** (or Google Doc), so export to PDF; (2) **finalise the DRAFT header** to issued rev g (signers
shouldn't sign a "DRAFT – not valid"). Also need each signer's **name + email**. **Delivered the instruction
for Anna:** `Runbooks/Instruction-Anna-Getting-a-RAMS-Signed-Google-eSignature.md` (generic + reusable, no
personal data) — Part 1 (Anna: finalise header, export PDF, attach a signer list) + Part 2 (sending/signing
in the browser) + watch-outs. Offered to drop a copy into Anna's own `Raw/` as the cross-KB hand-off.
