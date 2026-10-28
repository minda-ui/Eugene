# Construction project vision — the AI-augmented project, end to end (RND-22)

> **Eugene, 2026-10-28 (guide-only, §3).** The vision for how a construction project runs with the estate's
> AI + on-site brain behind it — and the **software** and **hardware** lists that fall out of it. **It's
> Anna's domain (construction):** this designs the *system/IT* side; the construction-process specifics are
> hers to confirm (scope via her Raw, like the Telegram pilot). **Humans run the site and decide; the AI
> captures, understands, drafts and records; nothing acts without a person (§3).** Builds on RND-7 (project
> record), RND-16 (vision), RND-21 (site chat), RND-2/3 (brain/storage).

## The vision (what we're aiming for)
**Every signal from a job — photos, voice notes, site messages, delivery notes, documents — is captured,
understood by the AI, and turned into records, flags and draft actions, so the project's file builds itself,
problems (H&S, progress slip, cost, missing materials) are caught early, and the site team + PM spend time
building, not on admin.** The human always decides; the record is always complete and searchable.

The core loop, repeated all day, per job:
**CAPTURE** (photo/voice/message/doc) → **UNDERSTAND** (vision, transcribe, summarise, extract) →
**DRAFT/FLAG** (a record entry, an H&S flag, a materials request, a progress update) → **HUMAN DECIDES** →
**RECORD** (the per-project file + the registers build automatically).

## The project lifecycle — where the AI helps at each stage
| Stage | What happens | AI help (drafts for a human) |
|---|---|---|
| **Win / start** | set up the job: register row, folders, programme | scaffold the project record + folders; pull the template |
| **Mobilise** | RAMS, inductions, site setup | RAMS issued + signed (DocuSeal); induction/competence tracked |
| **Delivery** (the bulk) | daily site work + updates | **site-chat + voice + photos → vision (progress/H&S/delivery notes) → summaries → requests → the record** |
| **Control** | progress vs programme, risks, variations, cost | progress-vs-programme flags; risk/variation/comms logs; materials → procurement + cost flags |
| **Handover** | as-builts, O&M, sign-off, lessons | assemble the handover pack; capture lessons learnt |

## The capture layer (how signals get in)
- **Phone photos + voice notes** via the site chat (Telegram now; WhatsApp later) — the main stream, £0 kit.
- **Fixed site cameras** — progress + time-lapse + security on active sites (where worth it).
- **Documents** — drawings, delivery notes, RAMS (Drive/NAS).
- **The brain** reads it all locally (vision/Whisper/RAG) — sovereign, nothing leaves the estate.

---

## The daily rhythm (the heartbeat)
The vision isn't a filing cabinet — it runs on a **cadence**: scheduled "brains" + continuous event-driven
processing, every output a **draft/alert for a human**.

**Continuous (all day) — capture + triage.** Photos/voice/messages arrive → vision tags · Whisper transcribes
· requests extracted → the live per-job record updates. **Anything urgent surfaces immediately** — an H&S
hazard on a photo, an urgent request — pushed to Anna/the PM *now*, not at end of day.

**Morning brief** (before site starts) — Anna drafts, for the PM + Minda:
- **Per job:** where it is vs programme · what's scheduled today · materials/deliveries due · open H&S flags ·
  who's on site · (weather if it matters).
- **At risk today:** material not arrived, a slip, an open risk.
- **Needs you today:** the decisions/approvals the PM or Minda must make.
- **Portfolio line:** every job at a glance, **worst-first**.

**End-of-day digest** (after site) — per job: "what happened on \<job\> today" (progress · decisions ·
requests raised · H&S flags · photos) → **registers updated** (materials/operatives/risks/progress %) →
**tomorrow look-ahead** (scheduled · needed · at risk).

**Weekly review** (Mon/Fri) — per job + portfolio: progress vs programme + trend · **cost position** (Rachel)
· materials forecast · risks/variations · **lessons captured** · next-week Last-Planner look-ahead.

**Event-driven (off the clock):** urgent H&S → immediate alert · delivery note read → materials log · request
→ procurement flag. The rhythm **surfaces**; the human **decides**.

## The intelligence layer (insight, not just records)
The record is the input; the intelligence is the payoff — the system doesn't just store **what happened**, it
tells you **what it means and what's coming**.
- **Progress** — site reality vs programme → "on track / N days behind / ahead", trend, **forecast completion
  date**; flag slip early.
