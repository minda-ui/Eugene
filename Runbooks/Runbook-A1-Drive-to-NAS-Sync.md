# Runbook — A1: one-way Google Drive → NAS sync (Stage 0 of the sovereignty roadmap)

> **Eugene, 2026-10-28 (guide-only, §3).** Stands up **A1**: Google Drive stays the main store; the NAS keeps
> a **continuous one-way copy** (Drive → NAS) as an **off-Google backup** and the **on-site brain's local
> files** for vision/RAG. **Nothing changes for humans or the cloud AI workforce.** Runs on the NAS once the
> pool is up (Saturday's R710 pool, then the Gen10). **Minda executes every step + holds the Drive OAuth;
> Eugene wrote + verifies. Drive is opened READ-ONLY — the sync can never modify Drive. Never trash: deletions
> on the NAS side are archived, and ZFS snapshots sit underneath.** Roadmap: `storage-sovereignty-roadmap-A1-to-D1.md`.

## ⚠️ The one operating rule for A1
`/nas/Projects` is a **read-only mirror of Drive**. **Do not author into it** — the next sync makes it match
Drive and would archive anything local that isn't on Drive. The brain **reads** it; if the brain (or anyone)
needs to **write**, write to a **separate** folder (e.g. `/nas/brain-work/`), never under `/nas/Projects`.
(Authoring on the NAS comes at Stage 2.)

## Prerequisites
- [ ] NAS pool + a dataset for the mirror, e.g. **`/mnt/tank/Projects`** (ZFS; snapshots enabled — Step 6).
- [ ] The NAS can reach the internet (Drive API).
- [ ] Minda knows the **Drive source**: the top-level Projects folder (its name/path, or its **folder ID**).
- [ ] Decide the schedule (A1 is a backup, not real-time → **30–60 min** is plenty).

## Step 1 — Install rclone (on the NAS) — Minda runs
```bash
curl https://rclone.org/install.sh | sudo bash
rclone version
```
(On TrueNAS SCALE you can instead use the built-in **Cloud Sync Tasks**, which is rclone with a GUI + logging
— same flags/filters apply; this runbook is the CLI form.)

## Step 2 — Configure the Google Drive remote — READ-ONLY — Minda runs
```bash
rclone config
#  n) new remote
#  name> gdrive
#  storage> drive
#  client_id / client_secret> (blank is fine, or Minda's own for higher quota)
#  scope>  1  (= "drive.readonly")   <-- IMPORTANT: read-only, so the sync can NEVER write/delete on Drive
#  root_folder_id> <the Projects folder ID>   (optional; pins the remote to Projects)
#  Edit advanced> no
#  Use auto config> (on a headless NAS choose "no" -> run `rclone authorize "drive"` on a laptop
#                    with a browser, sign in as minda@, paste the token back)
```
Verify it reads (and only reads) Drive:
```bash
rclone lsd gdrive:                 # lists top-level folders
rclone about gdrive:               # shows Drive usage
```
The token is Minda's, stored by rclone in `~/.config/rclone/rclone.conf` on the NAS — **never in git; Eugene
never holds it.** `drive.readonly` means even a bug can't harm Drive.

## Step 3 — First sync: dry-run → real → verify
```bash
SRC=gdrive:                        # or gdrive:Projects if not pinned via root_folder_id
DST=/mnt/tank/Projects

# 3a. DRY-RUN first — see what WOULD happen, change nothing:
rclone sync "$SRC" "$DST" --dry-run --progress \
  --drive-export-formats docx,xlsx,pptx,pdf,svg

# 3b. Real first pull:
rclone sync "$SRC" "$DST" --progress \
  --backup-dir "/mnt/tank/.rclone-archive/$(date +%Y-%m-%d_%H%M)" \
  --drive-export-formats docx,xlsx,pptx,pdf,svg \
  --transfers 8 --checkers 16 --tpslimit 10 --fast-list

# 3c. VERIFY (hash/size compare — proves the copy is good):
rclone check "$SRC" "$DST" --one-way --drive-export-formats docx,xlsx,pptx,pdf,svg
```
`--drive-export-formats` turns **Google-native Docs/Sheets/Slides** (which aren't real files) into real
`docx/xlsx/pptx/pdf` on the NAS. `--one-way` on check = "every Drive file exists on the NAS" (extra NAS files
are fine — they're the archive).

## Step 4 — The hardened sync script (what the schedule runs)
Create `/usr/local/bin/a1-drive-to-nas.sh`:
```bash
#!/usr/bin/env bash
set -euo pipefail
SRC="gdrive:"
DST="/mnt/tank/Projects"
ARCH="/mnt/tank/.rclone-archive/$(date +%Y-%m-%d)"
LOG="/var/log/a1-sync.log"
LOCK="/var/run/a1-sync.lock"

# --- GUARD 1: one run at a time ---
exec 9>"$LOCK"; flock -n 9 || { echo "$(date -Is) another run active; skip" >>"$LOG"; exit 0; }

# --- GUARD 2: dest must really be the mounted ZFS dataset, not an empty dir ---
mountpoint -q /mnt/tank || { echo "$(date -Is) ABORT: /mnt/tank not mounted" >>"$LOG"; exit 1; }
# sentinel the pool writes itself; refuse to sync into a pool that lost it:
test -f /mnt/tank/.pool-ok || { echo "$(date -Is) ABORT: pool sentinel missing" >>"$LOG"; exit 1; }

# --- GUARD 3: source must list (Drive reachable) ---
rclone lsf "$SRC" --max-depth 1 >/dev/null 2>>"$LOG" || { echo "$(date -Is) ABORT: Drive unreachable" >>"$LOG"; exit 1; }

# --- the sync: never deletes blind (archive + max-delete guard) ---
rclone sync "$SRC" "$DST" \
  --backup-dir "$ARCH" \
  --max-delete 200 \
  --drive-export-formats docx,xlsx,pptx,pdf,svg \
  --track-renames --fast-list \
  --transfers 8 --checkers 16 --tpslimit 10 \
  --log-file "$LOG" --log-level INFO \
  || { echo "$(date -Is) SYNC FAILED (rc=$?)" >>"$LOG"; exit 1; }

echo "$(date -Is) OK" >>"$LOG"
```
```bash
chmod +x /usr/local/bin/a1-drive-to-nas.sh
touch /mnt/tank/.pool-ok          # the sentinel (lives on the pool; gone if the pool isn't mounted)
```
**Why these guards:** `flock` = no overlapping runs; the **mountpoint + sentinel** checks mean a pool that
didn't mount makes the script **abort, not mirror an empty Drive-copy over nothing**; `--max-delete 200`
aborts a run trying to delete a suspicious number of files (tune to your churn); `--backup-dir` keeps every
overwritten/deleted file. Drive is read-only regardless, so Drive is never at risk.

## Step 5 — Schedule it (systemd timer) — Minda runs
`/etc/systemd/system/a1-sync.service`:
```ini
[Unit]
Description=A1 Drive->NAS one-way sync
[Service]
Type=oneshot
ExecStart=/usr/local/bin/a1-drive-to-nas.sh
OnFailure=a1-sync-alert.service
```
`/etc/systemd/system/a1-sync.timer`:
```ini
[Unit]
Description=Run A1 Drive->NAS sync every 30 min
[Timer]
OnBootSec=5min
OnUnitActiveSec=30min
Persistent=true
[Install]
WantedBy=timers.target
```
```bash
systemctl daemon-reload && systemctl enable --now a1-sync.timer
systemctl list-timers a1-sync.timer      # confirm next run
```
`a1-sync-alert.service` = a one-shot that logs loudly + notifies on failure (email / a Hub "sync failed" row /
a Tailscale push) — **fail loud, never silent.** (Tell Eugene the alert channel and he'll wire it.)

## Step 6 — ZFS snapshots under the mirror (versioning + rollback)
So the NAS copy is itself point-in-time recoverable (and A1 isn't just the latest state):
```bash
# with sanoid (preferred) keep e.g. 24 hourly + 14 daily on tank/Projects
# or a simple cron: zfs snapshot tank/Projects@$(date +%Y%m%d-%H%M)
```
Keep a short retention; this pairs with PBS (OI-26) so the mirror is covered by the estate 3-2-1(-1) too.

## Step 7 — Point the brain at it (read-only)
The on-site brain reads `/mnt/tank/Projects` directly for vision/RAG (fast, local, no Drive download per use).
Mount it **read-only** into the brain's VM/container so it can never write into the mirror:
```bash
# e.g. bind-mount read-only:  mount --bind -o ro /mnt/tank/Projects /brain/projects
```
Brain outputs go to `/nas/brain-work/` (separate), never under the mirror.

## Verify / rollback / guardrails
- **Verify:** after the first sync and weekly, `rclone check "$SRC" "$DST" --one-way …` → 0 differences.
  Watch `/var/log/a1-sync.log` for `OK`.
- **Rollback:** a wrong file on the NAS → restore from `/mnt/tank/.rclone-archive/<date>/` or a ZFS snapshot.
  **Drive is never touched** (read-only), so Drive is always the clean source.
- **Reversible:** A1 is a copy — turn the timer off and nothing is lost; Drive carries on as today.
- **§3:** Minda runs it + holds the Drive OAuth/token (never in git); Eugene writes + verifies; never trash.

## Next (when ready)
Stage 1 = Nextcloud on the NAS as a 2nd human path; Stage 2 = authoring moves to the NAS (two-way/federated).
See `storage-sovereignty-roadmap-A1-to-D1.md`.

---
_Guide-only (§3). A1 = Drive stays main; the estate gets its own continuous read-only copy + local brain
files; zero change for humans or the cloud AI. Drive opened read-only; deletions archived; snapshots
underneath. Pairs with RND-3, OI-26, the roadmap, and the AI-machine build list._
