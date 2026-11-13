# Estate Library — Principles v1

**LAB item — not evidence, not a Hub result. For team feedback; Minda decides.**
Debated and decided one by one by Minda with Eugene, 13 November 2026 (RND-36). Decision log:
git `R&D/lab/rnd-36/Library-Principles-v1-decisions.md`.

---

## One page

**The library is the Fishbone Group's safe for every registered document. Google Drive is the desk.**
It lives on our own servers, nothing in it is ever changed or thrown away, every document is checked
before it is trusted, and contradictions are shown so they are fixed before they cause damage.
This is the core foundation for accurate work by people and AI employees.

| # | Principle | In one line |
|---|---|---|
| P1 | What goes in | Every **registered** document (it has a document number). Unregistered material stays on Drive, covered by the Drive backup. |
| P2 | The lobby | Inside the safe. A document is **locked from the moment it is registered**. For email, the **whole email** is kept, not only the attachment. |
| P3 | Two levels | **Authentic** = genuine and unchanged (evidence). **Verified** = facts cross-checked (source of truth). Only Verified feeds the AI. |
| P4 | Versions | Every change makes a **new version with a change note** (what, why, who, when, on what authority). Old versions stay. |
| P5 | Four eyes | Whoever registers never certifies. Rules first; Verified needs a second, subject-owner seat; high-risk needs Minda. |
| P6 | Failures | A failed document is **Disputed**, resolved by its owner in 7 days. **Nothing is thrown away** — rejected documents form a quarantine case library for better rules and fraud evidence. |
| P7 | Deletion | Retention = **legal minimum + 2 years**. The record always stays; afterwards only the personal part is removed, recorded. Legal hold stops all removal. |
| P8 | Three forms | **Original** (evidence) · **readable copy** (reading, AI) · **data record** (analysis). If they disagree, the original wins. |
| P9 | Copies & keys | **3-2-1** + a yearly **offline disk** in a safe; no cloud. **Only Minda** administers, plus a **sealed emergency key**. Robots can add, never change or delete. |
| P10 | Who uses it | **Only Minda and Sarah** look inside. Everyone else works on Drive as today. One robot door out: Verified copies to Fishbone AI, and restores. Nightly Drive ↔ library check. |
| P11 | Self-checks | Nightly (problems only) · monthly one-page report to Minda + **Sarah's independent sample** · yearly offline disk and full restore drill. |
| P12 | Non-email documents | A **lobby inbox per company**; paper originals kept with their location recorded; only **issued** documents (sent/signed); **signed copy = same number, new version**; portal downloads recorded with source; site photos in batches. |
| P13 | Key-facts pages | Per company, **General** and **Finance** pages, rebuilt nightly from Verified data. **Contradictions highlighted at the top**, never resolved by the robot; gaps listed; every line sourced. |
| P14 | Checking rules | **Fixed rules decide**; AI only extracts and raises suspicions; if they cannot decide, **Minda decides**. Six rule families; "not checked" never passes; rules written, tested, reviewed and versioned; monthly rule report. |

---

## The flow

```
 Email / scan / portal / issued doc
            │  registered (document number) by Peter or the owner seat
            ▼
 ┌──────────── LIBRARY (pve-ai, locked) ─────────────────────────────┐
 │  LOBBY ── rules (+AI suspicions) ──► AUTHENTIC ── owner seat ──► VERIFIED │
 │    │                                     │   (or Minda, if undecided)     │
 │    └── fails ─► DISPUTED ─► owner 7 days ─► resolved / quarantine case lib │
 │  every change = new version + note · 3 copies + offline disk              │
 └───────────────────────────────────────────────────────────────────────────┘
            │ robot door out (only)
            ├─► Fishbone AI: Verified readable copies + key-facts pages
            ├─► restores to Drive on request
            └─► nightly check: Drive copy = library?  (changed / missing / disputed flagged)
 Drive (the desk): everyone works here as today.
```

---

## The principles in full

### P1 — What goes in
Only **registered** documents (a number in the group Document Register; policy v1.5 defines what is
registered). Everything else stays on Drive and is protected by the separate nightly Drive backup. The
library is the **archive**; the Drive copy is the **backup**.

### P2 — The lobby
The lobby is **inside the safe**. A document enters when it is registered and is **locked from that
moment** — nobody, including the registrar, can change it. Email arrivals keep the **whole email**
(sender, date, recipients, body) plus attachments. Model: email → Peter saves email + attachment →
lobby + register → safe → checks → certified.

### P3 — Two levels of certification
- **Authentic:** genuine (from whom it claims) and unchanged since arrival → usable as **evidence**.
- **Verified:** its facts cross-checked with other trusted sources → the **source of truth**; the only
  level the AI and key-facts pages read.
- **Authentic but disputed:** genuine but wrong (e.g. an invoice with a wrong amount) — kept as evidence,
  never used as truth. Drafts can be Authentic, not Verified.

### P4 — Versions and change notes
Every change creates a **new version**; earlier versions are kept unchanged. Every version carries a
**change note**: what changed, why, who, when, on what source or authority. A new version goes through
the checks itself. Status changes are recorded the same way.

### P5 — Who certifies: four eyes
1. The registrar never certifies their own document.
2. Rules run first and attach a check report.
3. **Authentic** is automatic only if **every** rule passes; otherwise a person decides.
4. **Verified** always needs a **second seat that owns the subject** (finance → Rachel, construction →
   Anna, property/company facts → John/Laima, …).
5. **High-risk** (money, legal, SSAS, any change of bank or payment details) needs **two people, one of
   them Minda**. Owner map = the master index + seat charters.