- **Materials / procurement** — requests + usage + lead times → "boards run out Thu, order by Tue"; predict
  shortfalls before they bite.
- **Cost** (with Rachel) — actual vs budget trend, variation impact, **early overrun warning**.
- **H&S** — recurring hazard patterns, near-miss trends, which crews/sites flag more → proactive safety focus.
- **Risk** — patterns that bit before, likelihood from history.
- **Quality / defects** — vision spots snags early → the snag list builds; recurring defects flagged.
- **Cross-project learning (the compounding bit)** — every job's lessons feed a knowledge base → *"last time
  we did a job like this, X went wrong"* surfaced at the right stage of the next one. **The estate gets
  smarter every project.**

**Headline output = predictive flags:** *"this job will finish ~2 weeks late at current rate"*, *"trending over
budget"*, *"material shortfall predicted"* — early enough to act.

**Design principles (non-negotiable):**
- **Grounded** — every flag/prediction **cites its evidence** (which photos/updates/numbers), never a black box.
- **Human-gated** — flags are alerts/drafts; the AI **never acts** on a prediction (§3).
- **Learns from outcomes** — right/wrong predictions feed back and sharpen over time.
- **Local/sovereign** — runs on the estate brain over estate data; nothing leaves.

**How they connect:** the intelligence runs on the **record** (registers + RAG + history) + the brain's
models, and **feeds the daily rhythm** — the morning brief surfaces today's predictions; the weekly review
shows the trends. Rhythm without intelligence is a diary; intelligence without rhythm is a report nobody reads.
Together they're the project brain.

---

## Running projects for other site managers (not just Minda) — the skeleton
The design above quietly assumed **Minda = the site manager** (she gets the brief, she approves). Fishbone has
several SMs — **Minda, Sebastian, Nev, Dainius, Andrejus** — and the system must work the same when any of them
runs a job, with Minda keeping **portfolio oversight**. The good news: this is **not new machinery** — it's the
estate's existing governance patterns (one-lead-per-job, the gate / per-person own-authority lists, the
Approvals Desk RND-9) applied **per site manager**.

**1. One responsible SM per project.** Every job names its **human site manager** on the Project Register (the
"one lead per job" rule, for the human). Everything for that job routes to that SM.

**2. The rhythm follows ownership.** Each SM gets **their** jobs' morning brief, end-of-day digest and urgent
alerts — their projects only. **Minda gets the portfolio** (every job, worst-first) **plus her own jobs**. So
Sebastian gets Sebastian's briefs; Minda sees all.

**3. Authority & escalation (the key bit).** Each SM has an **own-authority scope** — what they decide/approve
themselves (routine site calls, spend ≤ their limit, standard materials/variations) vs what **escalates to
Minda** (spend over the limit, a new commitment/payee, legal, cross-business, safety-critical, or "not sure").
The AI proposes → **routed to the SM if in-authority, to Minda if above** — one logged escalation path. This
**reuses the gate sanity check + per-person own-authority lists** already built (Project-A) + the Approvals
Desk (RND-9); nothing new to invent, just set per SM.

**4. The SM interface — meet them where they are.** The SMs are **site people, not Claude Code users.** They
work through the **site chat** (Telegram/WhatsApp): capture photos/voice there, receive the brief/digest/alerts
there, and **approve by replying** (or a one-tap yes/no). No new tool to learn. An optional dashboard / Open
WebUI for anyone who wants it. **Anna** is the AI behind it for every SM equally.

**5. Portfolio oversight (Minda).** Minda's view = **all jobs at a glance, worst-first**, with the
**exceptions that bubble up** — escalations, red flags, slips, overruns across every SM's jobs. She steps in
where **authority or risk** needs her, not for routine running.

**6. Access & privacy.** Each SM sees **their** jobs' data; Minda sees all; cross-job access is controlled
(ties to the storage access model).

**What to set / confirm:** each SM's **authority limits** (the own-authority list per person — **Minda's
call**, starter in `construction-sm-authority-matrix.md`); each SM's **channel** (WhatsApp / Telegram / email,
+ dashboard or not — ask the SMs); the **project → SM mapping** (the Project Register). Construction specifics
stay **Anna's**; this routing/authority layer is **Minda's org decision**.

---

