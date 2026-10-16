# Runbook — RND-3 interim: build the ZFS pool in the R710's internal bays (no shelf/cable needed)

> **Status:** READY 2026-10-16. **Why:** the SFF-8644→QSFP cable for the DS2246 is 2–3 weeks out and hard
> to source in the UK. This path stands up the whole NAS + backup stack **this week** using the R710's own
> **8× 2.5" internal bays** — no external shelf, no QSFP cable. The **DS2246 joins later as expansion**
> when the cable arrives. Guide-only (§3): Minda does the hardware/console steps, Eugene guides + verifies.

## The plan
- Put **8 of the 12 Seagate 900 GB** drives in the R710's internal bays.
- Pool: **1× 8-wide RAIDZ2 ≈ 4.3 TB usable** (6 data + 2 parity; survives 2 failures). Covers the ~4.6 TB
  target essentially on its own, so backups + Nextcloud + Drive copy can all start now.
- Later: add the DS2246 (12+ drives) as a **second vdev/pool** for capacity once the QSFP cable lands.

## Phase 0 — Bring the R710 to life (it has no OS yet)
**Goal:** get it POSTing, sane in BIOS, reachable on iDRAC, with install media ready. Nothing destructive.
1. **Power + console.** Both PSUs to mains (redundant). Monitor on the **VGA** port + USB keyboard (or use
   iDRAC once it's up). Press power.
2. **Watch POST.** It should pass memory + CPU and reach a boot prompt (there's no OS, so it'll end at
   "No boot device"/PXE — that's expected and fine). **Note the banners as they flash:** BIOS version,
   **iDRAC6**, and the **PERC/SAS controller** (H200/H310/H700/6iR). Snap a photo of the storage-controller
   line — that decides the IT-mode path.
3. **BIOS sanity (F2 → System Setup):**
   - **Processor Settings → Virtualization Technology = Enabled** (and **VT for Direct I/O / IOMMU** if
     present) — needed if you ever run VMs/PBS on this box.
   - **Date/Time** correct.
   - **Boot order:** we'll point it at USB/the new boot disk when installing.
4. **iDRAC for remote management (F10 Lifecycle Controller, or Ctrl+E at post → iDRAC Settings):**
   - Set **iDRAC IPv4** — DHCP, or a static in the HQ mgmt range. Note the IP + MAC.
   - Set an iDRAC **admin password** (Minda holds it — §3, Eugene never records it).
   - Then browse to `https://<idrac-ip>` from the HQ LAN → Virtual Console + Virtual Media (lets us mount
     the installer ISO and drive the box remotely without standing at it). *iDRAC6 virtual console is
     Java-based and fiddly — a physical monitor is fine for the install if iDRAC KVM won't cooperate.*
5. **Have ready for the OS install (next phase):**
   - **TrueNAS SCALE ISO** on an **8 GB+ USB stick** (write with Rufus/balenaEtcher), **or** mount it via
     iDRAC Virtual Media.
   - A **boot device for the OS**, separate from the pool: a small **SSD** (on an internal SATA port or a
     spare bay) is best — TrueNAS SCALE no longer recommends USB-stick boot. ~120 GB is plenty.
   - A **network cable** into an HQ switch port.
6. **Report back:** POST clean? Controller model? RAM seen (should be 24 GB)? iDRAC reachable? Then we pick
   the IT-mode path and install.

## ⚠️ Two things to confirm at the box FIRST (gathered during Phase 0)
1. **Which storage controller?** (decides IT-mode path — the only real gotcha.)
   - See it at **POST** (the PERC/SAS banner as the R710 boots), or **iDRAC → Storage**, or the
     **Lifecycle Controller → Hardware Config**.
   - **PERC H200 / SAS 6/iR / H310** → can be **crossflashed to IT mode** (free) → raw disks for ZFS. ✅
   - **PERC H700** → **RAID-only, no HBA/IT mode.** ZFS can't own raw disks through it. → buy a cheap
     internal HBA (**Dell HBA / LSI 9211-8i IT mode**, ~£15–25, common + next-day on eBay UK) and use the
     R710's internal SFF-8087 cable into it. (Faster to get than the external QSFP cable.)
2. **Dell 2.5" caddies for the R710 bays.** ⚠️ The R710's internal bays use **Dell R710 2.5" trays**, NOT
   the NetApp DS2246 caddies (those are for the shelf). Check the R710's bays already have 8 Dell caddies
   (often shipped fitted). If not, they're ~£3–5 each on eBay UK, next-day. (Keep the 24 NetApp caddies
   for the shelf.)

## Phase 1 — Controller in IT/HBA mode
- **H200/H310/6iR:** crossflash to IT firmware (LSI 9211-8i IT). Ask Eugene for the exact `sas2flash`
  sequence when you're at the box (back up the SAS address first). After flashing, the controller presents
  each disk raw.
- **H700:** don't fight it — fit the cheap internal HBA, move the internal SAS cable to it. (Or, if you'd
  rather, a single-disk RAID0 per drive is possible but **not recommended** for ZFS — go HBA.)
- Verify: booted into a Linux/TrueNAS shell, `lsblk` / `sas2flash -list` shows all 8 disks individually.

## Phase 2 — Fit the drives
- 8× Seagate ST900MM0006 into the R710 bays (Dell caddies). Power on. Confirm all 8 enumerate.

## Phase 3 — Host OS
- Install **TrueNAS SCALE** bare-metal on the R710 (OS on a small internal SSD/USB, or a pair of the bays
  mirrored for boot — but simplest: a USB/SSD for the OS, all 8 bays for the pool).

## Phase 4 — Sector-size check
```sh
sg_readcap -l /dev/sdX      # expect 512 (Seagate Savvio = 512n). If 520: sg_format --format --size=512
```
(These Seagates are 512n, so this should just pass — quick sanity check.)

## Phase 5 — ZFS pool + snapshots
- Create **1× 8-wide RAIDZ2** from the 8 drives → ~4.3 TB usable.
  (TrueNAS: pool → RAIDZ2, 8 disks. CLI: `zpool create tank raidz2 <d1..d8>`.)
- Enable **lz4 compression** + **hourly/daily/weekly snapshots**. `zpool status` healthy.

## Phase 6 — Shares + Nextcloud
- SMB share (map `Z:` on a PC, test write/read + snapshot restore). Nextcloud app for the Drive/OneDrive
  experience (web, desktop sync, mobile photo-upload, share links).

## Phase 7 — PBS = start backups now (closes OI-7/OI-17)
- Stand up **Proxmox Backup Server** targeting a dataset here; back up the FusionPBX VM + other VMs.
  **This is the win — the backup gap closes this week, not in three.**

## Phase 8 — later, when the QSFP cable arrives
- Fit the CP400e in the R710, cable to the DS2246 IOM A, confirm IT mode (`sas3flash -list`).
- Add the shelf drives as a **second RAIDZ2 vdev into `tank`** (grows the same pool) or a second pool for
  bulk/cold. Then Beverley `zfs send` replica + encrypted disaster copy.
- Full shelf procedure: `Runbooks/Runbook-RND3-Estate-Storage-Build.md`.

## §3 / safety
Guide-only; Minda runs every hardware/console step. No secrets held. Nothing touches the live PBX. R&D
until graduation (`R&D/graduation-register.md`).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
