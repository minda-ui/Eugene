---
name: saas-replacement-scope
description: Scope replacing a paid SaaS app with a self-hosted or local-AI version BEFORE anything is built, bought or cancelled — work out what the app really does for us, decide per feature whether to rebuild, reuse open source, keep paying or not copy, size the local-AI layer honestly, name the risks, design a shadow-run test on real data and hand Minda a decision note with the cost both ways. Use whenever Minda asks "can we replace Dext/EZOffice with our own?", "build our own X instead of paying", "a local AI version of an app", "do we still need this subscription?", or lab mode lands on a paid tool. Boundaries (charter §3): guide/advise only; never cancel, migrate or switch anything live (Minda decides); never write to a system of record (QuickBooks etc.) or another KB except its Raw/; never hold secrets. Pairs with integration-scope-with-owner and raw-handoff-to-employee. Built 2026-11-11 from RND-33 (Dext / Ledger Desk) and RND-34 (barcode scanning / EZOffice / Asset Desk).
---

# Scope a paid-SaaS replacement (self-hosted / local AI)

Minda in lab mode: "we pay for Dext — could we run our own?" The answer is almost never "rebuild it all"
or "no". It's a **per-feature split**, an **honest view of what our local models can and can't do**, and a
**shadow run on real data** before anyone touches the live app. RND-33 (Dext) and RND-34 (EZOffice) are the
two precedents — one high-stakes finance, one low-stakes asset register; the method is the same.

Related, don't duplicate: **`integration-scope-with-owner`** is for *connecting* to an outside system
read-only. This skill is for *replacing* a paid one. If the answer turns out to be "keep the app, just read
from it", switch to that skill.

**§3, every time (write it into the note):**
- Eugene scopes, designs, writes container/install steps and test scripts. **Minda decides** and runs every
  live step; **nothing paid is cancelled, migrated or switched off** by Eugene, ever.
- **Never write to a system of record.** Any replacement that posts to QuickBooks etc. does it as a
  **draft, on a human's click** — and Eugene never does it himself.
- Minda holds every admin login / API key; reference where it lives, never its value.
- Domain-owner contact goes via their **`Raw/` + a Hub row** (`raw-handoff-to-employee`).
- Finance documents live in the **Financial Archive** (Policy §7b), never in git — test data too.

## 1. What does the app actually do *for us*? Ask the owner first
Don't scope from the vendor's feature page. Find the domain owner — finance/Dext = **Rachel**,
workshop/production scanning = **Darius**, Amfa = Nadia/Darius, site kit = Anna, ops = Alex — and send a
`raw-handoff-to-employee` note with these questions (adapt):
1. What it does **well** today (must-match) and **badly / not at all** (our chance to do better).
2. **Which features we actually use** (often far fewer than we pay for).
3. **Volume** (docs/month, assets, users, scans) and how much is **fixed by hand** after the app.
4. **Cost** — the monthly/annual figure, or where Minda can find it.
5. **Must-haves to trust a replacement** (accuracy, audit trail, speed of the phone flow).
6. **Quiet periods** — when nothing must change (year-end, VAT quarter, busy season).
Also ask Minda the basics: is anything actually in it? (EZOffice turned out **empty** → no migration, start
clean — that changed the whole plan.) Write down what's known vs still a question.

## 2. Per feature: rebuild / reuse open source / keep paying / don't copy
Table every feature the owner named, one verdict each:
| Verdict | When | Precedent |
|---|---|---|
| **Rebuild** (small, ours) | Core is simple + we gain fit/privacy | Dext intake, supplier rules, duplicate check, review page |
| **Reuse open source** | A mature self-hosted tool covers it | EZOffice → **Snipe-IT** (one-by-one assets) + **InvenTree** (counted stock on makers' EAN barcodes); Shelf.nu if bookings matter |
| **Keep paying / keep the app for this part** | Fragile, per-vendor, or what the fee buys | Dext supplier-portal fetch; support, uptime, accountant access |
| **Don't copy** | Another estate tool already does it | Bank matching (QuickBooks has it); Dext Precision |
Then name what **we could do that the app can't** (construction fit: CIS, retentions, plot coding,
delivery-note ↔ invoice matching; chat-driven check-outs) — that's often the real case for it.

