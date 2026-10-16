# Runbook — RND-3 Estate Storage Build (DS2246 + R710 + CP400e → ZFS NAS + backup)

> **Status:** READY 2026-10-16. Guide-only (§3): **Minda executes at the hardware/console, Eugene guides
> + verifies.** Zero risk to the production PBX (separate box). Build it in phases; validate each before
> the next. Design rationale: `R&D/estate-storage/design.md`.

## Confirmed hardware (2026-10-16) — the whole stack is owned
| Part | What it is | Status |
|---|---|---|
| **NetApp DS2246** (NAJ-1001) | 2U JBOD shelf, 24× 2.5" SAS SSD (~5–7 TB raw), dual **IOM6** (6 Gb, **QSFP/SFF-8436** ports), dual PSU | ✅ owned |
| **Dell PowerEdge R710** | Storage host: 2× Xeon X5650 (12c/24t), **24 GB ECC DDR3**, 8× 2.5" bays, 2× PCIe risers | ✅ owned |
| **Fujitsu PSAS CP400e** | External SAS HBA = LSI **SAS3008**, 12 Gb, 2× **SFF-8644** — must be **IT mode** | ✅ owned |
| **SFF-8644 → QSFP (SFF-8436) cable** | Host HBA → shelf IOM6. ~£20–40. ×2 for multipath | ⬜ **buy (only purchase)** |

Why the R710 (not the DL380): keeps the DL380 free for the RND-2 GPU build. Clean separation of concerns.

## The only purchase
- **1× (or 2×) external mini-SAS HD cable: SFF-8644 ↔ SFF-8436 (QSFP), ~1–2 m.**
  Search terms: *"SFF-8644 to SFF-8436 QSFP external SAS cable"*. eBay/Amazon/CablesOnline. One works to
  start; a second cables the redundant IOM B for multipath.
- Everything else is in-hand. No RAM, no HBA, no drives to buy.

## Phase 0 — Pre-flight
1. R710 **not** carrying anything live (it's a fresh storage box). Rack space + UPS outlet + the shelf
   nearby (short SAS run).
2. Decide the host OS now (see Phase 3): **TrueNAS SCALE** (appliance, simplest NAS) vs **Proxmox + ZFS**
   (more flexible; can also run the VMs). Either is fine — TrueNAS SCALE recommended for a dedicated NAS.
3. A USB stick with the installer; a keyboard+monitor or iDRAC to the R710.

## Phase 1 — Fit the HBA + confirm IT mode (the key check)
1. Power off the R710, fit the **CP400e** in a PCIe riser (x8 slot), reseat the riser, power on.
2. Boot a Linux live/installer shell (or TrueNAS shell later) and check the mode:
   ```sh
   # list the SAS3008 and its firmware mode
   sas3flash -list          # or lsscsi / lspci -nn | grep -i sas
   ```
   - **IT mode** → reports an "IT" firmware, presents raw disks. ✅ proceed.
   - **IR mode** (hardware-RAID firmware) → **crossflash to 9300-8e IT** before building the pool:
     back up the SAS address, erase, flash the 9300-8e **IT** firmware + BIOS. (One-time; follow the
     9300-8e IT crossflash procedure — ask Eugene for the exact `sas3flash` sequence when you're there.)
   - ⚠️ ZFS must see **raw disks**, never a RAID volume. Do not create any RAID on the HBA.

## Phase 2 — Cable the shelf
1. **SFF-8644** end → CP400e port 0. **QSFP (SFF-8436)** end → DS2246 **IOM A** (top) SAS port.
2. Power the DS2246 (both PSUs). Give it ~30 s to spin up.
3. (Later, for multipath) second cable: CP400e port 1 → **IOM B**.
4. Boot the R710 → confirm all 24 bays appear: `lsblk`, `lsscsi`, or `sas3flash -list` disk count = 24.

## Phase 3 — Host OS + see the disks
1. Install **TrueNAS SCALE** bare-metal on the R710 (an internal SSD/USB for the OS; the pool lives on
   the shelf), **or** Proxmox + ZFS if you want VMs on the same box.
2. Confirm the 24 shelf SSDs are listed as individual disks in Storage → Disks.

## Phase 4 — 520→512 reformat (NetApp SSDs)
NetApp ships SSDs at **520-byte sectors**; ZFS/Linux want **512**. Check one:
```sh
sg_readcap -l /dev/sdX            # look for "Logical block length=520 bytes"
```
If 520, reformat each shelf SSD to 512 (⚠️ **wipes the disk** — these are spare/blank):
```sh
sg_format --format --size=512 /dev/sdX      # repeat per disk; can take minutes each
```
Re-check with `sg_readcap -l` → 512. (Script the loop over all 24 once the device list is confirmed.)

## Phase 5 — ZFS pool + snapshots
1. Create the pool across the 24 SSDs. Layout trade-off for all-flash:
   - **RAIDZ2** (2-drive fault tolerance, ~best capacity) — good default for a backup/NAS pool.
   - **Mirrors (striped)** — best IOPS/resilver, ~half capacity. Pick RAIDZ2 unless you need the IOPS.
2. Enable **compression (lz4)** and **hourly/daily/weekly snapshots** (the delete/ransomware first line).
3. Name it (e.g. `tank`), confirm `zpool status` healthy.

## Phase 6 — Shares (the NAS face)
1. **SMB** share for the office (map `Z:` on PCs — drawings, project folders, big files).
2. **NFS** if any Linux/VM host needs it.
3. Test: write a file from an office PC, read it back, check a snapshot can restore a deleted file.

## Phase 7 — Nextcloud (the Drive/OneDrive face)
1. Nextcloud (TrueNAS app / container) on a dataset → web + desktop sync + **mobile auto photo-upload**
   + **share links** (clients, no accounts) + versioning. Natural home for the Telegram evidence mirror.

## Phase 8 — Backup = this box's real job (fixes OI-7/OI-17)
1. **Proxmox Backup Server** (VM or the Proxmox host) targeting a dataset here → back up the FusionPBX
   VM + other VMs. **This closes the backup gap (OI-7, OI-17).**
2. **ZFS snapshots** already running (Phase 5).

## Phase 9 — Off-site replica (Beverley Place, over the IPsec VPN)
1. Stand up a replica target at Beverley (TO SPEC — a small box / spare bays / second JBOD).
2. **`zfs send/receive`** incremental, scheduled, over the existing VPN. Automatic off-site copy.

## Phase 10 — Disaster copy + restore test
1. **Encrypted** copy to cloud (Backblaze B2 / Wasabi) or a rotating USB kept off-site. **Key is Minda's**
   — Eugene never holds it.
2. **Test a restore** end-to-end — a backup isn't real until a restore works. Restore a VM from PBS and a
   file from a snapshot.

## Result = 3-2-1(-1)
Primary ZFS pool (HQ) + snapshots + PBS + Beverley replica + encrypted cloud/USB. Fixes OI-7/OI-17 and
gives the estate its self-hosted Drive/OneDrive.

## §3 / safety
Guide-only — Minda does every hardware/console step; Eugene specs + verifies. No secrets held (cloud
encryption key, any share passwords stay with Minda). Nothing here touches the live PBX. R&D until it
graduates (`R&D/graduation-register.md`).

## Related
`R&D/estate-storage/design.md`, `R&D/estate-storage/architecture.mmd`, `open-issues.md` OI-7 (laptop-only
VM backups — this supersedes it) / OI-17 (backup gap). Foundation for RND-2 (local AI/RAG) and the
Telegram evidence mirror.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