### P6 — When a check fails; nothing is thrown away
- Failed → **Disputed**, stays locked; owner resolves as *rule wrong* · *genuine but wrong* · *not genuine
  (rejected / suspected fraud, Minda told at once)*.
- Weekly disputed list to each owner, **7-day deadline**, then onto Minda's list.
- **Bank/payment detail changes** are always Disputed until confirmed by phone on a number we already hold.
- **Rejected documents are kept** in a **quarantine case library** with their rule report and decision —
  to improve rules, spot fraud patterns and keep evidence. Never opened on normal computers, never handed
  out, never read by the everyday AI; analysed only in the isolated Lab with Minda's approval; Minda and
  Sarah only.

### P7 — Deletion only by law
- The **record never disappears** (number, date, type, sender, fingerprint, decisions).
- **Retention = legal minimum + 2 years** (e.g. accounts/tax 6 → 8 years; tenancy files 8 years after the
  tenancy ends; deeds and company constitution permanent).
- At the end of retention, **personal details are removed** as a recorded new version — Minda decides,
  Sarah checks.
- **Legal hold** (dispute, claim, HMRC enquiry, fraud case) stops all removal.
- Full deletion only where a law requires it, with Minda's written decision + Sarah's check, recorded.
- A **retention schedule** per document type: Sarah drafts, Minda approves.

### P8 — Three linked forms
**Original** (evidence, never changes) · **readable copy** (PDF/A + text, OCR for scans; "derived, not
evidence") · **data record** (dates, amounts, parties, numbers, references — for analysis and the
rules). All tied to the document number and fingerprint; **the original wins** if they disagree. Data
records carry their status; analysis uses Verified data by default; personal details are replaced by
codes in analysis copies. Bigger data helps **only if it is right** — quality before volume.

### P9 — Copies and keys
- **3 copies** (pve-ai HQ master · pve-bev Beverley · R710 HQ), **2 storage kinds** (live ZFS + backup
  server), **1 off-site** (Beverley), **+ one offline disk per year** in a safe. No cloud.
- **Only Minda** administers (secret only in her 1Password) + a **sealed emergency key** with a trusted
  holder (to be named); opening it is recorded.
- Robot jobs can **add** and **hand out copies** only — never change or delete. Not even Eugene can alter
  the library.

### P10 — Who uses the library
- **Minda and Sarah only**, read-only, logged.
- **Everyone else works on Drive** as today; no library access for staff or AI seats.
- One robot door out: **Verified** copies + key-facts pages to **Fishbone AI**; **restores** on request.
- **Nightly Drive ↔ library check:** match ✔ · Drive copy changed / missing / disputed → flagged to owner.

### P11 — Self-checks
- **Nightly:** arrivals, Drive check, 3 copies — problems only.
- **Monthly:** all fingerprints on 3 copies · register ↔ library · disputed ageing · restore test from
  Beverley → one green/amber/red page to Minda; **Sarah independently samples** documents end to end.
- **Yearly:** offline disk to the safe · full restore drill of one company · emergency-key seal check.

### P12 — Documents that don't arrive by email
- **Lobby inbox per company** (Drive folder): anyone drops, the **owner seat registers**, the nightly job
  locks it in; daily "waiting" list to the owner.
- **Paper originals:** scanned and kept; data record holds "paper original held at …".
- **Our own documents:** enter when **issued** (sent or signed); drafts stay on Drive.
- **Signed copy = same number, new version** (needs a Change Request to policy v1.5).
- **Portal downloads:** "downloaded from [portal], by [seat], on [date]" + public reference.
- **Site photos:** registered in meaningful batches; single evidence photos get their own row.

### P13 — Key-facts pages per company
**Purpose: show and highlight contradictions so they are put right before they cause damage.**
- Built nightly from **Verified** data; changes confirmed by **Laima** (page owner) and section owners.
- **Two pages:** General (staff AI) and Finance (Rachel + Minda only). Public facts only for people.
- Every line sourced and dated; **contradictions at the top**, sent to the owner the same night, never
  resolved by the robot; **gaps listed** — the AI says "I don't know" for anything not on the page.

### P14 — The cross-checking rules
- **R1:** fixed rules decide; AI only extracts and raises suspicions; if rules and AI **cannot decide →
  Minda decides**, with rule report, AI note and owner's view attached; recorded.
- **R2:** six families — integrity · source · inside the document · against our records · against
  official sources (Companies House, HMRC, Land Registry) · fraud warning signs.
- **R3:** "not checked" never passes.
- **R4:** owner says what must be true · Eugene writes and tests on the case library · Sarah reviews ·
  Minda approves high-risk rules · rules versioned.
- **R5:** learning loop + monthly rule report.

---

## Open points (feedback requested)
| For | Question |
|---|---|
| **Victoria** | Does this fit the operating-system framework and master core? One **Change Request** to the group KB for: signed copy = same number + version (P12, conflicts with policy v1.5); new register fields (status Authentic/Verified/Disputed, checker, sensitivity, fingerprint, version). |
| **Laima** | Owning the key-facts pages (P13) and the company-facts sections; what each page must hold. |
| **Rachel** | Finance: is the library copy the Financial Archive's **backup**, or a second home (policy §7b)? Certifying finance documents (P5); the finance key-facts page. |
| **Sarah** | Retention schedule and the **+2 years for personal data** (P7); the quarantine case library (P6); your monthly independent sample (P11); library access for you and Minda only (P10). |
| **Anna** | Registering at issue and photo batches (P12); certifying construction documents (P5); the lobby inbox. |
| **Minda** | Holder of the sealed emergency key (P9). |

**Not built. Nothing changes on any live system until Minda approves after feedback.**
