# RND-26 — HQ server networking: every path to fast links for the AI server

_R&D (creative mode, 2026-10-31, Minda: "see all possible ways, then we choose"). Guide-only (§3). No
recommendation in this file — a menu. Prices rough, used UK._

**Today:** 2× 3850-48F stack, each with NM-2-10G (4 SFP slots: 1–2 = 1G only, 3–4 = 1G/10G). Slots used by
ASA-1, ASA-2 (both switches), Gen9 10G bundle (one per switch), Starlink (switch 1). 48 copper 1G ports
each, plenty free. 2 spare Cisco 10G DAC cables on hand. Free 10G slots: probably none (TBC).

**First question to settle:** how much fast networking does the AI server really need? Chat/requests are
tiny (kilobytes). The heavy traffic is: loading model files (tens–hundreds of GB, occasional), reading the
document copy (indexing), backups. That decides how far down this list is worth going.

## A. Don't need 10G at all
| # | Path | Cost | Work / risk | Gain |
|---|---|---|---|---|
| A1 | **Models + documents live on the AI server's own SSDs** (NVMe/SAS); network only for chat + nightly sync | SSDs ~£100–300 | none on the network | model loads at SSD speed (GB/s); 1G is plenty for chat |
| A2 | **Bundle 2–4 copper 1G ports** (AI server onboard NIC → free copper ports on both switches, LACP) | £0 (cables) | small switch config | 2–4 Gb/s, survives a switch failure |

## B. Use the switch slots differently (no new switch)
| # | Path | Cost | Work / risk | Gain |
|---|---|---|---|---|
| B1 | **Shuffle slots:** if any ASA/Starlink 1G link sits in a 10G slot (3–4), move it to a 1G slot (1–2) | £0 | re-patch + port config, phones-free window | frees 10G slots *if* the layout allows (needs `show interfaces status`) |
| B2 | **Starlink to a copper port** | £0 | small, Starlink VLAN on a copper port | frees one slot on switch 1 (only helps 10G if it's a 10G slot or with B3) |
| B3 | **NM-4-10G modules** (all 4 slots 10G) | £160–260 | module swap + rename ports, one switch at a time | all slots 10G; with B2 → 1 free 10G per switch |
| B4 | **ASA links to copper ports** | £0 | **touches the firewall uplinks** — highest risk | frees up to 4 slots |

## C. Add switching
| # | Path | Cost | Work / risk | Gain |
|---|---|---|---|---|
| C1 | **Small dedicated 10G "server switch"** (e.g. MikroTik CRS309: 8× SFP+, or Ubiquiti USW-Aggregation: 8× SFP+) just for servers; one link up to the 3850 (1G copper or a 10G slot) | ~£150–300 | new box, separate from office LAN | all servers 10G to each other; storage traffic off the office network |
| C2 | **Third switch in the stack** — a 10G 3850 (e.g. 3850-12XS) | ~£150–400 + stack cable | stack join (licence/IOS must match) | many 10G ports, same management |
| C3 | **Replace the stack** with newer multi-10G switches (e.g. Catalyst 9300 with 10G/mGig) | £££ | big project | future-proof whole site |

## D. Server-to-server direct (no switch involved)
| # | Path | Cost | Work / risk | Gain |
|---|---|---|---|---|
| D1 | **2nd 10G card in the Gen9 + direct DAC** to the AI server | ~£30–80 | Gen9 slot needed (with P40s fitted) | 10G storage ↔ AI server; rest of LAN at 1G |
| D2 | **Split the Gen9 bundle:** one 10G port to the switch, one direct to the AI server | £0 | loses Gen9's switch redundancy | 10G direct, no purchase |
| D3 | **Server triangle:** Gen9, AI server, R710 each with 2 ports, cabled to each other directly (Proxmox "full mesh") | 1–2 cards ~£30–80 each | routing config on the hosts | every server pair at 10G, no switch |
| D4 | **Go faster than 10G direct:** used 40G/25G cards (e.g. Mellanox ConnectX-3 40G ~£20–40 each) + QSFP cable | ~£60–120 | Gen9 slot needed; driver check | 40G storage ↔ AI server (4× faster model loads) |

## Facts needed to choose
1. `show interfaces status | include /1/` on the 3850 (what's in each slot, at what speed).
2. Gen9 lid-off: is the 331T (1G 4-port) slot free with the P40s fitted?
3. How Starlink is wired today (copper adapter → SFP, or fibre).
4. Where models/documents should live (A1 decides a lot).
