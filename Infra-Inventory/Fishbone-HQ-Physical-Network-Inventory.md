# Infra Inventory — Fishbone HQ Physical Network & On-Prem Hardware

_Eugene's living inventory of physical/on-prem infrastructure — first entry of this kind (everything
else in `Infra-Inventory/` so far has been cloud/Workspace state). Built 2026-09-17 from Minda's own
photos and direct answers during a structured walkthrough; cite, never copy secrets (charter §3).
**Eugene has no device-level access to anything in this file** — no SSH/console/ASDM/API connector for
any of it. Documentation and advisory only; Minda (and, for the firewalls, a contractor she brought in)
execute all changes. Confirmed facts carry a date; anything inferred rather than directly confirmed is
flagged as such._

## Sites

Fishbone's network spans **two physical locations**, tied together as one logical network:

| Site | Address | Role |
|---|---|---|
| **Fishbone HQ** | Unit 30–31, Point Pleasant Industrial Estate, Wallsend, NE28 6HA | Main site — office, workshop, and most of the network core |
| **Beverley Place** | 6 Beverley Place, Wallsend, NE28 7BH | Fishbone's registered company address; also Minda's home. Hosts a small server rack, the UniFi controller, and its own internet connection |

**Inter-site link:** a private **Ubiquiti airFiber AF-5** point-to-point wireless bridge, link name
`FISHBONE`, 583m (1,913 ft), 5GHz (RX 5810MHz / TX 5765MHz, 40MHz channel width), HQ end running as
Master. Two AF-5 radios are mounted on the HQ mast — **one active, one spare on standby** for a fast
swap if the primary fails. Confirmed 2026-09-17: ~36 days uptime, RF link Operational, ~430/375 Mbps
capacity each direction, signal strength running below the dashboard's "ideal power" mark (worth an
antenna-alignment check sometime if throughput ever underperforms, not urgent given the stable uptime).
**Resilience:** a separate **IPsec VPN between servers at both ends** provides a fallback path if the
wireless bridge drops, riding over each site's own independent internet — so the sites (and the UniFi
controller's reachability from HQ) stay connected even if the radio link fails.

---

## Fishbone HQ — rack inventory

### Server — updated 2026-10-01 (access regained)
_Discovery and recovery 2026-10-01, Minda executing with Eugene guiding; no credential recorded anywhere._

| Item | Detail |
|---|---|
| Hardware | **HPE ProLiant DL380 Gen9**, serial CZJ64905NP, System ROM P89 v3.40 (2024-08-29) |
| iLO | **iLO 4**, firmware 2.82, Standard licence. **Live address `10.224.10.50`** (read from the BMC via `ipmitool lan print 2` on the host, 2026-10-16; MAC `94:18:82:02:ac:02`). ⚠️ **Was recorded `.78` on 2026-10-01 — it is on DHCP and the lease has drifted to `.50`; set a DHCP reservation so it stops moving.** Password: **Minda changed it 2026-10-01, stored in the password manager** (1Password, HQ iLO / ProLiant DL380 entry). iLO clock shows 2001 (fix later, NTP). |
| Hypervisor | **Proxmox VE 8.2.2** on ZFS (`rpool/ROOT/pve-1`, systemd-boot), host `pve` at **`10.224.10.10:8006`** |
| Root access | **Regained 2026-10-01**: console `init=/bin/bash` root reset, new password in Minda's password manager; web UI login verified |

**VMs (2026-10-01):**
| VM | Name | State | Notes |
|---|---|---|---|
| 100 | test | stopped | |
| 101 | FW | running | Firewall/router VM, 2 NICs. Role (Beverley VPN?) to confirm; login unknown |
| 102 | public-proxy | running | Internet-facing reverse proxy; what it publishes to confirm |
| 103 | tftp | stopped | Likely phone provisioning |
| 104 | ssh-gateway | running | Likely the contractor's remote access route in; **security review** |
| 105 | PBX | running | FusionPBX (`10.224.13.9`) |

