# Runbook — RND-3 interim: build the ZFS pool in the R710's internal bays (no shelf/cable needed)

> **Status:** READY 2026-10-16. **Why:** the SFF-8644→QSFP cable for the DS2246 is 2–3 weeks out and hard
> to source in the UK. This path stands up the whole NAS + backup stack **this week** using the R710's own
> **8× 2.5" internal bays** — no external shelf, no QSFP cable. The **DS2246 joins later as expansion**
> when the cable arrives. Guide-only (§3): Minda does the hardware/console steps, Eugene guides + verifies.
> **2026-10-17:** only 2× Seagate 900 GB in hand so far → **go live now on a 2-way mirror** (Option A), rebuild
> to RAIDZ2 when the other 10 land. The DS2246 remains the later capacity upgrade.
>
> **AS-BUILT (2026-10-17, powering up the R710):** Service Tag **3MLS95J**; 2× Xeon X5650, **24 GB** (POST
> warns **DIMM B3 disabled, MEMBIST failure** → reseat/replace B3 later; not blocking). VT **already
> Enabled**. **iDRAC6** (fw 1.97.02) present, was on default 192.168.0.130 → set to `10.224.10.21`. Internal
> storage = **PERC 6/i Integrated** (RAID-only, no passthrough, SMART not passed to ZFS) → made **2× single-
> disk RAID-0 VDs** (Write-Through, No Read Ahead) for the 2× 900 GB. The **CP400e (SAS3008)** is already
> fitted (external only; shows no devices until the shelf is cabled). NIC1 MAC `D0:67:E5:F3:D0:A5`, NIC2
> `…A7`. **No separate OS drive** (only 2 disks + 1 USB) → **OS = Proxmox VE installed on the 2-disk ZFS
> mirror** (not TrueNAS, which needs a dedicated boot disk); matches the estate's Proxmox stack + native PBS.

## The plan — two ways in, pick by how many drives are in hand
**Option A — GO LIVE NOW on a 2-drive mirror (recommended if only 2 drives are here yet).**
- Put **2× Seagate 900 GB** in the R710 as a **2-way mirror** → **~900 GB usable, survives 1 failure.**
- Enough to prove the whole stack (TrueNAS → pool → PBS → **restore test**) and **start backing up the VMs
  this week** — the VMs (FusionPBX/DocuSeal/Proxmox guests) are tens of GB, so ~900 GB is ample, with room
  for a Nextcloud/SMB test. **Closes the backup gap (OI-7/OI-17) now.**
- ⚠️ **This mirror is a throwaway/interim pool.** ZFS can't reshape a mirror into the final 2×6 RAIDZ2 in
  place, so when the other 10 drives arrive you **destroy + recreate** as the 12-drive RAIDZ2 and re-run
  backups (PBS just backs up again, or a quick `zfs send/receive`). On a days-old backup pool that's
  trivial — nothing of value is lost. **Never stripe the 2** (no redundancy defeats a backup target).

**Option B — wait for all 12, build the final pool once.**
- Put **8–12 of the Seagate 900 GB** in and build **2× 6-wide RAIDZ2 ≈ 5.8 TB** (or 1× 8-wide ≈ 4.3 TB with
  8) — no later rebuild, but no backups until the drives land.

Either way the DS2246 joins later as a **second vdev/pool** once the QSFP cable arrives. **Drives are not the
blocker — the bare R710 is** (Phase 0 first). Use **matched ST900MM0006** drives in any one vdev.

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
4b. **Network wiring (HQ).** Segments: `10.224.10.x` = mgmt/servers (Proxmox `.10`, DL380 iLO `.50`,
   Cisco `.4`, + `.9/.51/.52`); `10.224.13.x` = phones; `10.224.20.x` = WiFi. Switch = Cisco 3850 stack.
   - **Data NIC:** patch **onboard Gb1 → a 3850 access port on the `10.224.10.x` server/mgmt VLAN** (same
     segment as Proxmox `.10` → keeps PBS backups same-subnet/fast; office PCs reach the SMB share via the
     3850's inter-VLAN routing). TrueNAS **static IP** — candidate **`10.224.10.20`** (ping-check it's free
     first).
   - **iDRAC:** if **iDRAC6 Enterprise** (dedicated RJ45) → second cable to a 3850 port on `10.224.10.x`,
     IP **`10.224.10.21`**. If **Express** → iDRAC shares Gb1, just set its IP (no extra cable).
   - ⚠️ **Static IPs or DHCP reservations only** — the DL380 iLO drifted `.78`→`.50` on plain DHCP; a NAS
     that moves IP breaks every mapped `Z:` and every PBS job. Pin both addresses.
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
- Option A: **2× Seagate ST900MM0006** into the R710 bays (Dell caddies). Option B: 8–12×. Power on,
  confirm all fitted drives enumerate (`lsblk`).

## Phase 3 — Host OS
**Interim (2026-10-17, 2 disks + 1 USB only): Proxmox VE on a 2-disk ZFS mirror** — no separate OS drive
needed (TrueNAS would need one). Write the **Proxmox VE ISO** with Balena Etcher (also fixes USB not booting
on this legacy-BIOS R710). Boot (F11 → USB) → **Install Proxmox VE** → **Target Harddisk → Options →
Filesystem `zfs (RAID1)` → tick both VDs** → root pw (Minda holds) → network **10.224.10.20/24**, gw as the
other 10.224.10 kit, hostname set → install → reboot → `https://10.224.10.20:8006`. The rpool mirror holds
OS + data; PBS runs natively.
- *(Final shelf build later could use TrueNAS SCALE on a dedicated boot disk; the interim box is rebuilt
  then anyway — see Phase 8.)*

## Phase 4 — Sector-size check
```sh
sg_readcap -l /dev/sdX      # expect 512 (Seagate Savvio = 512n). If 520: sg_format --format --size=512
```
(These Seagates are 512n, so this should just pass — quick sanity check.)

## Phase 5 — ZFS pool + snapshots
- **Option A (2 drives, go-live now): 2-way MIRROR → ~900 GB usable, 1-disk fault tolerance.**
  (TrueNAS: pool → Mirror, 2 disks. CLI: `zpool create tank mirror <d1> <d2>`.) **Not** a stripe.
- **Option B (8–12 drives, final): 2× 6-wide RAIDZ2 ≈ 5.8 TB** (or 1× 8-wide ≈ 4.3 TB with 8).
  (CLI: `zpool create tank raidz2 <d1..d6> raidz2 <d7..d12>`.)
- Enable **lz4 compression** + **hourly/daily/weekly snapshots**. `zpool status` healthy.
- ⚠️ **Mirror → RAIDZ2 is not an in-place reshape.** When the 10 drives arrive: back up / `zfs send` the
  datasets off (or just let PBS re-backup), **destroy the mirror pool**, recreate as Option B, re-run
  backups. Trivial on a days-old backup pool. (See Phase 8.)

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
