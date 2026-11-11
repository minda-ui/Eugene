---
name: asa5525x-to-opnsense
description: Convert a Cisco ASA 5525-X into an OPNsense firewall end to end — DIY VGA cable on header J9, AMI BIOS (ROMMON Boot off, SSD in AHCI, USB then HDD boot order), SSD wipe when the installer hides ada0, ZFS install on the SSD only (never the eUSB), root password at install, port map em0-em8 by MAC, safe bench access, firmware update, Dnsmasq-vs-Kea DHCP clash, HA pair sync and Kea HA ports, ALARM LED, encrypted backup. Use whenever Minda says "convert/reflash an ASA to OPNsense", "install OPNsense on unit N", "ASA 5525-X BIOS", "VGA cable for the ASA", "which em port is Gi0/x", or is benching the spare unit or a future ASA. Guide-only (charter §3): Eugene writes the steps and reads console output; Minda does every hands-on step and holds every password in 1Password — Eugene never asks for, sees or writes one. Built 2026-11-11 from units 3, 2 and 1.
---

# Cisco ASA 5525-X → OPNsense (bench to HA pair)

Three units done so far: **unit 3 → `bev-fw`** (6 Nov), **unit 2 → `hq-fw-a`** and **unit 1 → `hq-fw-b`**
(10 Nov). Unit 4 is the spare. The full reference — with every console line we saw — is
`Runbooks/Runbook-OPNsense-Install-ASA5525X.md`; HQ/Beverley build detail is in
`Runbooks/Plan-OPNsense-HQ-Translation-AWT-1069b.md` and `Runbooks/Plan-OPNsense-Beverley-Translation-AWT-1069c.md`.
Log each new unit there (per-unit status table + an install-log section), not only in chat.

**Guide-only (§3):** Minda cables, presses keys, types every password, plugs anything into a live network.
Eugene gives the next step, reads her console paste/photo, and says what it means. Passwords: generated in
**1Password first**, typed by Minda, never in chat or git. Only **public vendor factory defaults** may be
named (installer login `installer` / `opnsense`).

