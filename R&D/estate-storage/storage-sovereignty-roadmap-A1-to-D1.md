# Storage sovereignty roadmap — A1 now → D1 goal

> **Eugene, 2026-10-28 (guide-only, §3).** **DECIDED (Minda):** start at **A1** (Google Drive stays the main
> store; the NAS is a backup + the brain's local read-cache) and move, stage by stage, to **D1** (fully
> sovereign — everything on-estate, Google Drive dropped, the cloud AI on a custom connector). Each stage is
> independently useful and **reversible until the final cutover.** Minda executes + holds all creds; Eugene
> designs + writes config + verifies; never trash — archives + snapshots only. Options context:
> `project-storage-options-full.md`; sync mechanics: `project-sync-design-proposals.md`.

## Why this path is the right one
A1 changes **nothing** for humans or the AI workforce today, yet immediately buys an **off-Google backup** and
**local files for the brain** — both valuable regardless of the destination. D1 is then reached by *adding*
capability (not ripping anything out) until Drive is simply no longer needed. The one real build on the way is
**the custom AI connector** (there's no off-the-shelf Nextcloud/WebDAV connector for the cloud Claude Code
seats); everything else is configuration.

## The stages
| Stage | State | Delivers | Needs | Gate to next | Reversible? |
|---|---|---|---|---|---|
| **0 = A1** (now) | Drive primary; **NAS = one-way Drive→NAS backup + brain read-cache** | off-Google backup + local files for the brain; **nothing changes for anyone** | NAS pool live (Sat/Gen10) + rclone Drive→NAS + ZFS snapshots/PBS | NAS verified holding a good copy | **fully** (NAS is just a copy) |
| **1** | Drive primary; **Nextcloud live on NAS** as a 2nd path; snapshots/PBS protecting it | humans/brain can start using the NAS/Nextcloud alongside Drive; versioning local | Nextcloud (C1 layer) | humans comfortable on Nextcloud | fully |
| **2** | **NAS co-primary (B3 federated)** | CAD/photos authored on NAS→Drive; cloud-AI/remote outputs Drive→NAS; the brain works locally | the hardened two-way/partitioned rclone (B3+A) | the brain is doing real on-site work (less cloud-AI file dependence) | yes (Drive still a full copy) |
| **3** | **Build the sovereignty enabler** | the **custom Nextcloud/WebDAV MCP connector** for the AI seats, **dual-run** beside Drive (pilot: one seat) | engineering: the connector + per-seat wiring | connector proven across all seats | yes (Drive still live) |
| **4 = D1** | **Sovereign** — Drive dropped as primary | all data on-estate; AI on the connector; Nextcloud the human/brain home; Beverley the off-site | everything above + Drive's free features replaced (below) | — (this is the destination) | **point of no return** — keep a final Drive cold export |

## The long-poles (what actually paces the journey)
1. **The NAS + brain hardware** (RND-3 storage, RND-20 Gen10, RND-2 P40s) — in progress; A1 starts the moment the pool is up.
2. **The on-site brain doing real work** (the AI-machine build list) — the more the local brain handles (vision, RAG, summaries on-site), the **less the cloud AI needs Drive**, which is what makes dropping Drive painless.
3. **The custom AI connector** (Stage 3) — *the* blocker for D1. No off-the-shelf exists, so it's a real build: a Nextcloud/WebDAV MCP each AI seat uses in place of the Drive connector. Everything else is config.

## Before D1 can happen: replace what Drive gave us for free
Drive isn't just storage — dropping it means the estate must cover what it provided. Good news: the estate
build we're already doing covers each one:
| Drive gave us free | Replaced by | Status |
|---|---|---|
| Versioning / undo | **ZFS snapshots** (hourly/daily) | RND-3 ✓ planned |
| Off-site copy | **Beverley Gen10** (pull replica) | Beverley node ✓ planned |
| Share links | **Nextcloud** sharing | C1 layer |
| Mobile / sync clients | **Nextcloud** apps | C1 layer |
| The cloud AI's file access | **custom connector** (Stage 3) | **to build — the long-pole** |
| "Someone else runs it" | we run it (Proxmox/ZFS/PBS + the runbooks) | the estate discipline |

**D1 is only safe once every row above is ✓.** That's the real go/no-go checklist.

## Immediate next step (Stage 0 / A1)
As soon as the storage pool is up (Saturday on the R710, then the Gen10): stand up the **one-way Drive→NAS
sync** — `rclone sync GDrive:Projects → /nas/Projects`, scheduled, `--backup-dir` + `--max-delete` guard +
`--check-access`, verified with `rclone check`, on ZFS snapshots. That is A1 live: Drive unchanged for
everyone, the estate now holds its own continuous copy, and the brain has local files to work. (I can write
this runbook next.)

## Guardrails
- **Reversible until Stage 4** — Drive stays a full copy the whole way; a wrong turn is just "keep using Drive."
- **Never trash** — archives (`--backup-dir`) + ZFS/PBS snapshots underneath every stage.
- **D1 go/no-go = the replacement checklist above all ✓** — above all the AI connector proven across seats and
  a non-Google off-site copy live (Beverley).
- Guide-only (§3): Minda executes + holds the Drive OAuth + all creds; Eugene designs/writes/verifies.

---
_Guide-only (§3). A1 now → D1 goal, reached by adding capability not ripping it out. The custom AI connector
is the one real build; the rest is config + the estate hardware already planned. Pairs with RND-2 (brain),
RND-3 (storage), RND-20/Beverley (off-site), OI-26 (backups), the AI-machine build list, and the storage
options/sync docs._
