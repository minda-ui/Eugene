# Runbook — Google Drive mirror on pve-ai (CT 210 `drive-mirror`)

**Built:** 2026-11-12 (Minda at HQ, Eugene guiding; guide-only §3). **Purpose:** nightly read-only copy of minda@fishboneconstruction.co.uk's My Drive onto the DS2246 shelf, as (a) a second copy of Drive on our own kit and (b) a source for a **private** Fishbone AI knowledge collection (Minda only).

## As built
| Item | Value |
|---|---|
| Storage | ZFS `tank/drive` (lz4) on pve-ai, owned 100000:100000 (unprivileged CT) |
| Container | CT 210 `drive-mirror`, Debian 13 **amd64**, unprivileged, nesting=1, 1 core, 1 GB, 8 GB rootfs (local-zfs), 10.224.10.33/24 gw 10.224.10.1, DNS 1.1.1.1, onboot; mp0 `/tank/drive` → `/mnt/drive`; no root password (use `pct enter 210`) |
| rclone | **v1.76.0** from rclone.org install script (Debian's 1.60 can't read 1.7x token blobs) |
| Google | Cloud project **Fishbone Drive Mirror**, Drive API enabled, OAuth consent **Internal**, scope `…/auth/drive.readonly`, OAuth client **rclone** (Desktop app). Client ID/secret + token: 1Password only ("Google OAuth – Fishbone Drive Mirror", "rclone Google Drive token") |
| Remote | `gdrive` = drive, scope drive.readonly, own client_id, authorized as minda@ (rclone config → auto config n → `rclone authorize` on Minda's PC) |
| Size | My Drive ~52.9 GiB; no shared drives for minda@; "Shared with me" not included (decision pending) |
| First copy | `systemd-run --unit=drive-first rclone sync gdrive: /mnt/drive/mydrive --fast-list --transfers 8 --checkers 16 --log-file /var/log/rclone-drive.log --log-level INFO --stats 1m` |

## Lessons (12 Nov)
- `pveam available | grep debian-13 | tail -1` picked the **arm64** template → container would not start. Filter on `amd64`.
- Debian rclone 1.60 + PC rclone 1.76: new authorize output is a base64 blob (client_id, client_secret, token) → "invalid character 'e'". Use matching versions and the interactive `rclone config` flow (paste blob at `config_token>`).
- rclone's shared Google client_id is being retired in 2026 → own OAuth client required.
- At `scope>` type `drive.readonly` (name), not the menu number — "2" was sent literally → `invalid_scope`.
- Browser defaulted to info@ → do the consent in a private window as minda@.
- PowerShell on the office PC has no winget → download rclone zip with Invoke-WebRequest.

## Done later on 12 Nov
- First sync running (30 GB of ~53 GB after ~50 min). "Shared with me" = ~11.8 GiB / 19,226 objects (537 Google-native, unknown size) → included.
- `/usr/local/bin/drive-mirror.sh` (sync gdrive: → /mnt/drive/mydrive; sync gdrive: --drive-shared-with-me → /mnt/drive/shared) + `drive-mirror.service`/`.timer` **daily 01:30** (first run Fri 13 Nov).
- pve-ai `/etc/cron.d/drive-snapshots`: 04:15 daily `zfs snapshot tank/drive@YYYY-MM-DD`, keep newest 30.

- First full sync finished: **47,304 files in 1h21m**, 56 failed with `file name too long` (archive copies whose "(archived …, superseded by …)" names exceed the 255-byte filesystem limit). rclone 1.76 `--name-transform file,truncate_keep_extension=N` tested in dry-run → `transform cannot render path segments empty` errors → **not used**. Instead the nightly script got `--ignore-errors`, so deletions still propagate while those 56 stay Drive-only. Follow-up: Raw/ note to Alex to shorten the over-long archive names.

## Still to do
1. Include CT 210 in the pve-ai PBS backup job (container only; the shelf data is an mp0 bind and is not in the backup by design).
2. Fishbone AI: private knowledge collection from `/tank/drive/mydrive` (read-only mount into CT 200), visible to Minda only.
3. Raw/ note to Rachel: read-only AI copy includes the Financial Archive (its single home stays Drive).
4. Decide on "Shared with me" (separate remote with `--drive-shared-with-me`).
