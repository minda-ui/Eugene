# Construction project vision — the AI-augmented project, end to end (RND-22)

> **Eugene, 2026-10-28 (guide-only, §3).** The vision for how a construction project runs with the estate's
> AI + on-site brain behind it — and the **software** and **hardware** lists that fall out of it. **It's
> Anna's domain (construction):** this designs the *system/IT* side; the construction-process specifics are
> hers. **Humans run the site and decide; the AI captures, understands, drafts and records; nothing acts
> without a person (§3).** Builds on RND-7 (project record), RND-16 (vision), RND-21 (site chat), RND-2/3
> (brain/storage).
>
> **Owner inputs folded in 2026-10-29/30:** **Anna** (lifecycle, H&S, record shape, pilot — AWT-1035/1037),
> **Rachel** (cost model — AWT-1039), **Peter** (email→SM routing — AWT-1040), **Helen** (marketing capture —
> AWT-1038). Each was scoped via their Raw and is marked inline below with its source. What remains is
> **Minda's to decide** — gathered in the closing section.

## The vision (what we're aiming for)
**Every signal from a job — photos, voice notes, site messages, delivery notes, documents — is captured,
understood by the AI, and turned into records, flags and draft actions, so the project's file builds itself,
problems (H&S, progress slip, cost, missing materials) are caught early, and the site team + PM spend time
building, not on admin.** The human always decides; the record is always complete and searchable.

The core loop, repeated all day, per job:
**CAPTURE** (photo/voice/message/doc) → **UNDERSTAND** (vision, transcribe, summarise, extract) →
**DRAFT/FLAG** (a record entry, an H&S flag, a materials request, a progress update) → **HUMAN DECIDES** →
**RECORD** (the per-project file + the registers build automatically).

## Why this matters — the idea behind it (the business case)
Three problems it solves, and they're the real point:

