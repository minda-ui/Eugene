# Runbook — HQ build day (Saturday): storage pool + Gen9 brain, in the safe order

> **Eugene, 2026-10-28 (guide-only, §3).** One checklist for Saturday's HQ build. **Minda does the
> hands-on; Eugene guides + verifies; holds no credential.** Two builds in one day, deliberately ordered
> so the **zero-risk** work (R710 storage) comes first and its PBS then **protects** the **phones-risk**
> work (opening the live PBX host). Sources: `R&D/estate-storage/design.md` + `Runbook-RND3-Estate-Storage-Build.md`
> (storage), `R&D/local-models/parts-list.md` (P40 fit), `R&D/software-foundry/ram-upgrade-spec.md` (RAM),
> `Runbook-Backup-PullNotPush-Hardening.md` (append-only PBS, OI-26).

## ⚠️ The one difference that sets the order
- **R710 storage = separate box, phones untouched → zero risk.** Do it first.
- **Gen9 DL380 = the LIVE PBX host (VM 105).** Fitting RAM + P40s + PSU means **powering it down = a planned
  phones-outage window.** Back up its VMs to the new PBS first; verify phones back up before you finish.

## Pre-flight (before you start)
- [ ] **Parts in hand:** SAS cable ×2 (delivered ✅), 1400 W PSU (delivered ✅), 2× P40 + both risers + both
      power cables (dry-fitted ✅), high-perf fans (fitted ✅), **128 GB RAM kit — arriving Fri** (4× 840758-091).
- [ ] ⚠️ **GPU baffle/shroud** — the one outstanding item (`parts-list.md`). The P40s are **passively cooled**;
      without the baffle they **overheat under load**. **If it's not here by Saturday:** you can still do the
      full mechanical fit, but **don't run the GPUs under sustained load** (no model burn-in) until it's in.
      Idle/seated P40s are fine; it's load that cooks them.
- [ ] **Pick the phones-outage window** (evening/quiet period). Tell anyone who needs to know phones are down.
- [ ] Keyboard that works in a boot shell (the plain-keyboard lesson), labels/torch, anti-static.

---

