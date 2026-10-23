# Project A — Exchange-sheet template (AWT-0961) — strawman v1

> **Eugene, 2026-10-22, strawman v1 (guide-only).** The per-core "exchange sheet" for the Operating System
> Framework v0.2 Gate. Columns = **Peter's proposal + Minda's additions** as relayed by Victoria (curator)
> on AWT-0974; **Peter refines the columns, Victoria folds them in**. Target Fri 14:00. Eugene delivers the
> **template spec**; **Victoria/Minda instantiate** a sheet per core (v0.2 schedule: Victoria builds Irina's).
> **Guide-only (§3): nothing built on a live system here. ISO freeze respected.**

## What it is
One **exchange sheet per core**, built from this template, **shared with that core's person + Minda only**.
It's the Gate between a secondary core and the master core: a request goes in, Peter routes it into the
**master Hub**, a master assistant resolves it (Minda approves money/legal/signing), and a **cleaned
answer** comes back on the same sheet. The **master Hub stays on top**; the exchange sheet sits **beside**
it (v0.2 principle 5). **Victoria routes by hand until Peter's routing grant is written into his charter.**

## Columns (strawman — Peter proposes, Victoria folds in)
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
| 10 | **TEST** | Checkbox/Flag | Marks a test request (the Sat 24–Sun 25 testing window with Irina; test rows are ignored by real work). |
| 11 | **Routed-to** | Picklist | The master assistant the request is routed to (Rachel/Eugene/Anna/…). |
| 12 | **Routing row ID** | Text | The **master Hub** `AWT-####` row Peter creates when routing. |
| 13 | **Routing note** | Text | Peter may write: `Routed <time> to <owner>, <AWT id>`. Peter **only routes** — he does not decide, reply, or hold master content beyond routing. |
| 14 | **Status** | Picklist | Open → Routed → In Progress → Answered → Read (→ Closed). |
| 15 | **Answer** | Text | The **cleaned** answer the resolver posts back (no master-core internals leaked across the wall). |
| 16 | **Answered-by** | Text | The resolver. |
| 17 | **Answer date** | Date | When answered. |

_(Optional health/overdue column can mirror the Hub's RYGB formula later; left out of v1 to keep Peter's
column proposal clean.)_

## The flow (v0.2 "request flow through the gate")
1. **Request** — the secondary assistant posts a row (cols 1–10) on its core's exchange sheet.
2. **Route** — **Peter** picks the owner (col 11), creates a routing row in the **master Hub** (col 12),
   writes the routing note (col 13), sets Status = Routed. _(Victoria routes by hand until Peter's grant.)_
3. **Resolve** — the master assistant (Rachel/Eugene/Anna) does the work on the Hub side; **Minda approves
   money, legal, signing**.
4. **Answer** — the resolver posts the **cleaned** answer (cols 15–17), Status = Answered.
5. **Read** — the secondary assistant reads it and tells its person; Status = Read.
**Backstop:** Victoria takes anything Peter can't classify, and anything unrouted past a set time shows in
her daily check.

## How to instantiate per core (guide-only — Victoria/Minda)
- Create one sheet from these columns per core; name it `Exchange — <Core>`; **share with that person +
  Minda only** (not the Hub workspace, not other cores — see the Wall Map, Smartsheet row).
- Keep the **master Hub** as the system of record for routed work; the exchange sheet holds the request +
  the cleaned answer, not master-core internals (the wall).
- For the weekend test: create Irina's sheet, post **TEST**-marked requests, route by hand, confirm the
  loop (request → route → cleaned answer → read) before the Monday go/no-go.

## Open for Peter/Victoria
- Peter's final column list (add/rename/drop) — this is a strawman for him to refine.
- Whether **Request ID** is auto-numbered or manual per core.
- Whether a per-core sheet or one sheet with a **Core** filter (v0.2 says "an exchange sheet per core" →
  separate sheets, which also keeps the wall cleanest).

---
_Status: strawman v1 delivered (target Fri 14:00). Peter refines columns → Victoria folds in → Minda/Victoria
instantiate. Guide-only; ISO freeze respected. Project-A questions to Victoria (curator)._
