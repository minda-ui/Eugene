# Plan — Google Workspace consolidation & clean-up (for Minda's approval)

> **Guide-only / §3.** Eugene plans and verifies; **Minda (or a human admin) executes every console change.**
> No secret held. **Nothing changes before Minda approves.** Author: Eugene, 2026-10-14. Inputs: Rachel's
> mailbox clean-up brief (AWT-0653, 13-Oct user export + billing), the decided consolidation architecture
> (`Infra-Inventory/Workspace-and-Email-Inventory.md`), the IT security carry-over (AWT-0616), and the
> existing runbooks (Waste consolidation v0.4, Amfa DKIM/SPF/DMARC, Vault retention).
>
> **One rule above all: no email is ever lost.** Every removal exports/transfers the mail first, verified,
> before anything is deleted.

---

## 1. Where we are (current, from Rachel's 13-Oct export)

**Four paid Google Workspace subscriptions** (Rachel costed three; **Amfa is a 4th — confirm its billing**):

| Subscription | ~Monthly | Live users (paid seats) | Archived (still charged) |
|---|---|---|---|
| **Construction** (hub) | ≈ £134.46 + ≈ £14 archived | info@, minda@, ops@, andrej@, sebastian@, invoice@, nidjat@, info@holdings | enquiries@, anastasia@, nev@, lana@, vytautas@dry, yurii@ (6) |
| **Properties** (+Commercial) | ≈ £70 | info@, irina@, ops@, andrej@, commercial@ | dainius@ (1) |
| **Waste** | ≈ £56–70 | info@, sales@ | andrej@, lana@ (2) |
| **Amfa** (`amfa.uk`) | **confirm** | info@, enquiries@ | — |

≈ **£3,000/year** across the three Rachel costed. **Holdings** is already a secondary domain under
Construction (not a separate subscription). **SSAS** has no domain/Workspace.