## Stage 0 — Cisco image backup (optional, usually skip)
The ASA image (`asa982-20-smp-k8.bin`, ASDM `asdm-791.bin`) lives on the ~8 GB internal **eUSB (`da1`)**,
which OPNsense never touches — so the box can always go back to Cisco. A USB copy already exists
(unit 2's stick, 9.8(2)20). Only if wanted: `enable` → `dir disk1:` → `copy disk0:/asa982-20-smp-k8.bin disk1:/`.
The **licence activation key** (`show version`) goes only into Minda's 1Password. Previous-owner config files
on disk0 are wiped before any resale, never copied.

## Stage 1 — VGA console for the BIOS (the serial console can't reach setup)
F2/Del over PuTTY (any keyboard mode) never opens the BIOS. Use the internal **VGA header J9** ("VGA CONN",
2×8, 2.54 mm, next to the unpopulated J1 JTAG header) + a USB keyboard. No ready-made cable: build one from
6 female-to-male Dupont jumpers + a **VGA DB15 female screw-terminal breakout** (or a cut VGA cable).
**Wire by position**, board held with "VGA CONN" readable below the header. The empty position is
**bottom-left (silk 1)**; the community Axon07 guide numbers the opposite way (its pin N = silk 17−N).

| VGA signal → breakout terminal | Header position | Board silk |
|---|---|---|
| Red → 1 | top row, 1st from right | 16 |
| Green → 2 | bottom row, 1st from right | 15 |
| Blue → 3 | top row, 2nd from right | 14 |
| Ground → 10 | bottom row, 5th from right | 7 |
| H-sync → 13 | top row, 2nd from left | 4 |
| V-sync → 14 | bottom row, 2nd from left | 3 |

Check: the ground pin beeps to chassis on a meter. Cut-cable colours aren't standard — no picture → swap the
two sync wires. Keep the same cable for every unit.

## Stage 2 — BIOS (AMI Aptio, **F2**, no password)
1. **Boot tab:** **ROMMON Boot → Disabled** (space bar), Quiet Boot Disabled, Setup Prompt Timeout 1.
2. **Advanced → SATA Configuration:** Port0 = **Micron_M550_MT (128 GB)** (the ASA5500X-SSD120), mode **AHCI**.
   Not listed → reseat the SSD before going further.
3. **Boot order:** 1st **USB stick** (installer), 2nd **HDD** (Micron SSD), eUSB last. After install: HDD first.
4. Save = **F4**.
Until ROMMON Boot is off, a fitted SSD is dangerous: the Cisco image may offer to build a RAID on it —
press **Esc** at ROMMON / power off.

## Stage 3 — Installer stick and the hidden-ada0 trap
- Stick = OPNsense **26.7 serial amd64** image, **checksum + signature verified** (runbook §2) and written with
  Rufus (DD mode)/Etcher. **Never pre-write the image onto the SSD.**
- Boot the stick → live mode. Console is **115200** once OPNsense loads (ASA BIOS/ROMMON are 9600).
- Login: **`installer` / `opnsense`** (public factory default; not `root`).
- **If the installer offers only da0 (stick) + da1 (eUSB) and no ada0**, the SSD already holds an install
  image (units 3 and 1). Confirm from the shell: `glabel status | grep -i opnsense` → shows **ada0p4**. Fix:
  1. Power off, slide the SSD out. 2. Boot the stick. 3. Push the SSD back in.
  4. `camcontrol rescan all` 5. `gpart destroy -F ada0`
  6. `dd if=/dev/zero of=/dev/ada0 bs=1m count=10` 7. Re-run the installer.

## Stage 4 — Install
1. **Install (ZFS)** → **stripe** → tick **ada0 (Micron M550, ~119 GB) only**. Never `da1` "USB DISK MODULE"
   (~7 GB Cisco eUSB), never `da0` (the stick). (UFS/GPT on unit 3 is fine too; 1 and 2 are ZFS for boot
   environments.)
2. **Set the root password in the installer** — Minda generates it in 1Password first (item per box, e.g.
   "hq-fw-b") and types it. Unit 2 skipped this → came up with the factory-default root and had to be fixed
   with `passwd` at once. Don't repeat.
3. Finish, stick out, BIOS 1st Boot = HDD. Boots from `zroot/ROOT/default` (ZFS) or `/dev/gpt/rootfs` (UFS).

## Stage 5 — Port map (confirm by MAC every time)
FreeBSD numbers the Intel 82574L ports by PCI bus, same order on all three units so far:

| OPNsense | Cisco label | MAC offset (base = Mgmt MAC) |
|---|---|---|
| em0 | Gi0/6 | +8 |
| em1 | Gi0/4 | +7 |
| em2 | **Gi0/2** (HA SYNC cable) | +6 |
| em3 | **Gi0/0** | +5 |
| em4 | Gi0/7 | +4 |
| em5 | Gi0/5 | +3 |
| em6 | Gi0/3 | +2 |
| em7 | **Gi0/1** | +1 |
| em8 | **Management** | base |

Have Minda paste `ifconfig | grep -E '^em|ether'`; Eugene maps it and she labels the box. Record the MACs
in the runbook's per-unit table.

## Stage 6 — Bench access without locking yourself out
- Factory LAN is **192.168.1.1/24 + DHCP server** — **no network cable in** until it's changed (it clashes
  with the Starlink 192.168.1.x and would hand out addresses on the office LAN).
- **Console menu option numbers follow the interface list, which is alphabetical** — after assignments the
  OOB interface was option **5**, not 1. Read the menu before typing a number.
- Options that worked:
  - **Static em8 on the office net** (best): e.g. 10.224.11.245 / .246 /24 (outside the ASA DHCP pool
    .50–.240), gw 10.224.11.1, no DHCP server — set from the console *before* plugging the cable in.
  - Isolated: em8 = 192.168.99.1/24 + laptop direct on the Management port.
  - Remote: Minda's PC reaches the office net **via Tailscale → PVE1 (10.224.10.10)**, so admin traffic is
    sourced from **10.224.10.10**; ICMP on that path doesn't answer, HTTPS does.
- **10 Nov lockout rule:** the bench box must hold **no address in any subnet the admin traffic comes from**.
  hq-fw-a was given MGMT 10.224.10.252/24 on an unplugged VLAN → replies to 10.224.10.10 went out that
  connected route and vanished. Fix: MGMT IPv4 none until go-live; console option-2 changes may need a reboot
  to go live.
- Before giving a box an address in a VLAN that is bridged between sites, check **every SVI in that VLAN at
  both sites** (hq-fw-a .252 duplicated Beverley home-sw SVIs, 11 Nov).

## Stage 7 — First config
- Wizard blocks on the WAN page with no WAN → click the logo to skip; set **System → Settings → General**:
  hostname (`hq-fw-a` / `hq-fw-b` / `bev-fw` / next), domain `fishbone.local`, Europe/London, DNS 1.0.0.1 +
  8.8.8.8 (one per line).