## PART 1 — R710 storage pool (zero phone risk) — do first
**32 drives, all in hand:** 24 in the DS2246 shelf + 8 in the R710 internal bays. Full detail in
`Runbook-RND3-Estate-Storage-Build.md`. Order that matters:
- [ ] **Internal HBA for the 8 internal bays (DECIDED — adding it).** The R710 has a **PERC 6/i (RAID-only,
      no IT mode)**, so the internal bays need a **cheap internal HBA to join ZFS cleanly.**
      - **Buy it pre-flashed to IT mode** — "**LSI 9211-8i IT mode**" (or a Dell H200/H310 sold "IT-mode
        flashed"), ~£15–25, next-day eBay UK, **internal SFF-8087** ports. Pre-flashed = **no flashing on
        the day**, just fit it in a riser and move the internal backplane SAS cable to it. **This is the
        easy, safe path — get the pre-flashed one.**
      - **Only if it arrives as a RAID card** (H200/H310/9240 in IR firmware): it must be crossflashed to
        **9211-8i IT** before use. **Don't run a generic flash blind** — at the box, read the current
        firmware (`sas2flash -list`), **back up the SAS address first**, then Eugene gives the exact
        per-card `megarec`/`sas2flash` sequence for *that* card (a wrong .bin can brick it). Single-disk
        RAID-0 VDs are a last resort only — **not recommended** (hides SMART from ZFS).
      - **If the HBA isn't here by Saturday:** build the **shelf only** (already ~3× the need) and add the
        internal 8 once it lands — no rework.
1. [ ] **Fit the CP400e HBA → boot → confirm IT mode FIRST:** `sas3flash -list`. If it reports **IR/RAID**,
       crossflash to **9300-8e IT** firmware *before* building any pool. This is the check that can stop the
       day — do it before cabling the shelf.
2. [ ] **Cable SFF-8644 (HBA) → QSFP/SFF-8436 (DS2246 IOM A).** (Second cable to IOM B later for multipath.)
3. [ ] **Boot the storage OS → confirm all bays enumerate** (24 shelf + 8 internal). Drives are Seagate
       ST900MM0006 **512n**, so **skip the `sg_format` 520→512 step** — not needed.
4. [ ] **Build the pools (two, split by controller — never mix shelf + internal in one vdev):**
       - **`tank` (shelf, CP400e):** **4× 6-wide RAIDZ2 ≈ 11.6 TB** — bulk store.
       - **Boot:** 2× internal mirror (`rpool`) — already built.
       - **Internal data (new HBA):** remaining 6 → **1× 6-wide RAIDZ2 ≈ 2.9 TB** (or all 8 ≈ 4.3 TB if boot
         moves to an SSD). **Total ≈ 14.5 TB.** Enable **ZFS snapshots** (hourly/daily/weekly) on both.
5. [ ] **SMB/NFS share → map a test drive** from an office PC, write a test file.
6. [ ] **Stand up PBS** on the box — and wire it **append-only from the start** (don't retrofit OI-26):
       - PBS token for the HQ Proxmox = **`DatastoreBackup` only** (no Prune/Modify).
       - **Prune + GC + verify scheduled on the PBS box**, not on the PVE job.
       - A short **ZFS snapshot** history of the PBS datastore (`rpool/pbs-store`).
       (Steps in `Runbook-Backup-PullNotPush-Hardening.md` Phase A.)

---

## PART 2 — Back up the Gen9 production VMs to the new PBS (the safety net)
Before touching the Gen9 hardware, get a fresh backup of what's on it — so the "brain surgery" is reversible.
1. [ ] On the HQ Proxmox, **run a backup now** of **VM 105 (FusionPBX)** + the other production VMs to the new
       `pbs-nas` datastore → **TASK OK** on each.
2. [ ] (Belt-and-braces) take a **Proxmox snapshot** of VM 105 as well.
This is the synergy of doing storage first: the pool you built this morning now protects the phone server.

---

## PART 3 — Gen9 power-down window: do ALL the internal work in ONE box-opening
Open the DL380 **once** — fit RAM **and** P40s **and** the PSU together, not three separate outages.
1. [ ] **Graceful-shutdown** the Gen9 (stop VMs cleanly, then power off). Phones are now down — window open.
2. [ ] **RAM → 256 GB (8× 32 GB).** Add the 4× new **840758-091** to the 4× existing **809083-091**.
       - Both are **32 GB 2Rx4 RDIMM** → mixing is fine (never mix RDIMM+LRDIMM); all run at **2400**.
       - **Populate one DIMM in every channel = 4 per CPU, mirrored on both CPUs** → all **8 channels at
         1 DPC** = full bandwidth at 2400 (the config CPU inference wants). Follow the **HPE slot-population
         order** silk-screened on the board / in iLO (fill each channel's first slot before any second slot).
3. [ ] **PSU:** fit the **1400 W** (720620-B21). (It replaces the eBay pair that failed testing. Ideally run
       **2× for redundancy** if you have both; one 1400 W will power the box but gives no PSU redundancy.)
4. [ ] **P40s + risers** (already dry-fitted): seat both cards, connect **each P40's 8→10-pin power cable**,
       confirm the P840/NICs clear the double-wide heatsinks (per the 2026-10-16 dry-fit).
5. [ ] **Baffle:** fit it if you have it. If not → cards stay seated but **no load test today** (see pre-flight).
6. [ ] **BIOS on fit day:** enable **"Above 4G Decoding"** (+ large/≥ MMIO if present) so both 24 GB P40s map.

---

## PART 4 — Power up + verify (close the window properly)
1. [ ] **POST / iLO:** confirm **256 GB** at **2400 MT/s**, both CPUs, both P40s detected.
2. [ ] **Boot Proxmox → start the VMs → VERIFY PHONES:** internal call, **outbound**, and **inbound** (the
       OI-8 path) all work with two-way audio. **Don't call the window closed until phones are confirmed.**
3. [ ] **GPUs:** `nvidia-smi` lists **2× Tesla P40**, each 24 GB. (Install/confirm the driver.)
4. [ ] **Only if the baffle is in:** a short load test (watch `nvidia-smi` temps). Otherwise defer.
5. [ ] If anything's wrong with the PBX after boot → you have the PART-2 backup + snapshot to restore from.

## After the day
- Update `Infra-Inventory/` (256 GB, 2× P40, the storage pool + PBS), the change-log + ledger, and
  `R&D/` statuses (RND-2 brain hardware in; RND-3 storage live; RND-19 RAM fitted). Mark OI-7 context.
- **Friday's Gen10 order** is separate (confirm the 24SFF SAS expander, add 64 GB 2933 RAM, 865408-B21 PSUs).

---
_Guide-only (§3): Minda does the hands-on and holds all creds; Eugene guides + verifies. Order = zero-risk
storage first, then its PBS protects the phones-risk Gen9 work. Baffle gates GPU load, not the fit. Pairs
with RND-2/3/19 + the OI-26 append-only PBS hardening._
