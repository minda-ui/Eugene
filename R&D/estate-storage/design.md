# RND-3 — Estate self-hosted storage + backup foundation

_R&D working notes (git-primary). Status: **prototyped** (hardware all in-hand 2026-10-16; one cable to
buy). Guide-only — Minda executes at the console/hardware; Eugene designs/specs/verifies. §3 unchanged;
production PBX never put at risk. Diagram: `architecture.mmd` (rendered to Minda 2026-10-04).
Build runbook: `Runbooks/Runbook-RND3-Estate-Storage-Build.md`._

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

## Hardware CONFIRMED — the whole stack is owned (Minda, 2026-10-16) ✅
The storage stack is **physically in-hand** — only **one cable** to buy. Confirmed from photos/BIOS:

### The shelf — NetApp DS2246 (chassis NAJ-1001) ✅
- **2U, 24× 2.5" SFF SAS bays**, SAS **6 Gb/s**, **dual IOM6** (multipath), dual hot-swap PSU/fan,
  hot-swap drives/IOMs, ACP. A **"dumb" JBOD shelf — no controller** → ideal for ZFS (raw disks).
- **Populated:** 24× 2.5" SAS **SSD** (mixed 200/400 GB ≈ **5–7 TB raw**) — a fast all-flash pool.
- **IOM6 ports are QSFP (SFF-8436)** — NOT SFF-8088. ⚠️ This corrects the earlier "SFF-8088" note; the
  cable to the host must terminate **QSFP** at the shelf end.

### The host — Dell PowerEdge R710 (dedicated storage box) ✅
Using the **R710, not the DL380**, keeps the DL380 free for the RND-2 GPU build — clean separation.
- **2U, 8× 2.5" bays, 2× PCIe risers.**
- **CPUs: 2× Intel Xeon X5650** — 6-core / 12-thread each = **12c / 24t total**, 2.67 GHz, 12 MB L3
  (BIOS-confirmed 2026-10-16). Ample for ZFS + SMB/NFS + Nextcloud + PBS.
- **RAM: 24 GB ECC DDR3 @ 1333 MHz** (BIOS-confirmed 2026-10-16, Optimizer Mode) — comfortably above the
  ZFS ARC floor for a 5–7 TB flash pool + Nextcloud + PBS. **No RAM to buy.** (Headroom later if wanted.)
- R710 is EOL/old but rock-solid for a storage/backup role; it is storage-only, lives at HQ by the rack.

### The HBA — Fujitsu PSAS CP400e (owned) ✅
- **= LSI/Broadcom SAS3008, 12 Gb/s, external, 2× SFF-8644 ports** (equivalent to a Broadcom 9300-8e).
- ⚠️ **Must be in IT mode** (plain HBA, passes raw disks) — NOT IR/RAID. Confirm with `sas3flash -list`;
  crossflash to **9300-8e IT** firmware if it reports IR. **Key check before building the pool.**
- Fits an R710 PCIe riser (x8). Backward-compatible 12 Gb HBA ↔ 6 Gb shelf (negotiates to 6 Gb).

### The ONLY purchase — one SAS cable
- **SFF-8644 (host/CP400e) → QSFP / SFF-8436 (DS2246 IOM6)**, external mini-SAS HD → mini-SAS, ~£20–40.
  Buy **×2** to cable **both IOM6s** for multipath redundancy (one works to start).
- Exact spec: *"SFF-8644 to SFF-8436 (QSFP) external SAS cable, 1–2 m."* Common on eBay/Amazon/CablesOnline.

### Heads-ups (unchanged)
- NetApp SSDs are almost certainly **520-byte sectors** → one-time **`sg_format --format --size=512`**
  per disk before ZFS (reformats to 512; wipes the disk — these are spare/blank). Procedure in the runbook.
- 2U + dual PSU → put the shelf + R710 on the **UPS**; mind heat/noise (datacentre-loud).

## Beverley Place (off-site replica) — still to confirm
- **Beverley Place** rack — what's there to host the replica target (a second small box / spare bays / a
  second JBOD)? The `zfs send/recv` destination over the existing IPsec VPN. Spec once HQ pool is up.

## Phased build (zero risk to phones; guide-and-verify)
Full step-by-step in **`Runbooks/Runbook-RND3-Estate-Storage-Build.md`**. Summary:
1. Fit the **CP400e** in an R710 riser → boot → **confirm IT mode** (`sas3flash -list`; crossflash to
   9300-8e IT if IR). 2. Cable **SFF-8644 → QSFP** to **IOM A** (second cable to IOM B later for
   multipath). 3. Boot **TrueNAS SCALE** (bare-metal on the R710) or Proxmox+ZFS → confirm all 24 bays
   seen. 4. **`sg_format` 520→512** on each SSD if they report 520-byte. 5. Create the ZFS pool
   (RAIDZ2 or mirrors) + snapshots. 6. SMB/NFS share → map a test drive. 7. Nextcloud + desktop/mobile
   client. 8. **PBS** for the VMs (fixes OI-7). 9. Beverley Place replica + `zfs send/recv` over the VPN.
   10. Encrypted disaster copy. 11. **Test a restore** (a backup isn't real until a restore works).

## Links
Foundation for RND-2 (local AI/RAG) and the Telegram evidence mirror. Supersedes the laptop-only VM
backups noted in OI-7.
