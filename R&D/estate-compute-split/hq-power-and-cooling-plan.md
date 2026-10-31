# RND-28 — HQ power & cooling plan for the AI build

_R&D plan (creative mode, 2026-10-31, Minda: "let's plan it"). Guide-only (§3): Minda reads meters and makes any
physical/electrical change; electrical work beyond plugging into existing sockets = a qualified electrician.
Eugene plans + checks the numbers. All wattages below are **estimates until measured**._

## What we know
- **2× APC Smart-UPS 2200** cover the whole rack (servers, ASAs, switches, WAN, NVR). Exact model, battery
  age, load and runtime unknown. A Smart-UPS 2200 is typically **~1.98 kW max each**.
- **Important:** if each server's two PSUs are split across the two UPSes (A/B feed), the pair is only
  redundant while the **total stays under ONE UPS's capacity (~1.98 kW)** — if one UPS fails, the other
  carries everything.
- V100s need **inlet air ≤30 °C** (8SFF chassis); the P40s already run on Max Cooling.

## Step 1 — measure (all read-only, ~30 min at HQ)
| # | Read | Where |
|---|---|---|
| 1 | **UPS model, load %, runtime, battery status/date** | each UPS's front display (+ label on the back) |
| 2 | **What plugs into which UPS** | photo of the back of both UPSes + the PSU cables |
| 3 | **Gen9 power now** (current / average / peak W) + **inlet temperature** | iLO → *Power & Thermal* → Power Meter / Temperatures ("01-Inlet Ambient") |
| 4 | **Switch PoE draw** | 3850: `show power inline` (cameras, APs, phones) |
| 5 | **What feeds the UPSes** | plug type (13 A UK plug vs 16 A commando), and which wall circuit |
| 6 | **Room** | is there air-con? typical temperature on a warm day; door/vent |

## Step 2 — the power budget (estimates, to replace with measurements)
| Device | Today (typical) | After the AI build (typical → peak) |
|---|---|---|
| Gen9 (with 2× P40 today; storage + PBX later) | ~350–450 W | ~250–350 W (GPUs removed) |
| **New AI server, 3× V100** | — | **~400 W idle → ~1,300–1,500 W full load** |
| R710 (backups; off between runs) | ~180–250 W | ~0 most of the time, ~250 W during runs |
| 2× ASA 5550 | ~200–300 W | same (or less after path E) |
| 2× 3850-48F + PoE (16 cameras, APs, phones) | ~300–600 W | same |
| NVR, WAN kit, Starlink | ~100–200 W | same |
| **Rack total** | **~1.1–1.8 kW** | **~1.7–2.6 kW typical → ~2.6–3.2 kW peak** |

**Reading:** after the build, peak load is **likely above one UPS (~2 kW)** → no redundancy at full GPU load,
and short battery runtime. Heat ≈ power: **~2.5 kW ≈ 8,500 BTU/h** into the room.

## Step 3 — ways to make it fit (pick a mix)
**Reduce the load**
- **P1. Cap the V100s:** `nvidia-smi -pl 200` (from 250 W) → ~150 W less at peak, small speed loss.
- **P2. Heavy jobs at night** (night shift): cooler room, no clash with office load.
- **P3. Share with Beverley** (RND-27): Beverley's P40s take vision/batch → less heat at HQ.
- **P4. Path E later:** a modern firewall pair uses far less than 2× ASA 5550.

**Protect the critical kit first (phones, firewall, switches, storage)**
- **P5. Load-shedding on a power cut:** the AI server shuts down **first** (after ~1–2 min on battery) via
  APC PowerChute/NUT, so the battery runtime goes to the phones, ASAs, switches and Gen9.
- **P6. A/B feeds:** every dual-PSU box has one PSU on each UPS (check today's wiring in step 1).
- **P7. Give the AI server its own UPS** (e.g. a used 3 kVA online UPS, ~£300–800 + install) so it can never
  drain the critical pair. Needs a suitable socket/circuit.

**Grow the supply**
- **P8. Bigger/extra UPS** (3 kVA class) or **UPS battery replacement** if the batteries are old (3–5 yr life).
- **P9. Circuit check:** a 13 A plug tops out ~3 kW; heavier needs a 16 A commando / dedicated circuit —
  **electrician job**.

**Cooling**
- **C1. Measure first** (iLO inlet temp, a thermometer at the rack front on a warm afternoon).
- **C2. If inlet runs >25 °C under load:** portable AC (~9–12k BTU, ~£300–500) or extraction fan/vent
  (cheapest); **split AC** (~£1.5–3k, installer) if it's a permanent server room.
- **C3. Hot/cold discipline:** blanking panels, front-to-back airflow, nothing blocking the rear.
- **C4. Alarms:** iLO temperature alerts + UPS on-battery alerts into the silent-failure alarm (RND-6).

## Step 4 — decide (after measuring)
1. Fits with P1+P2+P5? → no purchase, just config + rules.
2. Doesn't fit → P7 (own UPS for the AI server) or P8 (bigger UPS) ± P9 (circuit).
3. Room too warm → C2.

## Step 1 results (Minda, 2026-10-31) + rebalancing plan
- UPS 1: **1 of 5 load LEDs lit**; UPS 2: **none lit** → almost all load on UPS 1. On battery, **UPS 1 runs flat first**. Devices were plugged in with no balancing. Feeds: **13 A plugs**; an upgrade (bigger circuit) is possible.
- iLO power meter (item 3) and `show power inline` (item 4): still to do.

**A/B rule 1 — dual-PSU kit: one PSU on each UPS:** Gen9, R710, 3850 #1, 3850 #2, future AI server.
**A/B rule 2 — single-PSU kit split so a UPS failure never takes both halves of a pair:**
ASA-1 → A, **ASA-2 → B**; Wavenet router → A, **Starlink → B**; NVR → B.
**Method:** dual-PSU = move one cable at a time, wait for PSU healthy (no outage). Single-PSU = brief power-off →
standby ASA-2 first + verify failover; the rest in a phones-free window. Target: both UPS load gauges roughly equal.
**Also:** UPS self-test + battery date/replace light (UPS 1's fast drain may also be ageing batteries); each UPS on its
own wall socket (ideally separate circuits), never a shared extension lead. 16 A dedicated circuit = later, if the AI
server gets its own 3 kVA UPS (electrician).
