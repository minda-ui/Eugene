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

### Server
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

Documented lightly so far — a small server rack exists but hasn't been walked through device-by-device
the way HQ's rack was. Known:
- Its own **1Gb FTTP fibre** connection (independent of HQ's WAN paths)
- Hosts the **UniFi controller** for the whole site's APs
- Has **server(s)** that form the IPsec VPN endpoint back to HQ
- IP telephony works there (via the inter-site link back to HQ's FusionPBX)

**To confirm next:** full device inventory for this rack, same level of detail as HQ (exact server
hardware/OS, what else if anything runs there, UPS coverage if any).

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
- **OI-7 (critical)** — FusionPBX server: no backup, no support contract, OS-level access still pending. See `open-issues.md`.
- Beverley Place rack — full device-level inventory still to do.
- WAN failover mechanism (Openreach/Starlink/Beverley-Place-fibre) — automatic or manual — not yet confirmed.
- Floor plan's original `(1)` SSID/zone legend — superseded by the confirmed live SSID names above; not worth chasing further.
