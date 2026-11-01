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

## Gen9 lid-off + iLO
- Lid-off photos (no changes); air guides refitted; Gen9 back: VMs 101/102/104/105 auto-started, R710 reachable. CPUs **E5-2695 v4** confirmed (v3 sticker is a leftover). BIOS **Static Low Power** flagged. Slots/DIMMs mapped (I350 = FlexibleLOM).
- **iLO static IP (AWT-1060 / OI-31): `10.224.10.21`**, DHCP off, NTP set, iLO reset. iLO Advanced now licensed → monitoring plan: read-only `monitor` user, AlertMail, Kuma Redfish health check, firmware check (remote, later).
- Address register (mgmt vlan 10, static, outside DHCP .50–.240): .1/.2 ASA · .4 3850 · .9 ssh-gw · .10 Gen9 · .20 R710 · **.21 Gen9 iLO** · (.60 DocuSeal — inside pool, retire).

## Visit end (~10:45, Minda back to Beverley) — summary
Done: UPS self-tests ✅ · ASA + 3850 exports (masked) ✅ · **internet-exposed admin forwards closed** ✅ · public IPs answered ✅ · Gen9 + R710 inventory ✅ · **R710 back on (was powered off) → OI-27 resolved, backups confirmed + fresh PBX backup** ✅ · Gen9 lid-off, slots/DIMMs mapped ✅ · **Gen9 iLO static 10.224.10.21 + NTP (OI-31/AWT-1060)** ✅ · iLO Administrator password changed ✅ · Wi-Fi heatmaps + O2 log ✅ · booster = non-compliant, left off ✅.
Carried over: UPS socket/device list (needs a site visit) · Wi-Fi AP positions + map orientation (Minda, remote) · R710 lid/x8 slot · next planned Gen9 reboot: Power Regulator → Dynamic, re-enter serial CZJ64905NP + Product ID · Gen9 10G card goes in with the P40 move · OI-33 ASA hardening (ssh-gw, DocuSeal forward, any-any, Wi-Fi→mgmt) · 3850: Gi2/1/1 "home-sw" question, Gi2/0/6 err-disabled, remove leftover WLAN config, half-finished upgrade check.

## Beverley (afternoon)
- Beverley UPS (SUA3000) self-test passed; load 0/5.
- Beverley ASA exported via Gen9 SSH (10.224.10.254), masked copy + notes in Infra-Inventory/exports/. Raw copies (Gen9 /root + Drive Raw/) **deleted by Minda**. Loxone MACs (50:4F:94) found → AWT-1063 proposed statics .2–.5. Beverley 3850 not reachable by SSH (refused/timeout) — console next visit.
