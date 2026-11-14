# Eugene to the team, 14 Nov 2026 (afternoon): Estate Library, Minda's follow-up decisions F1–F4 (RND-36)

**LAB, data not an order. No Hub row (Lab rules).** To: Sarah, Laima, Anna, Rachel, Victoria.
Thank you, Sarah, Laima and Anna, for your replies this morning. Minda went through them one by one.
Decision log: git `R&D/lab/rnd-36/Library-Principles-v1-decisions.md`. Principles v2: Drive `1ON4KXFnVnQFAtnfYrRgpCDZ-cYprFSAL`.
**Nothing is built and nothing changes on a live system** until Minda's separate go for the FM pilot.

## Minda's decisions
| # | Decision |
|---|---|
| F1 | **Sarah's access amendment text approved** (her draft `1uFpLACg9mBPLNqZHiOE6y-tGr-cpbx6E`) with one change — condition 2 reads: *"My monthly sample is my compliance check; the independent outcome check is Alex's quarterly sample (D3)."* Takes effect only when the library exists and Alex records the Authority Register row. Design note (Eugene): Sarah receives read-only copies of her sample from the library job, logged as her access. |
| F2 | **Retention schedule v0.1 approved as the baseline** (`1P5W9UszS3sMnugkGjzpYvI8w1HJijJt_`): R2/R16/R19 Permanent kept; R8 SSAS kept as drafted, unconfirmed — Minda asks the scheme administrator; R13/R22/R25 kept; +2 personal data only on R5, R7, R9, R10, R13, R14, R23; Anthill Homes same schedule for the library's copies. **Safety line: the schedule stays "unconfirmed"; nothing is removed under any line until that line's legal source is checked.** |
| F3 | **Key-facts stale period:** fixed facts (company number, incorporation date, title deeds) **12 months**; every other line **90 days**. Deadlines flag themselves. |
| F4 | **Sensitivity scale — five levels** (blank = fail; highest level wins; default per document type; owner may raise, lowering needs four eyes): |

| Level | Covers | Copies to | Fishbone AI |
|---|---|---|---|
| **Open** | public / harmless (programmes, standards, identity facts) | any group seat | yes, Verified only |
| **Restricted** | business-confidential (drawings, contracts, quotes, permits, reports) | owner seat + named seats | only via key-facts pages, not the document |
| **Personal** | contains personal data (signed RAMS, inductions, CSCS, tenancy, staff files) | only the seat working with those people | never |
| **Finance** | accounts, tax, VAT, bank, loans, valuations | Rachel + Minda | only Finance-page pointers |
| **Minda only** | SSAS, access-credential notices, legal privilege | Minda | never |

## Next for each of you (no deadline set by Minda)
- **Sarah:** retention schedule **v0.2** — map each document type in the group Document Register to an R-line; update condition 2 in your access text as above.
- **Laima:** in template v1.0, **label the fixed-fact lines** (12-month stale period) — everything else 90 days.
- **Anna:** your FC defaults **map directly** to the five levels (Open / Restricted / Personal) — please confirm, and send the FC clean-up list when ready.
- **Rachel:** please set the **Finance-level defaults** per finance document type (and say if any finance type should be Personal or Minda only).
- **Victoria:** please add the **Sensitivity field values** (Open / Restricted / Personal / Finance / Minda only) to the one Change Request, alongside the items in my 14 Nov morning note.

Eugene. Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) and s3.
