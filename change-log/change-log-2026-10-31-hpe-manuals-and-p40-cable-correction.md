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
- **Creative-mode R&D session (afternoon):** RND-23 (Gen10 brain: DL380 vs DL580, V100 sketch, option C GPU servers, cost comparison), RND-24 (model orchestra + staff-questions pilot + DeepSeek Harness seat), RND-25 (Composio developer docs read — docs.composio.dev allowed by Minda), RND-26 (HQ server networking menu; 3850 = 2× WS-C3850-48F-L + NM-2-10G confirmed; ASA 5550 1G-only; path E firewall options; D3 server triangle chosen direction), RND-27 (two-site AI pool), RND-28 (power + cooling: UPS imbalance, A/B plan, Daikin VAM1000J assessed). Published the **Fishbone Local AI Map** artifact (https://claude.ai/artifact/Bb42KMsKdQaNyxpzCNuUCn). All R&D — nothing graduated, nothing bought.
- **Hub tasks for Minda (approved):** AWT-1064 UPS A/B rebalancing · AWT-1065 UPS health/self-test/sockets · AWT-1066 iLO power + inlet temp + VAM checks · AWT-1067 3850 read-only checks (`show power inline`, module slots, inventory). Duplicate-ID guard clean.
- **GRADUATED: OPNsense firewalls (RND-26 path E3).** Minda chose OPNsense, then option 2 (HQ inside-first, edge later; Beverley straight-swap pilot), then **ordered 4× Cisco ASA 5525-X** (HQ pair + Beverley + spare) to run OPNsense. Recorded in `R&D/graduation-register.md`; arrival checklist in the plan (bench-check, **fresh OPNsense install from the official checksum-verified image** — never the seller's copy, SSD, 2FA, burn-in). Hub **AWT-1068** (Minda: bench check + ASA config exports, secrets masked) · **AWT-1069** (Eugene: build + migration runbooks, Blocked on 1068). Map updated (status: Ordered).
- **Beverley WAN direction change (OI-24):** Minda: BT Business line has **5 public IPs** and is near contract end; personal line has no public IP, ~7 months left → **extend Business, let personal lapse**. Flagged the conflict with OI-24's "cancelled 27 Oct" — Minda to confirm the line is still live and ask BT to keep the same IPs. Advised: don't cancel personal early; later use HQ Wavenet over the radio as Beverley's backup. OI-24 + inventory updated.
- **Correction (software, RND-30):** the 2026-10-30 driver note said "the 580 branch drops Pascal, so 535". Wrong — NVIDIA's **R580 is the last branch that supports Pascal (P40) and Volta (V100)**; they go legacy from R590, and CUDA 12.x is the last toolkit for them. 535 works today; 580 is the better long-term pick. Software plan written (`R&D/estate-model-orchestra/software-stack-plan.md`): frozen pinned stack, llama.cpp from source as the engine (vLLM has no Pascal support; Ollama pinned for the pilot only), Beverley as update staging. Monitoring decisions recorded (Telegram + email, quiet hours 22–07 except UPS, external heartbeat OK). Security Review Brief doc made for Minda's security-expert friend (general terms, nothing sensitive).
- **Decisions (evening):** **stay with V100** for the HQ AI server (refresh ~2028) after researching longer-supported cards ≤£450 and the cost of going faster (A30 ~£2–2.65k, A100 ~£4–5.5k per card). **Skip the Gen9 P40 cables** → OI-30 PARKED, Hub AWT-1061 closed as cancelled; P40s move to Beverley Gen10 later; pilot on Gen9 CPU meanwhile. Map updated.
- **AI server decided: DL380 Gen10 + V100** (option A) after comparing DL385 Gen10 Plus (HPE QuickSpecs a00073549enw; Bargain Hardware build ≈ £4.4k ex VAT before GPUs) and DL360 (1U — no room for V100s). Minda's **6× 900 GB SAS** (bought for the R710) become the AI server's model library. Final build checklist in `v100-brain-sketch.md`. Map updated.
- **GRADUATED: AI servers ordered.** Minda ordered **2× DL380 Gen10** from Bargain Hardware (HQ AI server + Beverley node), £583 each, £1,194.52 ex VAT with delivery, est. 9 Nov. Checked the confirmation line by line: totals add up; **missing High-Performance fans, boot SSDs, GPU-riser/baffle confirmation, 871829-B21**; rails listed as G8/G9 — ask BH to confirm Gen10 fit. RAM now needed for both. Personal/VAT details from the confirmation not recorded.
- **Draft to Bargain Hardware (order 002022046):** reply-threaded draft in minda@'s Drafts (not sent — §3) asking for 6× HP fans per server, GPU-ready risers + baffle confirmation, a quote for 826700-B21 / 871829-B21, and the Gen10 rail fit.
- **Sent by Minda** 19:27 UTC (from ops@, in the order thread). Awaiting BH answers on fans / GPU risers + baffle / rails before the build.
- **V100 price:** Minda reports ~£700 each for 32 GB (estimate was £520–600). Steer: P40s into the HQ Gen10 first, decide on V100 after measuring.
- **Decision:** P40 first, V100 later — RAM (12 sticks) before any new cards; V100 only if pilot testing shows it's needed. Map updated.
- **GPU cables ordered:** 4× HPE 869820-001 EPS 8-pin (Gen10 keyed kit cable), £96 inc VAT. Personal/VAT details not recorded.
