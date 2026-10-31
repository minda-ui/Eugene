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

## Cooling — what HQ has (Minda, 2026-10-31)
**Daikin VAM1000J** ducted heat-recovery ventilator, 1,000 m³/h, 240 V — **ventilation, not air-con**: it can only
bring the room *towards outside temperature*. Rough capacity if all the air reached the rack: ≈ 1.2 kg/m³ × 1,005 J/kg·K ×
0.278 m³/s ≈ **335 W per °C** (room minus outside) → 2.5 kW needs the room ~7–8 °C above outside:
outside 10 °C → ~18 °C ✅ · 18 °C → ~26 °C ✅ · **25 °C → ~33 °C ❌** (V100 limit 30 °C). Real figure worse — the
1,000 m³/h serves the whole building.
- **Winter bonus:** in heat-recovery mode the server heat pre-warms the office's fresh air (free heating).
- **Summer:** needs **bypass / free-cooling mode** (VAM auto mode) or it recycles server heat.
- **Check:** rack-area supply/extract grilles + share of airflow · VAM mode (Auto/Heat-exchange/Bypass) · filters · iLO inlet temp on a warm afternoon.
- **Options:** night/cool-hours heavy jobs + V100 power cap (£0) → rack-area extract fan/duct to outside (~£100–400 + installer)
  → portable AC for summer peaks (~£300–500) → split AC (~£1.5–3k) → shift summer load to Beverley (£0).
- **Read:** VAM likely fine autumn–spring; **summer is the gap** — measure a warm day before buying.

## UPS model confirmed (Minda, 2026-10-31)
**3× APC Smart-UPS 2200VA RM 2U 230V `SUA2200RMI2U`** (1,980 W each) — **2 at HQ, 1 at Beverley**. One bought
**10 Oct 2025** (order #38435, £349.70, 2-yr warranty → to Oct 2027); purchase dates of the other two not yet known.
- Battery pack for this model: **APC RBC43** (check the label before buying). Batteries last ~3–5 yr → the Oct 2025 unit's
  are young; **UPS 1's fast drain is more likely the load imbalance than age** — confirm with a self-test (AWT-1065).
- **Monitoring:** USB/serial → NUT on a server (free), or a **SmartSlot network card AP9631/AP9630** (~£40–80 used) for
  on-battery alerts + the AI server's early shutdown (P5, C4).
- **Capacity:** 2× 1,980 W at HQ. New AI server (2× P40 + CPUs) ≈ 600–800 W under load → fits once the load is balanced
  across both UPSs (AWT-1064). Beverley Gen10 (CPU-only) ≈ 250–400 W → fine on its one UPS.

### Correction from minda@ email (UPS Centre, checked 2026-10-31)
- **Order 38435 — 1× SUA2200RMI2U (2200 VA / 1,980 W)**: ordered 10 Oct 2025, card payment refunded 16 Oct, then re-invoiced
  (INV-001637, £360.49) and **delivered by pallet ~22 Oct 2025**.
- **Order 38606 — 1× SUA3000RMI2U (3000 VA / 2,700 W)**: ordered 1 Nov 2025, invoiced INV-001693 (£459.79), **delivered ~9 Nov 2025**.
- So the three are **not all 2200s**: at least **one 3000 VA**. The **third UPS isn't from UPS Centre** — source/date unknown.
  Both of these have ~1-year-old batteries (2-yr warranty to Oct/Nov 2027). Both 2U models are believed to take the same pack (RBC43) — check the label.
- **To confirm (Minda):** which unit is where (HQ ×2 / Beverley ×1) and the third unit's model + age (front display/rear label).
  If the 3000 VA is at HQ, HQ has 1,980 + 2,700 W — plenty for the AI server.
- **Confirmed (Minda, 2026-10-31): both UPS Centre units are at HQ** → HQ = **1× SUA2200RMI2U (1,980 W) + 1× SUA3000RMI2U (2,700 W)
  ≈ 4.7 kW**, batteries ~1 yr old. Beverley = the third unit (model/age to read off its display). For A/B balancing (AWT-1064): put
  the heavier side (incl. the new AI server's 2nd PSU) on the **3000 VA**. Note: the **3000 VA draws up to ~13 A at full load** — fine
  on a 13 A plug at today's loads, but it's the first thing to check before adding much more (16 A circuit option).
- **Third UPS found (minda@fishbonedrylining, UPS Centre order 36438, 24 Oct 2024):** **SUA2200RMI2U, refurbished with
  brand-new batteries, 2-yr return-to-base warranty**; Minda accepted 31 Oct 2024, delivered early Nov 2024 → **Beverley**.
  Batteries ~2 yr old. ⚠️ **Warranty ends ~early Nov 2026** — run a self-test/runtime check at Beverley **now**, so any fault is
  claimed in time. All three units: SUA 2U family, believed RBC43 packs.
  | Site | Model | Delivered | Batteries | Warranty to |
  |---|---|---|---|---|
  | HQ | SUA2200RMI2U | ~22 Oct 2025 | ~1 yr | ~Oct 2027 |
  | HQ | SUA3000RMI2U | ~9 Nov 2025 | ~1 yr | ~Nov 2027 |
  | Beverley | SUA2200RMI2U (refurb, new batteries) | ~early Nov 2024 | ~2 yr | **~Nov 2026** |
- **CORRECTION (Minda, 2026-10-31): the latest unit (3000 VA, Nov 2025) is at BEVERLEY.** Supersedes "both UPS Centre units at HQ"
  and the 3000 VA balancing note above. Final:
  | Site | Model | Arrived | Batteries | Warranty to |
  |---|---|---|---|---|
  | HQ | SUA2200RMI2U (refurb, new batteries) | ~early Nov 2024 | ~2 yr | **~early Nov 2026** |
  | HQ | SUA2200RMI2U | ~22 Oct 2025 | ~1 yr | ~Oct 2027 |
  | Beverley | SUA3000RMI2U | ~9 Nov 2025 | ~1 yr | ~Nov 2027 |
  HQ = **2× 1,980 W ≈ 3.96 kW**. AI server (~600–800 W) still fits once load is balanced 50/50 (AWT-1064), but headroom is
  tighter — split each server's two PSUs across the two UPSs. ⚠️ **The HQ refurb unit's warranty ends ~early Nov 2026** →
  self-test + runtime check at HQ **now** (if it's UPS 1, the one that drains first, this matters most).