## Per-person views (one source, many cuts)
Everyone works off the **same record + intelligence** — the views are just **role-shaped cuts** of it, on the
channel that suits each person. Each sees what they need to **act**, nothing more (access follows job-ownership
+ authority).

**The site manager's view** (Sebastian / Nev / Dainius / Andrejus / Minda-as-SM) — **their jobs only**
- **Today (the default):** their active jobs, each with status vs programme · what's on today · deliveries due
  · open H&S flags · **"needs you today"** (their in-authority decisions) · anything urgent.
- **Drill into a job:** the live record — recent photos/updates · progress % · materials (ordered/needed/due) ·
  who's on site · open risks/snags · requests · the look-ahead.
- **Do:** approve/decline (in authority) · raise a request · flag something · add a note/photo.
- **Channel:** the **site chat first** (brief/digest/alerts pushed there, reply to act — mobile, where they
  already are) + an **optional simple dashboard** for anyone who wants the fuller view.

**Minda's portfolio view** — **all jobs**
- **At a glance, worst-first:** a line per job — SM owner · RAG status · progress % · cost position · open
  escalations · red flags.
- **The "needs Minda" queue:** escalations awaiting her across *all* SMs' jobs — over-limit spend, new
  commitments, completion-date changes, safety events.
- **Drill into any job** (she sees all) + **portfolio trends** (which jobs trending late/over; materials/
  resource across jobs).
- **Channel:** a proper **dashboard** + her morning brief (portfolio summary) + escalation alerts.

**The client view** (optional, per project) — **outward, human-gated**
- A curated, plain-English **progress update**: progress photos/time-lapse · milestones hit · status — **not**
  internal data (no costs, no internal flags). Drafted by Anna, **approved by the SM/Minda before it's sent**
  (§3 + photo consent). The polished/marketing version pairs with Helen.

**Other role slices** (same source): **Rachel (finance)** — cost position per job, variations, overrun flags
(ties to QuickBooks); **Anna (the AI)** — the working queue across all jobs + drafts awaiting approval.

**Principles:** one source → many cuts (not separate systems) · role-shaped + access-controlled (you see your
jobs; Minda sees all) · exception-led (worst-first, surfaced not hunted) · channel-appropriate (chat for site,
dashboard for Minda, curated update for clients) · **outward views human-gated**.

---

## SOFTWARE to build (construction-specific, priority-marked)
_Extends the AI-machine build list with the construction angle._
| Pri | Build | What it does | Depends on |
|---|---|---|---|
| 🔴 **P1** | **Site-chat + voice + photo ingest** (one job) | messages/voice/photos → the brain → Anna's feed | RND-21 bridge, Whisper, storage |
| 🔴 **P1** | **Site-vision sentinel** (construction-tuned) | progress tags · **H&S checklist** (PPE/height/access/exits) · read **delivery notes** · spot obvious defects | P1 vision model |
| 🟠 **P2** | **Daily job digest** (end-of-day) | "what happened on \<job\> today" + open requests + flags, drafted for the PM | summariser |
| 🟠 **P2** | **Morning brief + portfolio line** | per-job state / at-risk / needs-you, worst-first across all jobs, before site starts | the record, summariser |
| 🟠 **P2** | **Request / materials extractor** | spoken/typed "need 20 boards Thu" → a structured request → procurement + cost flag | extractor, Rachel (cost) |
| 🟠 **P2** | **Per-project record writer** (RND-7) | folds the day's photos/updates/requests/flags into the job's file + registers | the above, storage |
| 🟡 **P3** | **Progress vs programme** | compare site reality to the Last-Planner programme → slip/ahead flags | the record, the programme |
| 🟡 **P3** | **Predictive flags / forecasting** | forecast completion date, material shortfalls, overrun warnings — **grounded (cites evidence), human-gated** | the record, progress + cost + materials data |
| 🟡 **P3** | **Cross-project lessons KB** | every job's lessons feed a store → surfaced at the right stage of the next job (compounding) | the record, RAG |
| 🟡 **P3** | **Per-SM routing + approvals/escalation** | route each job's brief/digest/alerts to its SM; AI proposes → **the responsible SM approves in-authority, escalates to Minda above it** → logged | SM profiles, own-authority lists, Approvals Desk (RND-9) |
| 🟡 **P3** | **SM profiles + authority matrix** | per-SM: their jobs, channel (WhatsApp/Telegram/email), **own-authority limits** (decide vs escalate) | Minda sets authority; Project Register |
| 🟡 **P3** | **Portfolio dashboard** (Minda) | all jobs worst-first (RAG/progress/cost/escalations) + the "needs Minda" queue + trends | the record across jobs, routing |
| 🔵 **P4** | **Client progress-update generator** | curated plain-English update + photos/time-lapse per project — **drafted, human-approved before sending** (§3 + consent) | the record, Helen, consent sign-off |
| 🟡 **P3** | **Estate/project RAG** | ask the drawings/RAMS/specs, cited | RAG, NAS |
| 🟡 **P3** | **RAMS + compliance hooks** | RAMS issue/sign (DocuSeal) + competence/expiry tracking | DocuSeal, Sarah |
| 🔵 **P4** | **Handover pack assembler** | gather as-builts, O&M, sign-offs, photo record into the pack | the full record |
| 🔵 **P4** | **Time-lapse / progress video** | assemble fixed-camera stills into a progress/marketing time-lapse | site cameras |

