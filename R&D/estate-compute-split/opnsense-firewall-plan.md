# RND-26 path E3 — OPNsense firewall plan (HQ pair + Beverley)

_R&D plan (creative mode, 2026-10-31, Minda chose OPNsense). Guide-only (§3): replacing a firewall is
production-affecting — Minda buys, cables and runs every live step; Eugene designs, translates the ASA
config, writes the runbook and verifies. Secrets (passwords, VPN keys, config backups) are Minda's — never
in git or chat. Nothing bought._

## Why OPNsense (Minda's pick)
No licence or yearly fees, security updates for ever, a GUI for day-to-day, the whole setup in **one
config file** Eugene can review before every change, no vendor cloud — fits the estate's data-ownership aim.

## Shape
| Site | Today | OPNsense |
|---|---|---|
| **HQ** | 2× ASA 5550 active/standby | **2 identical boxes, CARP high-availability** (shared virtual IPs, live session sync, auto config sync) |
| **Beverley** | 1× ASA 5550 | **1 box** (pair later if wanted) — **pilot site first** |

## Hardware (per box, identical at HQ)
Needs ≥4 ports: **WAN Wavenet · WAN Starlink · LAN trunk (10G SFP+ to the 3850s) · dedicated HA sync**.
| Choice | Example | ~£ each | Notes |
|---|---|---|---|
| **Small appliance PC** | fanless box with 2× 10G SFP+ (Intel 82599/X710) + 4× 2.5G (Intel i226) | ~£300–450 | cheapest; check Intel NICs (best OPNsense support) |
| **Short-depth 1U server** | used Dell R250 / Supermicro + Intel X520-DA2 | ~£300–600 | rack-native, redundant-ish, IPMI |
| **Deciso (OPNsense's maker)** | DEC2700/DEC3800 series (10G SFP+) | ££ — quote | official hardware + optional Business Edition support |
3 boxes ≈ **£0.9–1.8k** (own hardware). Intel NICs, AES-NI CPU, 8–16 GB RAM, small SSD.

## The one hard requirement — public IPs for the HQ pair
CARP needs **3 addresses per interface**: one per box + the shared virtual one.
- **LAN/VLANs:** private — easy.
- **Wavenet:** need a **/29 (or larger)** public block. **If only one IP:** keep the Wavenet router doing NAT and
  put both firewalls on a small private "transit" network behind it (works, but double NAT → SIP/RTP and port
  forwards need extra care).
- **Starlink:** consumer Starlink is CGNAT/dynamic → always the "behind the Starlink router" pattern (private transit).
- **Check now (read-only, HQ ASA):** `show interface ip brief` + `show run interface | include ip address` → the
  outside **mask** (`.248` = /29 ✅). Or the Wavenet contract.

## What moves from the ASA (Eugene maps every line)
| ASA today | OPNsense |
|---|---|
| VLAN gateways (10 mgmt, 11, 12 CCTV, 13 phones, 21 guest, 30 DMZ, 2, 4, …) | VLAN interfaces + per-VLAN rules |
| DHCP per VLAN (**no MAC reservations**) | **Kea/ISC DHCP with static mappings by MAC** → fixes the iLO (AWT-1060) and Loxone/printer (AWT-1063) problems natively |
| NAT + port forwards (SIP `:5080`, RTP range → PBX; DocuSeal via public-proxy) | port forwards + **static-port outbound NAT for SIP** |
| Failover pair (folink/statelink) | **CARP + pfsync + config sync** over the dedicated sync port |
| Wavenet primary / Starlink backup | **gateway group** (tier 1 Wavenet, tier 2 Starlink) with link monitoring |
| (HQ↔Beverley over the radio) | radio stays primary; **WireGuard tunnel over the internet as automatic backup** (RND-27) |
| — | optional: **Tailscale plugin** (could replace the subnet-router VMs), **Suricata IDS** on the WAN only |

## Safety rules
- **Config backups contain secrets** → stored encrypted by Minda (1Password / NAS), never in git. Eugene reviews
  **redacted** diffs only.
- Every change: backup first → change → test → note in the change-log.
- Monthly updates in a quiet window, HQ secondary first.

## Phases
| Phase | What | Risk |
|---|---|---|
| **P0 facts** | public-IP block; **ASA config export** (`show running-config` — Minda checks secrets are masked `*****` before sharing); Beverley ASA too | none (read-only) |
| **P1 design** | Eugene translates both ASA configs → OPNsense plan + IP plan + cut-over runbook | none |
| **P2 buy + build** | 3 boxes; build offline, lab-test on spare switch ports | none to production |
| **P3 Beverley pilot** | swap the single ASA in a quiet window; ASA kept as roll-back | low (one phone, small site) |
| **P4 HQ cut-over** | phones-free window; standby first, then active; test internet failover, SIP both ways, DocuSeal, Tailscale, CCTV, radio + WireGuard | medium — roll-back = re-cable the ASAs (kept racked, off, 30 days) |
| **P5 tidy** | DHCP reservations (iLO, Loxone, printer), retire ASAs (archive config, never trash) | low |

## Open questions for Minda
1. Public IP block at HQ (and Beverley)?
2. Hardware style: small appliance PCs, 1U servers, or Deciso?
3. OK to start with Beverley as the pilot?
