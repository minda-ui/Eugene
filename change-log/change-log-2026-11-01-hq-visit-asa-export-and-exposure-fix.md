# Change log — 2026-11-01 (Sun) — HQ visit: UPS checks, ASA export, internet exposure closed

_Minda at HQ, guided live (§3). No credential held by Eugene._

## UPS (Block 1)
Both HQ SUA2200RMI2U: self-test **passed**, battery full, no alarms. Top JS0727011051 (2/5 load), bottom AS1111… (0/5) → imbalance confirmed. SmartSlots free for AP9631. No UPS monitoring today.

## ASA export (Block 2)
Full export saved masked → `Infra-Inventory/exports/hq-asa-2026-11-01-export-MASKED.txt` + notes. Secondary unit currently active; ASA 9.1(7)32; clock wrong (no NTP); Wavenet = **one public IP (/30)**; BT /29 idle; Vodafone link found (vlan 3).

## 🔴 Security: admin ports open to the internet → CLOSED (Minda executed, 2026-11-01)
- Found: every outside ACL ends `permit ip any any`, so port-forwards to **Proxmox SSH (22024), Proxmox GUI (35392), iLO (16078), 3850 SSH (22023)** were reachable from anywhere (24,579 hits on Proxmox SSH).
- Checked Proxmox: **763 failed SSH logins since 1 Oct, 0 successful from outside** — all 9 accepted logins internal (10.224.11.x / 10.224.20.x) on 1 Oct. No sign of compromise.
- **Fix:** removed all 12 static NATs for those 4 services on outside_fttb/bt/vf; `write memory` OK; `show nat detail | include 22024|35392|16078|22023` → empty. Rollback = same lines without `no`.
- **Still open:** ssh-gateway forward (22999) — purpose to confirm; `permit ip any any` on outside ACLs; Wi-Fi (sec 100) reaches mgmt; Proxmox root password SSH; DocuSeal .60 inside DHCP pool; statelink down; NTP. → OI-33.

## R710 / backups (Block 5)
- Gen9 couldn't reach pve-nas 10.224.10.20 (PBS stores inactive). R710 nic0 UP, MAC not on 3850 → the R710 was **powered off** (Minda: "it was not booted"); started it. Once up: Gen9 → 10.224.10.20 ping OK. **OI-27 resolved.** Next: PBS stores active + a fresh backup (no backups since ~30 Oct).
- Why was it off? Unknown — check its iLO/iDRAC log or power cable/UPS outlet; add to UPS-outlet list.
- `pvesm status`: **pbs-nas active** (843 GB, 1.5 % used) · **pbs-tank active** (13.9 TB, 0.08 %).
- Backup jobs exist (`/etc/pve/jobs.cfg`): **02:00 → pbs-nas**, VMs 101,102,103,105,106, keep-daily 14 · **21:00 → pbs-tank**, VMs 101–106, **no prune set** (tidy later) · `repeat-missed 0` → nights missed while the R710 was off were not caught up. **OI-17 (nightly job) effectively done.** Minor: 104 ssh-gateway not in the 02:00 job; 106 DocuSeal backed up though not needed.
- **Manual PBX backup OK** 09:40–09:41 → pbs-tank: 50 GiB in 53 s, incremental (98 % reused — earlier backups intact), 'Backup job finished successfully'.
