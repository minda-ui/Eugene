# Estate Library — Principles v2

**LAB item — not evidence, not a Hub result. Direction approved by Minda 14 Nov 2026; nothing is built.**
v1 debated and decided by Minda with Eugene, 13 Nov 2026 (RND-36). v2 folds in the five team replies of
13 Nov (Sarah, Laima, Anna, Rachel, Victoria — all in Eugene's Raw/) and **Minda's decisions D1–D11 of
14 Nov**. **Bold = changed from v1.**
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
| P1 | What goes in | Every registered document, **Anthill Homes included (prefix AH)**. **Registered within 1 working day of arrival.** |
| P2 | The lobby | Inside the safe; locked at registration; whole email kept. |
| P3 | Two levels | Authentic (evidence) → **Verified (record)**: facts cross-checked and recorded — **not a technical or design approval.** |
| P4 | Versions | Every change = new version + change note. **A new revision issued by its author (drawing Rev A→B) is a new document, not a version.** |
| P5 | Four eyes | Registrar never certifies; rules first; **a named human records Verified**; **high-risk narrowed** and needs Minda. |
| P6 | Failures | Disputed → owner, 7 days. Nothing thrown away. **Quarantine has its own retention line and access log; originals opened only in the Lab.** |
| P7 | Retention | **Per document type, each with its written legal reason** (finance 8 yrs; construction from the Limitation / Defective Premises / CDM rules). **+2 years for personal data only with a written reason per type.** Record always stays; legal hold. |
| P8 | Three forms | Original · readable copy · data record. Original wins. |
| P9 | Copies & keys | 3-2-1 + yearly offline disk; no cloud; Minda + **emergency key held by Irina (interim, break-glass only, waiting period, every opening recorded)**; robots add-only. |
| P10 | Who uses it | Minda and Sarah look inside (**Sarah after a charter amendment + Authority Register grant**). One robot door: **Fishbone AI only. Restores never into the Collaboration Space. Secondary cores never through the library.** |
| P11 | Self-checks | Nightly · monthly · yearly. **Sarah reviews rules and samples 5 documents a month; Alex samples outcomes quarterly** (independence). |
| P12 | Arrivals not by email | Lobby inbox per company; issued-only; signed copy = same number, new version; **Sensitivity required (blank = fail); year-end accounts exports locked at sign-off and at filing.** |
| P13 | Key-facts pages | **General page: Laima. Finance page: Rachel.** Contradictions at the top, sent to the source-row owner; **SSAS identity documents and SSAS modelling never on a page.** |
| P14 | Checking rules | Fixed rules decide; AI flags; Minda decides if undecided. **Finance starter rules from Rachel; Sarah reviews rules.** |
| **P15** | **One catalogue, three keys** | **The group Document Register is the catalogue. Document number = identity; fingerprint = proof of content; Drive file ID = join key** to the desk copy across register, ledgers, master index and Hub. Nothing is typed twice. |

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
**Anthill Homes is in (D6).** Minda and Irina each own 50%. It gets its own prefix **AH** (Change Request) and its
own key-facts pages. **Irina's Google Drive stays Anthill's desk; the library keeps copies only.** Anthill's shared
folders reach us through the nightly Drive mirror ("Shared with me" is included since 12 Nov).

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
   | Construction | Anna (cross-check report) | **Minda for now** (FM pilot); a **named construction-team checker** before FC enters the library (D4) |
   | Company facts | Laima | Laima's seat as owner (D5) |
   | Property facts | John | John's seat as owner |
   | Others | per master index + seat charters | owner seat |

6. **High-risk (narrowed, Rachel)** needs two people, one of them Minda:
   bank or payment detail changes · loans and guarantees · HMRC filings and Time-to-Pay · SSAS ·
   **one-off payments or commitments over £5,000** (D7). Split payments just under the threshold are a
   fraud-sign rule. Rachel reports the volume after 3 months and Minda adjusts.
   Everything else follows the normal owner route.

### P6 — When a check fails; nothing is thrown away
Unchanged from v1 (Disputed → owner, 7 days → Minda's list; bank-detail changes Disputed until confirmed
by phone on a number we already hold; rejected documents kept in the quarantine case library).
**v2 (Sarah):** the quarantine case library has **its own retention line** in the schedule, **an access
log** (who opened what, when, why), and **originals are opened only in the isolated Lab**.

### P7 — Retention
- The **record never disappears** (number, date, type, sender, fingerprint, decisions).
- **v2: a retention schedule per document type, each line with its written legal reason.** **Sarah drafts and
  checks; Minda decides** (D2). No outside data-protection adviser for now; one can be added later.
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
3-2-1 + yearly offline disk in a safe; no cloud; only Minda administers; robots add-only.
**Emergency key (D10): held by Irina, interim.** A named exception to the gate rule, because it is break-glass,
not a data route:
- **1Password emergency access with a waiting period** — Minda can refuse during it, so it only opens if she
  cannot answer;
- **emergency use only; every opening recorded** and reported to Minda, Sarah copied;
- **holder reviewed at the yearly seal check** (P11).
Eugene never sees or records the key; he writes the sealing / checking / opening runbook.

### P10 — Who uses the library
- **Minda and Sarah** look inside, read-only, logged. **Sarah's access comes through a charter amendment and an
  Authority Register row** (D1: Minda approves, Alex records, amendment to Sarah via her Raw/); it takes effect
  only when the library exists. Sarah never adds, changes or hands out copies.
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
- **v2 — independence (D3):** Sarah reviews the **rules** before they go live; **Alex samples the outcomes
  quarterly** as the independent check. Sarah's monthly sample stays as her compliance check.

### P12 — Arrivals and registration details
- Lobby inbox per company; paper originals kept with location recorded; only **issued** documents; signed
  copy = same number, new version (Change Request — P15/next steps); portal downloads with source; site
  photos in batches, single evidence photos their own row. *(v1)*
- **v2 — Sensitivity is mandatory** at registration, **default set per document type** (Anna); **blank =
  fail** (Sarah).
- **v2 — year-end lock (D8):** Rachel registers the trial balance and general-ledger exports **at sign-off of
  the accounts and again on filing** (with the filed accounts and CT600). A nightly rule compares QuickBooks with
  the locked year; **any change to a closed year is a contradiction on the Finance page**, flagged to Rachel and
  Minda. The QuickBooks closing date is an extra, at Rachel's discretion.

### P13 — Key-facts pages per company
**Purpose: show and highlight contradictions so they are put right before they cause damage.**
- Built nightly from **Verified** data; every line sourced and dated; contradictions at the top; gaps listed.
- **General page — owner Laima** (content and checking; Eugene builds). A **9-section template** (Laima);
  Laima confirms **only what changed**; **stale dates flagged**; pages will be thin at first. **They replace
  Laima's hand-made AWT-1089 pages** at switch-over, only once they are at least as good; hers are
  archived, never deleted (D5).
- **Finance page — owner Rachel.** Bank details **last 4 digits only**. Rachel has already found three
  real contradictions to seed it. **Laima has read-only access** (D5).
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

### P15 — One catalogue, three keys (new, Victoria; refined D9)
- **The group Document Register is the catalogue.** Nothing else becomes a second catalogue.
- **Document number = the library's identity** (never changes). **Fingerprint = proof of content.**
  **Drive file ID = the join key** to the working copy: register rows and processed-items ledger rows already
  carry it, and the library, register, ledgers, master index (`Wiki/00_INDEX.md`) and Hub rows join on it, so
  nothing is re-entered. All three sit on the register row.
- **Why not the Drive ID alone:** it changes when a file is deleted and re-uploaded (archive-then-recreate),
  and stays the same when content is replaced (FM0000008). A changed ID is flagged nightly and the owner
  updates the row.
- **Pieces to join (Victoria's list + Eugene's Lab findings):** group Document Register · **the older
  "1. General" register (still live)** · per-KB processed-items ledgers · `00_INDEX` · Hub rows · Drive ·
  the Financial Archive · the property / project registers.
- **Clean-up before the pilot** (full register read, 13 Nov): 68 rows without a Drive file ID (folder links,
  free text, blank), 44 email-only rows, 3 duplicate document numbers, 1 status outside the policy list.
  Owners fix; Eugene changes nothing.

---

## Minda's decisions (14 Nov 2026)

| # | Decision | Minda |
|---|---|---|
| D1 | Sarah's library access | Charter amendment + Authority Register row; read-only, logged; from when the library exists |
| D2 | Retention | Per-type schedule with written legal reasons; +2 years for personal data only with a reason; Sarah drafts and checks, Minda decides; no outside adviser for now |
| D3 | Independence | Sarah reviews rules; Alex samples outcomes quarterly; Sarah's monthly sample kept |
| D4 | Construction | "Verified (record)"; Minda records for now; construction-team checker named before FC enters |
| D5 | Key-facts pages | General = Laima, Finance = Rachel, Laima read-only on Finance; replace AWT-1089 at switch-over |
| D6 | Anthill Homes | In (prefix AH); Irina's Drive is Anthill's desk, the library keeps copies |
| D7 | High-risk | Rachel's narrowed list; £5,000; review after 3 months |
| D8 | Year-end lock | At sign-off and on filing; changes to a closed year flagged |
| D9 | Victoria's conditions + keys | All three conditions; document number + fingerprint + Drive file ID |
| D10 | Emergency key | Irina, interim; 1Password emergency access with waiting period; reviewed yearly |
| D11 | Direction | **Approved** |

## Next steps
1. **Victoria** raises **one Change Request** to the group Document System (SRC-39), **after FG-CR-0003**
   (policy v1.6): signed copy = same number + new version; register fields status / checker / sensitivity /
   fingerprint / version; **prefix AH for Anthill Homes**; the three keys (P15).
2. **Sarah** drafts the retention schedule (P7) and her access amendment request (P10).
3. **Owners** clear the register clean-up list (P15): rows without a Drive file ID, email-only rows, duplicate
   numbers. Eugene changes nothing.
4. **Laima** sends the 9-section General page template; **Rachel** the Finance page contents and starter rules.
5. **Eugene** writes the emergency-key runbook and, on Minda's separate go, the **FM pilot** (28 documents).

## Where each change came from
| Reply | Changes in v2 |
|---|---|
| **Sarah** | P6 quarantine retention + log + Lab-only; P7 written reason per type; P10 access via charter + Authority Register; P11 5-document sample, starts after approval, independence; P12 Sensitivity blank = fail |
| **Laima** | P5 company vs property facts; P13 General page owner, 9-section template, changed-only confirmation, stale dates, contradictions to source owner; Finance page = Rachel; replaces AWT-1089; Anthill Homes question; Fishbone AI as master core |
| **Anna** | P1 1 working day + age; P3 "Verified (record)", supplier designs Authentic; P4 author revisions = new row; P5 human records Verified + second checker; P7 construction periods; P10 moves expected; P12 Sensitivity default per type |
| **Rachel** | P5 finance certification by fingerprint, high-risk narrowed + £5,000; P10 Financial Archive = finance desk; P12 year-end lock; P13 Finance page, last 4 digits; P14 finance starter rules; P7 finance/loan/TTP retention |
| **Victoria** | P10 SSAS exclusions, no restores to Collaboration Space, secondary cores via gate; P15 one catalogue, one key; Change Request sequencing; P7 adviser check |

**Not built. Nothing changes on any live system until Minda gives a separate go for the FM pilot.**
