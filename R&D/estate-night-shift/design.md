# RND-15 — The Estate Night Shift (design sketch v1)

_R&D design (git-primary; creative mode, 2026-10-25). Status: **spark → exploring**. Guide-only (§3):
every output is a **draft for morning sign-off**; the night shift reads and drafts, it never sends,
pays, or changes a live system. It yields to the PBX, always._

## The one-sentence idea
While the office sleeps and the GPUs sit idle, the estate does its heavy, async thinking in **batch** and
leaves **drafts, digests and flags** ready by morning — so Minda wakes to decisions, not a to-do list.

## Why
The P40s are idle ~18 hours a day; the PBX is quiet overnight. That's free compute going to waste. The
work that's *too slow or too bulky* for interactive use (whole-day photo review, a 480B coder build, a
full RAG re-index) is exactly the work that fits a night window. Turn dead hours into done work.

## The nightly run (≈ 00:00–06:00, one job after another)
A scheduler in a capped LXC wakes on cron, and for each job calls the **gateway (RND-14)** for inference,
then files the result as a **draft** in the right place:

| Job | Does | Lands as | Ties |
|---|---|---|---|
| **Photo digest** | review the day's site photos (vision) | a tagged summary + any hazard flags | RND-16 / RND-7 |
| **Delivery-note OCR** | read the day's delivery-note photos | draft QuickBooks/Dext entries for Rachel | RND-16 / AWT-0805 |
| **RAMS pre-draft** | tomorrow's jobs → first-cut RAMS | drafts for Anna to finish | RND-8 |
| **Mail pre-triage** | overnight ops@ arrivals | proposed labels/routes for Peter to confirm | mail-triage |
| **Morning brief** | fuse Hub + registers + photo digest + mail + alarm status | one page on Minda's phone | the `morning` flow |
| **Foundry builds** | the 480B coder works a backlog item | a tool in staging + a PR to review | RND-19 |
| **Housekeeping** | re-index the KB for RAG; verify last night's backup restored | a health line in the brief | RND-3 / RND-6 |

## How it stays safe (the design, not a disclaimer)
- **Everything is a draft.** Nothing is sent, posted, paid or deployed by the night shift. The morning
  brief is a *review queue*, and anything irreversible rides the Approvals Desk (RND-9).
- **The PBX always wins.** The batch LXC is CPU-deprioritised (cpuunits) and core/RAM-capped — if a call
  comes in at 3am, the phones get the box, the model waits.
- **Local-first at night too.** Batch stays on local models (the egress wall, RND-18); no surprise cloud
  bill rung up while everyone's asleep.
- **Not a black box.** Each run writes a "night shift ran — here's what it did, here's what it skipped"
  line into the brief, so it's auditable, not mysterious.

## The morning brief (the shop window)
The one artefact Minda actually sees. A single page, on the phone, by 7am:
- **Needs you:** approvals waiting, hazard flags from the sites, anything blocked.
- **Drafts ready:** RAMS, delivery-note entries, mail routes, any tool the foundry built.
- **Estate health:** PBX/WAN/trunk up?, backups verified?, anything the alarm (RND-6) caught overnight.
- **Today:** the day's jobs + diary.
It's the human-facing face of the whole organism — every organ's overnight output, one scroll.

## Honest edges
- **Draft quality needs a feedback loop** — a bad draft that looks confident wastes more time than no
  draft. Start with the jobs where a wrong draft is cheap to spot (photo digest, mail labels), earn trust,
  then add the costlier ones (RAMS, QuickBooks).
- **Don't over-fill the night.** If batch runs long it mustn't bleed into the morning's interactive use.
  Time-box each job; skip-and-log rather than overrun.
- **Garbage in** — it only sees what was captured (photos taken, mail received). It supplements the day,
  never replaces attention.

## Phasing
- **P0 (CPU, today):** one job — the **morning brief** from Hub + registers (no models needed to start) →
  prove the "wake to a page" habit.
- **P1:** add the **photo digest** + **mail pre-triage** (needs the sentinel RND-16 + gateway).
- **P2:** add **RAMS pre-draft** + **delivery-note OCR → Rachel**.
- **P3 (post-RAM/480B):** add **foundry overnight builds**.
- **P4:** the brief becomes the daily front door; feedback tunes each job.

## Graduation
Pairs with the gateway (RND-14) + sentinel (RND-16). First real step: the P0 morning brief as a scheduled
job writing an Outputs page — genuinely useful before any GPU. Cross-KB jobs (Rachel/QuickBooks,
Anna/RAMS, Peter/mail) route through each employee's Raw/ + Minda's approval.

---
_Guide-only; drafts for sign-off; PBX-priority; local-first; auditable. Pairs with RND-14 (gateway),
RND-16 (eyes), RND-19 (foundry), RND-6 (health), RND-9 (approvals), RND-3 (storage)._
