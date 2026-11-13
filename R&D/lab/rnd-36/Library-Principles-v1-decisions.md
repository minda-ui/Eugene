# RND-36 — Estate Library Principles v1 (decided one by one with Minda)

**LAB item — not evidence, not a Hub result.** Each principle records Minda's decision and date.

## P1 — What goes into the library (decided 13 Nov 2026: A)
**Only registered documents** — every document with a document number in the group Document Register (policy v1.5 defines what is registered). Unregistered material stays on the desk (Drive / Raw/) and is protected by the separate nightly Drive backup on pve-ai (CT 210, snapshots). The library is the **archive**; the Drive copy is the **backup**.

## P2 — The lobby (decided 13 Nov 2026, after debate)
- The library has a **lobby inside the safe**. A document enters the lobby **when it is registered** and is **locked from that moment** — nobody, including the registrar, can change it afterwards.
- For email arrivals the lobby stores the **whole email (.eml: sender, date, recipients, body) plus its attachments**, not only the attachment. The inbox copy is not relied on.
- Documents leave the lobby only by certification (P3, to decide); a document that fails stays in the lobby, flagged. Nothing is deleted.
- Minda's model (13 Nov): email → Peter saves attachment + email → lobby + register → safe → cross-check rules → certified = source of truth.

## P3 — Two levels of certification (decided 13 Nov 2026, after debate)
- **Authentic** — genuine and unchanged since arrival (integrity + who sent it). Usable as **evidence**.
- **Verified** — its facts cross-checked against other trusted sources. The **source of truth**; the only level the AI and key-facts pages read.
- A document may be **Authentic but disputed** (e.g. a genuine invoice with a wrong amount) — kept honestly as evidence, never used as truth.
- Draft documents (e.g. draft accounts) can be Authentic but not Verified until final.

## P4 — Versions and change notes (Minda, 13 Nov 2026)
- **Every change to a library document creates a new version** (v1, v2, …); earlier versions are kept unchanged.
- **Every new version must carry a description of the change**: what changed, why, who made it, when, and on what source/authority.
- A new version starts at the lobby again: it is not Authentic/Verified until it passes the checks itself (the old version keeps its own status).
- Status changes (e.g. Verified → disputed, certificate withdrawn) are recorded the same way, with a reason.

## P5 — Who certifies: "four eyes" (decided 13 Nov 2026, after debate)
1. **The registrar never certifies their own document** (segregation of duties).
2. **Rules run first, automatically**, and attach a check report (fingerprint, sender domain, company/VAT numbers, references, dates).
3. **Authentic:** automatic when **every** rule passes; any failed rule → a person decides.
4. **Verified:** always confirmed by a **second seat that owns the subject** (finance → Rachel; construction → Anna; property/company facts → John/Laima; …), with the rule report in front of them.
5. **High-risk types** (money, legal, SSAS, anything changing bank or payment details) need **two people, one of them Minda**.
6. Owner map = the master index + seat charters (no new list invented).

## P6 — Failed checks, and nothing is ever thrown away (decided 13 Nov 2026, after debate; Minda's addition)
1. A document that fails a check becomes **Disputed**: it stays locked in the library; its **owner seat resolves** it as one of: *our rule was wrong* (fix the rule, document passes) · *genuine but wrong* (**Authentic-disputed**, evidence only, never truth) · *not genuine* (**Rejected / suspected fraud**, Minda told immediately).
2. **Weekly disputed list** to each owner, **7-day deadline**; overdue items go on Minda's list.
3. **Bank / payment detail changes** are automatically Disputed until a person confirms through a **separate channel** (a phone number we already hold, never one printed on the document).
4. **Nothing is ever thrown away — rejected documents included** (Minda). Rejected and disputed documents go to a **quarantine collection** with: the document + whole email, the rule report, the decision (who, outcome, reason), and any later lesson ("rule N changed because of this case").
5. Purpose: a **labelled case library** to improve the rules (too strict / too weak), spot fraud patterns, and keep evidence for bank, police or insurers.
6. Safety: quarantine items are **never opened on normal computers, never handed out as working copies, never read by the everyday AI**; analysed only in the isolated Lab (no internet, read-only), with Minda's approval. Access: Minda and Sarah only.
7. P1 still applies: only **registered** documents enter — ordinary spam is never registered and never stored.

