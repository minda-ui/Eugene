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

## SOFTWARE to build (construction-specific, priority-marked)
_Extends the AI-machine build list with the construction angle._
| Pri | Build | What it does | Depends on |
|---|---|---|---|
| 🔴 **P1** | **Site-chat + voice + photo ingest** (one job) | messages/voice/photos → the brain → Anna's feed | RND-21 bridge, Whisper, storage |
| 🔴 **P1** | **Site-vision sentinel** (construction-tuned) | progress tags · **H&S checklist** (PPE/height/access/exits) · read **delivery notes** · spot obvious defects | P1 vision model |
| 🟠 **P2** | **Daily job digest** | "what happened on \<job\> today" + open requests + flags, drafted for the PM | summariser |
| 🟠 **P2** | **Request / materials extractor** | spoken/typed "need 20 boards Thu" → a structured request → procurement + cost flag | extractor, Rachel (cost) |
| 🟠 **P2** | **Per-project record writer** (RND-7) | folds the day's photos/updates/requests/flags into the job's file + registers | the above, storage |
| 🟡 **P3** | **Progress vs programme** | compare site reality to the Last-Planner programme → slip/ahead flags | the record, the programme |
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
