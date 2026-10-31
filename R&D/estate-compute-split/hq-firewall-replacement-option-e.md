# RND-26 path E — replacing the HQ firewall pair (ASA 5550 ×2)

_R&D research (creative mode, 2026-10-31). Guide-only (§3): a firewall swap is production-affecting —
Minda executes in a planned window; Eugene designs, writes the migration and verifies. Nothing bought.
Prices are rough (mixed USD/GBP, new vs used) — get UK quotes._

## Why look at all
- **ASA 5550 = end of support**, software 9.1(7)32 (no security fixes), ~1.2 Gb/s, all ports 1G.
- At HQ the ASA is the **gateway between VLANs** → any cross-VLAN traffic is capped at ≤1G.
- Beverley has a single ASA 5550 too — a replacement plan should cover both sites.

## What a replacement must do (HQ)
Active/standby pair · two internet lines (Wavenet FTTB + Starlink) with failover · VLAN gateways
(10 mgmt, 11, 12 CCTV, 13 phones, 21 guest, 30 DMZ…) · NAT/port-forwards for the PBX (SIP) and DocuSeal via the
public-proxy VM · link to Beverley (today: airFiber L2 + Tailscale; any IPsec to confirm) · multi-gig, 10G ports ·
manageable by Minda with Eugene guiding · sensible running cost.

## The options
| # | Option | 10G | Throughput (vendor/reviews) | HA | Cost (rough) | Ongoing | Fit |
|---|---|---|---|---|---|---|---|
| **E0** | **Keep the ASAs; route the *server* VLAN on the 3850 stack** (switch does that VLAN's routing at wire speed; ASA stays the internet edge) | switch 10G | wire speed in the switch | the stack is already redundant | **£0** | £0 | quickest win; removes firewalling *between* server VLANs (switch ACLs instead); LAN Base routing limits to check. Doesn't fix ASA age |
| **E1** | **UniFi Dream Machine Pro Max ×2** | 1× 10G SFP+ WAN + 10G SFP+ LAN | 5 Gb/s with IDS/IPS | **Shadow Mode** (VRRP-style failover) | ~£500–600 each | none mandatory | matches the **UniFi already at Beverley** (Cloud Key, APs); simple GUI; fewer advanced VPN/firewall knobs than Cisco/Fortinet |
| **E2** | **UniFi Enterprise Fortress Gateway (EFG) ×2** | 25G SFP28 | ~10–12.5 Gb/s IPS (sources differ) | Shadow Mode, dual PSUs | ~£1,500–2,000 each | none mandatory | same as E1, much more headroom; likely overkill |
| **E3** | **OPNsense** — on Deciso appliances (e.g. DEC3850: 2× 10G SFP+) **or our own small servers** (Intel 10G NICs) | yes | multi-gig routing; full IDS at 10G is not realistic on small boxes | **CARP + pfsync** (sessions survive failover; needs a dedicated sync link) | own hardware ~£300–600 each; Deciso more | free (optional paid support) | open source, very capable, no licences; DIY skills needed; data sovereignty fits the estate ethos |
| **E4** | **FortiGate** pair (100F is end-of-sale Apr 2026 → **120G** is the current model) | yes | 100F: ~20 Gb/s firewall, ~1 Gb/s full NGFW | yes (each unit licensed) | 100F ~$2.5–4k each (list varies) | **FortiCare/UTM ~15–25 %/yr** | strong security suite, SD-WAN built in; subscription cost every year |
| **E5** | **Cisco Firepower 1150** pair (can run the **ASA image**) | **2× 10G SFP+** | ~7.5 Gb/s (ASA image) | yes | new ~$4.9k each (resellers vary); used cheaper | Cisco support/licences | **easiest migration** — same ASA config style Minda + the old contractor know; check end-of-sale status |
| **E6** | **MikroTik** (e.g. CCR2004) pair | 10G/25G | high routing; light firewall | VRRP | ~£400–600 each | none | very cheap and fast; steep learning curve (not researched in depth) |

## How the choice splits
- **Just fix the server bottleneck now, no swap:** **E0** (and keep AI server + storage on one VLAN anyway).
- **Least change for the people who run it:** **E5** (ASA config carries over).
- **One system across both sites, simplest day-to-day:** **E1** (Beverley already UniFi).
- **No licences, most control:** **E3**.
- **Strongest security suite, accept yearly fees:** **E4**.

## Migration shape (any option, guide-only)
1. Export + review the ASA config (read-only `show running-config`, Eugene maps every rule/NAT/VPN).
2. Build the new pair offline with the translated config; lab-test with a spare switch port.
3. Phones-free window: swap the uplinks, test internet failover, SIP, DocuSeal, Tailscale, CCTV.
4. Keep the ASAs racked and powered off for a fast roll-back.
5. Beverley follows with the same platform.

## Sources
- UniFi UDM Pro Max tech specs (techspecs.ui.com) · UniFi gateway comparisons (ifeeltech, streakwave, tech2have)
- FortiGate price/lifecycle guides (aloinfousa, eosl.ai, gammateksolutions)
- OPNsense HA/CARP (opnsenselab), Deciso DEC3850 (shop.opnsense.com), OPNsense SFP compatibility docs
- Cisco Firepower 1150 listings (SHI, networkoutlet, UK resellers), Cisco Community
