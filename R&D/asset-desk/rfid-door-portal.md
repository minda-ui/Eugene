# RND-34 — "Smart door": UHF RFID portal + cameras for the warehouse (lab sketch v0.1, 2026-11-04) — **PARKED 2026-11-04: Minda, too expensive.** Stay with QR labels + office check-out/in. Revisit only if a cheap DIY portal (budget integrated UHF reader ~£150–400 on one pedestrian door) proves itself, or tool losses justify the cost.

**Minda's idea:** warehouse only, no manual check-out/check-in. Walk through the door with a tool → antennas read its tag → the system records it **out** or **in** automatically. The intelligent cameras show **who** carried it.

## How it would work
```
 inside zone antennas ── doorway ── outside zone antennas
          \                                /
           fixed UHF reader (PoE, on the server VLAN)
                         │  tag reads with time + which antenna
                         ▼
        "door bridge" (small program on our server — Eugene writes it)
          · direction: inside antenna then outside = OUT; reverse = IN
          · de-duplicate, ignore tags that never cross (tools parked near the door)
          · update Snipe-IT via its API: OUT → checked out to "Left warehouse";
            IN → checked in to "Warehouse"
          · ask the NVR for the snapshot / clip at that second → attach link to the event
                         ▼
   Event list: "14:32 OUT · SDS drill FB-T-0012 · camera 7 clip" → office sees who
```

## Who carried it — three options
| Option | How | Privacy (UK GDPR) | Accuracy |
|---|---|---|---|
| **A. Camera snapshot attached** (recommended start) | NVR clip/still at the time of each door event; a person looks if needed | Ordinary CCTV use for security/asset protection — update the CCTV notice/policy to say footage is used for tool tracking | a human identifies; no automatic name |
| **B. Staff badge tag** | each person carries a UHF badge (key fob/lanyard); the reader sees badge + tools together → names the person automatically | Light — employee ID, not biometrics; staff told | good if everyone carries the badge |
| **C. Automatic face recognition** (DeepinMind NVR can do it) | NVR matches faces to a staff list | **Biometric = special-category data** → needs a DPIA, a clear lawful basis/condition, staff notice and a real necessity case; Minda + Victoria decision | good, but highest legal and trust cost |
Recommendation: **A now, B if automatic names are wanted; avoid C unless there's a strong reason.**

## Hardware (rough, ex VAT — quotes needed)
| Item | Examples | Rough £ |
|---|---|---|
| Fixed UHF reader, EU 865–868 MHz, PoE | Impinj R700, Zebra FX9600 / FX7500, budget 4-port readers | 400–1,800 |
| Antennas (2 inside + 2 outside for direction) | circular-polarised panel antennas | 4 × 80–250 |
| Cables, brackets, PoE switch port | — | 100–250 |
| Rugged on-metal tags for tools | epoxy / flexible on-metal UHF | £1–6 each |
| **Typical one-door total** | (excluding tags) | **~£1,000–3,000** |
Off-the-shelf RFID portal kits exist (reader + antennas pre-tuned) — easier set-up, higher price.

## Watch-outs
- **Doors:** a narrow pedestrian door is easy; a wide **roller/shutter door** needs more antennas and tuning. Every way out of the warehouse needs a portal, or tools leave unseen.
- **Missed reads:** tool in a metal case, tag shielded by the body, running fast. Mitigate: on-metal tags in good spots, antennas both sides, a short "reads per second" test per tool type; daily handheld sweep (or weekly) to catch drift.
- **Stray reads:** tools stored near the door read constantly → keep a no-storage zone ~2 m each side, use the direction logic.
- **Network & security:** the cameras sit on the **isolated CCTV VLAN** — keep it so. Only the door bridge gets a narrow, logged permission to ask the NVR for snapshots (Hikvision ISAPI), via the firewall (OPNsense rule later). The reader sits on the server VLAN, not the office LAN. No camera or reader exposed to the internet.
- **Not anti-theft:** it records what leaves; it doesn't stop it. Tags can be removed.
- **Stock too:** the same portal could read tagged *stock* cartons/pallets, but materials are tracked by barcode in InvenTree — keep RFID for tools first.

## Smallest honest trial
1. One door, one reader + 4 antennas, **20 tools** tagged.
2. Eugene writes the door bridge (reader → direction → Snipe-IT + NVR snapshot link) — tested on the bench first.
3. Two weeks: compare every door event against what people actually took. Target: >98% of crossings caught, direction right, no stray events.
4. Then decide: more doors, more tools, badges (B).

## Questions for Minda
- Which warehouse (HQ unit?) and **how many doors**, and are they pedestrian or roller doors?
- About how many tools would be tagged?
- Do the cameras already cover the door(s) — which camera models (DeepinMind NVR DS-9632NI-M8 at HQ, 16 cameras)?
- Comfortable with option A (snapshot, person decides), or want B (badges)?
