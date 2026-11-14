# RND-36 — Pilot: Fishbone Commercial Properties (FM) — library design + key-facts draft

**LAB item — not evidence, not a Hub result. Advice only, not to be built to.** Eugene, 2026-11-13.
Sources (read-only, 13 Nov): Document Register, all 28 FM rows (not sampled); FM Property Register
(8289112509515652, 2 rows). Nothing copied, moved or changed. Finance values are pointed to, not copied.

## 1. The 28 FM documents, sorted for the library
| Library area | Documents | Count | Copy automatically? |
|---|---|---|---|
| **General** (open to the FM team + AI) | FM0000001–03 insurance; FM0000008 building-control letter; FM0000010 certificate of incorporation; FM0000013–15 structural package | 8 | yes (Drive id) |
| **General, email-only** | FM0000016 email to Building Control | 1 | **no** — save the .eml first (already an open follow-up in the register) |
| **Finance** (Rachel + Minda only; Financial Archive is the working home) | FM0000004–07, 11, 12, 17–28 accounts, CT600s, CT statements, VAT, valuation | 18 | yes, into the finance area only |
| **Restricted** (Minda only) | FM0000009 Government Gateway user-ID notice (an access credential notice) | 1 | yes, restricted area — or leave out entirely (Minda decides) |
| **Total** | | **28** | **27 now, 1 after the .eml is saved** |

## 2. What the pilot job does (nightly, read-only)
1. Read the FM rows of the Document Register (paged, `isSampled:false` checked).
2. For each **Issued** row with a Drive id: download by Source key (read-only Drive access, same pattern as the Drive mirror in CT 210).
3. Save as `library/<area>/FM/<Document No>__<sha256-12>.<ext>` on pve-ai (ZFS dataset per area). **Never overwrite** — if the file changes, a new file with a new hash appears next to the old one, and the change is reported.
4. Write a run report (Lab folder for the pilot): copied / unchanged / **changed** / missing / no Drive id.
5. ZFS snapshot daily, kept 90 days; datasets in the nightly PBS backup.

**Proof it's needed, from the FM register itself:** FM0000008's source file "in the immutable Raw/" was **replaced under the same name on 8 Sep 2026** (2,127,628 → 784,555 bytes), and nobody can explain why. The filed copy now holds the shorter version. A locked library with hashes would have kept the original and flagged the change the next night.

## 3. Draft key-facts page — FM (generated from the registers; would be rebuilt nightly)
> **Fishbone Commercial Properties Ltd** · company **13687238** (incorporated 19/10/2021, FM0000010) · VAT-registered from 01/03/2023 (FM0000011, FM0000027) · prefix **FM**
>
> **Property:** **FM2301** — 145 High Street East, Wallsend NE28 7RL. Freehold of the whole two-storey building: ground-floor retail unit let to Food Land; upper-floor flats 2 & 2A Ferndale Avenue held on a lease by **Fishbone Properties Ltd** (their FP 2202). FM, as freeholder, is responsible for the structure and is carrying out structural works (estimated completion 01/11/2026, owner statement 03/09/2026).
>
> **Structural works:** Studio Structure package 049-25 (FM0000013–15); Building Control pre-submission 26/01250/PRESUB (FM0000008, FM0000016).
>
> **Insurance:** property owners policy via BQI Group (FM0000001–03).
>
> **Finance (pointers only — values live in the Financial Archive):** accounts to 30/04/2025 (FM0000004, FM0000017); CT returns and HMRC statements (FM0000006, 18–19, 21, 23–26); VAT returns (FM0000028); SSAS loanback secured on FM2301 (valuation FM0000007).
>
> **Gaps on file:** lease of the flats; EPC, EICR, gas, fire risk, asbestos; insurer and policy number not copied into the property register though FM0000001 holds them.
>
> *Built from: Document Register (28 rows) + FM Property Register (2 rows), 13/11/2026. Every line cites its document number.*

## 4. What the pilot already shows about "not working together"
| Finding | Example |
|---|---|
| Registers don't feed each other | Property register says "insurer, policy number not on file" — but FM0000001 (registered 2 Sep) holds them |
| Originals are not safe | FM0000008 source replaced under the same name |
| One ID, two rows | FM Property Register uses **FM2301** for both rows (the building and the reference-only leasehold row) — fine for people, ambiguous for software |
| Email-only items | FM0000016 has no file copy |
| Credential-type documents in the general flow | FM0000009 (Gateway user-ID notice) sits with ordinary compliance documents |

## 5. To run the pilot (all later, all Minda's go)
- A read-only Drive login for the library job (could reuse the Drive-mirror pattern — Minda creates it).
- Three ZFS datasets on pve-ai (`library-general`, `library-finance`, `library-restricted`) with access set per area.
- Decision on FM0000009 (restricted copy or excluded).
- Owners' feedback first (requested 13 Nov: Victoria, Laima, Rachel, Sarah, Anna).

## 6. Principle set by Minda (13 Nov): EVERY document goes into the library
"All documents need to go to library. Then which documents people or AI employees can read or receive — that's what we need to design."
- **Storage is complete:** every registered document, every area, no exclusions (FM0000009 included, kept in the restricted area).
- **Access is a separate layer**, designed next: who may **read** (look at the locked copy) and who may **receive** (get a labelled working copy, e.g. into their Raw/), per document area, per person or AI seat.
- The library itself is never edited by anyone; access rules decide only who sees or gets what.
