# Plan — Complete Outstanding Rack Jobs (HQ + Beverley)

> **Created 2026-10-17** (Minda's request: "a plan to complete all outstanding jobs on both racks").
> Guide-only (charter §3): Minda does every physical/console step on-site; Eugene writes the exact
> commands and verifies. No credential held. This is the single consolidated checklist pulled from
> `open-issues.md` (OI-13/14/17/19/20), the RND-2/RND-3 R&D work, and the HQ/Beverley change-logs.
> Nothing here is new scope — it's the backlog in one place, prioritised, with what each job needs.

## How to read it
Each job is tagged:
- **Where:** 🖥️ remote (over Tailscale) · 🔧 on-site HQ · 🏠 on-site Beverley
- **Needs:** a cable / a part to buy / just config
- **Priority:** **P1** completes redundancy or closes a real gap · **P2** tidy/correctness · **P3**
  parts-dependent build · **P4** cosmetic
- **Risk:** whether it can disrupt live service (so it wants a maintenance window)

A ⭐ marks the three you spotted at the rack.

---

## A. HQ — physical cabling (🔧 on-site, needs cables)

| # | Job | Needs | Prio | Risk / window |
|---|---|---|---|---|
| A1 ⭐ | **Reconnect the 3850 StackPower cables** (the two power interconnects you saw unplugged). Left disconnected on purpose during the Oct-1 recovery. Reconnecting gives the stack **shared PSU power redundancy**. | The 2 StackPower cables (already on the rack) | **P1** | ⚠️ Reconnecting triggers a **stack power resync** — do it in a quiet window; expect a brief blip. Switch-1's faulty StackWise *data* adapter (A2) is separate and doesn't block this. |
| A2 | **Replace/remove switch-1's faulty StackWise-480 adapter** (`SIF_MGR-1-FAULTY_CABLE`, Cisco bug CSCvj49423 — it floods the console and corrupted saves during recovery). Options: swap the C3850 stack adapter/cable, **or** upgrade IOS-XE to **16.3.6+ / 16.9.x** which masks the driver print. | A replacement StackWise adapter **or** an IOS upgrade window | **P2** | Adapter swap = power off switch 1 (stack loses redundancy briefly). Cosmetic to forwarding, but it makes future console work painful — worth clearing. |
| A3 ⭐ | **ASA stateful-failover link** — connect **Gi1/3 ↔ Gi1/3** between the two ASAs. The heartbeat/config link (Gi0/3) is already in; this extra cable makes failover **stateful** so live connections (incl. calls) survive a failover instead of dropping. OI-14(a). | 1 patch cable between the two ASAs | **P1** | Low — adding the link is non-disruptive; then one `failover link`/`failover interface` config line. |
| A4 ⭐ | **R710 (`pve-nas`) 2nd data cable → 3850 #2 `Gi2/0/44`** (already set to `access vlan 10` today) + build the **Proxmox active-backup bond** (bond `nic0`+`nic1`, move `vmbr0` onto it). Gives the backup server switch-level redundancy (survives losing either stack member). | 1 patch cable R710 NIC2 → Gi2/0/44 | **P1** | Low — active-backup bond, no LACP/switch port-channel needed; I'll give the `/etc/network/interfaces` bond stanza and we verify failover by pulling one cable. |
| A5 | **Connect the BT WAN (vlan 4)** — `Gi1/0/46` is `notconnect`. Currently FTTB (Wavenet) is primary + StarLink backup; wiring BT back adds a third WAN to the ASA SLA set. | BT NTE/modem patch into Gi1/0/46 | **P3** | Low — adds a path; ASA SLA already has BT at metric 10. Only matters for full WAN redundancy. |

---

## B. HQ — config / tidy (🖥️ remote over Tailscale)

| # | Job | Prio | Notes |
|---|---|---|---|
| B1 | **Rename the ASA `TMP_ASA_LINK` uplink ports → `ASA-1`** (cosmetic leftover from recovery). OI-14(b). | P4 | One-line interface descriptions on the active ASA. |
| B2 | **Controlled ASA failover test** in a maintenance window — prove the pair actually fails over cleanly (and, once A3 is in, that it's stateful). OI-14(c). | P2 | `failover active` on the standby → confirm internet/phones, fail back. We did this once for OI-8; worth a clean scheduled test. |
| B3 | **DHCP-reserve the DL380 iLO at `10.224.10.50`** — it's drifted on DHCP (`.78`→`.50`); pin it so iLO/IPMI stays put. RND-2 flag. | P2 | Reservation on whatever serves VLAN-10 DHCP (ASA). Also pin `pve-nas` .20 / iDRAC .21 are static ✓. |
| B4 | **Let the ASA web UI answer over Tailscale** — `http 10.224.10.10 255.255.255.255 <inside>` so you can manage the ASA remotely (currently times out from the TS source). | P2 | From the Tailscale remote-access follow-ups. |
| B5 | **Trim the dead `10.224.11.0/24` HQ route** advertised in Tailscale (leftover; HQ computers are on `.11` via the ASA, the /24 route to `.10.10` isn't needed). | P4 | Clean-up in the subnet-router `--advertise-routes`. |
| B6 | **NTP across HQ devices** — iLO clock showed 2001, the PBX clock reads ~2h behind (OI-19-adjacent), 3850 time. Point them all at an NTP server so log timestamps line up. | P3 | Cosmetic but helps every future diagnosis. |
| B7 | **Finish OI-19** — FusionPBX CDR stopped logging after the Oct-1 restore. Check `mod_xml_cdr` is loaded + CDR settings write to the DB (needs the PBX SSH we now hold). | P2 | Separate open issue, but it's an HQ-rack software job; folding it in for completeness. |

---

## C. HQ — DL380 GPU build (RND-2, 🔧 on-site, parts-dependent) — **P3**

The local-AI host upgrade. Gated on parts landing:
- **2× 1400 W PSU (720620-B21)** — ordered 2026-10-16 from Techbuyer (current 2× 500 W too small for dual P40).
- **GPU power cable** (2nd) — ordered 2026-10-16.
- **GPU baffle** — still to buy (airflow for passive P40s).
- **Pre-fit check:** confirm the **primary + secondary GPU riser slots are free** vs the P840 + 3 NICs (box is card-heavy) — iLO → Device Inventory, or physical.
- Then: fit 2× Tesla P40, enable "Above 4G Decoding", bring up the model stack (RND-2).

---

## D. HQ — RND-3 storage expansion (🔧 on-site, parts-dependent) — **P3**

The NAS is live now on the interim 2-disk mirror (`pve-nas`). To reach the full pool:
- **Reseat/replace DIMM B3** on the R710 (POST MEMBIST-disabled; 24 GB → full RAM once fixed). Not blocking.
- **Buy the SFF-8644 → QSFP (SFF-8436) cable** — Cablexa CAB-8644-QSFP-1M (UK stock scarce, 2–3 wk).
- **Buy the other 10× Seagate 900 GB** (have 2, pool wants 12) — ~£120 already-known pricing.
- Then: fit the CP400e cable to the **DS2246 IOM A**, confirm IT mode (`sas3flash -list`), **destroy the interim mirror → rebuild as 2× 6-wide RAIDZ2 ≈ 5.8 TB**, re-point PBS. (Mirror→RAIDZ2 is not in-place; trivial on a days-old backup pool.)

---

## E. Beverley — rack completion (🏠 on-site, OI-20 follow-ups)

All three core boxes (Proxmox, ASA, 3850) are **recovered + secured**. Remaining:

| # | Job | Prio | Notes |
|---|---|---|---|
| E1 | **Distinct per-box passwords** — one password was reused across boxes and was visible in recovery photos. Rotate to unique, store in 1Password. | **P1** (security) | Minda holds all creds; Eugene never records them. |
| E2 | **Fuller security sweep each box** — other users, cron jobs, reverse tunnels, sshd config. | **P1** (security) | Same pattern as the HQ contractor-lockout sweep. |
| E3 | **Stand the Beverley Proxmox up as the RND-3 off-site replica** (ties to the 3-2-1 goal, item G) — install PBS or set up `zfs send`/PBS-sync from HQ, so HQ's backups replicate to Beverley. | **P1** | The Beverley box is empty, ZFS `rpool` 115 G free, ideal. This is what makes the backup truly off-**site**, not just off-**host**. |
| E4 | **Replace the 3850's faulty StackWise adapter** (`SIF_MGR` — cosmetic on a single switch). | P4 | Same fault class as HQ A2. |
| E5 | **3850 flash 72% full** (`PLATFORM-4-ELEMENT_WARNING`) — free space (`request platform software package clean` / delete old images). | P3 | Non-urgent housekeeping. |
| E6 | **NTP on the 3850 + ASA** — clock reads 2019; fix so log timestamps are right. | P4 | Cosmetic. |
| E7 | **UniFi Cloud Key** — left as-is (WiFi APs only). Optionally adopt to `unifi.ui.com` for remote management. | P4 | Optional; never factory-reset. |
| E8 | **Full device-level inventory** of the Beverley rack (same depth as HQ) — exact server HW/OS, UPS coverage, what else runs there. | P2 | Feeds Infra-Inventory (Beverley section is light). |
| E9 | **Write `Runbooks/Runbook-Beverley-Place-Recovery.md`** from the now-proven recovery sequence. | P2 | Documentation owed (OI-20). |

---

## F. Inter-site radio link — airFiber (🔧 HQ mast + 🖥️ UI)

**Status: understood + under our control, but unmonitored; one open alignment check.**
- **F1 — Verify live health now.** Log into the airFiber UI (you hold the login). Check: link uptime, RF
  signal/capacity, errors. If its mgmt IP is on an HQ subnet we advertise over Tailscale, I can walk the
  readout with you remotely. **P2.**
- **F2 — Antenna-alignment check** (flagged 2026-09-17: signal below "ideal power"). Improves throughput
  margin + weather resilience. Needs someone at the mast. **P3.**
- **F3 — Confirm the IPsec VPN failover actually carries traffic** if the radio drops (phones/replication
  should survive). Worth a deliberate test. **P2.**
- **F4 — Add it to monitoring** once the estate has a monitor (ties to the silent-failure alarm idea
  RND-6). **P3.**
- **F5 — Record the airFiber mgmt IPs** in Infra-Inventory (we don't have them written down). **P2.**

---

## G. Cross-site goal this all serves — 3-2-1 backup

The pieces above combine into the estate's **3-2-1**: production VMs at HQ (copy 1) → nightly to `pve-nas`
PBS at HQ (copy 2, done ✓) → **replicated to the Beverley Proxmox over the airFiber/VPN** (copy 3,
off-site — item E3). Completing E3 + F (a healthy, verified inter-site link) is what turns tonight's
off-host backup into a true off-**site** disaster copy.

---

## Suggested sequence

1. **Next remote session (now-ish, over Tailscale):** B1–B5, B7, F1, F5 — all config, no travel, low risk.
2. **Next HQ visit (bring: 2 patch cables):** A3 (ASA stateful), A4 (R710 bond cable) — both low-risk,
   complete two redundancy gaps in one trip. Then A1 (StackPower) + B2 (failover test) in a **booked
   quiet window** (brief blips).
3. **Next Beverley visit:** E1, E2, E8, then E3 (off-site replica) — the security + off-site-copy work.
4. **When parts land:** C (GPU), D (storage expansion), A5 (BT WAN), A2/E4 (StackWise adapters).
5. **Opportunistic:** B6/E5/E6/E7 (cosmetic/housekeeping), F2 (mast alignment).

## §3 / safety
Guide-only throughout; Minda executes every physical/console step and holds every credential. Items that
can blip live service (A1 StackPower, A2 adapter, B2 failover test, D pool rebuild) are flagged for a
booked window. Nothing here changes a live system without Minda at the keyboard.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
