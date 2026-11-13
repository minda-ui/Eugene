# RND-36 — Estate Library: principles + access table v0.1 (first proposal)

**LAB item — not evidence, not a Hub result. Advice only, not to be built to.** Eugene, 2026-11-13.
For review by **Sarah** (personal data, access), **Rachel** (finance), then **Minda** decides.
Built from what I know of the seats' charters and owner notes — every cell is a proposal; `?` = I don't know, owner to answer.

## 1. Principles (Minda, 13 Nov)
1. **The library is the safe; Google Drive is the desk.** The library is our own storage (pve-ai, ZFS), not Drive.
2. **Every registered document goes into the library** — no exclusions. Restricted items go into a restricted area, not left out.
3. **Nothing in the library is ever edited or deleted.** A changed document is stored as a new version beside the old one, and the change is reported.
4. **Three copies:** pve-ai + Beverley (off-site) + R710 (once rebuilt). Snapshots are locked — not changeable even with an admin login.
5. **Access is a separate layer:** who may **read** (look at the locked copy) and who may **receive** (get a labelled working copy, e.g. into their Raw/). The library never moves; only copies go out.
6. **Every "receive" is logged** (what, to whom, when, why) so the access audit (report D) can check it.
7. **Keys:** only Minda administers the library; one read-only job hands out copies; no AI seat has write access; the admin secret lives only in 1Password.

## 2. Areas (one label per document, set at registration)
| Area | What goes in | Example (FM pilot) |
|---|---|---|
| **General** | contracts, insurance, certificates, drawings, correspondence, compliance | FM0000001 insurance, FM0000013 structural calcs |
| **Finance** | accounts, tax, VAT, bank, loans, valuations, invoices | FM0000004 accounts, FM0000025 CT statement |
| **Personal** | documents about private individuals (tenants, staff, customers) | tenancy agreements (FP), Amfa customer orders |
| **SSAS** | pension scheme and member records | FS rows |
| **Restricted** | access credentials / ID notices, legal privilege, board-only | FM0000009 Gateway user-ID notice |

## 3. Access table v0.1 — R = read, C = receive a copy, – = no
| Who | General | Finance | Personal | SSAS | Restricted |
|---|---|---|---|---|---|
| **Minda** | R C | R C | R C | R C | R C |
| **Rachel** (finance) | R C | **R C** | ? (payroll?) | R (finance side) ? | – |
| **Peter** (mail triage, external registers) | R C | C on request ? | C on request ? | – | – |
| **Anna** (construction) | R C (FC, FM property) | – | C (site staff/RAMS) ? | – | – |
| **John** (properties) | R C (FP, FM) | C (property loans) ? | C (tenants) ? | – | – |
| **Nadia / Darius** (Amfa) | R C (FA) | – | C (Amfa customers) ? | – | – |
| **Laima** (entities) | R (all companies) | R ? | – | – | – |
| **Victoria / Alex** (coordination, housekeeping) | R | – | – | – | – |
| **Sarah** (compliance) | R | R | R | R | R ? (audit only) |
| **Eugene** (IT) | – (runs the job, never opens content) | – | – | – | – |
| **Fishbone AI** (staff use) | R (key-facts pages + General, per company) | – | – | – | – |
| **Andrejus's assistant** (secondary core) | C only, on request, logged | ? | – | – | – |
| **Irina's core** (secondary) | C only, on request (her companies) ? | ? | – | – | – |

**Defaults behind the table:** a seat sees its own companies, not all; finance is Rachel's; personal data only to the seat that works with those people; SSAS stays closed except Minda, Rachel (finance side) and Sarah (audit); secondary cores get **copies only, never read access** (existing owner rule).

## 4. Honest limits
- On **pve-ai** these rules can be enforced: the library job decides what it hands out.
- In **Drive** they stay paper rules while every seat acts as minda@ — real per-seat enforcement needs separate identities (raised 12 Nov).
- AI read access means **copies or summaries delivered to the seat**, not the seat browsing the library.

## 5. Questions for reviewers
- **Sarah:** is "personal → only the seat that works with those people" enough? Retention for personal data inside a library that never deletes?
- **Rachel:** may finance be copied into the library at all (policy §7b says the Financial Archive is its single home) — or is the library copy the archive's backup, not a second home?
- **Minda:** secondary cores (Andrejus, Irina) — copies only, case by case, as now?
