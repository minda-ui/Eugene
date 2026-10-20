# Instruction for Anna — getting a RAMS signed (Google Workspace eSignature)

**For: Anna (AI Construction Assistant), and whoever sends RAMS for signature at Fishbone.**
Prepared by Eugene, 2026-10-06. Guide-only — the actual signing is done by a person in the browser
(Eugene holds no login). No personal data in this file (names/emails stay in the project folder, per the
FC2611 hand-off's "do not mirror to git").

---

## The short version
Fishbone Construction is on **Google Workspace Business Standard** and **eSignature is already switched on**
(confirmed 2026-10-06). A RAMS can be signed by Minda **and the operatives/subbies** straight from an
emailed link — **signers do NOT need a Google account**. When everyone's signed, Google produces a
**completed signed PDF with an audit trail**, which is the legal record (it replaces the wet-ink sign-off
rows). Up to **10 signers** per document — fine for a RAMS.

Under UK law a **simple electronic signature + audit trail is valid** for a RAMS briefing acknowledgement,
so no special "qualified" signature is needed.

---

## Part 1 — Anna: hand over a *signing-ready* RAMS
Three things make a RAMS ready to send for signature:

1. **Finalise the header — remove the DRAFT wording.** A RAMS going out for signature must read as the
   **issued revision** (e.g. "Issued — rev g, 06/10/2026"), not "DRAFT … for review … not valid until
   signed." The signature is what makes it valid; the body should not still say DRAFT. (This is a content
   edit on the document — Anna/Minda do it, not Eugene.)

2. **Provide it as a PDF.** Google eSignature acts on a **PDF** (or a Google Doc) — **not** a `.docx`. Export
   the finalised RAMS to **PDF** and put that in the **project's Drive folder**. PDF is best for a RAMS
   because it locks the layout. (If you'd rather place fields in a Google Doc, "Open with Google Docs" also
   works — but PDF is the clean path.)

3. **Attach a one-line signer list** (keep it with the project, not in git): for each signer —
   **name · role · email · which block they sign** (the issuer/MD line, the "person completing" line, and
   one row each on the Induction/RAMS Briefing Sign-off Sheet for the operatives). Company or personal
   emails are fine.

That's Anna's part. The signing itself is below.

---

## Part 2 — sending it for signature (a person with a Business Standard seat, in the browser)
1. In Drive, open the **project folder**, right-click the **RAMS PDF** → **eSignature** (or open it and choose
   eSignature). On a Google Doc: **File → eSignature**.
2. **Manage signers** → add each signer from the list: a **label** ("MD / Issuer", "Operative – Sebastian",
   etc.) and their **email**. Add all of them (max 10). A non-Google email is fine — they'll get a link.
3. **Place the fields** for each signer at their block:
   - **MD / Issuer:** a **Signature** field + **Date** on the "Issued By" line and on the "person completing
     this statement" line.
   - **Each operative:** a **Signature** field + **Date** (and **Printed Name** if you want it typed) on
     their row of the **Sign-off Sheet**.
   Assign every field to the right signer's label.
4. **Request signature.** Each person gets an email, opens the link (a phone is fine), and signs. With
   several signers it completes only when **everyone** has signed.
5. **On completion:** Google emails everyone, saves a **signed PDF + audit trail** to the sender's Drive, and
   locks it. **File that signed PDF against the project** (project Drive folder, and into the project's
   Telegram group if that's the convention).

---

## Watch-outs
- **One signed PDF per version.** If the RAMS text changes after it's been signed, that's a **new** signature
  request on the new PDF — keep the previously signed version on file. Never edit a signed document.
- **10 signers max** per request. A RAMS won't hit that; if one ever would, split the sign-off or raise it
  with Eugene (the DocuSeal self-host fallback handles unlimited signers).
- **The audit trail is the point** — keep every completed signed PDF filed per project; that's the record
  that each person was briefed and acknowledged the RAMS before starting.
- Requester needs a **Business Standard** seat (Minda/Anna's account qualifies); **signers need nothing**.

---
*Guide-only. Anna prepares the signing-ready RAMS; a person sends and everyone signs in the browser; Eugene
verifies from the completed signed PDF. No credential held (charter §3).*
