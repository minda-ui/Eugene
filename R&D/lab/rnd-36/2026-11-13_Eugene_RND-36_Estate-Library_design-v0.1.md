# RND-36 — Estate Library: map of what exists + design v0.1

**LAB item — not evidence, not a Hub result. Advice only, not to be built to.** Eugene, 2026-11-13.
Read-only research: Drive search, the group policy, the master index, a sampled read of the Document Register.

## 1. Finding: most of the library already exists
| Piece | Where | What it already does |
|---|---|---|
| **Numbering + filing policy v1.5** (locked, group-wide) | Group KB `Wiki/Process-Document-Numbering-and-Filing.md` | One register, one ID, one stored file; dedup on entry; prefix per company (FC/FP/FH/FW/FA/FM/FS/FG) + 7 digits; change via a review loop |
| **Document Register** (the catalogue) | Smartsheet 7352854736144260, "Fishbone Group - Documents" | **396 documents** registered; columns Document No, Entity, Direction, Date, Category, Title, Entities involved, Description, Status (Draft/Issued/Superseded/Void), Source key, File link, Location |
| **Master index** | Group KB `Wiki/00_INDEX.md` | "Where each thing lives": the system of record for every topic (property registers, loans, SSAS, Amfa, workshop, finance, QuickBooks…) |
| **Change Requests** | Smartsheet 8918834172004228 | How the policy gets improved |
| **Working files** | Collaboration Space (per company / per project `Documents/`); Financial Archive (finance only, Rachel) | Where people actually work |
| **Owners** | Each company KB + seat (Anna, Rachel, Peter, John, Nadia, Darius, Laima…) | Each appends its own register rows |
| **Spine registers** | Project Register (FC26xx), Property Registers (FP/FM 4-digit codes), Machinery, Drawing, Asset, Authority, Build | Topic indexes |

**Alexey's 1983 method is already the house method:** company prefix + running number (`FC0000072`), incoming/outgoing in one register, "case closed → archive" as Status Superseded/Void. The Project/department part of his number lives in the folder (filed with its project) and the Project Register.

## 2. What is missing (the "not working together")
| # | Gap | Evidence |
|---|---|---|
| G1 | **No locked originals.** The only copy is the working copy in Drive. | Collaboration Space: writer = whole construction domain + 3 outside accounts (Victoria's check, 4 Nov). Anyone with access can overwrite or delete. |
| G2 | **"Checked" is not recorded.** Status says Issued, not *who checked it, against what, when*. | Register columns (above). |
| G3 | **Facts are not a layer.** Key facts (directors, addresses, titles, contracts, lines, systems) live in prose across KBs and `Org-` articles; nothing machine-readable per company. | 00_INDEX + Org- articles. Our own HQ "Wavenet" misname lived for months for this reason. |
| G4 | **Registers don't point at each other by ID.** Document ↔ Project ↔ Property ↔ Asset links are free text. | Location / Description fields. |
| G5 | **AI cannot use it.** Fishbone AI has only Minda's private Drive copy; no per-company, checked, read-only collection. | RND-35 tests: accuracy came from facts given, not the model. |
| G6 | **The register itself is sampled on read** (`isSampled: true`, 54 of 396) — every reader must page it fully. | Rachel's standing rule (HL), confirmed again today. |

## 3. Design v0.1 — four layers, three of them exist
```
  Working copies (Drive)  ──register row──►  Document Register (catalogue)  ──nightly──►  Locked library (pve-ai)
  Collaboration Space,                        + 4 new columns                              ZFS, read-only, snapshots
  Financial Archive                                                                        one file per Issued row
                                                      │
                                                      ▼
                                           Key-facts pack per company  ──►  Fishbone AI collections (read-only, per company)
```
1. **Catalogue = the Document Register (exists).** Proposed 4 new columns (a policy change → Change Request, Victoria/Minda decide): `Checked by`, `Checked on`, `Sensitivity` (Normal / Personal / Financial / SSAS), `Library hash` (sha256 of the locked copy).
2. **Working copies stay where they are (exist).** No migration; people keep working in Drive.
3. **Locked library on pve-ai (new, small).** A nightly job (same pattern as the Drive mirror, CT 210, read-only Drive scope) copies the file of every **Issued** row by its Source key into `tank/library/<entity>/<Document No>.<ext>`, records its sha256, never overwrites (a changed file = a new version file), ZFS snapshots kept. Read-only to everyone; covered by PBS. **Financial and SSAS rows go to a separate dataset** with tighter access (Rachel / Minda only).
4. **Key-facts layer (new, generated).** Per company, one short machine-readable page built **from** the register + property / project registers + the `Org-` article — never typed separately. It replaces the hand-made estate facts pack and feeds Fishbone AI per-company collections.

## 4. Decisions for Minda (in order)
1. **Agree the shape:** register stays the catalogue, Drive stays the workspace, pve-ai holds locked copies, facts are generated. (Yes / change.)
2. **Owners:** policy and register changes → Change Request to the group KB, Victoria coordinates; entity facts → Laima; finance/SSAS rows → Rachel; library job + storage → Eugene.
3. **Pilot:** one company first. Suggest **Fishbone Commercial Properties (FM)** — few documents, one property, clean.

## 5. Not decided / not checked
- Full register read (only 54 of 396 rows sampled today; full paged read needed before any count is cited).
- Whether `pve-ai` access for staff (read-only browse of the locked library) is wanted, or AI-only.
- Personal-data handling inside the library (SSAS members, tenants) — needs Sarah's view.
- Depends on per-seat identities (RND-36 note) for true read-only enforcement in Drive; the pve-ai copy is read-only regardless.
