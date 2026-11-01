# HQ servers — inventory notes (2026-11-01, read-only)

## Gen9 `pve` (10.224.10.10)
| Item | Value |
|---|---|
| Proxmox | 8.2.2, kernel 6.8.4-2-pve |
| VMs | 100 test (stopped) · **101 FW = OPNsense VM** (running; IPsec to Beverley, dmz .30.11 / inside .11.11) · 102 public-proxy (running, 10.224.30.30) · 103 tftp (stopped) · 104 ssh-gateway (running, 256 MB, 10.224.10.9) · 105 PBX (running, 8 GB) · **106 DocuSeal (STOPPED — 10.224.10.60; ASA shows ~20k hits, so it is used)** |
| Containers | none |
| Storage | local-zfs ~3.6 TB, 0.6 % used, **all pools healthy** · **pbs-nas / pbs-tank inactive: "No route to host" 10.224.10.20:8007 → backups to R710 not running (OI-27)** |
| NICs | 10G `ens6f0np0` + `ens6f1np1` UP (bond0 → 3850 Po4, OVS) · mgmt0 10.224.10.10/24 · Tailscale 100.84.133.120 · onboard eno1–4 DOWN · 4-port 1G card eno49–52 DOWN (the 331T — its slot is the candidate for the 2nd 10G card) |
