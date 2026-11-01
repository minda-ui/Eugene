# HQ Wi-Fi survey — 2026-11-01 (WiFiman signal mapper, Minda walking)

Source: 2 screenshots from Eugene `Raw/` (Drive ids 1ukzjFH08cyatbkjNfu2q8k1eqEDzObkq → `scan1.png`, 1dp2WODJmfH0IcXcgJslPw5ggCo1TEtdZ → `scan2.png`).
Colour scale (WiFiman): green = strong · yellow = OK · orange = weak · red = poor. **No dBm values, legend, floor plan or AP positions yet.**

## First read
| Map | Good | Weak | Poor |
|---|---|---|---|
| scan1 | right side + bottom section green | left side and top-left orange | **one red spot in the middle** (by the walk path junction) |
| scan2 | left/central area green | top-right corner and bottom-right section orange | small red-orange patch top-centre-right |

## Still needed
Which area/floor each map is · orientation (where the entrance is) · where the 3 APs are mounted · dBm at the red/orange spots · speed tests · G-NetTrack log.

## Mobile signal — G-NetTrack Lite log (O2, 10:31:48–10:33:09, Drive `O2_-_UK_2026.11.01_10.31.30.txt`)
| Time | Tech | Level (dBm) | Read |
|---|---|---|---|
| 10:31:48 | 4G | −340 | invalid / no reading |
| 10:31:58 | 4G | **−121** | very poor |
| 10:32:45 | **2G** | −111 | fell back to 2G |
| 10:32:58 | -- | −113 | **no service** |
| 10:33:09 | 4G | −253 | invalid / no reading |
Only 5 samples over ~80 s, one GPS position (indoors), KML exports empty. **O2 indoors at HQ is very poor (4G −121, drops to 2G / no service).** Not yet known: whether the booster was on, other networks (EE/Vodafone/Three), booster on/off comparison, booster model (Ofcom).

## Booster check (2026-11-01)
Label: **"800/900/1800/2100/2600MHz Booster", model SR-FBG70/22-K** (≈70 dB gain / 22 dBm), no Ofcom/IR 2102 marking.
→ Generic **multi-operator, 5-band, high-gain** repeater = **not licence-exempt in the UK** (Ofcom allows only IR 2102-compliant single-operator boosters; others are illegal to install/use under the Wireless Telegraphy Act and can interfere with the networks). **Eugene does not guide its set-up.** Keep it switched off.
**Options:** (1) Wi-Fi calling on staff phones — free, now; (2) Ofcom-approved O2 booster (e.g. Cel-Fi GO class, ~£500–1,000 + fit) re-using the mast position; (3) ask O2 business about indoor coverage options.
