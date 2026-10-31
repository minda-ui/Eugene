# Change log — 2026-10-31 (Sat, at HQ) — Gen9 BIOS NVRAM recovery + dead CR2032, and the P40 power root-cause narrowed to the board→riser feed

_Minda hands-on at HQ (Gen9 console + lid off); Eugene guided + verified, held no credential (§3). Phones free all weekend — no window pressure. Session ended with **"Log today's work and restart session"** so the `*.hp.com` network allow takes effect in a fresh session and we finish the P40 cabling with HPE's own diagram._

## 1. Gen9 BIOS NVRAM corruption + dead RTC battery — FOUND and RECOVERED (new OI-32)

Minda powered the Gen9 down to re-check the P40 cables; on the next boot the **System Health** screen showed:

> **266 — Non-Volatile Memory Corruption Detected. Configuration settings restored to defaults.** (Health Status: Configuration Required.)

Diagnosis (decisive): in RBSU the **system clock read 2001** — i.e. the **CR2032 coin cell on the system board is flat**. A dead RTC battery is the classic cause of "NVRAM corruption / settings reset to defaults" on a ~2015 Gen9, and it means **settings don't persist across a full power-off** until the cell is replaced. (It also explains the long-standing "iLO clock shows 2001" note in the inventory.)

**Recovery (guide-only; Minda at the keyboard):**
1. RBSU → **Date and Time** → set to the correct time (UK is on **GMT** now = UTC, so local == UTC today).
2. Restored the config that had been wiped to defaults and **F10-saved**:
   - **Boot Mode = UEFI** (critical — a flip to Legacy would stop Proxmox booting).
   - **Max Cooling** (for the passive P40s), **VT-x + VT-d** enabled.
   - Left **Secure Boot disabled** (Proxmox runs without it; the "may be lost" line is harmless here).
3. Confirmed we were in the right menus only — the **Advanced System ROM Options** screen (NMI Debug/PCI Bus Padding/CDN "LOMs Only"/Mixed-PSU-reporting/ECRC) all stay at defaults; nothing there needed changing. Also read off **Serial `CZJ64905NP`, Product ID `843556-425`** (DL380 Gen9, already on file).

**Result — box came back clean and the estate is healthy:**
- `timedatectl` → `2026-10-31 … GMT/UTC`, **`System clock synchronized: yes`, `NTP service: active`** (NTP corrects it while powered; it only falls back to 2001 on the next full power-off, until the cell is swapped).
- `zpool status -x` → **`all pools are healthy`** (`rpool` + `tank`, no casualties from the power-cycling).
- `qm list` → **PBX (105) running** + FW (101), public-proxy (102), ssh-gateway (104) running; `test` (100), `tftp` (103), `Docuseal` (106) stopped (stopped-state to confirm against `onboot`, not a fault). Phones back.

**Fix outstanding (OI-32):** replace the **CR2032** on the system board (it's right by the silk-screened **`SYSTEM BATTERY`**, easy to reach). Until then every full power-off resets the clock (and can re-trip the NVRAM). If config **re-corrupts after** a fresh battery + a power-cycle → that's a deeper NVRAM/firmware issue (BIOS reflash / HPE), not just the cell.

## 2. P40 aux power — root cause narrowed to the board→riser feed (OI-30 updated; do NOT trial-plug)

`nvidia-smi` still reports both P40s *"does not have the necessary power cables connected"* (`0x24:0x1c:1447`), identical to Friday. Worked it to ground with photos:

**Ruled OUT (all cleared today):**
- **Cards** — both **enumerate** in `lspci` → slot power (75 W) fine, cards alive; **driver** 535.309 in use.
- **PSUs** — **2× 1400 W fitted** (confirmed on the labels) → ample; power isn't being withheld for capacity.
- **BIOS** — there is **no RBSU setting that gates riser 12 V**; config restored anyway (section 1).
- **IML** — **nothing logged** (no EFUSE/P12V/power-on fault) → the board never saw a draw or a fault on the aux rail.
- **GPU-end cable** — the **`805123-001` (10-pin → 8-pin EPS)** is the **correct** cable for the P40 (EPS 8-pin), and is **seated at both ends** (riser 10-pin + P40 8-pin), on **both** cards, which are on **two different risers**.

**What the photos established:**
- Riser = **DL380 Gen9 Secondary 3-slot GPU-ready riser `777283-001` / `729810-001`** (Slots 4/5 x16 + Slot 6 x8). It has **exactly one power connector** (the white 10-pin the `805123-001` plugs into); **the back of the riser is bare** — no second/input connector on the card face.
- Therefore the riser's GPU power must **originate at the system board** — the PCIe slot alone can't carry the P40's ~175 W aux. HPE-cable listings describe `805123-001` as sourcing *"from the internal board's 10-pin connector,"* and a Gen9 forum case needed a **separate feed to the riser's power port** (`669777-B21`).
- Checked a board connector Minda pointed at — it was the **front storage I/O area** (`PORT1`/`PORT2` = mini-SAS drive **data**; `763989-001` SAS cable; a drive-cage **power** cable) — **not** GPU power. A GPU-power header, if the board has a discrete one, is at the **rear by the secondary-riser slot**, not the front.

**Conclusion (high confidence):** the **board→riser GPU-power feed is not established** — right now the `805123-001` runs riser↔GPU only, leaving the system board (the real source) out of the loop. Either that 10-pin belongs on a **board** header, or a **board→riser feed cable** is missing.

**⚠️ Safety call:** did **not** let Minda trial-plug any power connector — the Gen9 has other 10-pin headers (e.g. backplane power `776386-001`) and forcing a GPU cable onto the wrong one can damage the board/card. **Confirm against HPE's "Installing a GPU device" diagram first.**

**Blocked this session:** every HPE/HP service-guide host (`support.hpe.com`, `theserverstore.com`, `manualslib.com`, `getprice.pl`, `h10032.www1.hp.com`) is **refused by this session's network** (WebSearch works, full-PDF WebFetch doesn't). Minda allowed `*.hp.com` / `support.hpe.com`, but the change **doesn't apply to an already-running session** → hence the restart.

**Next (fresh session):** pull HPE's DL380 Gen9 "Installing a GPU device" cabling figure → name the exact source connector → confirm whether it's a mis-route of the `805123-001` or a missing board→riser feed cable → if a part's needed, **draft a Techbuyer order** (Liam/Garrick, DL380 Gen9 S/N `CZJ64905NP`, order SO483746). Model stack still also gated on the **GPU baffle**.

## 3. Facts captured for the inventory
- **PSUs: 2× 1400 W, FITTED** (was "on order").
- **Secondary GPU riser = `777283-001` / `729810-001`** (single 10-pin power connector; Slots 4/5 x16 + 6 x8); both P40s on separate risers (so the old "confirm riser slots free" follow-up is resolved).
- **System battery = CR2032 on the board, flat** (OI-32); `SYSTEM BATTERY` silk by the FPGA.
- Serial `CZJ64905NP`, Product ID `843556-425` re-confirmed from RBSU.

## 4. State
- **Gen9 is up and healthy** — time synced, pools healthy, PBX + core VMs running, phones working. BIOS config restored.
- **Outstanding at HQ:** CR2032 swap (OI-32); the P40 board→riser feed (OI-30, needs the HPE diagram next session); GPU baffle; iLO password (OI-31); pve-nas cable to `Gi1/0/44` (OI-27).
