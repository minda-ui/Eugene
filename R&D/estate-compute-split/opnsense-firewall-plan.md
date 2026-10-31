# RND-26 path E3 — OPNsense firewall plan v2 (HQ: inside first, edge later · Beverley: straight swap)

_R&D plan (creative mode, 2026-10-31). v2 per Minda: **HQ uses option 2** — OPNsense goes in *behind* the ASAs
first, takes the internet edge later; **Beverley = straight swap (pilot)**. Guide-only (§3): firewall changes are
production-affecting — Minda buys, cables and runs every live step; Eugene designs, translates ASA config,
writes runbooks, verifies. Secrets (passwords, VPN keys, config backups) are Minda's — never in git or chat.
Nothing bought. (v1 — straight swap at both sites — superseded by this file; see git history.)_

## Why OPNsense (Minda's pick)
No fees, updates for ever, GUI day-to-day, one config file Eugene can review before every change, no vendor cloud.

## The shape
```
STEP A (HQ)                                   STEP B (HQ, later)
Internet ─ Wavenet / Starlink                 Internet ─ Wavenet / Starlink
            │                                             │
        ASA pair  ← edge: NAT, SIP forwards,         OPNsense pair (CARP) ← edge + inside
            │        DMZ (public-proxy, DocuSeal)          │
     transit VLAN (private /29)                      VLANs + DMZ + DHCP + WireGuard
            │                                             │
   OPNsense pair (CARP) ← inside: VLAN gateways,     ASAs retired (config archived)
            │        DHCP + reservations, WireGuard
        3850 stack → office VLANs
```

## STEP A — OPNsense inside, ASAs stay the edge (HQ)
**What changes:** the **gateway for each office VLAN moves from the ASA to the OPNsense pair**, one VLAN at a time.
**What doesn't:** internet, NAT, the phone system's port forwards (OI-8 setup), the DMZ — all stay on the ASAs.

| Piece | How |
|---|---|
| **Transit link** | new private VLAN between ASA and OPNsense, e.g. `10.224.250.0/29`: ASA `.1`, OPNsense A `.2`, B `.3`, **CARP virtual `.4`**. ASA gets a static route for the office ranges → `.4`. **No public IPs needed** in Step A. |
| **Same gateway addresses** | each VLAN's gateway `.1` becomes an OPNsense **CARP virtual IP** with the *same* address → **no client changes** (PCs, phones, cameras keep their settings). |
| **DHCP** | each VLAN's DHCP moves with its gateway → **reservations by MAC** (fixes iLO AWT-1060 natively). |
| **Connections to the switches** | switch SFP slots are full → each OPNsense box on **2× 1G copper LACP (one per 3850)**; inter-VLAN up to ~2 Gb/s per box (vs ≤1 Gb/s ASA). Bulk server traffic is on the private triangle anyway (D3). Later: free SFP slots (e.g. ASA links to copper) → 10G. |
| **ASA config change** | per moved VLAN: remove its sub-interface, update NAT objects to the transit interface, add the route. **Eugene writes the exact lines** from the exported config; Minda applies. |
| **WireGuard to Beverley** | on OPNsense; the ASA forwards one UDP port to the CARP `.4` — backup path if the radio drops (RND-27). |