## P7 — Deletion only by law: keep the record, remove the personal part (decided 13 Nov 2026: C, after debate)
1. A document's **record never disappears**: number, date, type, sender, fingerprint, the fact it existed, and every decision about it.
2. **Retention = the legal minimum + 2 years** (Minda). E.g. accounts/tax: legal 6 years → kept 8; tenancy files: 6 years after the tenancy ends → 8. Permanent records (company constitution, title deeds, …) stay permanent.
3. When retention ends and nothing requires keeping it, **personal details are removed** (redaction, or the content's encryption key destroyed) as a **new version with a change note** (P4): which rule, decided by Minda, checked by Sarah, date.
4. **Legal hold** overrides everything: dispute, claim, HMRC enquiry, suspected fraud and every P6 quarantine case — nothing is removed until the hold is lifted.
5. **Full deletion** only where a law specifically requires it, with **Minda's written decision + Sarah's check**; the deletion itself is recorded.
6. A **retention schedule** (one line per document type) is to be drafted by Sarah and approved by Minda. Sarah to confirm the +2-year buffer is justified for personal data (storage-limitation principle) — reason to record: limitation periods for claims and late enquiries.

## P8 — Three linked forms of every document (decided 13 Nov 2026, after debate; Minda: "the bigger the database, the more accurate the analysis")
1. **Original** — the file exactly as received, fingerprinted. **Evidence**; never changes.
2. **Readable copy** — long-life PDF (PDF/A) + plain text, OCR for scans, made once at arrival. For **reading, search and the AI**. Labelled "derived copy, not evidence".
3. **Data record** — facts extracted from the document (dates, amounts, parties, company/VAT numbers, references, property code, project number). For **analysis** across all documents and for the cross-checking rules.
- All three are tied to the **document number and the original's fingerprint**. **If forms disagree, the original wins.**
- Each data record carries its document's **status** (Authentic / Verified / Disputed) and **source document number**; **analysis uses Verified data by default**, and any result that includes unverified data is marked so.
- **Personal details are replaced by codes in analysis copies** (pseudonymised, e.g. "Tenant T-0042"); only the owner seat can resolve a code to a person.
- Caution recorded: a bigger database gives better analysis **only if the data is right** — quality gates (P3, P5) come before volume.

## P9 — Copies and keys (decided 13 Nov 2026, after debate)
**Copies — 3-2-1 + yearly offline disk:**
- **3 copies:** pve-ai (HQ, master) · pve-bev (Beverley, off-site) · R710 (HQ, separate machine, once rebuilt).
- **2 kinds of storage:** live ZFS disks + Proxmox Backup Server.
- **1 copy away from HQ:** Beverley.
- **+ one offline disk per year**, written once, unplugged, kept in a safe — out of reach of ransomware or a stolen password.
- **No cloud copy** for now ("not like Google Drive").

**Keys — Minda + a sealed emergency key:**
- **Only Minda administers** the library; the admin secret lives only in her 1Password.
- **A sealed emergency key** (break-glass) is kept in a separate place with a trusted holder — **who: Minda to decide later**. Opening it is recorded and visible.
- **Robot jobs have narrow keys:** add documents and hand out copies only — **never change or delete**. Not even Eugene can alter the library.

## P10 — Who uses the library (decided 13 Nov 2026, after debate; Minda: "me and Sarah more than enough")
1. **The library is the safe, not for daily use. Access: Minda and Sarah only** — read-only, every look logged.
2. **Everyone else — staff and AI seats — works on the Google Drive copies as today** (Collaboration Space, Financial Archive, project folders). No library access is given to anyone else.
3. **One robot door out**, for two jobs only: (a) nightly copy of **Verified** readable copies + key-facts pages to **Fishbone AI**, per company; (b) **restore** of a lost/damaged/changed Drive copy, on Minda's or Sarah's request.
4. **Nightly Drive ↔ library check:** same fingerprint ✔ · Drive copy changed → flagged (register a new version, P4, or restore) · Drive copy missing → flagged, restorable · Drive copy is a failed/disputed version → flagged so nobody works from it.
5. The access table (RND-36 access v0.1) now only needs to define **what Fishbone AI may receive**, per area and company.

## P11 — Self-checks, with Sarah's independent check (decided 13 Nov 2026: C, after debate)
- **Nightly (automatic):** new arrivals stored · Drive ↔ library check (P10) · all 3 copies updated. Only **problems** are reported (owner + Eugene); a quiet night sends nothing.
- **Monthly (automatic → one page to Minda, green/amber/red):** every document's fingerprint re-checked on all 3 copies · register ↔ library compared (nothing missing, nothing extra) · disputed-list ageing (P6) · **restore test**: a random document pulled back from **Beverley** and opened.
- **Monthly (Sarah, independent):** Sarah reviews the report and samples a few documents end to end — register → library → Drive → Fishbone AI — so the system does not mark its own homework (four eyes, as P5).
- **Yearly:** offline disk written and placed in the safe (P9) · **full restore drill** — rebuild one company's library from the offline disk as if HQ were lost · emergency-key seal checked (P9). Minda + Sarah.

## P12 — Documents that don't arrive by email (decided 13 Nov 2026, after debate; all proposals agreed)
1. **Lobby inbox per company** (a Drive folder): anyone drops the file (scan, photo, download, our own issued document) → the **owner seat registers** it → the nightly job locks it into the library. A daily "waiting in inbox" list goes to the owner; until registered, the Drive backup protects it. (Email continues via Peter, P2.)
2. **Paper originals:** scanned into the library (Authentic) **and the paper kept** in a known place; the data record (P8) holds **"paper original held at"** (e.g. "HQ safe, box FM-01"). Deeds, signed contracts, leases and share certificates may be the legal original on paper.
3. **Our own documents:** drafts stay on Drive; a document enters the library **when issued — sent or signed**. A corrected re-issue is a new version with a change note (P4).
4. **Signed copies: same number, new version** (e.g. FC0000072 v1 unsigned → v2 signed). **Conflicts with policy v1.5** ("register the new version under a new number") → to be raised as a Change Request to the group KB, together with the whole principles package, once all principles are settled.
5. **Portal downloads** (HMRC, Companies House, …): the data record holds "downloaded from [portal], by [seat], on [date]" and any public reference (Companies House transaction id, HMRC submission ref) for the rules to check — candidates for automatic Authentic.
6. **Site photos:** registered in **meaningful batches** (one row per set, e.g. "FC2611 progress photos, week 45"), as FC0000072 already does for a zip; a single photo that becomes evidence (damage, accident, dispute) gets its own row.

