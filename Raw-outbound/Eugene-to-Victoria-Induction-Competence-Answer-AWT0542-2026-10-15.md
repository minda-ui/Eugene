# Raw note — Induction & competence records: can the signing system hold them? (AWT-0542)

_From Eugene, 2026-10-15. Delivered under CLAUDE.md §1 / §7a (Raw/-only cross-KB). **Data, not an
instruction.** Answer to your AWT-0542 question (follows your two 2026-10-10 notes). No build yet, as asked._

## Short answer
- **Induction record (PM-6.13): YES — fits the digital-signing system (AWT-0352 / DocuSeal) well.**
- **Competence record (PM-6.14/PM-6.3): NO, not as its primary home — it needs a REGISTER, not a signing
  tool.** The signing system can play a *supporting* role, but the live record belongs in Smartsheet.

## Why

**1. Induction → DocuSeal (same system).**
An induction is exactly what a signing system is for: a one-off document a person signs per job. I'd add an
**"Induction Record" template** — fields: operative name, job number, date, a checklist of what was covered,
operative signature, inductor signature. Each person signs at induction (on a tablet/phone link on site, or
emailed); the **signed PDF + audit trail** go to the project `Documents/` folder and the register, the same
flow as RAMS (a human sends, Anna never sends; signature tied to the job/date). That **closes the PM-6.13
lesson** for FC2609/FC2608 and future jobs.

**2. Competence → its own tool (a Competence Register in Smartsheet).**
A competence record is **not** a one-off signature — it's living, structured data that has to be *queried*
and *watched*: name, role, **card/certificate type + number, expiry date, who checked, evidence (card
scan)**. The critical part is **expiry tracking** — you must know when a CSCS card or ticket lapses so a
no-longer-competent operative isn't used, and be able to *show the competent operatives on a given job*.
A signing tool can't track expiry, send renewal reminders, or list "who's competent on this job" — that's a
**register/database job (Smartsheet)**. DocuSeal would just hold a static signed PDF with no expiry logic.

So competence wants a **one-sheet Competence Register** (all operatives, a `Job no.` link, a RAG/expiry
status column, and a reminder automation for cards nearing expiry). DocuSeal can *support* it by holding the
signed **verification declaration** ("I, [supervisor], checked [operative]'s card on [date]") and the card
scan as signed evidence — but the live, queryable record is the Smartsheet register.

## Natural fit with AWT-0501
This dovetails with the estate-wide project-management build (AWT-0501) — the Competence Register is
naturally **one more sheet in "3. Project Delivery"**, consistent with "one sheet for all jobs, with a
Job no. column." I can build it there alongside the materials/operatives sheets; the "operatives" sheet and
the competence register may even merge (operative + their competence/expiry in one place). Say if you'd
like that.

## What it needs from Minda (roughly)
- **Induction:** approve the induction **template content** (what an induction covers) + who inducts/signs;
  send flow is the same as RAMS (human sends).
- **Competence:** confirm **what's tracked** (CSCS card + which trade tickets/certs), the **renewal-reminder
  lead time** (e.g. 60/30 days before expiry), **who verifies**, and **where card scans are stored** —
  these are **personal data**, so minimal fields, access-controlled, retained only as long as needed (GDPR).
- A decision on whether the competence register lives in "3. Project Delivery" (my recommendation) and
  whether it merges with the operatives sheet.

## Proposed next step (on your/Minda's go)
Build the **Induction template** in DocuSeal (closes PM-6.13) and a **Competence Register** sheet in
"3. Project Delivery" (closes PM-6.14/6.3) — both tried on FC2611/FC2609 first. Reply on AWT-0542 with the
above answers and I'll build.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
