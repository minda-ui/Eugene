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

## Minda's decisions on the fold-in list (same session, 2026-10-30)
Minda answered the closing decision list:
1. **Pilot = FC2614** (Macdonald) — not FC2611 (whose programme ends 29 Oct, Anna's caution). Phone + chat,
   no fixed cameras for the pilot.
4. **Label naming:** job labels should key off the **FC job number** (e.g. `FC2614`, `SM/<name>`), not Peter's
   `FG/Job/` wrapper. Recorded as her steer; flagged that `FG/` is the shared estate mail-label standard
   (Peter's Gmail + Victoria's convention), so the change is applied **by Peter/Victoria inside that standard**
   — Eugene does not rewire Peter's label scheme, and no labels are built before privacy is settled anyway.
5. **SM authority = £500 start** for every SM.
6. **Create** the Register Site-manager column + the Marketing-Footage folder.

## What was created (structure only; guide-only §3)
- **Project Register `5250912102778756`** — added a **"Site manager" PICKLIST** column (options Sebastian /
  Nev / Dainius / Andrejus / Minda) at index 27, **col id `4239425787266948`**. It's the responsible *human*
  SM (distinct from "Lead assistant", the AI); **Anna fills/keeps it from Set-up**, Peter reads it live to
  route project mail. Structure only — Eugene built the sibling delivery registers (ledger 115), so this is
  build-work, not a system-of-record data write; no row data touched.
- **Collaboration Space** — created **`Marketing-Footage/`** (id `1KnnqHqDkGyby4dThbvGV2tkFJ8E3FZGD`, parent
  `1YNj5BIpKVzcmI4U1DRkgu7kcnSDizGEi`) with a pilot **`FC2614/`** subfolder (id
  `1zyy9Cjk0tA9dfKAqfQuxU9c_zUo_qQjV`). Empty structure only; **write-access / sharing left to Minda**
  (sharing is guide-only, §3).

## Docs updated
- `construction-sm-authority-matrix.md` — Table B set to **£500 start** for every SM (spend + variation),
  title/notes de-drafted, "To finalise" #1 ticked; channels still TBC.
- `construction-project-vision.md` — pilot = **FC2614**; Peter routing subsection re-labelled to the **FC**
  job-number scheme; closing section split into **Decided (2026-10-30)** vs **Still open**, with the created
  column + folder ids.

## Still parked / open after today
- **Privacy / DPIA / notice / retention** (Minda + Victoria, AWT-1036) — the capture build stays parked.
- **Cost-flag + request rule** + the **one QB job-coding rule** (Rachel's gaps).
- **Peter's label grants** (§2e, FC-keyed) + digest-vs-filtered-access + attachments decision.
- Each SM's **channel**; the Marketing-Footage **write-access** (Minda sets sharing).

## Saturday: finish DocuSeal (Minda's add, 2026-10-30)
Minda: "one more thing for Saturday — finish with DocuSeal." The SMTP + wire-Anna steps were already written
and READY (`Runbook-DocuSeal-SMTP-and-Wire-Anna.md`, OI-21 a+c, since 2026-10-12); added them to the Saturday
day-plan as **PART 5** with the build-day ordering + two Saturday-specific risks:
- **DocuSeal is VM 106 on the Gen9** being opened Saturday → it's **down during the PART-3 power window**. So
  PART 2's backup now names **VM 106** explicitly, and PART 5 runs **while DocuSeal is up** — ideally in the
  morning alongside PART 1 (storage, zero phone risk), or else after PART 4 restores the Gen9.
- **The Workspace SMTP-relay admin change can take up to ~24h to propagate** → flagged to do the relay config
  + app password (Part A1/A2) **the day before**, so Saturday is just point-DocuSeal-at-relay → sign test →
  wire Anna.
PART 5 steps: Workspace relay (Fri) → DocuSeal SMTP + Send-test → full internal sign test on our box (tagged
Sample-RAMS .docx → signed PDF + audit) → wire Anna (API token + env; Anna self-wires per AWT-0589) → verify
from an Anna session → **graduate RND-8 + close OI-21 (a)+(c)**. Secrets Minda-held in 1Password (§3). Ledger
146.

## Next
- Commit + push `claude/lucid-mayer-nsoili`; Drive-sync the R&D docs + the Saturday runbook + this log + ledger
  + current-state (byte-verified).
- When Minda settles privacy (AWT-1036): unpark the FC2614 capture pilot build.
- **Saturday:** storage pool + Gen9 brain + **finish DocuSeal (PART 5)**.
