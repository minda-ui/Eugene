# Change log — 2026-10-30 — RND-22 construction vision: all four owner scopings folded in

_Eugene, guide-only (§3). Git + Drive only; nothing installed, no live-system change, no secret held._

## What happened
On 28 Oct the RND-22 construction-project vision was scoped with four domain owners via their Raw folders.
Over 29–30 Oct all four replied. Minda asked, in turn, to check for each reply (Peter first, then Helen —
Helen's landed last, 30 Oct 00:07), then said **"Fold all four into RND-22 now."** Done: every answer is
now folded into `R&D/construction-project-vision.md`, each attributed inline to its source and AWT.

## The four replies, and where each landed in the vision
- **Anna** (construction domain — AWT-1035 Telegram pilot / AWT-1037 vision):
  - **Lifecycle table** replaced with Fishbone's own stages (the `project-lifecycle` skill): Enquiry → Quoted
    → Ordered → Set-up → On site → Handover → Snagging → Closed/Lost, with per-stage "what matters most"
    (Quoted = price basis + exclusions; Ordered = PO/written acceptance before work, PM-3.4; Set-up = RAMS/
    permits/current-rev drawings/CSCS; On site = permit cover every shift + daily progress vs programme +
    materials on site; Closed = close-out + lessons).
  - **New H&S subsection** ("What the site-vision sentinel flags"): the real photo flags (PPE, working at
    height, blocked access/escape, housekeeping, missing permit/isolation signs, unsafe stacking, unguarded
    openings); the flag is always **"check", never "pass"** — a photo can't show competence/permit validity/
    RAMS compliance; everything flagged goes to a person; the vision **does not certify** and **does not
    replace a competent H&S adviser** (CDM 2015 regs 8 & 15; Charter-Rules 0i). Progress signals measured vs
    the programme + quote basis, never guessed from a photo.
  - **Record shape** block added to the capture layer: one feed item = date·time·project·sender·type·text·
    photo-link, each type routing to its register (progress/materials/operative/risk/comms/permits); drawings
    and RAMS never filed from chat (DR-/FC numbers); a person confirms every register entry, the feed only
    drafts.
  - **Pilot** corrected: **not FC2611** (its programme ends 29 Oct) — the next job starting after privacy is
    settled, phone camera + site chat, **no fixed cameras for the first pilot**.
- **Rachel** (finance — AWT-1039): new **"Cost intelligence — how it actually works"** subsection — budget
  lives in Smartsheet (Classifier codes L/M/P + Health formula), not QuickBooks; actuals lag (hand-entered
  from invoices, only `Completed` rows count); QB job-coding not yet uniform → join is Smartsheet plan +
  QB/invoice actuals, no ready QB report; read-only pull yes for the budget; flag signals in order; the
  request→cost-flag rule (within-budget auto-note / over-or-no-code flag to SM+Minda / never orders or pays);
  Amber/Red/Trend overrun thresholds; where figures land (weekly per-job + portfolio column, "internal
  management figures, not accounts"); the gaps (commitments list, plan phasing/%-complete, one QB job-coding
  rule, payroll-per-job).
- **Peter** (inbox triage — AWT-1040): new **"Project email → SM routing"** subsection — classify by job on
  signals in reliability order (FC number / client code / thread automatically; sender+site only when exactly
  one live job fits, else `FG/Job/unclear`); needs `FG/Job/` + `FG/SM/` label families (§2e grant); the
  Project Register needs a **Site-manager column** (Anna fills at Set-up, Peter reads live); mechanism phase 1
  = label + daily digest draft per SM (he can't send/forward), phase 2 = filtered read access (Eugene builds);
  attachments via a pointer in Anna's Raw; never-route-to-SM list (money/legal/signatures/security/personal
  data) + gate red-flag patterns.
- **Helen** (marketing — AWT-1038): the **marketing section** rewritten with her capture spec — content types
  (time-lapse, fixed-frame before/during/after stills, social clips, private client reel); one wide fixed
  view locked once placed, 4K/1080p landscape, one still every 5–10 min, keep originals, no burnt-in
  timestamp on the master; out-of-frame list (faces/plates/neighbours/signage/screens/paperwork); best
  showcases = the branded retail fit-outs (live-ones = Minda/Victoria to say); `Marketing-Footage/<project>/`
  folder in the Collaboration Space; consent/release = Minda+Victoria, she drafts only from cleared footage
  and publishes nothing.

## Diagram
`R&D/construction-project-vision.mmd` provenance comment bumped to "owner-confirmed 2026-10-30". The diagram
is the high-level loop; the register set, SM gate and 3-way camera use it already shows were exactly what the
owners confirmed, so no structural change / no PNG re-render was needed. (Offered to refresh the HTML page's
notes panel with the attributions if Minda wants them visible there.)

## Closing section rewritten
"What to confirm with Anna" → **"Owner inputs — folded in and what Minda must now decide"**: pilot job +
phone/chat; privacy/lawful-basis/DPIA/notice/retention with Victoria (AWT-1036, build parked until settled);
the cost-flag + request rule + one QB job-coding rule; Peter's label grants + mechanism + attachments
decision; per-SM authority £ limits + channels; the Register Site-manager column + the Marketing-Footage
folder. Plus the still-missing data owners must create (commitments list, plan phasing/%-complete, payroll
per job).

## §3 posture
Guide-only throughout. Design/record work in Eugene's own KB; no other KB edited (the four replies were read
from Eugene's own Raw, where the owners filed them under §1); no live system touched; no secret held. The
build itself stays parked until Minda settles the decisions above — privacy (AWT-1036) first.

## Next
- Minda's decisions (the closing section).
- Commit + push `claude/lucid-mayer-nsoili`; Drive-sync the vision doc + this log (byte-verified).
- When Minda says go: build the Register Site-manager column + the Marketing-Footage folder; then the P1
  construction builds once the brain hardware (Saturday) is in.
