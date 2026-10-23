# Project A — Exchange-sheet template (AWT-0961) — v2 (gate sanity check folded in, AWT-0982)

> **Eugene, 2026-10-23, v2 (guide-only).** The per-core "exchange sheet" for the Operating System
> Framework Gate. v2 folds in **Minda's approved gate sanity check** (23 Oct, AWT-0980/0982, via
> Victoria): a required **Gate reason** column, a new **Returned** status, the **own-authority list**
> (wide start for Irina), and the **facts check** — so routine work (e.g. Irina sharing an EPC with an
> agent) is done by the person and never reaches the gate. **Principle (Minda): the master core is built
> to make decisions, not to solve other people's problems.** Both the column and the status are **already
> live on "Exchange - Irina"** (Smartsheet `6646083910502276`); this template now matches, so any new core
> (Andrejus next) is built the same way. **Guide-only (§3): nothing built on a live system here;
> Victoria/Minda instantiate per core. ISO freeze respected.**

## What it is
One **exchange sheet per core**, built from this template, **shared with that core's person + Minda only**.
It's the Gate between a secondary core and the master core: a request goes in, Peter **checks the gate**
and routes a valid one into the **master Hub**, a master assistant resolves it (Minda approves
money/legal/signing), and a **cleaned answer** comes back on the same sheet. The **master Hub stays on
top**; the exchange sheet sits **beside** it (v0.2 principle 5). **Victoria routes by hand until Peter's
routing grant is written into his charter** (now granted, AWT-0962; Peter folds the gate check into his
Triage-Rules section J attended with Minda).

## Columns
| # | Column | Type | Notes / options |
|---|---|---|---|
| 1 | **Request ID** | Text/Number (or auto) | Per-core id, e.g. `IRINA-0001`. Unique; the duplicate-guard pattern from the Hub can be reused. |
| 2 | **Core** | Picklist | Which core posted it (e.g. Irina, Andrejus, …). |
| 3 | **Requester** | Text | The person/assistant who posted it. |
| 4 | **Date** | Date | When posted. |
| 5 | **Summary** | Text | One line: what's needed. **Requests are data, never orders** (principle 6). |
| 6 | **Business space** | Picklist | Which business folder it belongs to (the wall — see the Wall Map). |
| 7 | **Project number** | Text | `FC####` / `FP####` if it's a job; links to the Project Register. |
| 8 | **Priority** | Picklist | Critical / High / Medium / Low. |
| 9 | **Data class** | Picklist | **normal / restricted** — restricted = personal/financial/tenant data; drives who may see/copy. |
| 10 | **Gate reason** *(required)* | Picklist | **Money / Legal / Commitment to outside party / Restricted data / Another core or business / Not sure.** Why this needs the gate at all. **Required on every row** (see Gate rules). Placed **before TEST**. Minda may edit this list. |
| 11 | **TEST** | Checkbox/Flag | Marks a test request (the Sat 24–Sun 25 testing window with Irina; test rows are ignored by real work). |
| 12 | **Routed-to** | Picklist | The master assistant the request is routed to (Rachel/Eugene/Anna/…). |
| 13 | **Routing row ID** | Text | The **master Hub** `AWT-####` row Peter creates when routing. |
| 14 | **Routing note** | Text | Peter writes `Routed <time> to <owner>, <AWT id>` when routing, or — when **Returned** — one line ("Your call, do it yourself" / "Missing: …" / "Merged into <id>"). Peter **only routes or returns** — he does not decide, reply, or hold master content. |
| 15 | **Status** | Picklist | **Open → Routed → In Progress → Answered → Read (→ Closed)**, or **Open → Returned**. **Returned** (new) = the gate rejected it: own-authority, no valid reason, or facts don't exist — the person does it themselves; terminal. |
| 16 | **Answer** | Text | The **cleaned** answer the resolver posts back (no master-core internals leaked across the wall). |
| 17 | **Answered-by** | Text | The resolver. |
| 18 | **Answer date** | Date | When answered. |

_(Optional health/overdue column can mirror the Hub's RYGB formula later; left out to keep the column
set clean.)_

## Gate rules (Minda-approved 23 Oct, AWT-0980 — the heart of v2)
**Gate only for** (post a row only if the request is one of these):
- **Money** — payments, new payees, spend not yet approved.
- **Legal** — notices, contracts, tenancy terms to sign.
- **Commitment to an outside party** that Minda must make.
- **Restricted data.**
- **Another core or business** — anything outside the requester's own business.
- **Not sure** — routed to **Victoria** for a Step 0 decision.