**Network segments found:** `10.224.10.x` management (**iLO now `.50`** — DHCP, was `.78` on 2026-10-01; Proxmox `.10`, a Cisco web login at `.4` (probably the 3850 stack), plus `.9`, `.51`–`.52`); `10.224.13.x` phones (PBX `.9`, Yealink T48S `.10`, `.11`); `10.224.20.x` WiFi `FSG0218`.

#### Server hardware baseline — 2026-10-16 (iLO/IPMI readout, GPU-upgrade prep RND-2)
_Read non-intrusively via `ipmitool` on the running host (`fru print`, `sdr`); no reboot, no credential held. For the DL380 Gen9 `CZJ64905NP`._
| Item | Detail |
|---|---|
| Model | ProLiant **DL380 Gen9**, product/board **843556-425**, S/N **CZJ64905NP** |
| BIOS | **P89, 08/29/2024** — recent enough that "Above 4G Decoding" is present for the P40 |
| CPUs | 2× **Intel Xeon E5-2695 v4** @ 2.10 GHz (both sockets populated — GPU riser needs CPU2 ✅) |
| RAM | **128 GB** = 4× **32 GB** DDR4-2400 RDIMM (HP `809083-091`), in DIMM 9 & 12 of each CPU; **DIMM banks 1–6 empty (10 slots free)** |
| PSUs | **2× present → Fully Redundant**; live draw ~140 W idle. **Rated 500 W** (physical check 2026-10-11); **2× 1400 W (720620-B21) on order** for the dual-P40 build. (IPMI FRU does not expose PSU wattage on this box.) |
| Fans | **6× present → Fully Redundant**, running cool (CPUs 40 °C, inlet 21 °C). **High-performance kit — CONFIRMED by label 2026-10-16:** GPN `747597-001` / HPE `796850-001` / SPS `777285-001`, fan = Delta **PFR0612XHE DC12V 3.30A**. ✅ **No fan purchase needed for the GPU build.** |
| Storage ctrl | **Smart Array P840** (`761880-001`) |
| NICs | 10 Gb 2-port **562SFP+** (`727055-B21`); 1 Gb 4-port **366FLR** (`665240-B21`); 1 Gb 4-port **331T** (`649871-001`); embedded 1 Gb 4-port **331i**; Smart Storage Battery (`875242-B21`) |
| ⚠️ Pre-GPU-fit check | Box is heavily populated (P840 + 3 add-in NICs). Two Tesla P40s are double-wide and need the **primary + secondary GPU risers** — **confirm those slots are free** (a NIC/the P840 may be in the way; iLO → System Information → Device Inventory, or physical). More 1 GbE ports than needed → a spare NIC could move/come out. |
| Open follow-ups | (1) **DHCP-reserve iLO `.50`**; (2) **buy GPU baffle** (only outstanding part — fans confirmed high-perf); (3) **GPU-riser slot availability** vs P840/NICs; (4) iLO NTP (clock showed 2001). |
**Firewalls:** confirmed **Cisco ASA 5550** pair (end of support), bottom unit active, top standby (2026-10-01).

#### Earlier record (2026-09-17)
| Item | Detail |
|---|---|
| Hardware | HP ProLiant (2U, SFF chassis, Intel Xeon) |
| OS | **Debian 12** (confirmed via console observation, no login) |
| Role | **FusionPBX** (self-hosted FreeSWITCH-based PBX), internal IP `10.224.13.9` — the phone system for **both sites** |
| Management | FusionPBX web admin (Minda has full access); **OS-level (SSH/console) access not currently held by Minda** |
| Backup | **None** — no built-in FusionPBX backup feature exists on this install (checked Advanced, Applications, and the 55-module Modules page, 2026-09-17) |
| Support contract | **None** |

**⚠️ See `open-issues.md` OI-7 — critical.** No backup and no support contract on the server running the
entire company's phone system for both sites is a genuine single point of failure. OS-level access is
the current blocker; Eugene drafts the actual backup runbook once that's available.

