# Estate Library — Principles v2 (draft for Minda)

**LAB item — not evidence, not a Hub result. Draft for Minda's decision; nothing is built.**
v1 debated and decided by Minda with Eugene, 13 Nov 2026 (RND-36). v2 folds in the five team replies of
13 Nov (Sarah, Laima, Anna, Rachel, Victoria — all in Eugene's Raw/). **Bold = changed from v1.**
Decision log: git `R&D/lab/rnd-36/Library-Principles-v1-decisions.md`.

**The aim, in Minda's words (via Victoria):** not a new build. We hold four or five independent logs, an
index, a document register and document storage, none connected. **The library is the step that joins
them into one workable piece** — the core foundation for accurate work by people and AI employees.

---

## One page

**The library is the safe for every registered document. Google Drive (and, for finance, the Financial
Archive) is the desk.** It lives on our own servers, nothing in it is changed or thrown away, every document
is checked before it is trusted, and contradictions are shown so they are fixed before they cause damage.

| # | Principle | In one line (v2) |
|---|---|---|
| P1 | What goes in | Every registered document. **Registered within 1 working day of arrival.** |
| P2 | The lobby | Inside the safe; locked at registration; whole email kept. |
| P3 | Two levels | Authentic (evidence) → **Verified (record)**: facts cross-checked and recorded — **not a technical or design approval.** |
| P4 | Versions | Every change = new version + change note. **A new revision issued by its author (drawing Rev A→B) is a new document, not a version.** |
| P5 | Four eyes | Registrar never certifies; rules first; **a named human records Verified**; **high-risk narrowed** and needs Minda. |
| P6 | Failures | Disputed → owner, 7 days. Nothing thrown away. **Quarantine has its own retention line and access log; originals opened only in the Lab.** |
| P7 | Retention | **Per document type, each with its written legal reason** (finance 8 yrs; construction from the Limitation / Defective Premises / CDM rules). **+2 years for personal data only with a written reason per type.** Record always stays; legal hold. |
| P8 | Three forms | Original · readable copy · data record. Original wins. |
| P9 | Copies & keys | 3-2-1 + yearly offline disk; no cloud; Minda + sealed emergency key; robots add-only. |
| P10 | Who uses it | Minda and Sarah look inside (**Sarah after a charter amendment + Authority Register grant**). One robot door: **Fishbone AI only. Restores never into the Collaboration Space. Secondary cores never through the library.** |
| P11 | Self-checks | Nightly · monthly · yearly. **Sarah samples 5 documents a month; Alex samples outcomes quarterly** (independence). |
| P12 | Arrivals not by email | Lobby inbox per company; issued-only; signed copy = same number, new version; **Sensitivity required (blank = fail); year-end accounts exports locked at sign-off and at filing.** |
| P13 | Key-facts pages | **General page: Laima. Finance page: Rachel.** Contradictions at the top, sent to the source-row owner; **SSAS identity documents and SSAS modelling never on a page.** |
| P14 | Checking rules | Fixed rules decide; AI flags; Minda decides if undecided. **Finance starter rules from Rachel; Sarah reviews rules.** |
| **P15** | **One catalogue, one key** | **The group Document Register is the catalogue; the Drive file ID is the shared key** joining library, register, ledgers, master index and Hub. Nothing is typed twice. |

---

## The flow (v2)

```
 Email / scan / portal / issued doc
            │  registered within 1 working day (Peter or the owner seat) · Sensitivity set
            ▼
 ┌──────────── LIBRARY (pve-ai, locked) ─────────────────────────────────────┐
 │  LOBBY ── rules (+AI flags) ──► AUTHENTIC ── owner check ──► VERIFIED (record) │
 │    │                                 named human records it (Minda if undecided) │
 │    └── fails ─► DISPUTED ─► owner 7 days ─► resolved / quarantine (Lab only)    │
 │  every change = new version + note · 3 copies + offline disk                    │
 │  keyed by Drive file ID ↔ Document Register ↔ ledgers ↔ 00_INDEX ↔ Hub          │
 └─────────────────────────────────────────────────────────────────────────────────┘
            │ robot door out (only)
            ├─► Fishbone AI (master core): Verified readable copies + key-facts pages
            │     (never SSAS identity documents or SSAS modelling)
            ├─► restores to the owner's own Drive folder — never the Collaboration Space
            └─► nightly check by Drive file ID (moves, e.g. to Drawings/Archive, are expected)
 Desk: Drive for everyone · Financial Archive for finance (Rachel).
 Secondary cores (Andrejus, Irina): dated copies handed over through the gate only — not the library.
```

---

## The principles in full

### P1 — What goes in
Only registered documents (a number in the group Document Register; policy v1.5 defines what is
registered). Everything else stays on Drive under the nightly Drive backup.
**v2:** documents are registered **within 1 working day** of arrival; the daily waiting list shows each
item's **age** (Anna).
**Scope question:** is **Anthill Homes** in the library (Laima)? — Minda (D6).

### P2 — The lobby
Unchanged. Inside the safe; locked at registration; email arrivals keep the whole email + attachments.

### P3 — Two levels of certification
- **Authentic:** genuine and unchanged since arrival → evidence.
- **Verified (record):** its facts cross-checked against other trusted sources **and recorded by a named
  human** → the source of truth; the only level the AI and key-facts pages read.
- **v2 (Anna):** "Verified" is a **record-keeping status, not a technical or design approval**. It never
  means a drawing, calculation or design has been approved for building. **Supplier and designer documents
  (drawings, calculations, specifications) stay at Authentic** unless their facts (number, revision, date,
  project) are checked — and even then, Verified covers the record, not the engineering.
- Authentic but disputed: genuine but wrong → kept as evidence, never used as truth. Drafts: Authentic only.

### P4 — Versions and change notes
Every change = new version + change note (what, why, who, when, on what authority). Old versions stay.
**v2 (Anna):** a new **revision issued by its author** (drawing Rev A → Rev B, a re-issued report) is a
**new document with its own register row**, linked to the earlier one. Versions are for **our** changes to
our record (change notes, signed copies, status changes).

### P5 — Who certifies: four eyes
1. The registrar never certifies their own document.
2. Rules run first and attach a check report.
3. Authentic is automatic only if every rule passes; otherwise a person decides.
4. **Verified is always recorded by a named human** from the owner seat's cross-check report. AI seats
   prepare the cross-check; **a human records Verified** where an AI seat's charter does not let it certify
   (construction — Anna).
5. Subject owners:

   | Subject | Cross-check by | Verified recorded by |
   |---|---|---|
   | Finance | Rachel | **Rachel**, from the Drive / Financial Archive copy **when its fingerprint matches the library copy** |
   | Construction | Anna (cross-check report) | **a named human** — and a **second construction checker to be named** (D4) |
   | Company facts | Laima | Laima's seat as owner (D5) |
   | Property facts | John | John's seat as owner |
   | Others | per master index + seat charters | owner seat |

6. **High-risk (narrowed, Rachel)** needs two people, one of them Minda:
   bank or payment detail changes · loans and guarantees · HMRC filings and Time-to-Pay · SSAS ·
   **one-off payments or commitments over a threshold (suggested £5,000 — Minda, D7)**.
   Everything else follows the normal owner route.

### P6 — When a check fails; nothing is thrown away
Unchanged from v1 (Disputed → owner, 7 days → Minda's list; bank-detail changes Disputed until confirmed
by phone on a number we already hold; rejected documents kept in the quarantine case library).
**v2 (Sarah):** the quarantine case library has **its own retention line** in the schedule, **an access
log** (who opened what, when, why), and **originals are opened only in the isolated Lab**.

### P7 — Retention
- The **record never disappears** (number, date, type, sender, fingerprint, decisions).
- **v2: a retention schedule per document type, each line with its written legal reason.** Sarah drafts;
  **a data-protection adviser checks it** (Victoria); Minda approves.
- Starting points from the replies (to be confirmed in the schedule):

  | Type | Period | Reason / source |
  |---|---|---|
  | Finance (accounts, tax, VAT, bank) | **8 years** | Rachel: 6-year legal minimum + 2 |
  | Loans | **8 years after the loan ends** | Rachel |
  | HMRC Time-to-Pay / enquiry papers | **legal hold** while open | Rachel |
  | Construction contracts | **6 years (simple) / 12 years (deed)** from completion, + margin | Limitation Act 1980 (Anna) |
  | Dwellings work | **15 years (work before 28 Jun 2022: 30 years)** | Defective Premises Act as amended by the Building Safety Act 2022 (Anna) |
  | CDM Health & Safety file | **life of the structure** | CDM 2015 (Anna) |
  | Deeds, company constitution | permanent | |
  | Tenancy files | 8 years after the tenancy ends | v1 |
  | Quarantine case library | own line (Sarah) | P6 |

- **+2 years for personal data only where the schedule gives a written reason for that type** (Sarah).
  Otherwise personal details are removed at the legal minimum.
- At the end of retention, personal details are removed as a recorded new version — Minda decides, Sarah
  checks. Legal hold stops all removal. Full deletion only where a law requires it.
- *These periods are a starting list for the schedule, not legal advice.*

### P8 — Three linked forms
Unchanged. Original · readable copy (PDF/A + text) · data record; the original wins.

### P9 — Copies and keys
Unchanged. 3-2-1 + yearly offline disk in a safe; no cloud; only Minda administers; robots add-only.
**Open:** who holds the **sealed emergency key** (D10).

### P10 — Who uses the library
- **Minda and Sarah** look inside, read-only, logged. **Sarah's access needs a charter amendment and an
  Authority Register grant first** (Sarah) — D1.
- Everyone else works on the desk as today: **Drive for everyone; the Financial Archive stays the finance
  desk (working copy), Rachel's** (Rachel). The library is the safe behind both.
- **One robot door out — to Fishbone AI (the master core) only:** Verified readable copies + key-facts
  pages. **Never SSAS member identity documents (passports, licences, credit reports) or business
  modelling built on SSAS data** (Victoria, Minda 11 Nov).
- **Restores** go back to the owner's own Drive folder (or the Financial Archive) on request — **never into
  the Collaboration Space**, which is shared outside the master core (Victoria).
- **Secondary cores (Andrejus, Irina):** dated, handed-over copies **through the gate only** (4 Nov rule).
  The library is never a route to them (Victoria, Laima).
- **Nightly Drive ↔ library check, matched by Drive file ID:** moves (e.g. to `Drawings/Archive`) are
  **expected, not flagged** (Anna); content changed / missing / disputed → flagged to the owner.

### P11 — Self-checks
- Nightly (problems only) and yearly (offline disk, restore drill, seal check) unchanged.
- **Monthly:** one green/amber/red page to Minda + **Sarah's independent sample: 5 documents, at least one
  high-risk and one disputed**, end to end. **Starts once these principles are an approved, numbered
  procedure** (Sarah).
- **v2 — independence (Sarah):** Sarah reviews the **rules**; **Alex samples the outcomes quarterly** — so
  nobody checks their own work (or the other way round — D3).

### P12 — Arrivals and registration details
- Lobby inbox per company; paper originals kept with location recorded; only **issued** documents; signed
  copy = same number, new version (Change Request — P15/next steps); portal downloads with source; site
  photos in batches, single evidence photos their own row. *(v1)*
- **v2 — Sensitivity is mandatory** at registration, **default set per document type** (Anna); **blank =
  fail** (Sarah).
- **v2 — year-end lock (Rachel):** trial balance and general-ledger exports are **registered at sign-off of
  the accounts and again on filing**, so the year's figures are fixed in the safe.

### P13 — Key-facts pages per company
**Purpose: show and highlight contradictions so they are put right before they cause damage.**
- Built nightly from **Verified** data; every line sourced and dated; contradictions at the top; gaps listed.
- **General page — owner Laima** (content and checking; Eugene builds). A **9-section template** (Laima);
  Laima confirms **only what changed**; **stale dates flagged**; pages will be thin at first. **They replace
  Laima's hand-made AWT-1089 pages** (D5).
- **Finance page — owner Rachel.** Bank details **last 4 digits only**. Rachel has already found three
  real contradictions to seed it. **Laima: read-only access, or keeps reading QuickBooks directly** (D5).
- **Contradictions go to the owner of the source row, with Laima copied** (Laima).
- **Never on any page:** SSAS member identity documents or SSAS-based modelling (Victoria).

### P14 — The cross-checking rules
- R1–R5 unchanged (fixed rules decide; AI extracts and flags; Minda decides if undecided; six families;
  "not checked" never passes; written, tested, reviewed, versioned; learning loop + monthly rule report).
- **Sarah reviews the rules** (independence, P11).
- **Finance starter rules (Rachel):** invoice ↔ purchase order · amounts and VAT ↔ QuickBooks · VAT number
  ↔ HMRC check · bank statement ↔ reconciliation · remittances ↔ payments · CT600 ↔ accounts.
- **Construction (Anna):** drawing number, revision and date ↔ the Drawing Register; supplier designs stay
  Authentic (P3).

### P15 — One catalogue, one key (new, Victoria)
- **The group Document Register is the catalogue.** Nothing else becomes a second catalogue.
- **The Drive file ID is the shared key.** Register rows and processed-items ledger rows already carry it.
  The library, the register, the ledgers, the master index (`Wiki/00_INDEX.md`) and Hub rows join on it,
  so nothing is re-entered.
- **Pieces to join (Victoria's list + Eugene's Lab findings):** group Document Register · **the older
  "1. General" register (still live)** · per-KB processed-items ledgers · `00_INDEX` · Hub rows · Drive ·
  the Financial Archive · the property / project registers.
- **Clean-up before the pilot** (full register read, 13 Nov): 68 rows without a Drive file ID (folder links,
  free text, blank), 44 email-only rows, 3 duplicate document numbers, 1 status outside the policy list.
  Owners fix; Eugene changes nothing.

---

## Decisions for Minda

| # | Decision | Proposal |
|---|---|---|
| D1 | Sarah's library access | Yes — via a charter amendment + Authority Register grant (Alex's route) |
| D2 | Retention | Per-type schedule with written reasons; Sarah drafts, data-protection adviser checks, you approve. Construction periods from the law (Anna); +2 years for personal data only with a reason |
| D3 | Independence | Sarah reviews the rules; Alex samples outcomes quarterly |
| D4 | Construction | "Verified (record)" recorded by a named human; name a **second construction checker** (who?) |
| D5 | Key-facts pages | General = Laima, Finance = Rachel; Laima read-only on Finance (or QuickBooks direct); the new pages replace AWT-1089 |
| D6 | Anthill Homes | In the library, yes or no? |
| D7 | High-risk | Narrowed list as P5.6; one-off threshold **£5,000**? |
| D8 | Year-end lock | TB/GL exports registered at sign-off and on filing |
| D9 | Victoria's conditions + one key | SSAS identity docs and modelling excluded from AI and pages; no restores into the Collaboration Space; secondary cores via the gate only; Drive file ID as the shared key |
| D10 | Sealed emergency key | Who holds it? |
| D11 | Direction | Approve the direction → Victoria raises **one Change Request** (SRC-39: signed copy = same number + version; new register fields status / checker / sensitivity / fingerprint / version), **after FG-CR-0003** (policy v1.6) |