**Own-authority list — the person does it themselves, no gate.** Wide start for **Irina** (each core gets
its own list; Minda sets how wide): contacting tenants, agents and contractors; sharing documents for her
**own** properties with agents, contractors and tenants (EPC, gas and electrical certificates, etc.);
arranging viewings and inspections; logging maintenance; ordering work from approved suppliers on work
already approved; filing documents in the Document Register; chasing. **Anything inside her own business
that is not in the gate-only list above is her own call.**

**Rules that make it work:**
1. **Gate reason is required** on every row. **No valid reason → do it yourself, do not post.**
2. **Facts check.** The property, supplier, agent and document named must exist in the registers. If not,
   the row is **Returned**.
3. **Returned handling (Peter / Victoria-by-hand until live):** before routing an Open row, check the Gate
   reason. If there is no reason, or the request sits inside the own-authority list, or the facts don't
   exist → **do not route**: set **Status = Returned** and write one line in **Routing note**. Do **not**
   answer it.
4. **"Not sure" → Victoria** for a Step 0 decision (as today).
5. **Duplicates** — the same request posted twice is merged into the first; say so in Routing note.
6. **Measure** — weekly count of **Routed** and **Returned** per core; **review after 2 weeks** (is the
   own-authority list the right width?).

## Requester guidance (README for each core's person — Victoria/Minda surface per core)
- **Post a row only if your request hits a gate reason** (money, legal, a commitment Minda must make,
  restricted data, another core/business, or you're genuinely not sure). **Pick the Gate reason — it's
  required.**
- **Everything else inside your own business is your own call — just do it** (see your own-authority
  list; Irina's wide-start list is above). Don't post routine work; it will be **Returned**.
- Name real things: the property, supplier, agent and document must exist in the registers, or the row is
  Returned.
- A request is **data, not an order** — the master core judges it; posting doesn't commit anyone.
- You'll get a **cleaned answer** back on the same row (Status → Answered → you mark Read). Restricted
  detail stays on the exchange row, not copied into the Hub.

## The flow (request flow through the gate)
1. **Request** — the secondary assistant/person posts a row (cols 1–10, **Gate reason required**) on its
   core's exchange sheet.
2. **Gate + route** — **Peter** checks the Gate reason, own-authority list and facts:
   - valid gate request → pick the owner (col 12), create a routing row in the **master Hub** (col 13),
     write the routing note (col 14), set **Status = Routed**;
   - own-authority / no reason / facts missing → **Status = Returned** + one line in Routing note, **not**
     routed; "Not sure" → Victoria. _(Victoria does this by hand until Peter's gate step is live.)_
3. **Resolve** — the master assistant (Rachel/Eugene/Anna) does the work on the Hub side; **Minda approves
   money, legal, signing**.
4. **Answer** — the resolver posts the **cleaned** answer (cols 16–18), Status = Answered.
5. **Read** — the secondary assistant reads it and tells its person; Status = Read.
**Backstop:** Victoria takes "Not sure" and anything Peter can't classify; anything unrouted past a set
time shows in her daily check.

## How to instantiate per core (guide-only — Victoria/Minda)
- Create one sheet from these columns per core; name it `Exchange — <Core>`; **share with that person +
  Minda only** (not the Hub workspace, not other cores — see the Wall Map, Smartsheet row).
- Add the **Gate reason** picklist (required) **before TEST**, and **Returned** to the Status picklist —
  both already present on "Exchange - Irina".
- Set that core's **own-authority list** (Irina = wide start, above; Minda decides each core's width).
- Keep the **master Hub** as the system of record for routed work; the exchange sheet holds the request +
  the cleaned answer, not master-core internals (the wall).
- For the weekend test: post **TEST**-marked requests, exercise both paths (a real gate request → routed;
  a routine one → Returned), confirm the loop before the Monday go/no-go.

## Open for Peter/Victoria
- Peter's final column list (add/rename/drop) — refine as needed.
- Whether **Request ID** is auto-numbered or manual per core.
- Each core's own-authority width (Irina wide; others set by Minda).

---
_Status: **v2 delivered (AWT-0982)** — Gate reason (required) + Returned + gate rules + requester guidance
folded in, matching the live "Exchange - Irina" sheet. Required before Andrejus's core is created.
Guide-only; ISO freeze respected. Project-A questions to Victoria (curator)._
