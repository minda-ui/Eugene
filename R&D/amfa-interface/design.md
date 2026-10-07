# RND-10 — Amfa furniture arm: internal ops interface (design)

_Status: exploring (2026-10-07). Minda chose **(B) internal ops** — the order + production management
system to run the furniture business on. Creative-mode R&D; cross-KB (Amfa/Nadia) so this stays in Eugene's
pool and graduates to Amfa via `Raw/` with Minda's approval. Guide-only; Eugene builds/tests software (§2c),
a human deploys; no secret held; process content is verified by Minda/Nadia before it's authoritative._

## Design principle
**The interface is a direct map of the business process.** One screen/step per stage; the money and sign-off
milestones become **gates** the system enforces. So we lock the process first, then the UI falls out of it.

## Part 1 — the end-to-end process (from `order-fulfilment-process.md`, to VERIFY with Nadia/Minda)
Every commission is an **Order** moving through these stages. ⚠ = unverified / confirm.

| # | Stage | What happens | Data captured | Money milestone | System / doc today |
|---|---|---|---|---|---|
| 1 | **Enquiry** | client application → qualified lead | client, rooms, budget, source | — | intake form → Smartsheet tracker; Nadia |
| 2 | **Concept / estimate** | measure + engineer → preliminary → **final quote** | measurements, unit list, drawings, quote £ | — | Design & Process; cabinet library; quote doc |
| 3 | **Approval & contract** | client approves; **contract signed** | signed contract, agreed spec | — | eSignature / DocuSeal (RND-8) |
| 4 | **Ordering / engineering** | issue materials; engineer for production | BOM, cut data, material order | **Deposit 1** (fixed £ ⚠) + **Deposit 2** (% ⚠) | SmartCabinet; supplier orders |
| 5 | **Production** | cut & edge-band → assemble → QC → pack | job status, QC result, pack list | — | `smartcabinet-and-production-workflow` (Vitap CNC) |
| 6 | **Delivery** | ready → delivered | delivery date, proof | **pre-delivery payment** | schedule; delivery note |
| 7 | **Install → review → closed** | fit, snag, sign-off | install date, snag list, review | **final payment** | install sheet; sign-off (eSign) |

**Gaps to confirm (the doc flags these):** is this the *current* process or legacy (source dated 2026-01-27)?
exact **Deposit 1 £ and Deposit 2 %**? does it match the **live Smartsheet "AMFA Furniture" tracker** status
values? These get nailed down with Nadia/Minda before the plan is authoritative.

## Part 2 — the interface (internal ops)
Core object = **Order**. Six views:

1. **Pipeline board (Kanban)** — columns = the 7 stages, cards = live orders. See all WIP at a glance; advance
   a card only when the stage **gate** passes (below).
2. **Order record** — the spine: one page per commission — client · rooms/units · current stage · **documents**
   (quote, contract, drawings, RAMS) · **payments** (D1/D2/pre-delivery/final: due vs paid) · **production**
   status · delivery/install dates · notes + photos.
3. **Production view** — stage 5 detail: cut list / CNC (SmartCabinet→Vitap) / assembly / QC / pack, lines
   drawn from the **cabinet library** (AMFA Wall/Base units).
4. **Money dashboard** — deposits due/received, outstanding by stage, cashflow (ties to QuickBooks / Rachel).
5. **Schedule** — delivery + install calendar and capacity.
6. **Client comms** — enquiry intake form, quote send, status updates (Nadia; email/Telegram).

**Data model (entities):** Order · Client · Room/Area · Line-item (a unit from the cabinet library) ·
Document · Payment · Production-job · Delivery/Install-event.

**Stage gates = the process made real (and enforced):**
- → Production only when **contract signed + Deposit 1 & 2 received**.
- → Delivery only when **pre-delivery payment** received.
- → Closed only when **final payment + review/sign-off** done.
These gates tie straight into **RND-9 (Approvals/money milestones)** and **RND-8 (eSign contract/RAMS)**.

## Part 3 — what to build it on (phased, own-the-estate)
| Option | What | Effort | When |
|---|---|---|---|
| **1. Mature the Smartsheet tracker** | add stage/gate/payment columns + intake form + a dashboard to the live "AMFA Furniture" sheet Nadia already uses | low | **MVP now** — prove the pipeline + gates on real orders, zero new infra |
| **2. Self-hosted low-code app** | **NocoDB/Baserow** (DB + grid + forms + API) + **Budibase/Appsmith** (dashboards/UI) on the Proxmox box | medium | **the real tool** — own-the-estate, roles, automations (ties RND-2/3/7) |
| **3. Bespoke web app** | full custom build | high | only if it outgrows low-code |

**Recommendation:** **MVP on Smartsheet now** (it maps the process and Nadia lives there already), then
**graduate to the self-hosted low-code app** when it earns it — the same prove-cheap-then-own pattern as the
rest of the estate.

## Estate ties (why this fits the bigger picture)
- **SmartCabinet / Vitap** — production feed (stage 5).
- **Cabinet library** — the standard units are the Order's line-items.
- **QuickBooks / Rachel** — the payment milestones.
- **eSignature / DocuSeal (RND-8)** — contract + RAMS signing at stages 3/7.
- **Nadia** — the human/AI operator who runs the pipeline day-to-day.
- **RND-9 Approvals** — the money gates are approval events.
- **RND-7 project-brain** — each Order record becomes the searchable per-job record; **RND-2 local AI** can
  draft quotes and read drawings.

## Next steps (pick one)
1. **Draft the authoritative process plan** — read `smartcabinet-and-production-workflow` + the live Smartsheet
   tracker, reconcile, and produce the verified end-to-end plan (deposits + statuses confirmed with Nadia/Minda).
2. **Wireframe the two key screens** — the Pipeline board + the Order record — as the interface spec.
3. **Scope the Smartsheet MVP** — exact columns, gates, intake form, dashboard — so Nadia can run the real
   pipeline next week.

Graduation: hand the verified process plan + interface spec to Amfa (Nadia) via her `Raw/`, with Minda's
approval, and turn the MVP into a real Hub task.