## HARDWARE to buy (construction-specific, priority-marked)
_The brain + storage + backups are already in `Estate-Hardware-Shopping-List.md`; these are the site/capture
items this vision adds._
| Pri | Item | Why | ~£ (verify) |
|---|---|---|---|
| 🔴 **P1** | **nothing** — phone cameras + the site chat | the ingest pilot runs on what people already carry | £0 |
| 🟠 **P2** | **NAS capacity headroom for photos/video** | site photo/video volume is large — size the pool for it | in the storage BOM |
| 🟡 **P3** | **Fixed site camera(s)** per active job — **4G/solar or PoE+NVR** | progress monitoring + time-lapse + security without site infrastructure | ~£150–500 /site |
| ✅ **have** | **Site connectivity** — 4G router + SIM, **large monthly data bundle already owned** (Minda, 2026-10-28) | upload photos/video + run the cameras + site chat | **£0** (reuse) — extra router only if several sites run at once |
| 🟡 **P3** | **Rugged tablet/phone** for the site team (optional) | capture + Anna access on site | ~£150–400 |
| 🔵 **P4** | **PTZ / time-lapse camera** (optional) | wide coverage + a proper progress/marketing time-lapse | ~£200–600 |
| 🔵 **P4** | **Edge box at a big site** (optional) | local pre-processing if upload is a bottleneck | ~£150–300 |

## Marketing bonus — the same cameras feed Helen (Minda, 2026-10-28)
The fixed site cameras go in for progress/H&S, but the **same footage is near-free marketing material** —
**time-lapse build videos, progress reels, finished-project showcases, social clips**. Getting **Helen** (AI
Content & Marketing) in **before** the cameras are placed means the capture (angles, resolution, interval,
retention) serves marketing too, not just monitoring. ⚠️ **Marketing use needs a different consent basis** than
internal monitoring — **client permission** for the site + people's consent to appear — so that's a
Minda/Victoria + client-agreement check, flagged to Helen. Scoped to Helen via her Raw (AWT below).

## Governance + privacy (before any of it goes live)
Site photos + voice = **personal data** (staff + subbies + people on site). Running them through AI =
workplace monitoring + data processing. **Lawful basis + a notice to the people on site + a retention rule =
Minda + Victoria's call** (already flagged, AWT-1036), not Eugene's. Fixed cameras add CCTV/GDPR signage
duties. Local-only processing (nothing leaves the estate) is the privacy-friendly default.

## What to confirm with Anna (her domain)
1. The **lifecycle stages** + what matters most at each (is the table right for how Fishbone runs jobs?).
2. The **H&S checklist** the vision should flag (your site rules), and the **progress** signals that matter.
3. The **record shape** — how a job's file + registers should build (ties to the Project Delivery sheets already built).
4. **Which pilot job** + whether fixed cameras are wanted (and where).
Scope via her Raw + a Hub row (the integration-scope-with-owner pattern).

---
_Guide-only (§3): Eugene designs the IT/system side + builds/verifies; Anna owns the construction domain;
Minda executes + decides (incl. privacy with Victoria) + holds creds. The vision → the soft + hardware lists
above. Pairs with RND-7/16/21, RND-2/3, the AI-machine build list, and the Project Delivery registers._
