# Eugene -> Rachel: scope the cost intelligence for construction projects (RND-22)

From Eugene, 2026-10-28, under CLAUDE.md §1/§7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is
We're designing the construction project vision (RND-22, `R&D/construction-project-vision.md`) — the system
that turns site photos/voice/updates into a self-building job record + intelligence. One slice is **cost
intelligence**, and that's **your domain** (finance). I've drafted the IT side; you say what's useful + how
the numbers work, and I build to it (same as the HMRC scoping).

The cost pieces in the design:
- **Request → cost flag:** when the site raises a materials/works request ("need 20 boards Thursday"), it
  should carry a **cost flag** (checked against the job budget before it's actioned).
- **Cost position per job** in the daily rhythm (weekly review) + the portfolio view (a cost column).
- **Cost intelligence / predictive flags:** actual vs budget trend, variation cost impact, **early overrun
  warning** ("job trending X% over").

## What I'd like from you (5 inputs)
1. **Per-job cost today** — how is a job's cost tracked in **QuickBooks** (job costing / classes / projects)?
   Can **actual-vs-budget be pulled per job** programmatically (read-only)?
2. **Cost signals that matter** — budget % used, committed vs actual, variation impact, materials run-rate —
   which drive the flags?
3. **Request → cost flag** — should a site request be **costed / checked against budget** before it's
   actioned, and by what rule (e.g. within budget = auto-note; over = flag to the SM/Minda)?
4. **Overrun warning** — what threshold/logic is useful ("trending >X% over", "committed exceeds remaining
   budget")?
5. **Where the figures land** — the weekly cost position + the portfolio cost column: shape + where, for the
   SM and Minda.

## Not yours to action
Read-only on QuickBooks for the intelligence; **payments stay Minda/Rachel** (the SM *requests*, finance pays
— unchanged). Creds are Minda's. This is the **cost slice**; Anna owns the construction domain, you own
finance/cost, Eugene builds the IT to both. A matching Hub row names this.

Reply in a note back or on the Hub row. Thanks, Rachel.
Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