**VLAN order (least critical first; one per window, test, then next):**
1. **21 Guest Wi-Fi** — the rehearsal.
2. **11** office, **12 CCTV**.
3. **10 Management** (Proxmox, iLO, switches — careful; console access ready).
4. **13 Telephony** — last, phones-free window, test calls both ways.
- **30 DMZ stays on the ASA** until Step B (it's tied to the public forwards).
- **Roll-back per VLAN:** put the sub-interface back on the ASA (saved lines), remove the VIP on OPNsense — minutes.

## STEP B — OPNsense takes the edge (HQ, later, calm)
- Move Wavenet + Starlink + DMZ + NAT/SIP forwards to OPNsense; ASAs retire (config archived, never trashed).
- **Public-IP question returns here:** a **/29 from Wavenet** for a clean CARP WAN, or keep the Wavenet router in
  front with a private transit (double NAT; SIP needs extra care). Starlink always uses the "behind its router" pattern.
- **Why not stay on Step A for ever:** the ASAs get **no security fixes** and the internet edge is where that matters most.

## BEVERLEY — straight swap (pilot)
- One OPNsense box replaces the single ASA 5550 in a quiet window; ASA kept on the shelf as roll-back.
- Learns the platform on a small site first: VLANs 110/111, DHCP + **reservations (Loxone, printer — AWT-1063)**,
  BT internet, WireGuard to HQ, Beverley phone (ext 1006).
- Can go **before or alongside HQ Step A**.

## Hardware (3 boxes; buy Step-B-ready from day one)
≥4–6 ports each: **2× 1G/2.5G for the switch LACP · 1 HA sync · 2 WAN (for Step B) · spare**; Intel NICs, AES-NI CPU,
8–16 GB RAM, small SSD; 10G SFP+ ports welcome for later.
| Style | ~£ each |
|---|---|
| Small appliance PC (Intel i226 2.5G ×4–6 + 2× SFP+) | £300–450 |
| Short 1U server (Dell R250 / Supermicro) + Intel NIC | £300–600 |
| Deciso DEC2700/3800 (+ optional Business support) | quote |

## Phases
| # | What | Risk |
|---|---|---|
| P0 | Facts: both ASA configs (`show running-config`, secrets masked `*****` — Minda checks before sharing); interface/IP list; Beverley ASA too | none |
| P1 | Eugene: VLAN-by-VLAN migration plan, ASA change lines, OPNsense config plan, Beverley swap runbook | none |
| P2 | Buy + build 3 boxes offline; lab-test | none |
| P3 | **Beverley swap** (pilot) | low |
| P4 | **HQ Step A**, VLAN by VLAN (guest → office/CCTV → mgmt → phones) | low per step, roll-back in minutes |
| P5 | Settle the public-IP route for Step B | none |
| P6 | **HQ Step B** — edge to OPNsense, ASAs retired | medium, phones-free window, ASAs kept 30 days |

## Safety rules
- Config backups contain secrets → encrypted, held by Minda; Eugene reviews **redacted** diffs only.
- Backup → change → test → change-log, every time. Updates monthly, HQ secondary node first.

## Hardware research (2026-10-31) — need ≥5 ports per box (2 switch LACP + 1 HA sync + 2 WAN for Step B)
| Option | Ports | Throughput (vendor) | Form | Price each | 3 boxes |
|---|---|---|---|---|---|
| **Deciso DEC2750 v2** | 3× 2.5G + 2× 10G SFP+ (5) | ~8–10 Gb/s | 1U | **€999** (shop.opnsense.com) | ~£2.6k |
| Deciso DEC2752 | same, higher spec | ~8.5–10 Gb/s | 1U | €1,178 | ~£3.0k |
| Deciso DEC3852 | 4× 2.5G + 2× SFP+ (6) | ~17 Gb/s | 1U | quote | — |
| Protectli VP6600 series (VP6670 i7) | 4× 2.5G i226 + 2× SFP+ (6) | multi-gig | desktop + shelf | ~£1k+ (one UK listing £2.3k w/ 64 GB) | ~£3k+ |
| Supermicro SYS-5019D-FN8TP (Xeon D-2146NT, QAT, IPMI) | 4× 1G + 2× 10GBASE-T + 2× SFP+ (8) | plenty | 1U | ~$1.9–2.3k new | ££ |
| Generic N100/N305 appliance (Intel 82599 SFP+ + i226) | 4× 2.5G + 2× SFP+ (6) | multi-gig | desktop + shelf | ~£250–400 | ~£0.8–1.2k |
Note: Deciso warns not to mix 2.5/5G and 10G SFP+ modules on one box. Earlier "£0.9–1.8k for 3" assumed generic boxes.
**Steer:** HQ pair = 2× DEC2750 (official, HA-tested, rack, optional support); Beverley = DEC2750 (one platform + common spare) or generic (~£600 less). ≈ £2.6k all-Deciso / ≈ £2.0k mixed. Awaiting Minda's pick.

## Low-cost path spotted (Minda, 2026-10-31): reflashed Cisco ASA 5500-X as an OPNsense box
eBay (seller techreform, £49.99 + £3.30, used): "pfSense/OPNsense box, 7× Intel GbE, 8 GB DDR3, 8 GB storage, Xeon" — a retired
**ASA 5500-X** (likely 5525-X/5545-X if Xeon). **Fit:** 7× 1G Intel ports cover Step A (2× 1G LACP to the 3850s + sync)
and Step B (2 WAN); ~1–2 Gb/s; 1U rack; ~100 W; no vendor support; c.2012 hardware; no 10G.
**Idea:** buy **1 first → Beverley pilot**; if good, 2 more (+1 spare, ~£200 total) for HQ Step A; move to 10G boxes
(Deciso) only if traffic needs it — the cheap units become lab/spares. **Ask seller:** exact model + CPU; OPNsense
installed on what drive (add a 2.5" SSD); tested + console cable; PSU (single — fine in a CARP pair).

## Browse list — retired appliances that reflash to OPNsense (2026-10-31, used UK eBay, rough)
| # | Search term | Ports | Why | ~£ |
|---|---|---|---|---|
| 1 | **Sophos SG 330 / SG 430 / XG 330** | 8× 1G Intel + **FleXi bay (2× 10G SFP+ module)** | popular for OPNsense; 10G add-on later; 1U | 60–150 (+module) |
| 2 | **WatchGuard Firebox M400 / M500** | 6–8× 1G Intel | Intel Core, cheap, 1U | 50–120 |
| 3 | **Cisco ASA 5525-X / 5545-X** | 6× 1G (+6-port module) | 1U, Xeon, often pre-flashed | 50–120 |
| 4 | **Supermicro SYS-E300-8D** | **2× 10G SFP+** + 6× 1G, IPMI | best cheap built-in 10G; small/quiet | 200–350 |
| 5 | **Check Point 5400 / 5600 / 4600** | 6–8× 1G + expansion | 1U Intel; 10G card possible | 50–150 |
| 6 | **Dell R230/R240 + Intel X520-DA2** | 2–4× 1G + 2× SFP+ | plain 1U server + iDRAC; more power | 100–200 |
**Look for:** Intel NICs · ≥8 GB RAM · SSD or slot · x86 with AES-NI · console access · "tested OPNsense/pfSense" / BIOS unlocked
(Sophos/WatchGuard may have BIOS passwords) · identical pair (+ spare) for HQ.
**Avoid:** Intel **Atom C2000** units (ASA 5506/5508/5516-X, Supermicro A1SRi-2758 — early-failure chip fault) · FortiGate /
Juniper SRX (not standard x86) · Core 2/Pentium-era · "for parts".
**Pick:** Sophos SG/XG 330 (cheap, 8 Intel ports, 10G later via FleXi); Supermicro E300-8D for built-in 10G.
