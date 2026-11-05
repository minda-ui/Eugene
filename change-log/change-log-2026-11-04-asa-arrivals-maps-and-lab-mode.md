# Change log — 2026-11-03 (evening) + 2026-11-04 — ASA arrivals, two maps updated, lab mode (gpt-oss, Dext, asset desk)

_Guide-only throughout (§3); no credential held; no live-system change made by Eugene._

## Update 2026-11-04 ~18:50 UTC — Good night
- **Lab mode** ('Lab mode' added as an alias of Creative mode in `.claude/hooks/creative-mode.sh`).
- **RND-31 exo** — parked (watch): Linux CPU-only, P40 likely unsupported, needs fast links. `R&D/local-models/exo-watch.md`.
- **RND-32 gpt-oss** — Minda: definitely test. Plan `R&D/local-models/gpt-oss-test-plan.md`: **Stage 1 CPU-only on the Gen9 at HQ 5 Nov** (capped LXC, PBX-safe) because the Gen9 P40s still have no aux power (OI-30) — corrected my earlier suggestion of a P40 test; Stage 2 on the Gen10 P40s after 9 Nov. Photo-model shortlist (Qwen3-VL 30B-A3B first). 
- **RND-33 Ledger Desk** (own Dext) — spark; **Rachel asked first** via Raw/ + Hub **AWT-1115**.
- **RND-34 Asset Desk** (EZOffice empty → start clean): requirements v0.1 (IT, site tools, plant/vehicles, stock, Amfa consumables; check-out/in, service, value; QR by phone; office-only 2–3 users); Snipe-IT for one-by-one assets + InvenTree for counted stock via manufacturers' barcodes; IT seed CSV (26 assets, no secrets); scanner shortlist; RFID research; **smart-door RFID portal parked (too expensive)**; **Darius asked** about production scanning via Raw/ + Hub **AWT-1116**.
- **5 Nov HQ list** in `current-state.md`: gpt-oss CPU test, VM 101 read-only look, Snipe-IT install, R710 backups if time.

## Update 2026-11-03 ~21:35 UTC — ASA units 2/3, two maps
- **AWT-1069:** OPNsense install runbook v0.2 (ASA 5525-X) + HQ ASA→OPNsense translation plan v0.1; Minda's 6 answers recorded (HQ pair = units 1+2; copy then tighten a week later; VM 101 unused → check, off 7 days, remove UDP 500/4500 forwards — OI-33; keep BT + Vodafone; tmp_hack = leftover; windows go-with-the-flow, telephony phones-free).
- **ASA unit 3 arrived** (V02, Lic FCH1802J4Y9, chassis FGL1804407Y from photo) → **assigned to Beverley (`bev-fw`)**. 3 of 4 in hand; SSDs due 4–5 Nov.
- **Artifacts updated:** Fishbone Local AI Map (to 3 Nov: firewall choice, answers, VM 101 card, deliveries) and **Fishbone Network Map** (from 19 Oct to 3 Nov: Vodafone WAN, ASA replacement, iLO .21, VM 101, R710 auto-backups down, BT Business kept (OI-24), Beverley Loxone/printer fixed IPs, Tailscale fallback, exposure closed 1 Nov).
