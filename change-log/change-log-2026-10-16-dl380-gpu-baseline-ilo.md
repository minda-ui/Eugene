# Change log — 2026-10-16 — RND-2 DL380 GPU upgrade: parts status + host baseline (iLO/IPMI)

_Guide-only / §3. Minda at HQ, Eugene guiding. No secret held, no reboot, no live change. Branch
`claude/lucid-mayer-nsoili`._

## Context
Minda asked for the outstanding server-parts specs for the RND-2 GPU upgrade (DL380 Gen9, 2× Tesla P40),
then checked minda@ for a parts update, then read the live host over iLO/IPMI while stood at the box.

## Parts status (from minda@ Gmail + Minda)
- GPU side complete: **2× P40** (Bytestock #000006986), **both risers** (719073-B21 + 719076-B21), **1st
  power cable** — all ordered 10 Oct.
- **2nd GPU power cable** (eMagTech 8-pin) — **ordered 2026-10-16** (Amazon).
- **2× 1400 W PSU (720620-B21)** — **ordered from Techbuyer 2026-10-16**, awaiting confirmation email.
- Techbuyer had **not replied** to the 8-Oct quote request; Minda ordered the PSUs anyway.
- **Still to buy:** GPU baffle/shroud; high-perf fan kit (`747598-001`) **only if** the fitted fans are
  standard (unconfirmed).

## Host baseline — read non-intrusively via ipmitool (no reboot, no secret)
Box = HQ Proxmox host `pve` @ `10.224.10.10`. `ipmitool fru print` + `ipmitool sdr`:
- **DL380 Gen9 `CZJ64905NP`**, board **843556-425**, **BIOS P89 08/29/2024** ("Above 4G Decoding" present
  for the P40), **2× Xeon E5-2695 v4** (CPU2 populated ✅), **128 GB** = 4× 32 GB `809083-091` (DIMM 9 & 12
  per CPU; **10 slots free**).
- **PSUs** 2× present → **Fully Redundant**, ~140 W idle (rated 500 W per the 11-Oct physical check; IPMI
  FRU doesn't expose PSU wattage here). → 1400 W pair on order.
- **Fans** 6× present → **Fully Redundant**, cool (CPUs 40 °C, inlet 21 °C). Kit type unconfirmed.
- **Smart Array P840** (`761880-001`) — corrects an earlier "P440ar" note.
- **NICs:** 562SFP+ 10 Gb (`727055-B21`), 366FLR 1 Gb (`665240-B21`), 331T 1 Gb (`649871-001`), embedded
  331i; Smart Storage Battery (`875242-B21`).

## Findings / corrections
- **iLO address corrected: `10.224.10.50`** (read from the BMC via `ipmitool lan print 2`; MAC
  `94:18:82:02:ac:02`). Was recorded `.78` on 2026-10-01 — it's on **DHCP and the lease drifted**. →
  **set a DHCP reservation.** iLO web password was set 2026-10-01 and is in Minda's 1Password (answered
  her "I don't remember the iLO password").
- ⚠️ **Pre-GPU-fit check:** the box is card-heavy (P840 + 3 add-in NICs). Two P40s are double-wide and
  need the **primary + secondary GPU-riser slots** — confirm those are free before the cards arrive; a
  spare NIC may need to move (more 1 GbE ports than needed).

## Recorded in
`Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md` (new "Server hardware baseline — 2026-10-16"
block + iLO address correction) · `R&D/local-models/parts-list.md` (orders + baseline) · ledger 117.

## Open follow-ups
(1) DHCP-reserve iLO `.50`; (2) confirm fan-kit type (read a fan label / IML after fit); (3) buy GPU
baffle (+ high-perf fans if standard); (4) confirm GPU-riser slot availability; (5) fix iLO NTP (clock
showed 2001).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