## 3. The AI layer — size it honestly
Local models on **pve-ai** (Gen10, P40s): **gpt-oss-120b** (generalist / reasoning), **gpt-oss-20b**
(fast receptionist / agent), **Qwen3-VL "Eyes"** for documents and photos. Facts from the tests
(`R&D/local-models/gpt-oss-test-plan.md`, Eyes test 2026-11-09):
- Printed text read very well (descriptions, model/serial exact, ~60 t/s), and it said "unclear" rather
  than inventing prices.
- But a delivery note scored **≈93% line accuracy** with **one quantity error that mattered** (copied
  from the line above), a split description line, and **O/0, I/1, S/5** confusion in reference numbers.
- On a **site photo it invented details** (hi-vis on the wrong person, "cords" that were hoses).
So the design is always: **model drafts → code validates** (OCR cross-check, line count, qty × unit =
totals, references fuzzy-matched against the supplier/PO list, never trusted as read) → **human confirms**.
Never auto-post; say so in the note.

## 4. Risks — write each one down
- **Data protection:** what personal/financial data moves where; local is a plus, but backups (PBS),
  access (Tailscale-only) and retention (7-year HMRC for finance) become ours. Biometrics/monitoring →
  DPIA, Victoria + Minda's call (e.g. the parked RFID door's face-recognition option).
- **Accounting / HMRC accuracy:** a wrong VAT figure is an HMRC problem — human approval on every bill.
- **Support:** no vendor helpdesk; month-end outages are ours to fix.
- **Lock-in both ways:** can we export from the SaaS (CSV/API)? Is the open-source tool's data portable?
- **Maintenance burden:** updates, supplier-format changes, API changes, model upgrades — an honest
  hours/month estimate. Plus **staff habit**: if the phone flow is slower, people stop using it.

## 5. Smallest honest test — a shadow run on real data
No big build. The paid app stays live throughout.
1. **Offline benchmark:** a real sample the app has already processed (Dext: 50 invoices) through our
   pipeline; score **field by field** against the app / what was published.
2. **Shadow run:** ours runs alongside on live intake for **2–3 months** (low-stakes tools: ~1 month),
   avoiding the owner's quiet periods. Measure accuracy, hand-fix rate, time per item, breakages.
3. **Gate:** switch only when ours matches for the whole run. If not → stay with the app and use the local
   models for what it can't do. Both are good outcomes.

## 6. Decision note for Minda
Write `R&D/<slug>/design.md` (spark → exploring) and add/update the `R&D/ideas-log.md` row, with:
- Owner's answers (step 1), the per-feature table (2), the AI-layer plan + its limits (3), risks (4).
- **Cost both ways:** subscription per year vs our build hours + monthly maintenance + hardware share
  (pve-ai is already bought — say so, but count the time). Unknown figures marked "Minda to confirm".
- The test plan (5) and the **one decision she's being asked** (e.g. "approve the 50-invoice benchmark").
- An explicit line: **"No cancellation, migration or live switch — Minda's decision, after the shadow run."**
Graduation to a real build goes through `R&D/graduation-register.md` on Minda's approval. Then the usual
change-log + ledger entry.

## Worked precedents
- **RND-33 Ledger Desk (Dext, Rachel):** `R&D/ledger-desk/design.md`;
  `Raw-outbound/Eugene-to-Rachel-Ledger-Desk-own-Dext-questions-2026-11-04.md`. High stakes → draft bills only.
- **RND-34 Asset Desk (EZOffice, Darius for production):** `R&D/asset-desk/design.md`, `requirements.md`,
  `scanner-options.md`; `Raw-outbound/Eugene-to-Darius-barcode-scanners-production-2026-11-04.md`.
  EZOffice empty → start clean on Snipe-IT + InvenTree, IT kit first.

---
_Guide-only (§3): Eugene scopes, designs and tests; the owner says what's needed; Minda decides, runs
every live step and holds all logins. Nothing paid is cancelled or switched until a shadow run proves it._
