# Change log — 2026-11-12 (Thu, HQ) — storage shelf onto pve-ai, Drive mirror + private AI collection, HQ APs back

_Guide-only (§3). Minda ran every live step and holds every secret (1Password); Eugene never saw a value._

## Network / Wi-Fi
| Item | Result |
|---|---|
| HQ APs offline since ~Jul (OI-34) | 3850 trunks Gi1/0/48, Gi2/0/48, Gi1/0/47 had native VLAN 5 (stranded) → native 10 + Kea MGMT pool 10.224.10.200–.239 + `set-inform` → **all 6 APs on one controller**; old entries forgotten; 3850 saved |
| Fishbone AI / SSH from Beverley | hq-fw-a rule `MGMT to Beverley (asymmetric)` (TCP, sloppy state) — fixed ERR_CONNECTION_ABORTED |
| VM 101 (OI-33) | found stopped since ~4 Nov, start-at-boot off; 6 ASA IPsec forwards (UDP 500/4500 ×3 WANs) removed, write mem |
| Estate map | redrawn as-built (`Infra-Inventory/fishbone-estate-map.*`), synced to Drive |
| Open issues | OI-8, OI-15, OI-19 resolved with evidence; OI-24 updated; OI-35 Wi-Fi review raised (same-channel APs at Beverley) |

## Storage + backups (OI-26)
| Item | Result |
|---|---|
| Shelf | DS2246 + CP400e moved R710 → **pve-ai**; `tank` imported (24 disks ONLINE, 0 errors) |
| PBS | PBS 4.2.10 installed on pve-ai, datastore `tank-store` reused; tokens gen9-backup (regenerated after an on-screen exposure) + pveai-backup, DatastoreBackup only; GC daily, prune 14d/4w, verify weekly |
| Clients | Gen9 `pbs-tank` → 10.99.12.2 (storage.cfg edit), pve-ai `pbs-tank` → 127.0.0.1; `pbs-nas` disabled; **test backups TASK OK both** |

## Google Drive mirror + Fishbone AI (new)
| Item | Result |
|---|---|
| Google | Cloud project "Fishbone Drive Mirror", Drive API, consent Internal, scope drive.readonly, own OAuth client (rclone shared client_id retiring 2026) |
| CT 210 `drive-mirror` | Debian 13 amd64, rclone 1.76; `tank/drive` on the shelf; first sync 47,304 files / 1h21m; 56 over-long archive names skipped (`--ignore-errors`); "Shared with me" (~11.8 GiB) added; nightly 01:30 timer; ZFS snapshots daily, keep 30; CT in backup job |
| Fishbone AI | import script → knowledge collection **"Minda - Drive"**, verified **Private**; test 20/20; full import running; nightly after the sync |
| Runbook | `Runbooks/Runbook-Drive-Mirror-pve-ai.md`; script `Hardware-Projects/drive-mirror/owui-import.py` |

## Open
- Full import completion check; prune of Drive-deleted files from the collection.
- Raw/ notes: Rachel (Financial Archive in private AI copy), Alex (shorten 56 over-long archive names).
- R710 rebuild as scheduled 3rd copy (H200 + disks arriving 13–19 Nov).
- Wi-Fi review OI-35 (AP locations + weak spots from Minda).
