# Project storage — the full option space (where the files live + how everyone reaches them)

> **Eugene, 2026-10-28 (guide-only, §3).** Every realistic option for where the project folders live and how
> all four actors reach them — including **Google Drive as the main store**. For choosing the operating model;
> the two-way *sync* mechanics (if we sync) are in `project-sync-design-proposals.md`. Minda executes + holds
> all creds; Eugene designs + verifies.

## The constraint that rules everything (verified 2026-10-28)
The four actors don't have equal reach:
| Actor | Can reach Google Drive? | Can reach the on-site NAS? |
|---|---|---|
| Humans at HQ | yes | **yes** (LAN) |
| On-site brain (local AI) | yes (download) | **yes** (fast, local) |
| **Cloud Claude Code employees** (Anna, Peter, Eugene…) | **yes** (Composio Drive connector) | **no** — can't see the private LAN |
| Remote humans | yes | via Tailscale/Nextcloud |

**There is no ready-made Composio Nextcloud/WebDAV connector** (checked — it falls back to Google Drive tools).
So **the cloud AI workforce is tied to Google Drive as its file surface.** Consequence: *unless we build a
custom connector, Google Drive must hold a live copy of anything the cloud AI employees touch.* This is what
makes "drop Drive entirely" a real project, not a setting.

---

> **DECIDED (Minda, 2026-10-28): A1 now → D1 goal.** Start Drive-primary (zero disruption, reversible,
> immediate off-Google backup + local brain files); move stage-by-stage to full sovereignty (drop Drive, AI on
> a custom connector). The staged path, long-poles and D1 go/no-go checklist are in
> `storage-sovereignty-roadmap-A1-to-D1.md`.

## The options (by where the source of truth lives)

### A. Google Drive = main store (least change)
**A1 — Drive primary, NAS = backup + brain read-cache.** Drive stays the single source of truth (as today).
The NAS runs a **one-way Drive→NAS** pull so the brain has fast local copies for vision/RAG, and as an
off-Google backup. Everyone writes to Drive as now.
- ✅ Zero migration, nothing changes for humans or the AI workforce; Google owns versioning/sharing/uptime.
- ❌ Not sovereign (data lives at Google); brain depends on internet + the download; big CAD/photo sets are
  slow over the wire; ongoing Google storage cost; no local-first.

**A2 — Drive primary, NAS = smart cache (`rclone mount` + VFS cache).** Drive is truth; the NAS *mounts* Drive
as a local filesystem, cached for speed, writes flushed back to Drive. "Drive main, NAS as a fast lens on it."
- ✅ One source of truth (Drive), local-speed reads, writes go to Drive, brain + HQ see a normal folder.
- ❌ Cache/write-back complexity; still internet-dependent; a mount glitch needs care; not sovereign.

### B. NAS = main store, Drive = synced copy (balanced)
**B1 — NAS primary, Drive one-way copy (NAS→Drive mirror).** NAS is truth; Drive is a read copy + off-estate
backup. Cloud AI **reads** Drive; its *outputs* go to Smartsheet + KBs (not into project folders).
- ✅ Sovereign + local-first + fast brain; simple (one-way, no conflicts); Drive still backs it up + serves
  cloud AI reads.
- ❌ Cloud AI/remote can't *write* back into project folders (only read) — fine if they never do.

**B2 — NAS primary, Drive two-way synced copy.** NAS is truth; Drive is a live two-way mirror so cloud
AI/remote can write back too. (This is what you picked; robustness design = `project-sync-design-proposals.md`,
recommended backbone **partitioned single-writer + hardened rclone**, on ZFS/PBS.)
- ✅ Sovereign + local-first + fast brain **and** cloud AI/remote can write; Drive = off-estate copy.
- ❌ Two-way = conflict surface → needs the 3-layer robustness (partition + never-lose + rollback).

**B3 — Dual-home / federated (per-dataset natural home).** Each dataset lives where it's authored: CAD/photos
on the NAS (→Drive copy), cloud-AI/remote outputs on Drive (→NAS copy). Two-way overall, each leg one-way.
- ✅ Conflict-proof by design; each thing lives where it's actually worked; robust.
- ❌ Needs a "who-authors-what-where" convention.