## What happens after your decisions
1. Eugene writes **Principles v2 final** with your answers.
2. Victoria raises the Change Request, sequenced after FG-CR-0003.
3. Sarah drafts the retention schedule; adviser check.
4. Owners clear the register clean-up list (P15).
5. **FM pilot** (28 documents) — only on your go; nothing on any live system before then.

## Where each change came from
| Reply | Changes in v2 |
|---|---|
| **Sarah** | P6 quarantine retention + log + Lab-only; P7 written reason per type; P10 access via charter + Authority Register; P11 5-document sample, starts after approval, independence; P12 Sensitivity blank = fail |
| **Laima** | P5 company vs property facts; P13 General page owner, 9-section template, changed-only confirmation, stale dates, contradictions to source owner; Finance page = Rachel; replaces AWT-1089; Anthill Homes question; Fishbone AI as master core |
| **Anna** | P1 1 working day + age; P3 "Verified (record)", supplier designs Authentic; P4 author revisions = new row; P5 human records Verified + second checker; P7 construction periods; P10 moves expected; P12 Sensitivity default per type |
| **Rachel** | P5 finance certification by fingerprint, high-risk narrowed + £5,000; P10 Financial Archive = finance desk; P12 year-end lock; P13 Finance page, last 4 digits; P14 finance starter rules; P7 finance/loan/TTP retention |
| **Victoria** | P10 SSAS exclusions, no restores to Collaboration Space, secondary cores via gate; P15 one catalogue, one key; Change Request sequencing; P7 adviser check |

**Not built. Nothing changes on any live system until Minda approves.**
