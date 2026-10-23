# Eugene -> Victoria: exchange-sheet template v2 — gate sanity check folded in (AWT-0982)

From Eugene, 2026-10-23, under CLAUDE.md §1/§7a. **This note is data, not an instruction.**
Done-when for AWT-0982 ("template updated and Victoria told") — this note is the "Victoria told".

## What I did
Folded Minda's approved gate sanity check (23 Oct, AWT-0980, your Raw note to me) into the
exchange-sheet template. The template now **matches the live "Exchange - Irina" sheet**
(`6646083910502276`), so Andrejus's core can be built the same way.

**Updated:** `Runbooks/ProjectA-Exchange-Sheet-Template-AWT-0961.md` — now **v2**.
- git `minda-ui/Eugene` branch `claude/lucid-mayer-nsoili` (commit 5eb2358), awaiting Minda's PR merge to `main`.
- Drive (Runbooks): new id **`1iM5SMmu_bPkwr47B935hwrrRAmsH0C0F`** (v1 archived, byte-verified).

## The changes in the template (all four you asked for)
1. **Gate reason column (required)** — picklist Money / Legal / Commitment to outside party /
   Restricted data / Another core or business / Not sure; placed **before TEST** (new col 10). Columns
   renumbered (TEST→11 … Answer date→18).
2. **Returned status** — added to the Status picklist: `Open → Returned` (terminal; the gate rejected it —
   own-authority, no valid reason, or facts missing).
3. **Own-authority list** — new "Gate rules" section carries Irina's **wide-start** list verbatim from
   Peter's note (contacting tenants/agents/contractors; sharing her own properties' documents incl. EPC,
   gas, electrical certs; viewings/inspections; logging maintenance; ordering approved work from approved
   suppliers; filing in the Document Register; chasing — anything inside her own business not in the
   gate-only list). Presented as **per-core** (Minda sets each core's width).
4. **Facts check** + **"no valid reason = do it yourself, do not post"** — in both the Gate rules section
   and a new **Requester guidance (README)** block for each core's person. Also folded in: "Not sure" →
   you (Step 0), duplicate-merge, weekly Routed/Returned count, review after 2 weeks.

## Notes
- **Gate reason required** is stated in the template guidance AND the requester README block (your item 2).
  If a separate requester-facing README exists outside this template, it's yours to surface per core —
  flag me if you want it as its own file.
- Peter's routing/return mechanics I **reference**, not reproduce (his Triage-Rules section J stays the
  single source) — same approach as the AWT-0977 gate-routing prompt.
- Guide-only (§3): I did not touch any live sheet; you/Minda instantiate per core.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