### C. Nextcloud = the hub (unify the human/brain view)
**C1 — Nextcloud primary on the NAS + Drive mirrored via rclone.** Nextcloud gives humans/brain real-time,
versioned, mobile local sync; rclone bridges it to Drive (where the cloud AI still works). (= Proposal C.)
- ✅ Best human UX (clients, mobile, sharing, built-in versioning) + sovereign primary + Drive for cloud AI.
- ❌ Most moving parts (Nextcloud + DB + rclone); Drive leg still scheduled.

**C2 — Nextcloud primary with Google Drive *mounted into* Nextcloud (external storage).** One Nextcloud
namespace; Drive appears as a subfolder/backend. Humans/brain see everything in Nextcloud; the cloud AI hits
the same Drive the external-mount points at.
- ✅ One unified human view; Drive stays the AI-facing backend without a separate sync job for that part.
- ❌ External-mount two-way semantics are fiddly; Google-native files still don't round-trip; still Google in
  the loop for the mounted part.

### D. Full sovereignty — drop Google Drive
**D1 — NAS/Nextcloud only; re-point the AI workforce off Drive.** Everything on the estate; the cloud AI
employees reach files through a **custom Nextcloud/WebDAV MCP connector** (built, since none exists off-the-
shelf) or by running the AI on-site.
- ✅ Fully sovereign; no Google; no ongoing cloud storage cost.
- ❌ **Big change** — must build + maintain a custom connector for every AI seat, lose Drive's free
  versioning/sharing/off-site, and give up the simplest off-estate backup. Highest effort/risk.

**D2 — Cloud-neutral object store (MinIO/S3 self-hosted) as primary.** Variant of D1 with S3 semantics; same
connector problem for the AI workforce. Mentioned for completeness; same trade-offs as D1.

---

## Comparison at a glance
| Option | Source of truth | Sovereign | Brain speed | Cloud-AI works? | Migration effort | Internet-dependent | Off-site backup |
|---|---|---|---|---|---|---|---|
| **A1** Drive + NAS backup | Drive | ✗ | good (cached) | yes, unchanged | **none** | yes | NAS copy |
| **A2** Drive + NAS mount-cache | Drive | ✗ | good | yes, unchanged | low | yes | NAS copy |
| **B1** NAS + Drive one-way | NAS | ✓ | **best** | read-only | low | no (local) | Drive copy |
| **B2** NAS + Drive two-way | NAS | ✓ | **best** | **yes (R/W)** | medium | no | Drive copy |
| **B3** Dual-home federated | split | ✓ | **best** | **yes (R/W)** | medium | no | both ways |
| **C1** Nextcloud + Drive bridge | NAS | ✓ | **best** | yes (R/W via Drive) | medium-high | no | Drive copy |
| **C2** Nextcloud + Drive mount | NAS/Drive | partial | best | yes | medium | partly | mixed |
| **D1/D2** Sovereign, no Drive | NAS | ✓✓ | best | **only via custom connector** | **high** | no | must build |

## How to choose (what you optimise for)
- **Least disruption / keep it simple** → **A1** (Drive stays primary, NAS backs it up + feeds the brain).
- **Robust + sovereign + local-first + keep the AI workforce writing** → **B2** or **B3** (what you're leaning
  to; B3 is the most conflict-proof).
- **Best human experience too** → **C1** (Nextcloud) layered on B2/B3.
- **Maximum sovereignty, willing to build** → **D1** (custom connector; biggest project).

**My read for "robust + the brain needs local big-file/photo access + Claude Code stays":** **B3 run with the
hardened rclone (then add Nextcloud C1 for UX)** on ZFS/PBS. It gives local-first speed and sovereignty, keeps
the cloud AI working on Drive unchanged, is conflict-proof, and Drive doubles as the off-estate copy — without
the cost/risk of building custom connectors (D). **A1 is the fallback if you decide the migration isn't worth
it yet** — it's reversible and changes nothing.

## Decisions for Minda
1. **Which family** — A (Drive stays main), B (NAS main + Drive copy), C (Nextcloud hub), or D (drop Drive)?
2. If B: **B1 / B2 / B3** (you said two-way → B2 or B3; I'd suggest **B3** for robustness).
3. Nextcloud now, later, or not (the UX layer).
4. Appetite for a **custom AI connector** (only if D).

---
_Guide-only (§3): Eugene designs + writes config; Minda executes + holds creds. The cloud-AI-ties-to-Drive
constraint is the deciding fact. Pairs with the migration plan + the two-way sync proposals + RND-3 + OI-26._
