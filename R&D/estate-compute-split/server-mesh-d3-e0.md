# RND-26 chosen direction — D3 server triangle (+ E0 in reserve)

_R&D design (creative mode, 2026-10-31, Minda: "E0 with D3 is a great idea"). Guide-only (§3): Minda fits
cards/cables and runs host + switch commands; Eugene designs, writes configs, verifies. Nothing bought._

## The idea
The three HQ servers get **their own private 10G cables to each other** — a triangle. Bulk traffic
(model files, document copy, backups, replication) runs **only on those cables**: never through the 3850s,
never through the ASA. The office network keeps carrying the small stuff (chat, management, phones).

```
                      office LAN (3850 stack, VLANs, ASA = internet edge)
                 ┌───────────────┬───────────────────┬──────────────────┐
                 │ 2×10G bundle  │ 1G copper (×2–4)  │ 1G copper        │
          ┌──────┴──────┐  10G  ┌┴────────────────┐  │                  │
          │  Gen9        │══════│ AI server Gen10  │  │                  │
          │  storage+PBX │ DAC  │ 3× V100          │  │                  │
          └──────┬──────┘       └────────┬─────────┘  │                  │
              10G║ DAC                10G║ DAC        │                  │
                 ║   ┌─────────────────┐ ║            │                  │
                 ╚═══│  R710 backup    │═╝────────────┘                  │
                     │  (off between   │                                 │
                     │   backup runs)  │                                 │
                     └─────────────────┘                                 │
   ═══ = private server triangle (10G, no gateway, not routed to the LAN)
```

## What each server needs
| Server | Triangle ports | How | LAN connection |
|---|---|---|---|
| **Gen9** | 2× 10G | **add a 2-port 10G card** (e.g. HPE 560SFP+ / 530SFP+, ~£20–40) in place of the unused **331T** 1G 4-port — *slot must be x8 and free with the P40s fitted (lid-off check)* | keeps its existing **2× 10G bundle** to both switches |
| **AI server (Gen10)** | 2× 10G | **FlexibleLOM 2-port 10G** (no PCIe slot needed — all three GPU slots stay free) | **onboard 1G copper bundled to both switches** (chat traffic is tiny) |
| **R710** | 2× 10G | **2-port 10G card** (Intel X520-DA2 class, ~£20–30; R710 PCIe Gen2 x8 = enough) | existing 1G port |

**Cables:** 3 × SFP+ DAC. **2 spare Cisco 5 m DACs on hand** → buy **1 more** (~£13). DACs between non-Cisco
NICs normally work; test each link.

## Addressing (simple, isolated)
Each cable is its own tiny private network with **no gateway** — it can't reach the LAN or the internet:
| Link | Subnet | Ends |
|---|---|---|
| Gen9 ↔ AI server | `10.99.12.0/30` | .1 Gen9 / .2 AI |
| Gen9 ↔ R710 | `10.99.13.0/30` | .1 Gen9 / .2 R710 |
| AI server ↔ R710 | `10.99.23.0/30` | .1 AI / .2 R710 |
Services point at the peer's triangle address (e.g. AI server mounts the Gen9 model/document share at
`10.99.12.1`; R710's backup pull uses `10.99.13.1`). Jumbo frames (MTU 9000) on triangle links only.
(Later option: Proxmox "routed full mesh" with automatic fallback if one cable dies.)

## Why it's good
- **Speed:** 10G server-to-server with zero switch/firewall work; same-VLAN rule no longer matters for bulk.
- **Security:** storage + backup traffic is physically off the office network; the backup copy (R710)
  is reachable only over a private cable — fits the pull-not-push backup design (OI-26).
- **No risk to live systems:** nothing changes on the 3850s or ASAs.
- **Cheap:** ~£60–110 total (two cards + one DAC), plus the AI server's FlexibleLOM.

## Where E0 fits (in reserve)
E0 = let the 3850 stack route the server VLAN instead of the ASA. With the triangle doing the bulk work,
E0 only matters if **office ↔ server** traffic grows (e.g. many staff loading big files from storage).
Keep it on the shelf; revisit if the ASA ever shows as a bottleneck. Check the LAN Base licence's routing
limits first.

## Phasing
| Phase | What | When |
|---|---|---|
| **P0** | Gen9 2-port 10G card + R710 10G card + 1 DAC → **Gen9 ↔ R710** link; backups move onto it | any time (next lid-off) |
| **P1** | AI server arrives with FlexibleLOM 10G → cable **Gen9 ↔ AI** and **AI ↔ R710** | with the Gen10 |
| **P2** (optional) | routed full mesh with fallback; E0 if needed | later |

## Facts to confirm
1. Gen9 lid-off: the 331T's slot — free, x8, and clear of the P40s?
2. R710: free PCIe slot (it has several; confirm the PERC/other cards).
3. Gen10 order includes a **2-port 10G FlexibleLOM** (e.g. HPE 562FLR-SFP+ / 530FLR-SFP+) — add to the BOM.
