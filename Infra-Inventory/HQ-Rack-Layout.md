# HQ rack layout — draft v0.1 (2026-11-06, from Minda's photos)

**Cabinet:** HP 36U. **Free:** ~10–16U (Minda). U numbers not yet read — HP rails have them printed; fill in on the next visit.
**Rule of thumb:** heavy/hot low, network near the patch panels, every device on a UPS outlet (A/B split = AWT-1064/1065).

## Now (top → bottom, approximate)
| Zone | Device | Notes |
|---|---|---|
| Top | Patch panels + cable entry from ceiling | |
| Top | **2× ASA 5525-X (new, for OPNsense)** | keep **off** the live network until bench-built; unit 2 comes out for the VGA/BIOS job |
| Upper | **HP rack PDU** (power distribution unit, horizontal) | which UPS feeds it? — key for the A/B split (AWT-1064/1065) |
| Upper/middle | **DL380 Gen9** (2U, sliding rails) | loose items on top (console cable, caddy, adapters) → remove |
| Middle | **~2U empty sliding rails** | **planned: AI server DL380 Gen10** |
| Middle | **Hikvision DS-9632NI-M8 NVR (2U) on a wooden board** | → rack ears or 2U shelf |
| Lower-middle | **2× ASA 5550 (old, live HQ firewalls)** | stay until Step B, then removed (frees 2U) |
| Lower | 3850 stack (ports to the rear), Dell R710 (2U), fibre / Wavenet router area | |
| Bottom | **2× APC Smart-UPS 2200** (+ new AP9631 cards) | |

## Planned additions
| Device | Size | Where |
|---|---|---|
| AI server DL380 Gen10 | 2U | empty rails under the Gen9 |
| OPNsense pair (5525-X) | 2× 1U | already at the top |
| OOB switch TP-Link TL-SG1016 | 1U | near the top, next to the firewalls / patch panels |
| 1U cable manager(s) | 1U each | rear, by the 3850s and patch panels |
| NVR fix | (ears) or 2U shelf | where it is now |

## Tidy list
1. NVR off the wooden board.
2. Clear the top of the Gen9.
3. Rear cabling: velcro + cable manager; label both ends of every patch lead touched.
4. After Step B: remove the ASA 5550 pair.
