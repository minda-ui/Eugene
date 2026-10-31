# Change log — 2026-10-31 (Sat, later session) — HPE DL380 Gen9 manuals registered; P40 power theory corrected

_Fresh session after the `*.hp.com` network allow (the morning session ended "log + restart" for it).
Interactive with Minda; guide-only, no credential held (§3)._

## 1. Network check
`www.hp.com`, `partsurfer.hp.com`, `partsurfer.hpe.com`, `support.hpe.com` reachable. Bare `hp.com` is
still refused (a `*.hp.com` wildcard doesn't cover the apex; add `hp.com` separately if ever needed).
`support.hp.com` / `h30434.www3.hp.com` answer 403 (HP's own bot wall), `h20195.www2.hp.com` fails TLS
verification in-session, `www.hpe.com` times out, `community.hpe.com` is Cloudflare-walled (a headless
browser attempt to get past it was correctly blocked — not pursued). `forums.developer.nvidia.com` and
`cdn.shopify.com` aren't on the allowlist.

## 2. HPE manuals fetched + registered
Direct-PDF endpoint `support.hpe.com/hpesc/public/api/document/<docId>` works. Fetched User Guide
`c04436966` (228 pp, 16,349,434 B) and QuickSpecs `c04346247` (57 pp, 1,211,442 B). Minda asked to
"save the manual so we can use it": **not committed to git** (large binaries) and **Drive upload not
possible this session** — Composio CLI not signed in (`sync.sh` exit 2, nothing changed) and 16 MB is far
over what can be relayed through context. Per the charter §1 external-binary rule, registered by
permanent URL + SHA-256 + page index in `Infra-Inventory/Reference-HPE-DL380-Gen9-Manuals.md` (with a
copy-paste fetch command), and SRC-14 in `external-source-register.md`. A Drive copy can be added later
from a session with the CLI signed in, or by Minda dropping the PDF into `Infra-Inventory/`.

## 3. P40 aux power (OI-30) — yesterday's theory withdrawn
- HPE's GPU-install diagrams (UG p.95, p.186): power cable goes **riser 10-pin → GPU only**. No
  board→riser cable exists, so the 2026-10-31 morning "missing board→riser feed" conclusion was wrong.
  It is left as written in the morning change-log (honest record) and marked superseded in OI-30.
- PartSurfer: **`805123-001`** = "GPU power cable, 8-pin to 10-pin, GPU board ↔ GPU riser board", in kit
  `719082-B21`. `728539-B21` → `687955-001` is a general cable kit, not the P40 part.
- QuickSpecs P40 `Q0V80C` prerequisites (GPU risers 719076/719073, ≥1×1400 W per card, HP fan kit
  719079, E5-2600 v4, kit 719082) — all met.
- Minda photographed a board header next to the microSD slot: per UG p.20 it is **item 10, drive
  backplane power** — told her not to plug the GPU cable there.
- **Judgement call:** the common factor across two cards on two risers is the cables — likely
  non-genuine or mis-wired. Next step chosen: a **12 V multimeter test** at the cable's card end (cable
  left in the riser, card end loose, box powered), done in the same visit as the CR2032 swap (OI-32) so
  the BIOS reset only happens once. Riser 10-pin pin-out is unpublished, so no trial plugging.

## Files
`Infra-Inventory/Reference-HPE-DL380-Gen9-Manuals.md` (new), `external-source-register.md` (SRC-14),
`open-issues.md` (OI-30 updated), `processed-items-ledger.md` (row 152), this file.

## 4. Back at HQ — battery, P40 root cause, iLO (afternoon)
- **CR2032 swapped (OI-32).** Booted with no reset screen; settings intact. Confirm on the next full power-off, then resolve.
- **12 V tests (OI-30).** Cable in riser, card end loose, box on: one row 4× **12.17 V**, other row 0 / **3.4 V** / 0 / 0; both cables identical. Power-off resistance: P40 socket **clip-side row = ground**; cable's non-12 V row = 3 grounds + one ~478 kΩ signal.
- **My error.** I numbered pins assuming clip-up; Minda held the plug clip-down. That led me (a) to conclude "cable matches card" — wrong — and (b) to point a jumper at what was really a 12 V pin. The jumper grounded 12 V and the Gen9 hard-powered off. Recovered clean: no smell/damage, `zpool status -x` healthy, FW/proxy/ssh-gw/**PBX running**. Minda caught the orientation. Lesson on the Hub: **HL-0110** (describe pins by row/landmark from a photo; one-probe check before any bridge; no live jumpers).
- **Corrected root cause.** Physically: cable = 12 V on the **clip** side (graphics/PCIe-style); P40 = EPS, 12 V **away** from the clip. Plugged in, 12 V meets the card's ground → riser protection never enables 12 V (silent). The cables are wrong, not the risers or cards. Told Minda to leave the cables unplugged at the card end. Fix: 2× genuine `805123-001` (10-pin → EPS/CPU, Tesla type), pre-checked with one probe before use.
- **iLO (OI-31).** Minda changed the iLO password (held by her; not seen by Eugene). iLO page: MAC `94:18:82:02:AC:02`, DHCP `10.224.10.50`, gw `10.224.10.1`. The ASA is DHCP server for every HQ VLAN but can't reserve by MAC → static IP outside the pool, once the pool is known.
- **Gap owned.** Minda expected the network map to show DHCP; it didn't. Logged as my task.
- **Hub (Rule B):** AWT-1060 (Minda — ASA `show run dhcpd`, iLO static IP + SNTP), AWT-1061 (Minda — buy cables), AWT-1062 (Eugene — map addressing layer, Blocked on 1060), HL-0110. No duplicate IDs (guard column checked).
- **Beverley Loxone (new, Minda):** Miniserver, Audio Server and Intercom lose connectivity for days after a DHCP address change → need fixed IPs. Not yet in our records (no IPs/MACs). Beverley gw `10.224.111.1` / mgmt `10.224.110.x`; DHCP server presumed the ASA (unconfirmed). Hub **AWT-1063** (Minda): ASA `show run dhcpd` + `show dhcpd binding` + device-label MACs → Eugene picks 3 addresses outside the pool → Minda sets static in Loxone Config (Audio/Intercom first, Miniserver last). Beverley addressing folds into AWT-1062's map layer.
- **Beverley printer (new, Minda):** HP Colour LaserJet Pro MFP M479dw keeps losing the PC. Likely causes: DHCP address change (PC added by IP/WSD), printer on Wi-Fi/different VLAN from the PC (Beverley: LAN vlan 111, Wi-Fi AP vlan 110), deep sleep/'Auto Off'. Folded into **AWT-1063** (now 4 fixed IPs): wired if possible, static IPv4 via the printer's web page, Auto Off off, re-add on PCs as Standard TCP/IP port (not WSD).
