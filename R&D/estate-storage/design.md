# RND-3 — Estate self-hosted storage + backup foundation

_R&D working notes (git-primary). Status: **exploring**. Guide-only — Minda executes at the
console/hardware; Eugene designs/specs/verifies. §3 unchanged; production PBX never put at risk.
Diagram: `architecture.mmd` (rendered to Minda 2026-10-04)._

## Goal (Minda, 2026-10-04)
"Main foundation: data storage, then backup." A self-hosted NAS / Google-Drive-like / OneDrive-like
store on the HQ server, then a proper backup around it. Everything else (local AI/RAG RND-2, the
Telegram evidence mirror) sits on top of this.

## Why it fits this estate
Two assets most setups lack: a **big server** (DL380 Gen9, 128 GB) and a **second site on an IPsec VPN**
(Beverley Place) — so the off-site backup is free and already-wired.

## Storage — one ZFS pool, two faces
- **Base:** ZFS pool via **TrueNAS SCALE as a Proxmox VM**, disk controller **passed through** so ZFS
  owns raw disks. ZFS = checksummed integrity + snapshots + compression.
- **SMB/NFS shares** = the NAS (mapped `Z:` on office PCs; drawings, project folders, big files).
- **Nextcloud** = the Drive/OneDrive experience: web, desktop sync, **mobile app auto photo-upload**,
  **share links** (clients, no accounts), versioning. Natural landing zone for the Telegram evidence
  mirror.

## Backup — 3-2-1(-1)
1. Primary: the HQ ZFS pool.
2. **ZFS snapshots** hourly/daily/weekly — instant undo (delete/ransomware first line).
3. **Proxmox Backup Server** for the VMs (FusionPBX etc.) → **fixes OI-7**.
4. **Off-site:** `zfs send/receive` to a **replica NAS at Beverley Place** over the IPsec VPN
   (incremental, automatic).
5. **Disaster/offline:** **encrypted** copy to cloud (Backblaze B2 / Wasabi) or rotating USB kept
   off-site. Encryption key is Minda's (a secret Eugene never holds).

## Disk capacity SOLVED — spare NetApp DS2246 shelf (Minda, 2026-10-04)
Minda has a spare **NetApp DS2246** ("without work") → **this becomes the ZFS pool.**
- **2U, 24× 2.5" SFF SAS bays**, SAS 6 Gb/s, **dual IOM6** (multipath), dual hot-swap PSU/fan,
  hot-swap drives/IOMs, ACP. It's a **JBOD shelf** (no controller) — ideal for ZFS (raw disks).
- **Integration:** add an **external SAS HBA** to the DL380 (LSI 9207-8e / 9300-8e or HP H221, ~£40-80,
  **IT mode**) → **mini-SAS SFF-8088** to the shelf, cabling **both IOM6s** for multipath redundancy →
  TrueNAS/ZFS sees all 24 bays = one big pool. Supersedes the "use the server's internal bays" question.
- **Fill:** 24× 2.5" SAS/SATA — HDD for capacity or **SSD for a fast pool** (Nextcloud/VM/AI-index tier).
- **Heads-ups:** NetApp drives (if present) are likely **520-byte** → one-time `sg_format` to 512 before
  ZFS; needs the HBA + SFF-8088 cables (cheap, commodity); storage-only (lives at HQ by the DL380);
  2U + dual PSU → UPS/heat.

## Hardware checkpoints to confirm (Minda, console / iLO)
- **Disks in the DL380** — how many bays populated, sizes, SSD/HDD? (`lsblk`, iLO array config.) Decides
  pool size + layout (mirror vs RAIDZ2).
- **Controller** — DL380 Gen9 often has a **Smart Array P440ar**. ZFS wants **HBA/IT mode** (pass raw
  disks), not hardware RAID. P440ar can run HBA mode, or add an LSI HBA. **Key decision.**
- **Free PCIe/bays** for growth; current pool usage.
- **Beverley Place** rack — what's there to host the replica NAS (a second small box / spare bays)?

## Phased build (zero risk to phones; guide-and-verify)
1. Audit disks/controller (above). 2. Decide HBA mode + pool layout. 3. Stand up TrueNAS VM + pool
(snapshots on). 4. SMB share + map a test drive. 5. Nextcloud + desktop/mobile client. 6. PBS for the
VMs (OI-7). 7. Beverley Place replica + `zfs send/recv` over VPN. 8. Encrypted disaster copy. 9. Test a
restore (a backup isn't real until a restore works).

## Links
Foundation for RND-2 (local AI/RAG) and the Telegram evidence mirror. Supersedes the laptop-only VM
backups noted in OI-7.
