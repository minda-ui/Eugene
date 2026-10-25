# RND-16 — Site Vision Sentinel (design sketch v1)

_R&D design (git-primary; creative mode, 2026-10-25). Status: **spark → exploring**. Guide-only (§3):
nothing built on a live system; images stay in-building; every output is a draft/alert for a human, never
an automated action. Law/retention/privacy questions are **flagged to Minda/Victoria, not decided here**._

## The idea in one line
A **local vision model** watches the site-photo stream and, the moment a picture lands, does three jobs:
**tags the progress**, **reads the paperwork in the shot** (delivery notes, sign-in sheets), and **flags
H&S hazards** to Minda's phone — all inside the building, nothing to the cloud.

## Why it's worth it
- **Safety:** a second pair of eyes on every photo — no hard hat, blocked fire exit, missing edge
  protection — surfaced in minutes, not at the next site visit. The estate had multi-week *silent* failures
  before (RND-6); this is the same "end the silence" instinct, pointed at the sites.
- **Evidence & admin:** every photo becomes searchable, tagged project history (feeds the project brain,
  RND-7), delivery notes flow toward QuickBooks (Rachel), sign-ins become a record — the paper that
  usually dies in a chat.
- **Private by construction:** site images (which contain people) **never leave the building** — the whole
  reason to run it on our own P40s rather than a cloud vision API.

## Where it sits in the estate
```
 Telegram project groups ──▶  Ingest (Telethon/bot in a capped LXC)
   (site photos, notes)            │  new media → NAS/Nextcloud (RND-3), queued
                                   ▼
                     Local VLM on the P40s (Qwen3-VL, via the RND-14 gateway)
                       ├─ Progress tag   → project record (RND-7) + Nextcloud metadata
                       ├─ Doc read (OCR) → delivery note / sign-in → structured draft
                       │                     • delivery notes → Rachel / QuickBooks draft
                       │                     • sign-ins       → project H&S record
                       └─ Hazard scan    → if flagged: Telegram ping to Minda (RND-6 path)
                                            + an Action item (RND-9 Approvals) if action is needed
```
It's the **active vision layer**; RND-7 is the **record**, RND-14 is the **engine**, RND-6/9 are the
**alert + sign-off rails**. The sentinel is the thing that *looks*.

## The three jobs, concretely

### 1. Progress tagging
Per photo, the VLM returns a small structured record: `{job_no, room/area, trade/stage, % impression,
one-line caption, people_present (count only), has_document}`. Stored as sidecar metadata so the project
brain can answer "show me the second-fix joinery on FC2611" or "when did the hoarding go up?".

### 2. Document reading (the paper in the shot)
When `has_document`, the VLM extracts structured fields:
- **Delivery note** → supplier, date, order ref, line items, quantities → a **draft** for Rachel /
  QuickBooks (never auto-posted; Dext stays the system, auto-publish OFF — ties AWT-0805).
- **Sign-in / induction sheet** → names, company, date, times → the project H&S record (ties the
  induction/competence gap, AWT-0542).

### 3. H&S hazard scan (the showstopper — and the one to treat carefully)
The VLM runs each photo against a **hazard checklist prompt**. Starter list (UK construction, advisory):
- PPE missing — no hard hat / hi-vis / eye protection where expected
- Open edge / void with no edge protection or guardrail
- Blocked or obstructed fire exit / escape route
- Scaffold without a current tag, or obvious incomplete guard-rail/boards
- Housekeeping / trip hazards, trailing leads, blocked walkways
- Ladder / access misuse; working at height without protection
- Exposed live services; unsafe COSHH/flammable storage
- Missing mandatory signage

**Output = a flag with the photo, the hazard class, a confidence, and one line of why.** Minda (or the
site lead) looks and decides. **It never enforces, never messages the site, never closes anything.**

## ⚠️ Honesty box — what this is NOT
- **Not a certified safety system.** A VLM will miss things (false negatives) and cry wolf (false
  positives). It is an **advisory prompt to look**, never a compliance tick or a substitute for the
  competent person / real site inspection. Trusting it blindly would be *worse* than not having it.
