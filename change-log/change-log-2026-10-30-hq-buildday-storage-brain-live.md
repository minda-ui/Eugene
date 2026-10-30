# Change log — 2026-10-30 — HQ build day: storage pool + Gen9 brain LIVE (guided, §3)

_Eugene guided live; Minda did all the hands-on at HQ and held every credential (§3). A marathon,
interactive build. The office was empty (phones/systems free), so the phones-outage window was open._

## Outcome — the big items are LIVE and reboot-proven
- **RND-3 storage: LIVE.** The full-shelf ZFS pool is built on the R710 (`pve-nas`).
- **RND-2 brain: LIVE.** The Gen9 DL380 now has 256 GB RAM + 2× Tesla P40 + new PSU; phones confirmed.
- **Backups:** all 6 Gen9 VMs backed up to the new pool + local snapshots before the hardware work.
- **One item left:** pve-nas is **network-isolated** (a cable went into the wrong switch port during the
  work) — its **data is safe**, it just needs its uplink cable moved back to `Gi1/0/44` (OI-27). Minda
  finishes it tomorrow.

## PART 1 — storage pool on the R710 (`pve-nas`) ✅
- **CP400e HBA confirmed in IT mode** (`lspci` → SAS3008 on `mpt3sas`; the PERC 6/i is separate, on
  `megaraid_sas`, holding the 2 boot disks) — **no crossflash needed.**
- **DS2246 shelf** cabled SFF-8644 (CP400e) → **square ▪ (input) port** on the IOM; all **24 drives
  enumerated.**