- **Firmware → Update** to the latest 26.7.x (26.7.8_2 on 10 Nov). Temporary WAN for updates if needed:
  em3 (Gi0/0) DHCP on an office socket. **"Partial update failure" mid-fetch (nothing installed) → just
  re-run**; it succeeded the second time on unit 1. 26.7.8 regenerates SSH host keys (fingerprints change).
- All units on the **same version** before HA pairing.

## Stage 8 — DHCP (Kea) — two silent traps
- **Disable Dnsmasq** wherever Kea serves DHCP. Even bound to one interface, Dnsmasq holds UDP 67 on all of
  them → Kea log `DHCPSRV_OPEN_SOCKET_FAIL … port 67 … Address already in use` → clients "couldn't get IP"
  (bev-fw go-live, 10 Nov).
- Kea needs its **Interfaces** list ticked (Services → Kea → Settings) — with none selected it doesn't serve
  and says nothing. Subnets as network addresses (10.224.13.0/24, not .252/24).

## Stage 9 — HA pair (HQ pattern)
- Same interface identifiers on both (opt1…optN in the same order) or sync breaks.
- **SYNC** = em2 (Gi0/2) box-to-box cable, 10.99.250.1/30 ↔ .2/30, pass-any "HA Sync" rule on both.
- Primary: pfsync on SYNC, peer .2, Synchronize Config to .2 with b's root creds (typed by Minda). Sync only
  what's needed (Aliases, Firewall Rules, Virtual IPs, Kea DHCP). **Never sync Users and Groups or Web GUI**
  (overwrites b's root password). Backup box: peer .1, no config target. **"Synchronize and reconfigure all"
  (↻)** is what actually pushes. Check the address bar — the HA page was once filled on the wrong box.
- **Kea HA:** Control Agent on **8000**; HA peer URLs on a **different port (8001)** — same port → Kea red on
  both (start-up clash, `kea-dhcp4 -t` still passes).
- CARP password → 1Password. Gateways not in the 26.7 sync list → create by hand on b.

## Stage 10 — Finish
- **Front ALARM LED amber** with a healthy box (fans OK; temps via `kldload coretemp; sysctl dev.cpu | grep temperature`)
  → **cold power cycle**: power off, cord out 30 s (BMC stays on standby). Watch for recurrence.
- **Encrypted config backup** (System → Configuration → Backups, with encryption) → Minda stores it in
  1Password. Never in git or chat; Eugene reviews redacted diffs only.
- Update the runbook per-unit table; ledger row + change-log.

## Traps table
| Symptom | Cause | Fix |
|---|---|---|
| F2 does nothing over serial | BIOS setup is VGA-only | DIY VGA cable on J9 + USB keyboard |
| Black screen on VGA | Sync wires swapped / wrong pin | Swap H/V sync; re-check by position, not Axon07 numbers |
| ASA still boots Cisco / offers RAID on SSD | ROMMON Boot still enabled | BIOS → Boot → ROMMON Boot Disabled |
| Installer lists no ada0 | SSD holds an install image (ada0p4 label) | SSD out → boot stick → SSD in → rescan, gpart destroy, dd |
| "table 'ada0' is corrupt" / "Device busy" | Image pre-written to SSD | Same wipe; never pre-write the SSD |
| Root login works with factory default | Root password not set in installer | `passwd` now; set it in the installer next time |
| Garbage on console | Speed mismatch | 115200 for OPNsense, 9600 for BIOS/ROMMON |
| Typed menu "1" changed the wrong interface | Menu is alphabetical | Read the list (OOB was 5) |
| GUI dead after assigning VLAN IPs | Box owns an IP in the admin source subnet | Remove that IP; static OOB outside it; reboot |
| Firmware "Partial update failure" | Mirror fetch dropped | Re-run the update |
| DHCP clients get no address | Dnsmasq holds port 67 / Kea has no Interfaces | Disable Dnsmasq; tick Kea interfaces |
| Kea red on both HA boxes | Peer URL on Control Agent port | Peers 8001, agent 8000 |
| b's root password changed after sync | Users/Web GUI synced | Untick them; rotate b's password in 1Password |
| Amber ALARM LED, box fine | Stale latched alarm | Cold power cycle, cord out 30 s |

## Guardrails (always)
- **Guide-only (§3):** Minda does every hands-on and live-network step; Eugene writes, reads output, verifies.
- **Never touch da1 (eUSB)** — it's the way back to Cisco.
- **No passwords in chat, git or this file** — 1Password only; name the item, never the value. Factory
  defaults (`installer`/`opnsense`) are public and may be named.
- No cable into a live network until the box's addresses can't clash with it.