- **Tune for high precision on alerts, accept lower recall.** Better a few reliable flags than a stream of
  noise people learn to ignore. Every flag gets a human verdict; those verdicts feed prompt/threshold
  tuning (a simple review log, not model training to start).
- **People in photos = personal data.** Site shots show operatives; faces are personal data, and hazard
  flags about "someone with no hard hat" touch individuals. This is workplace monitoring — there's a
  **lawful-basis, notice-to-staff, access-control and retention** question. **Eugene flags this to Minda +
  Victoria; it is not Eugene's to decide** (same posture as the ISO/CDM work). Keep images in-building,
  access-controlled, with a retention policy agreed before go-live.
- **Photos are a biased sample** — the model only sees what someone chose to photograph. It supplements
  site management, never replaces it.

## What it needs
- **The P40s** for real-time/near-real-time vision (the GPU tier, RND-2). **CPU can do an overnight batch**
  of the day's photos slowly — so a proof and the nightly digest (RND-15) can start before the cards, but
  the "flag within minutes" promise is a post-P40 feature.
- **The ingest path** from Telegram (Telethon user-client or a bot added to the project groups) into the
  in-building store (RND-3). Composio has Telegram tools as an alternative.
- **The gateway (RND-14)** so the sentinel just calls one local endpoint for vision.
- **A hazard-prompt + review loop** — the real engineering is the prompt and the human-feedback tuning,
  not the plumbing.

## Phased build (each stage proves value before the next; all guide-only)
- **P0 — Proof (can start now, CPU):** feed a batch of **existing** FC2611/site photos through a small
  Qwen3-VL on CPU; measure hazard-flag precision/recall against Minda's eye on a labelled sample. Decide if
  it's good enough to pursue. *No ingest, no live wiring — just "is the eye good?"*
- **P1 — Ingest:** stand up the Telegram→in-building-store pipeline in a capped LXC (new media captured +
  queued). Still no alerts out.
- **P2 — Nightly batch:** overnight, tag + read-docs + hazard-scan the day's photos → a **morning digest**
  (ties RND-15). Human reviews; feedback tunes the prompt.
- **P3 — Near-real-time hazard ping:** once precision is trusted, flags go to Minda's phone within minutes
  (RND-6 path). Progress tags + docs keep flowing to the record.
- **P4 — Wire the outputs:** delivery-note drafts → Rachel/QuickBooks; sign-ins → H&S record; hazards that
  need action → RND-9 Approvals. All drafts/sign-off; nothing auto-sent.

## Success test (so we know if it's real)
On a labelled sample of, say, 200 real site photos: **hazard-alert precision ≥ ~80%** (few false alarms) at
a recall we're honest about, plus Minda's gut check that the flags are the ones she'd want. Delivery-note
field extraction accurate enough that Rachel edits rather than retypes. If P0 can't clear a sense-check,
we park it — better to know early.

## Open questions for Minda (not Eugene's to decide)
- The **staff-privacy / lawful-basis / retention** policy for AI-scanned site photos (with Victoria).
- Which **Telegram groups** are in scope, and whether a bot-in-group or a user-client is acceptable.
- Whether hazard flags go **only to Minda** first, or to a site lead too, once trusted.

## Graduation
Candidate once **P0 proves the eye is good** and the **privacy policy is agreed**. Then it becomes a real
build (its own runbook + Hub task), and the cross-KB bits (Rachel/QuickBooks, Anna/project record, the
Amfa/Nadia parallel) go through each employee's `Raw/` with Minda's approval. Until then: spark/exploring,
nothing live.

---
_Guide-only; images stay in-building; advisory not enforcing; drafts for sign-off; law/retention to a
human. Pairs with RND-2 (brain), RND-14 (gateway), RND-7 (record), RND-6 (alerts), RND-9 (approvals),
RND-15 (night shift)._