- **Drive correction:** the shelf drives are **NetApp `X423_SLTNG900A10`**, not the Seagate ST900MM0006
  the runbook assumed — but they're **512 n** (LOG-SEC/PHY-SEC = 512), so **no `sg_format` 520→512 reformat
  needed.** (Update the RND-3 runbook's drive note.)
- **Pool built:** `zpool create -f -o ashift=12 tank raidz2 (6) raidz2 (6) raidz2 (6) raidz2 (6)` →
  **`tank` = 4× 6-wide RAIDZ2, 12.9 TB usable**, lz4 + atime=off. Then **exported and re-imported by-id**
  so it's locked to stable `wwn-*` names — **confirmed it auto-imports on reboot.**
- **PBS datastore** `tank-store` → `/tank/pbs` created on the pool. **Append-only token** `root@pam!gen9-backup`
  with **privilege separation + DatastoreBackup only** (OI-26: the source can write backups, cannot
  prune/delete). Minda holds the token secret (1Password).

### ⚠️ PERC 6/i transient fault (watch item)
During the shelf work the R710's **PERC 6/i firmware faulted** (OCR, then `rpool` suspended — I/O error on
both boot disks at once = the controller, not the disks). A **cold power-cycle cleared it**; rpool imported
clean. It **booted clean a second time** too (Minda rebooted the R710 later). So it reads as a **one-off
transient on a 16-year-old controller** — but flagged to **watch for recurrence** (if it repeats, the
R710's boot reliability is in question; the data pool `tank` is on the healthy CP400e, not the PERC).

## PART 2 — backed up the Gen9 VMs ✅
Added the PBS storage `pbs-tank` on the Gen9, backed up **all 6 VMs to `tank-store`**:
100 skipped (test), **101 FW, 102 public-proxy, 103 tftp, 104 ssh-gateway, 105 PBX (phones), 106 Docuseal**
— all TASK OK. Plus **local Proxmox snapshots of 105 + 106** (`pre-upgrade`) so the phones rollback doesn't
depend on the R710. (Verified backups present on `pbs-tank`.)

## PART 3/4 — Gen9 brain hardware + verify ✅
- **RAM → 256 GB** (8× 32 GB, Advanced ECC) — POST confirmed 256 GB, both E5-2695 v4.
- **2× Tesla P40** fitted — `lspci` shows both (`08:00.0` + `84:00.0`, GP102GL). Above-4G Decoding was
  already on. **No GPU load test** (baffle not yet in — load gated, fit is fine).
- **1400 W PSU** fitted.
- **10 G NIC KEPT** — see the decision reversal below.
- NVIDIA driver not installed yet (that's the AI-machine software step, later).
- **Phones verified working** (internal / outbound / inbound). Outage window closed.

## DECISION REVERSED — the 10 G stays in the brain
The earlier plan (and open PR #30) was: **move the 10 G NIC to the Gen10, run the brain on 1 G.** At the
build, **both P40s fit with the 562SFP+ left in place** — no slot contention after all. So the **brain
keeps its 2× 10 G** (better for it), and **nothing moves.** This **reverses PR #30.** Consequence: the
**Gen10 storage spine will need its own 10 G NIC** later (the 3850 stack has only the 2× 10 G the brain now
uses — switch **Po4 "SERVER-DL380"**, cross-stack LACP `Te1/1/4`+`Te2/1/4`). Corrected in `design.md`,
`gen10-r710-replacement.md`, and the HQ inventory; PR #30 superseded by this build's PR.

## LESSON — adding PCIe cards renamed the NICs → OVS bond broke (OI-28)
Fitting the P40s shifted the PCI addresses, so the **10 G NIC renamed `ens3f0np0/ens3f1np1` → `ens6f0np0/
ens6f1np1`**. The Gen9 runs **OVS networking**, and both `/etc/network/interfaces` **and the live OVS DB**
referenced the old names → **`bond0` lost its members → no uplink → phones/host offline.** Fix:
1. `sed` the interface names in `/etc/network/interfaces` (ens3f* → ens6f*).
2. `ifreload -a` **warned "bond0 not recognized"** and did **not** fix the OVS bond — the OVS database still
   had the old dead ports (`ovs-vsctl show` → "could not open network device ens3f* (No such device)").
3. Rebuilt the bond directly: `ovs-vsctl --if-exists del-port vmbr0 bond0` then
   `ovs-vsctl add-bond vmbr0 bond0 ens6f0np0 ens6f1np1 bond_mode=balance-tcp lacp=active` (+ `mtu_request=9100`).
4. Gateway pinged, LACP formed (3850 ports green). **Verified it survives a reboot.**
**Takeaway for any future card change on an OVS Proxmox host:** adding/removing PCIe cards can rename NICs;
fix the names in `/etc/network/interfaces` **and** rebuild the OVS bond with `ovs-vsctl` (ifreload alone
won't). **Follow-up:** pin the 10 G NIC names by MAC via a systemd `.link` file so a future shuffle can't
rename them (OI-28).

## pve-nas network isolation (OI-27, Minda finishes tomorrow)
After its reboot, pve-nas can't reach the gateway or the Gen9. Diagnosed to the end: pve-nas's **config +
bridge are correct** (`nic0` → `vmbr0`, VLAN 10, `master vmbr0 state forwarding`, link up), and its **port
`Gi1/0/44` is the right VLAN-10 access port** — but **cables were changed during the build**, so `nic0`'s
cable is almost certainly in the **wrong switch port now** (link up, wrong VLAN). **Tomorrow:** on the 3850,
`show mac address-table address d067.e5f3.d0a5` (pve-nas nic0 MAC) to find the port it's really on; if it's
not VLAN 10, move the cable back to **`Gi1/0/44`**; then `ping 10.224.10.1` from pve-nas and
`ping 10.224.10.20` from the Gen9. **Data is safe throughout** (pools ONLINE, backups intact).

## Switch map captured (HQ 3850 stack)
`Po1 "ASA-1"` (trunk) · `Po2 "ASA-2-STANDBY"` (trunk) · **`Po4 "SERVER-DL380"` = the Gen9's 2× 10 G LACP**
(trunk, `Te1/1/4`+`Te2/1/4`) · `Gi1/0/44 "R710 pve-nas"` (VLAN 10 access) · `Gi2/0/47 "d1380 iLO"` (VLAN 10)
· `Gi1/1/1 "## Uplink to StarL"` (VLAN 2) · gateway `10.224.10.1` MAC `54:75:d0:e3:da:56` (Cisco/ASA).
Folded into the HQ inventory.

## Still to do
- **pve-nas uplink** (OI-27, Minda tomorrow — above).
- **PART 5 DocuSeal** (OI-21 a+c) — not started; needs the Workspace SMTP relay set first (propagation).
- **NVIDIA driver + model stack** on the brain (the P1 AI-machine build, a later session).
- **OI-26 Phase A remainder** on the new PBS: PBS-side prune/GC/verify jobs + ZFS snapshots of `tank/pbs`.
- **Pin the 10 G NIC names by MAC** on the Gen9 (OI-28) so a future card change can't break the bond again.
- **Watch the PERC 6/i** for any fault recurrence.

## §3 posture
Guided throughout — Minda did every hands-on step at HQ and held all credentials; Eugene guided + verified
and held no secret. The §3 "human executes live-system changes" line was exactly how this ran.
