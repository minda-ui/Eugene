# HQ servers — inventory notes (2026-11-01, read-only)

## Gen9 `pve` (10.224.10.10)
| Item | Value |
|---|---|
| Proxmox | 8.2.2, kernel 6.8.4-2-pve |
| VMs | 100 test (stopped) · **101 FW = OPNsense VM** (running; IPsec to Beverley, dmz .30.11 / inside .11.11) · 102 public-proxy (running, 10.224.30.30) · 103 tftp (stopped) · 104 ssh-gateway (running, 256 MB, 10.224.10.9) · 105 PBX (running, 8 GB) · 106 DocuSeal (stopped — **not needed, per Minda 2026-11-01**; ASA still forwards 80/443 to .60 → remove in OI-33 clean-up) |
| Containers | none |
| Storage | local-zfs ~3.6 TB, 0.6 % used, **all pools healthy** · **pbs-nas / pbs-tank inactive: "No route to host" 10.224.10.20:8007 → backups to R710 not running (OI-27)** |
| NICs | 10G `ens6f0np0` + `ens6f1np1` UP (bond0 → 3850 Po4, OVS) · mgmt0 10.224.10.10/24 · Tailscale 100.84.133.120 · onboard eno1–4 DOWN · 4-port 1G card eno49–52 DOWN (the 331T — its slot is the candidate for the 2nd 10G card) |
| PCI (lspci) | Broadcom **BCM5719 4×1G** (02:00, onboard/FLOM) · Intel **I350 4×1G** (04:00 — add-in card, probably HPE 366T; *corrects "331T"*) · Smart Array Gen9 (05:00) · **Tesla P40** ×2 (08:00, 84:00) · Intel **X710 2×10G SFP+** (81:00 — the 562SFP+, CPU2 side; works with the Cisco DACs) |
| Memory | **251 GB total, 11 GB used** (lots spare → 4 sticks to Beverley later is fine) |

## R710 `pve-nas` (10.224.10.20)
| Item | Value |
|---|---|
| Proxmox | **9.2.2**, kernel 7.0.2-6 (newer than the Gen9's 8.2.2 — Gen9 upgrade is a later, planned job) |
| VMs | none (runs Proxmox Backup Server stores only) |
| Pools | all healthy |
| NICs | 4× Broadcom BCM5709 1G onboard; **nic0 → vmbr0 10.224.10.20/24**, nic1–3 down |
| Storage controllers | PERC 6/i (LSI 1078, integrated slot) · **CP400e LSI SAS3008** (one PCIe slot, shelf) |
| Memory | 23 GB (DIMM B3 disabled) |
| PCIe | R710 has 4 slots; CP400e uses one → ~3 free; **x8 slot for the Mellanox to confirm with lid off** |
| Note | Was found **powered off** 2026-11-01 — check BIOS "AC Power Recovery" = On and that it's on a UPS outlet |

### Gen9 POST screen (2026-11-01 reboot)
| Item | Value |
|---|---|
| BIOS | P89 **v3.40 (29/08/2024)**, redundant ROM valid |
| CPUs | **2× Xeon E5-2695 v4** @ 2.1 GHz, 36 cores, HT on (the heatsink sticker "E5-2650 v3" is a leftover label — v4 confirmed, so the P40 v4 prerequisite *was* met) |
| Memory | 256 GB, Advanced ECC |
| ⚠️ Power | Power Profile **Custom**, Power Regulator **Static Low Power — CPUs clocked down**. Slows the CPU-only AI pilot on this box. Change to *Dynamic Power Savings* (or Static High Performance) in RBSU at the next planned reboot. |
| Inlet temp | **18 °C** |
| Heatsinks | 747608-001 (spare 777290-001) and 759519-002 — two different types |
| DIMMs | HPE 809083-091 (32 GB 2Rx4 DDR4-2400), Micron, white slots |
