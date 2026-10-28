# Two-way NAS ↔ Google Drive sync — robust design proposals

> **Eugene, 2026-10-28 (guide-only, §3).** Minda chose **two-way** (NAS primary + Drive synced copy, both
> sides read **and** written) and asked for a **robust** design. These are the proposals. **Minda executes +
> holds the Drive OAuth; Eugene writes config/scripts + verifies; nothing is ever trashed — archives only.**
> Extends `project-folders-migration-and-operating-model.md` (direction now = two-way, decided).

## The principle: robustness comes from THREE layers, not one tool
Any two-way sync *will* eventually hit a conflict or a glitch. "Robust" = no data loss when it does. So every
proposal below stacks the same three layers:
1. **Shrink the conflict surface** — partition *who authors what, where*, so most of the tree is effectively
   one-way (conflicts can't happen on a subtree only one side writes).
2. **Never-lose on the sync** — the sync engine archives every overwrite/delete, keeps **both** copies on a
   conflict, and **refuses to run** if a side looks un-mounted or would mass-delete.
3. **Recover anything underneath** — **ZFS snapshots + PBS** (OI-26 3-2-1(-1)) sit *below* the sync, so any
   sync mishap is a **rollback**, not a loss. This is the real safety net; the sync can misbehave and you
   still lose nothing.

A design that only has layer 2 (the sync tool's flags) is *not* robust. All three is.

---

## Proposal A — Hardened `rclone bisync` (pragmatic, free, proven)
The whole project tree, bidirectional, scheduled (every 15–30 min) on the NAS, with the full safety belt.
- **Engine:** `rclone bisync NAS:Projects GDrive:Projects` on a timer (systemd timer / cron), single-instance (flock).
- **Never-lose flags:** `--backup-dir` both sides (archive every overwrite/delete) · `--conflict-resolve none
  --conflict-suffix nas,drive` (keep **both** on conflict) · `--max-delete 10%` (abort a run that would delete
  too much — the mount-dropped guard) · `--check-access` with `RCLONE_TEST` marker files (refuse to sync if a
  side isn't really there) · `--resilient --recover` (survive interrupted runs).
- **Verify:** nightly `rclone check` (hashes) + a weekly `--resync` baseline refresh; log every run; **alert on
  any non-zero exit** (email/Hub row).
- **Pros:** free, mature, one component, runs on the NAS, no extra server. Backup-dir + snapshots = no loss.
- **Cons:** batch, not real-time → a sync-window where the two sides diverge (conflicts possible within it);
  bisync state can need a `--resync` after a bad interruption.
- **Robustness:** ★★★★ (with all 3 layers). **Best for: getting live now with least moving parts.**

## Proposal B — Partitioned single-writer (conflict-*proof* by design)
Make conflicts structurally impossible by giving each subtree **one** authoritative side.
- `Projects/` (drawings, photos, CAD — authored at HQ / by the brain) → **one-way NAS → Drive**.
- `from-cloud/` (anything the AI employees or remote staff create) → **one-way Drive → NAS**.
- Two-way **overall**, but **no single folder is written from both sides**, so there is **nothing to
  conflict**. Each leg is a simple, robust one-way `rclone sync` (+ backup-dir + max-delete + check-access).
- **Pros:** the most robust — conflicts can't occur; simplest failure semantics; easiest to reason about.
- **Cons:** needs a **convention** ("AI/remote write into `from-cloud/`, not into the drawing folders"); a file
  saved on the wrong side just needs moving. Slightly less free-for-all.
- **Robustness:** ★★★★★. **Best for: maximum robustness if we can agree who-authors-what.**

## Proposal C — Nextcloud hub + `rclone` Drive bridge (best human UX + real-time local)
Nextcloud on the NAS is the human/brain primary; rclone bridges it to Drive.
- **Humans + brain** use **Nextcloud** (desktop/mobile/web, SMB alongside) — **real-time** client sync with
  **built-in versioning + conflict-copy** handling (battle-tested).
- **rclone bisync** bridges the Nextcloud data tree ↔ Google Drive on a schedule (Proposal A's hardened job).
- **Cloud AI employees** keep using **Drive** as now.
- **Pros:** humans get instant, robust, versioned local sync (not a 15-min window); nicest UX; mobile + sharing.
- **Cons:** most moving parts (Nextcloud + rclone + DB); the **Drive-bridge leg still has the bisync window**
  (so Drive↔NAS freshness is still scheduled, even though human↔NAS is real-time).
- **Robustness:** ★★★★ (human side ★★★★★, Drive leg same as A). **Best for: if the human experience matters
  as much as the sync.**

---

## Comparison
| | A — hardened bisync | B — partitioned one-way | C — Nextcloud + bridge |
|---|---|---|---|
| Conflicts | possible (kept, not lost) | **impossible** | human side handled; Drive leg as A |
| Real-time | no (scheduled) | no (scheduled) | **yes** for humans; scheduled to Drive |
| Moving parts | 1 (rclone) | 1 (rclone, 2 jobs) | 3 (Nextcloud+DB+rclone) |
| Human UX | SMB/plain | SMB/plain | **best** (clients, mobile, sharing) |
| Robustness | ★★★★ | ★★★★★ | ★★★★ |
| Effort to stand up | low | low | medium |

## Recommendation — layer them
**Start with B's partitioning as the backbone** (conflict-proof: `Projects/` NAS→Drive, `from-cloud/` Drive→NAS),
run it with **A's hardened rclone** flags, and **add C's Nextcloud** as the human access layer when you want the
real-time/mobile UX — all sitting on **ZFS snapshots + PBS**. That gives: conflicts structurally avoided, no loss
on the rare edge, great local UX, and rollback for anything. You can ship **B+A now** and layer **C** later
without redoing the sync engine.

## Robustness details every proposal must get right
- **Never `--delete` blind:** always `--backup-dir` + `--max-delete` guard; a dropped mount must **abort**, not
  mirror emptiness. `--check-access` marker files enforce this.
- **Google-native files don't round-trip:** Google Docs/Sheets/Slides aren't real files — rclone exports or
  skips them. **Rule: project files stay real files (PDF/DWG/XLSX), not native Google formats**, or handle
  exports explicitly. (Big robustness trap — call it out before migrating.)
- **One run at a time:** `flock` so a long sync never overlaps the next tick.
- **Verify, don't assume:** nightly `rclone check` (hash compare) + log; **alert on failure** (don't fail
  silent). A weekly `--resync` re-baselines bisync.
- **Interrupted runs:** `--resilient --recover`; power-loss safe because ZFS + the backup-dir mean the worst
  case is "re-run / roll back."
- **Quotas/rate-limits:** rclone paces the Drive API; large initial seed runs off-hours.
- **The ultimate backstop:** ZFS snapshots (hourly/daily) + PBS — **any** sync accident is a rollback.

## Decisions / inputs from Minda
1. **Pick the backbone:** B+A (recommended), A alone, or go straight to C.
2. **Confirm the partition** (if B): AI/remote write into `from-cloud/`, humans/brain author `Projects/` — OK?
3. **Any native Google Docs/Sheets** in the project folders today? (decides the round-trip rule).
4. **Cadence** (15/30/60 min) + **Nextcloud now or later** (if C).

---
_Guide-only (§3): Eugene writes the rclone config + systemd timers + the verify/alert scripts; Minda runs them
on the NAS + holds the Drive OAuth. Never trash — archives + snapshots only. Robustness = partition + never-lose
+ rollback, all three. Pairs with RND-3, OI-26, the migration plan._