### Backup server — RND-3 interim, NEW 2026-10-17 (`pve-nas`)
_Brought up guide-only (Minda hands-on at HQ, then remote; PBS half over Tailscale from Beverley); no
credential recorded. This is the first off-box backup target the estate has had — closes OI-7/OI-17._

| Item | Detail |
|---|---|
| Hardware | **Dell PowerEdge R710**, Service Tag **3MLS95J**; 2× **Xeon X5650** (12c/24t); **24 GB ECC DDR3** (⚠️ POST warns **DIMM B3 disabled, MEMBIST failure** — disabled by BIOS, still 24 GB, **not blocking**; reseat/replace B3 later); 8× 2.5" internal bays |
| Storage (now) | **PERC 6/i Integrated** (RAID-only, no passthrough) → 2× single-disk RAID-0 VDs from **2× Seagate ST900MM0006 900 GB SAS** → **2-disk ZFS mirror** (`rpool`, ~832 G, ~804 G free, ONLINE). Interim pool — rebuilds to a 2×6 RAIDZ2 when the other 10 drives + the DS2246 QSFP cable arrive. |
| HBA | Fujitsu **PSAS CP400e** (LSI SAS3008) fitted — external SFF-8644 only; no devices until the DS2246 shelf is cabled |
| Hypervisor | **Proxmox VE 9.2.2** (Debian 13 trixie) on the ZFS mirror, host **`pve-nas`** at **`10.224.10.20:8006`** |
| Backup server | **Proxmox Backup Server 4.2.8** installed alongside (no-subscription repos), UI at **`https://10.224.10.20:8007`**; datastore **`store1`** on dataset `rpool/pbs-store`; cert fingerprint `86:63:…:96` (public, not a secret). Added as storage **`pbs-nas`** on the HQ Proxmox (`10.224.10.10`). |
| iDRAC | **iDRAC6** (fw 1.97.02) at **`10.224.10.21`** (moved off default `192.168.0.130`). Password Minda-held (§3). |
| Network | `vmbr0` → **`10.224.10.20/24` gw `10.224.10.1`** (the ASA — per-VLAN host gateway, NOT the 3850 SVI `.4`), data NIC `nic0` on 3850 **Gi1/0/44 (vlan 10)**. Reachable over **Tailscale** via the HQ subnet router (no Tailscale on the box itself). NIC1 MAC `D0:67:E5:F3:D0:A5`, NIC2 `…A7`. |
| Backups proven | **VM 105 (FusionPBX)** backed up (Snapshot, 50 GiB/84 s, TASK OK) + **restore-tested to a new VM 999** (round-trip proven). **Remaining: schedule the nightly vzdump→`pbs-nas` job** to fully close OI-17. |
| Status | R&D interim (RND-3) until graduation; DS2246 shelf joins later as capacity expansion. |

### Firewalls
| Item | Detail |
|---|---|
| Hardware | 2× Cisco ASA 5500-series |
| Configuration | **Active/standby HA pair** |
| Management | A contractor Minda brought in previously has looked over the config; **Minda is the primary human executor of any changes going forward** — Eugene has no network-device connector and firewall changes are guide-only regardless (charter §3) |

### Switching
| Item | Detail |
|---|---|
| Hardware | 2× Cisco Catalyst 3850-48 PoE+ (`3850-1`, `3850-2`), stacked |
| Port map | From the site's own printed "Fishbone Network diagram" — see table below |

| Port(s) | Switch(es) | Destination |
|---|---|---|
| 1–15 | 3850-1, 3850-2 | CCTV (own VLAN, isolated from the local network) |
| 16 | 3850-1, 3850-2 | CCTV Recorder (Hikvision NVR) |
| 17 | 3850-1, 3850-2 | iLO (ProLiant server) |
| 18–24 | 3850-1, 3850-2 | IP Telephony |
| 25–45 | 3850-1, 3850-2 | Computers and Printers |
| **44** | **Gi1/0/44 + Gi2/0/44** | **Reassigned 2026-10-17 → `switchport access vlan 10` (management/servers) for the `pve-nas` backup server.** `pve-nas` is single-homed on **Gi1/0/44**; **Gi2/0/44** is reserved for a later Proxmox active-backup bond (switch redundancy). |
| 46–48 | 3850-1, 3850-2 | WiFi AP |