**Must-not-break (Rachel/Peter connections + invoice path):**
- Rachel's Composio mailboxes: **`ops@`**, **`minda@fishboneconstruction`**, **`info@fishboneproperties`**, and now **`info@fishboneconstruction`** (AWT-0654, connected 14-Oct) — all four **stay real mailboxes**.
- **`ops@fishboneconstruction`** (Peter's agent identity) — stays.
- **`invoice@`** feeds **Dext → QuickBooks** (auto-forward to `mindaugas.gaudiesius@dext.cc`) **and** `ops@` (Peter, read-only), plus alias `invoice@fishbonedrylining.co.uk` — any change must preserve all three paths.

---

## 2. Objectives (in priority order)

1. **Cut cost, keep every email** — stop paying for seats nobody uses (archived users, dormant mailboxes).
2. **Simplify** — turn shared/near-empty mailboxes into free Google Groups or aliases where no one needs a login.
3. **Finish the decided consolidation** — fold the dormant **Waste** Workspace into Construction (runbook ready).
4. **Close the gaps** — deliverability (Amfa + Holdings SPF/DKIM/DMARC) and the security/governance carry-over (AWT-0616).

---

## 3. Workstream A — Quick wins (biggest saving, lowest risk, no architecture change)

Each row: **export the mail first → verify → then delete/convert.** Export method per §8.

| # | Mailbox | Action | How mail is kept | Est. monthly saving |
|---|---|---|---|---|
| A1 | **9 archived users** (enquiries@, anastasia@, nev@, lana@con, vytautas@dry, yurii@ · dainius@prop · andrej@waste, lana@waste) | Export each → **delete** the archived user | Vault export / data transfer to the owning company's KB `Archive/` before deletion | **≈ £14+/mo** (the "WORKSPACE ACC" archived-licence line) + frees seats |
| A2 | **nidjat@fishboneconstruction** (no sign-in since 13-Jun, 0.02 GB) | Export → **delete** user | Export his 0.02 GB; alias his address → ops@ if any residual mail expected | ~1 seat |
| A3 | **info@fishboneholdings** (0 GB, forward-only) | Convert to **free Google Group** or alias → Minda/ops@ | Nothing to keep (empty); it's a routing target only | ~1 seat |
| A4 | **commercial@fishboneproperties** (0.02 GB) | Convert to **free Google Group / alias** → info@fishboneproperties | Export the 0.02 GB first | ~1 seat (Properties) |
| A5 | **enquiries@amfa.uk** | Keep as-is **for now** (live intake → forwards to ops@, Hub AWT-0095) — revisit in Amfa workstream | n/a | — |

**Net of A:** removes ~10–12 paid/archived seats, keeps all mail. Exact £ depends on per-seat price — **Rachel/Minda read the real per-seat figure from each Billing page** (I can't see Billing; §10).

---

## 4. Workstream B — Waste → Construction (the one decided consolidation)

Waste is **dormant** (doesn't trade with outside customers — Rachel). Folding it in **kills the whole Waste
subscription (~£56–70/mo)**. Already fully decided (owner, 2026-09-15); **runbook v0.4 is ready**:
`Runbooks/Runbook-Workspace-Consolidation-into-Construction.md` (+ `Runbook-Waste-Migration-Execution-Checklist.md`).

Sequence (guide-only; Minda executes, I verify each step):
1. **Archive** `info@fishbonewaste` + `sales@fishbonewaste` mail/Drive into Waste's KB `Raw/` (Drive `1TlNINqtx8JU1Qe6152uqhEPZEvt7JN_C`).
2. Re-provision both under Construction (decided: both **stay live** under Construction — `sales@` becomes a normal mailbox/Group, see A/C; its Waste super-admin role falls away when the Waste subscription is cancelled, closing OI-5 for Waste).
3. **Remove** `fishbonewaste.co.uk` from the Waste Workspace → **add as a secondary domain** to Construction.
4. **Cut MX** (DNS wrinkle: Waste's nameservers point at **WordPress**, not IONOS — records change in the **WordPress DNS dashboard**; runbook Phase D/G).
5. **Cancel** the Waste subscription. Verify mail flow end-to-end.

Rachel's proposal #3 (`sales@fishbonewaste` → free Group forwarding to `info@fishbonewaste`) fits here —
after the fold-in, `sales@` can be a Group, not a paid seat.

---

## 5. Workstream C — How far to consolidate? (the one strategic decision for you)

Rachel's proposal #7 = "one Workspace, other domains as secondary, aliases per company." Here's the honest trade-off:

| Domain | Fold into Construction? | Recommendation | Why |
|---|---|---|---|
| **Holdings** | already done (secondary domain) | ✅ keep as is | dormant, zero cost |
| **Waste** | yes (Workstream B) | ✅ **fold in** | dormant, saves a whole subscription |
| **Properties (+Commercial)** | *could* (saves ~£70/mo) | ⚠️ **keep standalone for now** | genuinely active separate company (Irina + Andrejus work there daily); folding in muddies the governance line and makes them users under Construction. Saving is real but risk/effort is higher — revisit after the quick wins land. |
| **Amfa** (`amfa.uk`) | no | ❌ **keep standalone** | kept **sale-ready** (OI-13) — a standalone tenant is clean to carve out on a sale. Folding it in would have to be undone later. |

**Recommendation:** do **A + B now** (big saving, low risk), **keep Properties and Amfa standalone**, and
treat full Properties consolidation as a separate later decision once we see the post-clean-up cost. This
matches the 2026-09-13/15 architecture while capturing most of the saving Rachel is after.

---

## 6. Workstream D — invoice@ (handle with care — dependency-sensitive)

`invoice@fishboneconstruction` is where subcontractors send invoices. Minda is "happy with any alternative,"
but it has **three live dependencies** that must keep working or invoices silently stop arriving:
1. **Dext email-in** auto-forward → `mindaugas.gaudiesius@dext.cc` (→ QuickBooks).
2. **Forward → ops@** (Peter's read-only control check).
3. **Alias** `invoice@fishbonedrylining.co.uk` reaches the same mailbox.

**Before any change**, I verify (guide-only, from the Admin console with Minda) exactly what logs in/reads it
(Dext connection type — email-in vs API; any app password; forwarding rules). **Options, once verified:**
- **Keep it as a mailbox** (simplest, safest — one seat) — my default recommendation given the money path.
- **Convert to a Google Group** with external posting allowed, members = `dext.cc` + `ops@` — saves a seat **only if** Dext accepts mail from a Group and no app-password/API login is needed. Needs testing with a live test invoice before trusting.

**Do not change invoice@ until the dependency check + a test invoice both pass.**

---

## 7. Workstream E — Deliverability (so mail we send doesn't go to spam)

- **Amfa** (`amfa.uk`): DKIM/SPF/DMARC still pending → `enquiries@`/`info@` not safe for outbound yet. Runbook ready: `Runbooks/Runbook-Amfa-Email-DKIM-SPF-DMARC.md`. Do before Amfa sends customer mail.
- **Holdings** (`fishboneholdings.co.uk`, **OI-6**): SPF still references IONOS, not Google → add `include:_spf.google.com` in the 1&1/IONOS DNS panel. Low urgency unless Holdings starts sending.
- When Waste's domain moves (Workstream B), set its **SPF/DKIM/DMARC** fresh under Construction.

---

## 8. Workstream F — Security & governance (AWT-0616 + OI-5)

1. **Admin "unresolved security risk" notices** (9 & 12 Oct, to irina@): open Admin console → Security → review the flagged items (likely less-secure-app / suspicious sign-in / unenrolled 2FA) and resolve/acknowledge. I'll guide; Minda clicks.
2. **`all@fishbonedrylining.co.uk` Group moderator spam reports** (2/6/9 Oct): check the held queue — approve any legitimate mail, bin spam; tune the moderation setting so routine mail isn't held.
3. **Irina cross-domain sharing** + the duplicate **`EW37108579 - DPC.pdf`** in Properties `Raw/` she can't archive (cross-owner permission): fix the sharing scope; re-own or archive the duplicate (owner/admin action).
4. **Smartsheet "Changes to Tasks" alerts to info@ (near-daily):** turn off that notification in Smartsheet (the sheet's notification settings) — stops the noise.
5. **OI-5 (break-glass admin):** super-admin login = the shared business mailbox itself (anyone reading it has full admin). Advisory — recommend a **dedicated admin account + 2FA** as the break-glass identity, separate from `info@`. Your call.
6. **Export method for all deletions (Workstream A):** Google **Vault export** (where a Vault licence is held) or **Admin console → data transfer** (move Drive to another user) + **Takeout/Gmail export** for mail, landing in the owning company's KB `Archive/`. Verify the export opens before deleting the user.

Cosmetic: Construction org display name still reads **"Fishbone Drylining Ltd"** — rename in Admin console when convenient (no routing impact).

---

## 9. Order of work (safe sequence)

1. **Verify current state** with Minda in the Admin console (confirm the 13-Oct list still holds; read per-seat prices from each Billing page). *(Eugene can't see Billing — §10.)*
2. **Workstream F quick items** (Smartsheet alerts off; security notices reviewed; group spam queue) — immediate, no mail risk.
3. **Workstream A** — export → verify → delete archived users + nidjat; convert holdings/commercial to Groups. *(Biggest saving, low risk.)*
4. **Workstream D** — invoice@ dependency check + test; then decide keep-or-Group.
5. **Workstream B** — Waste → Construction (runbook v0.4), then cancel the Waste subscription.
6. **Workstream E** — deliverability (Amfa, Holdings, Waste-post-move).
7. **Revisit Workstream C** (Properties) once the new monthly cost is visible.
8. Rachel records the realised savings; update Infra-Inventory + close the Hub rows.

---

## 10. What Eugene can't see (needs Minda/Rachel)

- **Exact per-seat prices** — from each Workspace's **Billing** page (I have no billing access; Rachel asked for real figures — please read them so savings are exact, not estimated).
- **Live current state** — the user list is Rachel's 13-Oct export; confirm nothing changed since.
- **invoice@ dependencies** — exact Dext connection type + any app password (confirm in Admin console with me).
- **Amfa billing** — Rachel costed three subscriptions; confirm Amfa's cost/fate (recommend standalone, OK to leave out of the saving total).

---

## 11. Decisions I need from you

1. **Consolidation depth (Workstream C):** confirm **A + B now, keep Properties & Amfa standalone** (my recommendation), or do you want Properties folded in too?
2. **invoice@ (Workstream D):** happy for my default (**keep it a mailbox** unless the dependency check shows a Group is safe), or do you want it converted regardless?
3. **Andrejus's 3 addresses:** does he need **`andrej@fishboneproperties`** as a separate paid seat, or alias/Group it?
4. **OI-5 break-glass admin:** set up a dedicated admin account + 2FA, or leave as-is?
5. Go-ahead to **start with Workstreams F + A** (the no-regret wins) while the rest is confirmed?

_On your approval, Eugene delivers this plan into Rachel's `Raw/` and updates AWT-0653/0616; execution is
guide-only, one step at a time, mail exported and verified before any deletion._
