# RND-6 → monitoring plan — the estate watchtower

_R&D design (creative mode, 2026-10-31, Minda: "next gap, monitoring"). Grows RND-6 (silent-failure alarm, born
from: no inbound calls since 21 July unnoticed; office on Starlink backup for days unnoticed). Guide-only (§3):
read-only probes; Minda holds every read-only credential (SNMP/API keys) in the secret store; Eugene designs and
reviews alerts. Nothing built._

## The rule
**Silence is not "OK".** Every important thing either reports in on time or raises an alarm — and the watcher itself
is watched.

## The watchtower (simple tools)
| Piece | Tool | Why |
|---|---|---|
| Up/down checks + heartbeats | **Uptime Kuma** (small LXC on the Gen9, management VLAN) | simple web screen; ping/HTTP/TCP/DNS checks; "push" monitors that alarm when a job *doesn't* report in |
| Trends (temperatures, power, GPU, disk) | **Netdata** (later, optional) | graphs for spotting slow problems |
| Alerts to Minda | **Telegram bot** (+ email fallback) | where she already is; Telegram is in the estate already (RND-21) |
| Watching the watcher | **external heartbeat** (e.g. healthchecks.io free) pinged every 5 min | if HQ loses power or internet, the outside service alerts; it only sees "I'm alive", no data |
| Cross-watch | Beverley watches HQ, HQ watches Beverley (after the Beverley node) | one site can always report the other's outage |

## What we watch
**Tier 1 — business-critical (alert immediately, any hour)**
| Watch | How |
|---|---|
| Phones: PBX up, SIP trunk registered | Kuma TCP/SIP check + a script reading trunk status |
| Phones: inbound actually works | **daily test call canary** to a DDI, check a call record landed (RND-6) |
| Internet: which line is in use | script: "on Wavenet or Starlink?" → alert if on backup > 10 min |
| Firewall pair healthy | ASA failover state now; OPNsense CARP master/backup later |
| Radio link HQ ↔ Beverley | ping both radios + the far gateway; signal/capacity via SNMP later |
| DocuSeal public page | HTTPS check + certificate expiry |
| The watcher itself | external heartbeat |

**Tier 2 — infrastructure (alert in working hours; urgent ones any hour)**
| Watch | How |
|---|---|
| **UPS on battery** (urgent), battery %, runtime, load per UPS | NUT (UPS USB/serial or network card — model from AWT-1065); triggers the "AI server shuts down first" rule (RND-28) |
| Server health: temperatures (inlet), fans, PSUs, disks | iLO alert emails now; iLO SNMP/Redfish later |
| ZFS pools + disk SMART | script pushes `zpool status -x` / SMART result to a Kuma heartbeat |
| **Backups ran and are fresh** | each backup job pushes a heartbeat; **alarm if no backup in 26 h** (pairs with OI-17 scheduling) |
| Restore test | monthly reminder; result logged |
| Proxmox hosts + key VMs up | Kuma checks |
| Switch stack: member up, PoE budget, port errors | SNMP (read-only) |
| Certificates + domain renewals | expiry checks, 30-day warning |

**Tier 3 — AI (daily digest; outage alerts)**
| Watch | How |
|---|---|
| Gateway + model servers up | health endpoint checks |
| GPU temperature, power, memory errors | nvidia-smi exporter (Netdata) |
| Night-shift jobs finished | each job pushes a heartbeat |

## How alerts behave
- **Tier 1** → Telegram immediately, repeat until acknowledged. **Tier 2** → Telegram in working hours (UPS-on-battery always).
  **Tier 3** → morning digest; outages immediately.
- **One "all green" line every morning** (in the morning brief, RND-15) — so silence is never mistaken for health.
- Repeats grouped (one alert per problem, one "recovered" message).

## Security
Monitoring uses **read-only** access only (SNMPv3 read-only, read-only API keys), held by Minda in the secret store;
the watchtower sits on the management VLAN, no inbound from the internet; Telegram bot token = a secret (Minda).

## Phases
| # | What | Cost |
|---|---|---|
| **P0** | Uptime Kuma LXC; ping/HTTP checks for key devices + DocuSeal; external heartbeat; Telegram alerts; turn on iLO alert emails | £0 |
| **P1** | Backup heartbeats (with OI-17), ZFS/SMART push, PBX trunk + WAN-path checks, daily call canary | £0 |
| **P2** | UPS via NUT (USB cable or network card per UPS model) + AI-server-first shutdown | £0–200 |
| **P3** | OPNsense CARP + radio + switch SNMP (after the firewall swap) | £0 |
| **P4** | AI server + night-shift heartbeats, Netdata trends | £0 |
| **P5** | Beverley watcher (cross-watch) | £0 |

## Decisions for Minda
1. Alerts via **Telegram** (+ email fallback)? Whose phone(s)?
2. Quiet hours for Tier 2 (e.g. 22:00–07:00, except UPS on battery)?
3. OK to use a free external heartbeat service (sees only "alive" pings)?