**1. Data sharing — the right info to the right person.** Today a lot of project information — **emails**, docs,
delivery notes, updates — lands with **Minda as the single point**, not the SM actually running the job. That's
a bottleneck *and* a single point of failure. The system becomes the hub that **routes project data to the
responsible SM by job ownership**: project **emails** (via Peter's inbox triage) → the right SM; docs/updates/
deliveries → their feed. Minda stops being the inbox everything funnels through — she keeps **oversight**, the
SM gets **what they need to run the job.**

**2. An AI assistant for each site manager.** Not just Minda having Anna — **each SM gets an assistant for their
jobs**: ask questions about their project (RAG over the record + docs), draft their updates/requests, reminders,
"what needs you today". It **levels up every SM** — and helps a newer SM run a job like an experienced one.

**3. The data compounds into institutional knowledge.** Every project feeds a **learning engine** — what
sequencing worked, which suppliers deliver, which approaches avoid problems, what the best jobs did → **captured
good practices**, standardised and shared across all SMs and jobs. **The company gets better at building, not
just better at recording it** — and the more jobs run through it, the smarter it gets.

**The net:** break the information bottleneck · give every SM an assistant · turn every project into company-wide
learning — with Minda keeping oversight and the gate. *(The email-routing leans on **Peter** (inbox AI); scope
with him when ready.)*

## The project lifecycle — where the AI helps at each stage
**Fishbone's own stages (Anna, 2026-10-29 — the `project-lifecycle` skill, so the registers line up):**
Enquiry → Quoted → Ordered → Set-up → On site → Handover → Snagging → Closed (or Lost). The earlier
"win/mobilise/deliver/control/handover" framing maps on: win = Enquiry→Ordered, mobilise = Set-up, deliver =
On site, control runs *through* On site, handover = Handover→Closed.
| Stage | What matters most (Anna) | AI help (drafts for a human) |
|---|---|---|
| **Enquiry** | capture the lead | scaffold the project record + folders |
| **Quoted** | **price basis + scope exclusions** | pull the quote template; record the price basis |
| **Ordered** | **PO or written acceptance *before* work (PM-3.4)** | flag "no PO yet"; hold the start gate |
| **Set-up** | **RAMS · permits · drawings at current revision · competent operatives (CSCS)** | RAMS issued + signed (DocuSeal); induction/competence + CSCS tracked; drawings register |
| **On site** (the bulk) | **permit cover every shift · daily progress vs programme · materials on site** | site-chat + voice + photos → vision (progress/H&S/delivery notes) → summaries → requests → the record |
| **Handover** | as-builts, O&M, sign-off | assemble the handover pack |
| **Snagging** | the snag list closed out | vision spots snags → snag list; track to close |
| **Closed / Lost** | **close-out + lessons report** | capture lessons learnt → cross-project KB |

## The capture layer (how signals get in)
- **Phone photos + voice notes** via the site chat (Telegram now; WhatsApp later) — the main stream, £0 kit.
- **Fixed site cameras** — progress + time-lapse + security on active sites (where worth it).
- **Documents** — drawings, delivery notes, RAMS (Drive/NAS).
- **The brain** reads it all locally (vision/Whisper/RAG) — sovereign, nothing leaves the estate.

**The record shape (Anna, 2026-10-29).** One **feed item** = date · time · project · sender · type (photo /
request / progress / issue / delivery) · text · photo link. Each type **routes to its register**: progress →
**progress register**; a delivery or "need 20 boards Thursday" → **materials register**; a named person on
site → **operative register**; an issue or near-miss → **risk register**; a client instruction or query →
**communications log**; anything about access or isolation → **permits register**. **Drawings and RAMS are
never filed from chat** — they go through the Drawing / Document Registers with a **DR-/FC number**. **A
person confirms every register entry before it is written; the feed only drafts.**

---

## What the site-vision sentinel flags (Anna's H&S + progress signals, 2026-10-29)
**Photo H&S flags (what a camera can actually show):** PPE worn (hard hat, hi-vis, boots, gloves) · working
at height without edge protection or with a poor ladder/platform · blocked access or escape routes ·
housekeeping (waste, trip hazards, cables) · hot-work or isolation signs missing where a permit applies ·
unsafe stacking of boards/materials · unguarded openings. **A photo cannot show competence, permit validity
or RAMS compliance — so the flag is always "check", never "pass".** Anything flagged **goes to a person**
(site lead, then Minda). The vision **does not certify** and **does not replace a competent H&S adviser**
(CDM 2015 regs 8 & 15; Charter-Rules 0i).

**Progress signals (measured vs the programme + the quote basis, never guessed from a photo):** nights/days
worked vs programme · area or items completed vs the WBS line · materials delivered vs needed · open RFIs/TQs
· permit gaps · variations raised. "On / ahead / behind" is always against the programme, not a snapshot.

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

### Cost intelligence — how it actually works (Rachel, 2026-10-29)
**The budget lives in Smartsheet, not QuickBooks.** One budget sheet per project (e.g. `FP 2401_Budget`),
rows keyed by a **Classifier code** (L/M/P + section + sequence), with a **Health formula already built**
(Red > 100% of internal plan · Yellow 90–100% · Green below). **Actuals** reach it by hand/assistant from
supplier invoices (a note citing invoice no./date/calc), so actuals **lag** and only `Status = Completed`
rows count. **QuickBooks holds the ledger** (Construction Projects + classes) but **job coding isn't yet
uniform**. So the join is **Smartsheet plan + QB/invoice actuals** — there's **no ready QB actual-vs-budget
report per job**. **Read-only pull: yes for the Smartsheet budget** (`get_sheet_summary`); QB is a separate
read-only check Rachel is doing first.

**Flag signals, in order of usefulness:** (1) Completed Total ÷ Total Internal Plan per section/job (the
sheet's Health) · (2) **committed vs actual** (POs + accepted quotes not yet invoiced — *needs a commitments
list that doesn't exist yet*) · (3) variation impact (each variation a plan delta + approver + date) · (4)
materials run-rate (*needs plan phasing, not in the sheets*) · (5) unmatched spend (invoices with no budget
code).

**Request → cost-flag rule (Rachel's proposal — Minda approves, it's a spending control):** a site request
carries job + item + qty → look up the Classifier rate + budget row → **within remaining budget: auto-note**
"within budget, X% of row used"; **over remaining budget, or no matching code: flag to the SM + Minda before
it's actioned.** The flag **informs; it never orders or pays** — SM requests, Minda pays.

**Overrun thresholds (start here, tune on real jobs):** **Amber** = used ≥ 90% of plan with work not
Completed · **Red** = actual + committed > plan (row or job) · **Trend** = if (spend-to-date ÷ % complete)
projects > 5% over total plan (needs a % complete source from the SM).

**Where the figures land:** a **weekly position per job** (plan · actual-to-date · committed · forecast-at-
completion · variance · RAG · top-3 over-budget rows · open variations) + a **portfolio cost column**
(forecast variance % + RAG per job, linked to the budget sheet). Readers = SM + Minda. **These are internal
management figures, not accounts — the page says so.**

**Gaps to fill (owners):** commitments list (Anna/SM) · plan phasing + % complete source (Anna) · one QB
job-coding rule — every bill carries the project (Minda/Rachel) · payroll cost per job not yet allocated
(cf. AWT-1037 timesheet-days method).

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

### Project email → SM routing (Peter's design, 2026-10-29)
Peter's inbox triage already does part of this: an **`FC####` job number** in a thread routes it to Anna, and
he **never guesses**. To route to the **responsible SM**:
- **Classify by job** on signals, in reliability order: (1) our job number `FC####` · (2) the client's own
  job code (the Register already records some in Notes) · (3) the thread (a reply in a job's thread) — these
  **automatically**; (4) sender + site or (5) site/address **only when exactly one live job at Set-up / On
  site / Handover / Snagging fits**, else **not tagged** (`FG/Job/unclear`). Needs a **new label family
  `FG/Job/<FC####>`** — a §2e grant for Peter.
- **Find the SM:** the Project Register has **no site-manager column today** — the gap. Add a **"Site manager"
  picklist** (Sebastian / Nev / Dainius / Andrejus / Minda), **Anna fills it at Set-up**, Peter reads it live
  each pass (never from memory). *(This is the same project→SM map the multi-SM model above needs.)*
- **Mechanism (Peter can label + draft, cannot send/forward)** — **phase 1** = label `FG/SM/<name>` + a
  **daily digest draft per SM** in ops@ (job · sender · subject · date · one-line summary · thread link),
  released by a human; **phase 2** (optional) = each SM gets **read access to ops@ filtered to their label**
  (Eugene builds, Minda's access decision). **Not** a Hub row per email, **not** auto-forwarding.
- **Attachments:** Peter **tags** the thread and drops a **pointer in Anna's Raw** (thread id, file names,
  FC number); **Anna files** to the job folder + Drawing Register (as she does DR-numbers today). Direct
  filing by Peter would need a new §2c-style grant.
- **Never routed to an SM** (whatever the job tag): money (invoices/payments/CIS/retention) → Rachel/Minda ·
  legal/contract/signatures → Minda · security/sharing alerts · anything with personal data. Gate red-flag
  patterns (pay first, unverifiable approval, changed bank details) apply → Victoria/Minda. Everything stays
  visible in ops@; Peter's 17:50 digest shows the per-SM counts.

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
  already are) + an **optional simple dashboard** for anyone who wants the fuller view. **Future:** a
  dedicated **SM app** (site chat → PWA → native) — `construction-sm-app-future.md`.

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
| 🟠 **P2** | **Project email/doc → SM routing** (with Peter) | classify project mail/docs by job → route to the **responsible SM** (not just Minda), into their feed | Peter (inbox AI), project→SM map |
| 🟡 **P3** | **Progress vs programme** | compare site reality to the Last-Planner programme → slip/ahead flags | the record, the programme |
| 🟡 **P3** | **Predictive flags / forecasting** | forecast completion date, material shortfalls, overrun warnings — **grounded (cites evidence), human-gated** | the record, progress + cost + materials data |
| 🟡 **P3** | **Cross-project lessons KB** | every job's lessons feed a store → surfaced at the right stage of the next job (compounding) | the record, RAG |
| 🟡 **P3** | **Per-SM routing + approvals/escalation** | route each job's brief/digest/alerts to its SM; AI proposes → **the responsible SM approves in-authority, escalates to Minda above it** → logged | SM profiles, own-authority lists, Approvals Desk (RND-9) |
| 🟡 **P3** | **SM profiles + authority matrix** | per-SM: their jobs, channel (WhatsApp/Telegram/email), **own-authority limits** (decide vs escalate) | Minda sets authority; Project Register |
| 🟡 **P3** | **Portfolio dashboard** (Minda) | all jobs worst-first (RAG/progress/cost/escalations) + the "needs Minda" queue + trends | the record across jobs, routing |
| 🔵 **P4** | **Client progress-update generator** | curated plain-English update + photos/time-lapse per project — **drafted, human-approved before sending** (§3 + consent) | the record, Helen, consent sign-off |
| 🟡 **P3** | **Estate/project RAG** | ask the drawings/RAMS/specs, cited | RAG, NAS |
| 🟡 **P3** | **Per-SM assistant** (ask-your-jobs) | each SM asks about their jobs, drafts updates/requests, gets reminders — scoped to their jobs | RAG, the record, routing |
| 🟡 **P3** | **Good-practice / standardisation engine** | surface "how the best jobs did this" at the right moment; standardise + share across SMs | cross-project lessons KB |
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

## Marketing bonus — the same cameras feed Helen (Helen's capture spec, 2026-10-30)
The fixed site cameras go in for progress/H&S, but the **same footage is near-free marketing material**.
Getting **Helen** (AI Content & Marketing) in **before** the cameras are placed means the capture serves
marketing too, not just monitoring. Her inputs:
- **Content worth having (most→least useful):** (1) one **time-lapse build video** per flagship project
  (website + LinkedIn) · (2) **before/during/after stills from the same fixed frame** (case studies) · (3)
  10–20 s social clips cut from the time-lapse · (4) a private **client progress reel** (not public).
- **Capture spec:** one **wide fixed view** per project, **locked once placed** (moving it mid-job breaks the
  time-lapse) · **4K stills** if the camera allows, 1080p minimum, **shoot landscape** (crop to vertical for
  social later) · **one still every 5–10 min** in working daylight · **keep the original stills**, not just
  the video · **no burnt-in timestamp on the master** (fine on copies) · keep stills for the whole job until
  the case study is done.
- **Keep out of frame where possible:** faces · vehicle plates · neighbouring properties · client signage or
  unreleased product · screens · paperwork.
- **Best showcases** = the branded retail fit-outs on the "Our Work" list (Rolex, Armani, Versace, Superdry,
  Peloton, Sofa.com, Sushi Bar) — **which are live is Minda/Victoria's to say**. Cadence: one finished
  time-lapse per project at handover; stills at start/mid/end.
- **Where clips land:** `Marketing-Footage/<project>/` in the Collaboration Space (raw stills · cleared clips
  · a one-line clearance note per project) — **Eugene/Minda create it + set write access**. Helen holds no
  camera links or credentials.

⚠️ **Marketing use needs a different consent basis** than internal monitoring — **client permission** for the
site + people's consent to appear + **release of anything public** — **Minda + Victoria's call** (with the
client), **not Helen's**: she drafts only from footage **marked cleared** and **publishes nothing** (§3 +
AWT-1036).

## Governance + privacy (before any of it goes live)
Site photos + voice = **personal data** (staff + subbies + people on site). Running them through AI =
workplace monitoring + data processing. **Lawful basis + a notice to the people on site + a retention rule =
Minda + Victoria's call** (already flagged, AWT-1036), not Eugene's. Fixed cameras add CCTV/GDPR signage
duties. Local-only processing (nothing leaves the estate) is the privacy-friendly default.

## Owner inputs — folded in (2026-10-29/30) and what Minda must now decide
**All four owner scopings are in and folded above:**
- **Anna** (AWT-1035/1037) — real lifecycle stages · H&S photo flags ("check, never pass") + progress
  signals · the feed-item record shape + register routing · pilot = **not FC2611** (its programme ends
  29 Oct), the next job after privacy is settled, **phone + chat, no fixed cameras for the first pilot**.
- **Rachel** (AWT-1039) — budget lives in Smartsheet (Classifier codes + Health formula) · request→cost-flag
  rule · overrun thresholds · read-only pull yes for the budget, QB a separate check.
- **Peter** (AWT-1040) — `FG/Job/` + `FG/SM/` labels · a Site-manager column in the Register (Anna fills) ·
  daily digest drafts · attachments via Anna's Raw.
- **Helen** (AWT-1038) — the marketing capture spec + the `Marketing-Footage/` folder.

**What Minda must now decide (nobody below her can):**
1. **Pilot job** (Anna: the next job starting after privacy is settled) + confirm phone+chat for the pilot.
2. **Privacy / lawful basis + DPIA + site notice + retention** (with Victoria, AWT-1036) — **the build stays
   parked until this is settled.**
3. **Cost-flag + request rule** (Rachel's proposal — it's a spending control) + the **one QB job-coding rule**.
4. **Peter's grants:** the `FG/Job/` + `FG/SM/` label families (§2e extension) + the digest-vs-filtered-access
   mechanism + whether attachments stay with Anna (Peter's rec) or Peter gets a filing grant.
5. **SM authority £ limits** per SM (`construction-sm-authority-matrix.md`) + each SM's channel.
6. The **Site-manager column** in the Project Register + the **`Marketing-Footage/`** folder (Eugene builds
   once Minda says go).

**Still-missing data an owner must create** (flagged, not design blockers): a **commitments list** (Anna/SM),
**plan phasing + % complete** source (Anna), **payroll cost per job** allocation (cf. AWT-1037).

---
_Guide-only (§3): Eugene designs the IT/system side + builds/verifies; Anna owns the construction domain;
Minda executes + decides (incl. privacy with Victoria) + holds creds. The vision → the soft + hardware lists
above. Pairs with RND-7/16/21, RND-2/3, the AI-machine build list, and the Project Delivery registers._
