# Project folders — migration to on-site storage + operating model (NAS primary, Drive synced copy)

> **Eugene, 2026-10-28 (guide-only, §3).** How we operate once the project folders move to our own storage
> (the Gen10 NAS, RND-3) with **Google Drive kept as a synced copy**. **Claude Code stays** — the cloud AI
> employees keep their Drive-based workflow unchanged; this adds the NAS as the primary/local/sovereign home
> and the on-site brain, and keeps Drive as the cloud mirror. **Minda executes + holds all creds (incl. the
> rclone Drive OAuth); Eugene writes the config/scripts + verifies. Nothing deleted — every sync archives,
> never trashes (§3).**
>
> **Supersedes** the RND-3 capacity-planning assumption "*all drawings on Google Drive → NAS = backup copy
> not primary*". Decision now: **NAS = primary, Drive = synced copy.** Sizing still fine (NAS ~11.6 TB ≫
> ~3.7 TB 3-yr need).

## 1. The operating model — who works where (answers "how we operate")
| Actor | Primary workspace | How they reach it |
|---|---|---|
| **Humans at HQ** | **NAS** (fast, local, big CAD files) | SMB mapped `Z:` + Nextcloud desktop/mobile |
| **On-site brain** (local AI machine) | **NAS** (direct filesystem) | reads drawings/photos directly — fast, big-file, vision, sovereign |
| **Cloud Claude Code employees** (Anna, Peter, Eugene, Rachel…) | **Google Drive copy** | Composio Drive connectors **unchanged** — no migration pain for the AI workforce |
| **Remote humans** | Drive (or Nextcloud web, or Tailscale → NAS) | browser / sync |
| **Backups** | NAS (ZFS + PBS + Beverley + R710, OI-26) **and** the Drive copy | automatic |

**The shape:** the **NAS is the source of truth** (local, fast, sovereign, where the brain and CAD live);
**Drive is the continuously-synced cloud face** (where the cloud AI employees + remote staff + sharing live,
and an off-estate backup copy). A **sync** keeps the two aligned. Claude Code sees no change.

## 2. The sync — the crux of the design
A bridge keeps the NAS project tree and the Drive copy in step. Tool: **`rclone`** on the NAS (reliable
Drive bridge; Nextcloud/SMB is the human access layer, rclone is the Drive mirror). Scheduled (e.g. every
15–30 min, or hourly). **`--backup-dir` on every run → overwritten/deleted files are archived, never lost**
(charter: never trash). Verify with `rclone check` (counts + hashes).

**Direction — the one real decision (Minda):**
- **Option A — one-way `NAS → Drive` mirror (simplest, safest).** NAS is authoritative; Drive is a pure
  read-copy + backup. **Works cleanly *if* the cloud AI employees only *read* project folders** (they write
  their outputs to **Smartsheet + their own KBs**, not into the shared drawing folders). No conflicts ever.
- **Option B — two-way `rclone bisync` (keeps every current workflow).** Needed if the cloud AI or remote
  staff also **write into** the project folders on Drive (e.g. Anna drops a generated RAMS/report there).
  Handles both directions; conflicts keep **both** copies (`--conflict-resolve keep` + `--backup-dir`), so
  nothing is lost — just needs a tidy-up rule for the rare conflict.
- **Recommended: a hybrid** — **one-way NAS→Drive** for the bulk (drawings/photos authored at HQ/by the
  brain) **+ a small `from-AI/` inbox that syncs Drive→NAS** for AI/remote-authored files. Keeps 95% of it
  conflict-free while still letting the AI/remote write back. (If that's fiddly, plain **bisync** with the
  safety flags is the pragmatic default.)

_Decide this from one question: **do the cloud AI employees / remote staff ever save files *into* the project
folders, or only read them?** Read-only → Option A. They write → hybrid or B._

## 3. Migration plan (phased, no data loss, Drive stays intact until verified)
- **P0 — inventory + decide (now):** list the current Drive project folders + sizes (`rclone size`/`lsd`);
  decide the **NAS folder layout** (mirror the Drive structure, or tidy it); decide the **sync direction**
  (§2). Confirm what, if anything, the AI/remote write into project folders.
- **P1 — access layer on the NAS:** Nextcloud + SMB share on the Gen10 NAS (RND-3); create the project-folder
  tree. (Until the Gen10 is up, this can rehearse on the R710/pool built Saturday.)
- **P2 — seed the NAS (copy down):** `rclone copy GDrive:Projects /nas/Projects --backup-dir … --dry-run`
  first, then for real; **`rclone check`** to prove counts + hashes match. Drive untouched.
- **P3 — establish the sync:** `rclone bisync --resync` once to set the baseline (or the one-way job), then
  schedule it; **test with a known change both ways** and confirm it propagates + archives, not deletes.
- **P4 — cut over:** NAS becomes primary — humans map `Z:`/Nextcloud, the on-site brain points at the NAS,
  announce the new home. Drive now = the synced copy.
- **P5 — steady state:** ongoing scheduled sync; Drive remains the cloud-AI interface + off-estate copy;
  project data is now protected by the NAS 3-2-1(-1) (OI-26) **and** the Drive copy. Decommission nothing on
  Drive — it stays as the copy.

## 4. Why this is a good design
- **Claude Code unaffected** — the AI workforce keeps reading/writing Drive exactly as now; zero connector
  changes, zero retraining. The migration is invisible to them.
- **The brain gets local, fast, sovereign access** to the real files (big CAD, photo sets) — essential for
  vision + RAG, and the data never has to leave the estate to be worked.
- **Belt-and-braces resilience:** project data lives on the NAS (ZFS + 3-2-1(-1) backups) **and** on Drive
  (cloud copy) — more protected than today (Drive-only), not less.
- **Reversible:** Drive stays a full copy throughout, so a bad migration is just "keep using Drive."

## 5. Decisions / inputs needed from Minda
1. **Sync direction** (§2) — the one real call: do AI/remote staff *write into* project folders, or only read?
2. **NAS folder layout** — mirror Drive 1:1, or tidy the structure during the move?
3. **rclone Drive auth** — Minda creates the rclone Google Drive remote (OAuth, her creds; Eugene never holds it).
4. **Sync cadence** — 15 min / 30 min / hourly (trade freshness vs churn).

---
_Guide-only (§3): Eugene writes the rclone config + migration scripts + verifies; Minda runs them on the NAS
and holds the Drive OAuth. Never trash — every sync archives via `--backup-dir`; Drive stays a full copy
until the NAS is verified. Extends RND-3 (storage) + pairs with OI-26 (backups) and the AI-machine build
list (the brain reads the NAS)._
