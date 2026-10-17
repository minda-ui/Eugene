# Change log — 2026-10-17 — RND-3 R710 brought to life + Proxmox Backup Server LIVE (backup gap closed)

_Guide-only throughout (charter §3): Minda executed every console/BIOS/switch/Proxmox step; Eugene
produced the commands and verified. No credential held or recorded — Minda set the iDRAC and Proxmox
root passwords herself. Continued remotely over Tailscale from Beverley for the PBS half._

## Headline
The spare **Dell R710** (RND-3 interim host) was brought up from bare metal to a running
**Proxmox VE 9.2.2** box on a redundant 2-disk ZFS mirror, put on the HQ server VLAN, and stood up as a
**Proxmox Backup Server**. The **FusionPBX VM (105) now has its first real off-host backup, and the
restore round-trip is proven** — this closes the long-standing backup gap (**OI-7 / OI-17**). The DS2246
shelf remains the later capacity expansion once the SFF-8644→QSFP cable arrives.

## What was done

### 1. R710 bare-metal bring-up (from the 2026-10-16 power-up, completed into 2026-10-17)
- **Service Tag 3MLS95J**; 2× Xeon X5650 (12c/24t), **24 GB ECC DDR3** (POST warns **DIMM B3 disabled,
  MEMBIST failure** — disabled by BIOS, still 24 GB, **not blocking**; reseat/replace B3 later). VT
  already Enabled.
- **iDRAC6** (fw 1.97.02) present; moved off default `192.168.0.130` → **`10.224.10.21`**.
- Internal storage = **PERC 6/i Integrated** (RAID-only, no passthrough) → made **2× single-disk RAID-0
  VDs** (Write-Through, No Read Ahead) from the 2× Seagate 900 GB (ST900MM0006). CP400e (SAS3008) fitted
  (external only; no devices until the shelf is cabled).
- **USB-boot gotcha:** the known-good installer stick dropped offline mid-install on a front USB port
  (SQUASHFS / `device not accepting address -11`) — a **flaky R710 front USB port**, not the stick (it
  had imaged the estate Proxmox boxes fine). Fixed by using a **rear USB port**.
- **OS choice:** only 2 disks + 1 USB, no separate boot disk → **Proxmox VE** installed directly on the
  **2-disk ZFS mirror** (TrueNAS would have needed a dedicated boot disk; Proxmox doesn't, and it matches
  the estate's Proxmox stack + gives native PBS). Hostname `pve-nas`.

### 2. Network wiring (Cisco 3850)
- R710 first landed on an isolated `192.168.0.x` VLAN; no free management ports existed → configured two
  free ports **Gi1/0/44 + Gi2/0/44** (one per stack member) to `switchport access vlan 10`.
- Currently single-homed on **Gi1/0/44** (data NIC `nic0`). Gi2/0/44 reserved for a later
  active-backup bond (switch redundancy).
- **Gateway correction (important lesson):** the per-VLAN host gateway at HQ is **`.1` (the ASA)**, NOT
  the 3850 SVI (`10.224.10.4`). First set the R710 gateway to `.4` → web UI unreachable from Minda's PC
  (ERR_CONNECTION_TIMED_OUT) even though the box could ping Proxmox `.10`. Minda's PC is `10.224.11.62`
  gw `10.224.11.1`, so the gateway is `.1`. Changed R710 gateway `10.224.10.4` → **`10.224.10.1`** →
  web UI loaded, cross-VLAN worked.
- Final: `vmbr0` `address 10.224.10.20/24`, `gateway 10.224.10.1`, `bridge-ports nic0`.

### 3. Remote access (Tailscale)
- After Minda left HQ for Beverley, confirmed the R710 at **10.224.10.20** is reachable over Tailscale via
  the HQ Proxmox subnet router (advertises `10.224.10.0/24`; SNAT handles the return path) — **no
  Tailscale on the R710 itself**. "Proxmox login loaded over Tailscale" confirmed. The PBS half below was
  all done remotely from Beverley.

### 4. Proxmox Backup Server install + datastore
- Discovery: codename **trixie**, pve-manager **9.2.2**, deb822 repo format; `pve-enterprise.sources` +
  `ceph.sources` present (both 401 without a subscription).
- Disabled the two enterprise repos (renamed `.disabled` — reversible), added
  **`pve-no-subscription`** + **`pbs-no-subscription`** (Trixie, deb822, `proxmox-archive-keyring.gpg`).
  `apt update` clean, no 401.
- `apt install proxmox-backup-server` → **PBS 4.2.8-1**; `proxmox-backup-proxy` + `proxmox-backup` both
  `active`. PBS UI at **https://10.224.10.20:8007** (login `root` / realm *Linux PAM*, same root pw).
- Pool `rpool` 832 G, 804 G free, ONLINE (healthy 2-disk mirror). Created dedicated dataset
  **`rpool/pbs-store`** (`/rpool/pbs-store`). PBS datastore **`store1`** → backing path `/rpool/pbs-store`.
- Datastore fingerprint (public cert, not a secret):
  `86:63:e4:79:91:a5:c6:1f:de:a0:e5:db:68:a7:df:ef:f2:a7:5c:95:42:78:89:3d:a2:c6:06:57:cb:90:7e:96`.

### 5. First backup + restore test (the payoff)
- On the HQ Proxmox (`10.224.10.10`): added storage **`pbs-nas`** → server `10.224.10.20`, datastore
  `store1`, user `root@pam`, fingerprint above (Minda typed the password — §3).
- **Backed up VM 105 (FusionPBX)** in **Snapshot mode** (PBX kept running, no call interruption):
  50 GiB transferred in 84 s (609 MiB/s), sparse/incremental, **`TASK OK`** 13:56:20.
- **Restore test:** restored the backup to a **new, unused VM ID 999** (never overwrote the live 105),
  **"Start after restore" left unchecked** (a running duplicate PBX would clash on IP/MAC/SIP). Restore
  completed — `restore image complete (bytes=53687091200, duration=133.44s, speed=383.68MB/s)`. **Round-
  trip proven: backup → restore both work.** Test VM 999 then removed to reclaim the disk (PBS copy
  untouched).

## Result — backup gap CLOSED
- **OI-7** (critical SPOF — no backup on the company PBX): the off-box backup target now exists and the
  first backup + restore are proven.
- **OI-17** (no recent/automated Proxmox backup): the off-box PBS target is live; **remaining = add the
  scheduled nightly vzdump→PBS job with retention** (Datacenter → Backup → Add) to fully automate — a
  ~2-minute step, offered to Minda as the immediate follow-up.

## Lessons (for the runbook / inventory)
- HQ per-VLAN host gateway is **`.1` (the ASA)**, not the 3850 SVI `.4` — a box that can ping its own
  subnet but not cross VLANs almost always has the wrong gateway here.
- R710 **front USB ports are flaky** for installer boot — use a **rear port**.
- Proxmox-on-ZFS-mirror needs no separate boot disk (unlike TrueNAS) — the right call for a 2-disk box.
- PBS installs cleanly **alongside** Proxmox VE on the same host (supported for a single-box lab target).

## Status
RND-3 interim stack **live**: `pve-nas` (10.224.10.20) = Proxmox VE 9.2.2 + PBS 4.2.8, 2-disk ZFS mirror,
reachable on VLAN 10 and over Tailscale. Still R&D until graduation (`R&D/graduation-register.md`).
Later: scheduled nightly backup job (closes OI-17 fully); add Gi2/0/44 bond; buy the QSFP cable + the
other 10 drives → rebuild the mirror into the 2×6 RAIDZ2 ~5.8 TB + add the DS2246.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
