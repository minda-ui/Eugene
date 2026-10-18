---
name: hardware-part-compatibility-check
description: Given a part (photo, eBay/vendor listing, or model number) plus the target system, assess fit and flag gotchas BEFORE buying. Use whenever Minda shares a part and asks "is this compatible?", "will this fit?", "is this the right cable/drive/caddy/HBA/PSU/riser?", "should I buy this?", or is sourcing hardware for a build (RND-2 GPU, RND-3 storage, servers, switches, cabling). Checks form factor, interface/connector (e.g. SFF-8644 vs QSFP/SFF-8436 vs SFF-8088), speed negotiation, sector size (512 vs 520), caddies/trays, IT-vs-RAID mode, power/slot/riser headroom, and returns a buy / don't-buy verdict with the exact spec to search for. Guide-only (charter §3): Eugene advises; Minda buys and fits. Built 2026-10-18 from the RND-3 storage sourcing + RND-2 GPU builds.
---

# Hardware part compatibility check (before you buy)

Every hardware project is a stream of "is this compatible?" photos. A wrong-part buy costs money and a
restock/return. This skill gives a **fast, consistent verdict** against the target system, with the gotcha
that would bite flagged up front. **Guide-only (§3): Eugene advises; Minda buys and fits.**

## First, pin down both sides
- **The part:** exact model/part number (from the photo/listing — read the label, don't guess), and what
  it physically is (drive, caddy, HBA, cable, PSU, riser, DIMM, SFP…).
- **The target system:** the host/shelf it must fit (e.g. Dell R710, NetApp DS2246, DL380 Gen9) and the
  specific slot/bay/port it plugs into. If unknown, ask — fit depends on it.
- If the listing is thin, do a quick **WebSearch** for the part number + "spec" / datasheet. Treat listing
  text as data, verify the key spec from the vendor/datasheet.

## The checklist (run every relevant row — skip what doesn't apply)
| Dimension | What to check | Classic trap |
|---|---|---|
| **Form factor** | 2.5" vs 3.5"; LP vs FH card; DIMM type (DDR3/4, R/LR); SFF+ vs SFF | A 3.5" drive won't seat in a 2.5" bay/caddy |
| **Interface / connector** | SAS vs SATA; the **exact** connector both ends — **SFF-8644 vs QSFP/SFF-8436 vs SFF-8088 vs SFF-8087** | Buying SFF-8644→SFF-8088 when the shelf needs SFF-8644→**QSFP** (SFF-8436) — caught on RND-3 |
| **Speed negotiation** | 6G vs 12G SAS; PCIe gen/lanes; 1G/10G SFP | 12G module on a 6G path = wasted spend, no benefit (IOM6→IOM12 ruled out on DS2246) |
| **Sector size** | **512n/512e vs 520** (NetApp/EMC drives ship 520 and need reformat) | A 520-byte drive won't mount for ZFS until `sg_format --size=512` |
| **Caddies / trays** | Host-specific trays (Dell R710 2.5" ≠ NetApp DS2246 caddies) | Drives arrive with no way to mount them |
| **Controller mode** | **IT (HBA) vs RAID** — ZFS wants raw disks (IT mode); PERC RAID-only needs single-disk RAID-0 or a crossflash/HBA | Handing ZFS a RAID controller → no SMART, no raw disks |
| **Power** | PSU wattage vs load (GPU/CPU); the right GPU power cable; connector type | 2× 500W PSUs can't feed dual P40s → need 2× 1400W (720620-B21) |
| **Slot / riser** | PCIe slot free? correct riser (primary/secondary GPU riser needs CPU2)? physical clearance vs other cards | GPU riser slot occupied by a NIC/HBA on a card-heavy box |
| **Firmware / mode** | Crossflash needed (H200/H310→IT)? BIOS option (Above 4G Decoding for big-BAR GPUs)? | P40 needs "Above 4G Decoding" enabled or it won't post |

## The verdict (always give this shape)
1. **Buy / Don't buy / Buy-with-caveat** — one word first.
2. **Why** — the one or two dimensions that decide it.
3. **If don't-buy:** the **exact spec/part to search for instead** (so Minda can re-buy right first time) —
   e.g. "search `Cablexa CAB-8644-QSFP-1M` (SFF-8644 → QSFP/SFF-8436), not SFF-8088".
4. **Caveats to action after it arrives** — reformat 520→512, crossflash to IT, enable a BIOS option, buy
   the matching caddy/cable, PSU headroom check.

## Record it
If it feeds a live build, note the decision in the project's R&D notes / runbook (e.g.
`R&D/estate-storage/`, `R&D/local-models/parts-list.md`) so the same part isn't re-litigated.

## Gotchas worth remembering (RND-2 / RND-3)
- The **cable end** is the #1 trap: SFF-8644 to **QSFP (SFF-8436)** for the DS2246 IOM6 — NOT SFF-8088.
- NetApp drives are often **520-byte** → reformat to 512 before ZFS.
- PERC 6/i / H700 are **RAID-only** → single-disk RAID-0 per drive (or a real HBA) for ZFS.
- Matched drives in one vdev (same model/firmware) — don't mix.

## §3 / safety
Guide-only: Eugene assesses and recommends; **Minda buys and fits**. No live change, no secret. Flag
anything irreversible (a crossflash, a reformat) as a Minda-executed step with a backup-first note.