### WiFi
| Item | Detail |
|---|---|
| Access points | Ubiquiti UniFi — **5 indoor** (workshop/office areas, per the site's floor plan) + **1 outdoor** (loading-bay area) |
| Controller | Hosted at **Beverley Place**, not HQ (means HQ's APs depend on the inter-site link for central management/config changes — see Resilience note above; APs keep running on cached config if that link drops, just can't be reconfigured until it's back) |
| SSIDs | **`FSG0218`** — full local-network access, restricted to Minda and Andrejus only. **`Fishbone`** — limited local-network access, general use. (The site's printed floor plan legend implied a third zone; treat the two SSIDs above as current ground truth over that older planning document.) |

### WAN
| Path | Detail |
|---|---|
| **Openreach leased line** (primary) | 1Gb/1Gb symmetric, terminated on an **ADVA FSP150-GE1xxPro** NID |
| **Beverley Place fibre** (via the airFiber bridge / IPsec VPN) | 1Gb FTTP at the Beverley Place end, shared back to HQ |
| **Starlink** (backup) | Dish visible on the HQ roofline |

Three genuinely independent physical paths (leased line, separate residential fibre, satellite) — solid
redundancy for a site this size. Failover mechanism (automatic multi-WAN vs manual) not yet confirmed.

### Cellular signal repeater
Multi-band (800/900/1800/2100/2600MHz) indoor GSM/LTE repeater with an outdoor donor antenna mounted on
the HQ roof mast (confirmed 2026-09-17 — this is the mast antenna, not the airFiber radios, which are
mounted separately). Installed for indoor mobile signal coverage.

### CCTV
| Item | Detail |
|---|---|
| Recorder | Hikvision **DS-9632NI-M8** — 32-channel, 2U, 8K, DeepinMind (AI-capable) NVR |
| Cameras | **16 total** — 13 covering the building, 3 outside (16 of 32 available channels used, room to grow) |
| Remote viewing | Hikvision app, **only over VPN** — not exposed directly to the internet |
| Network | **Own isolated VLAN**, no access to the local network |

### Telephony
2× **Yealink T48S** touchscreen VoIP desk phones (confirmed at HQ), registered to the FusionPBX server.
Beverley Place also has working IP telephony via the inter-site link.

### Office equipment
- **Xerox VersaLink C415** — colour laser MFP (print/scan/copy, document feeder, touchscreen)

### Meeting room
- **Samsung WA65C** — 65" interactive display (Android-based, "Interactive Version 11")
- **Microsoft Surface Pro 6**, device name `MeetingRoom` — Intel Core i5-8250U, 8GB RAM, 238GB storage, Windows 11 Home 25H2
- USB condenser microphone on a desk stand, keyboard/mouse — video-conferencing setup

### Power
2× **APC Smart-UPS 2200** — cover the **whole rack** (server, firewalls, switches, WAN termination, NVR).

---

## Beverley Place — rack inventory

Recovered + partially walked 2026-10-10 (OI-20); more detail added 2026-10-17 from the inter-site link
incident (OI-23). The HQ stack in miniature: **1× Cisco ASA 5550** (single, serial MX1512L0FD), **1×
Catalyst 3850-48 + C3850-NM-2-10G** (single, no stack), **Lenovo mini-PC Proxmox** (`10.224.111.199`, no
iLO), **UniFi Cloud Key Gen2** (`10.224.110.5`), **APC UPS**.

**Two fibres on site:** both **BT** — a **BT Business** fibre and a **personal BT** fibre. ⚠️ The **BT Business** fibre is being
**cancelled 27 Oct 2026** (no replacement) — see **OI-24**. The **personal BT** fibre remains, so Beverley keeps
internet (redundancy loss, not outage). At HQ the BT feed is delivered **from Beverley over the airFiber
radio** and lands on **vlan 4** — it is only a *backup* WAN at HQ (HQ runs on Wavenet FTTB).

**Inter-site link = the airFiber radio** (see the Sites section). **VLANs 10 and 11 are bridged across
the radio**, so Beverley and HQ share `10.224.10.0/24` + `10.224.11.0/24`; a Beverley host reaches HQ
`10.224.10.x` natively over the link. **airFiber radio management IPs: Beverley `192.168.5.20`, HQ
`192.168.5.21`** (own isolated `192.168.5.0/24` mgmt subnet, not routed from the data LAN; Minda holds
the login). ⚠️ **2026-10-17: the Beverley dish lost power → the whole inter-site link dropped** (OI-23) —
a reminder the radio is a single point of failure for Beverley↔HQ (the VPN fallback rides each site's
own internet).

**Beverley Catalyst 3850 (`home-sw`):**
| Item | Detail |
|---|---|
| Mgmt IP | **`Vlan110 = 10.224.110.4`** (SSH here from the Beverley LAN). Also SVIs `Vlan10 = 10.224.10.252`, `Vlan11 = 10.224.11.252` (the bridged VLANs). |
| Software | IOS-XE 16.09.05 install mode (same as HQ). Minor `SIF_MGR-1-FAULTY_CABLE` StackWise warning — cosmetic on a single switch. |
| Uplink | `Po1` (LACP) to the ASA = `Gi1/0/1` + `Gi1/0/2` (ASA-Gi0/0 + ASA-Gi0/1). |
| Port map | `Gi1/0/3`–`39` LAN (access vlan 111); `Gi1/0/40` WiFi AP (vlan 110); `Gi1/0/44`–`46` UniFi APs (UAP trunks); `Gi1/0/47` UniFi Cloud Key (vlan 110); **`Gi1/0/48` BT-router for office (vlan 4)**; **`Gi1/1/1` BT-router (vlan 6)**; **`Gi1/1/2` AirFiber to office (trunk, SFP)** ← the inter-site radio. |

Credentials (ASA, 3850, Proxmox root, airFiber) are all in Minda's 1Password — Eugene holds none (§3).
**Still not held: the UniFi Cloud Key login** (OI-20) — WiFi runs on cached config; not on the wired
phone's path.

**To confirm next:** the Beverley ASA WAN interface map (which fibre is the BT one, for the OI-24
cutover); exact Proxmox mini-PC model; UPS model/coverage.

---

## Security posture — worth noting positively

Several deliberate, sound choices observed across this walkthrough, worth recording as strengths rather
than just facts:
- Active/standby HA firewall pair, not a single point of failure
- Three independent WAN paths (leased line, separate-site fibre, satellite)
- CCTV on an isolated VLAN with no local-network access
- CCTV remote access gated behind VPN, never exposed directly to the internet
- A restricted, small-membership full-access WiFi SSID kept separate from the general-use one
- A spare airFiber radio on standby for fast hardware swap
- Inter-site IPsec VPN as a resilient fallback to the wireless bridge

## Open items
- **OI-7 (was critical) — backup gap CLOSED 2026-10-17.** The FusionPBX server (VM 105) now has an off-box backup target: **`pve-nas`** (R710) running **Proxmox Backup Server** on VLAN 10 — first backup + restore-test both proven. OS access was regained 2026-10-01. **Remaining:** schedule the nightly backup job (OI-17); decide support-contract-vs-replace. See `open-issues.md`.
- Beverley Place rack — full device-level inventory still to do.
- WAN failover mechanism (Openreach/Starlink/Beverley-Place-fibre) — automatic or manual — not yet confirmed.
- Floor plan's original `(1)` SSID/zone legend — superseded by the confirmed live SSID names above; not worth chasing further.
