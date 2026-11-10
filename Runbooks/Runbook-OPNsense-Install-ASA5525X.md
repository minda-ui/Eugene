# Runbook — Install OPNsense on a Cisco ASA 5525-X (bench, before any live network)

**Hub:** AWT-1069 part (a). **Version:** v0.3, 2026-11-05 (Management port = admin; ROMMON/BIOS findings; VGA route) (extends the Drive v0.1 bench runbook, id 1H6hbUSpkwQD8MG8wr9VHJPjDP1EzVxcO).
**Guide-only (charter §3):** Minda downloads, verifies, cables, installs and holds every password (1Password). Eugene writes, reads console output, verifies.
**Status of the hardware (3 Nov):** 2 of 4 units in hand. Unit 2 (V04, FCH19267THV) bench-checked OK: X3430 4-core, 8 GB, POST pass, ROMMON 2.1(9)8, ASA 9.8(2)20, no config. Unit 1 (V03, FCH18187KX2) not yet booted. Unit 3 (V02, FCH1802J4Y9) arrived 3 Nov, **assigned to Beverley (`bev-fw`)**, not yet booted. Roles: units 1 + 2 = HQ pair, unit 3 = Beverley, unit 4 = spare. SSDs (Cisco ASA5500X-SSD120) ordered, due 4–5 Nov.

---

## 0. Before anything: keep the Cisco software (5 min per unit)
So each box can always go back to being a Cisco ASA (or be resold with its VPN Premium licence).
1. FAT32 USB stick in the front/rear USB port. On the ASA:
   ```
   enable
   dir disk1:
   copy disk0:/asa982-20-smp-k8.bin disk1:/
   ```
2. Also copy anything else listed by `dir disk0:` that ends in `.bin` or `.pkg` (e.g. ASDM `asdm-*.bin`).
3. Label the stick "ASA 5525-X images 9.8(2)20". Keep it in the IT box.
4. **Do not** record the licence activation key anywhere except Minda's 1Password (it is shown by `show version`).


### Unit 2 ROMMON findings (2026-11-05)
- Cisco images backed up to USB (`asa982-20-smp-k8.bin` 108877824 B, `asdm-791.bin` 29197944 B, verified by size). disk0 also holds `oldconfig_2018Nov29_1400.cfg` (previous owner's config — not copied; wipe before any resale).
- BIOS screen (9B2C109A) shows **no setup / boot-menu key**; ROMMON `dev` lists only network ports (no storage). → **Use the fallback: write the image to the SSD with a USB-to-SATA adapter** (ordered).
- `dev` PCI bus per port → expected OPNsense `em` order (FreeBSD numbers em by PCI bus; **confirm by MAC at first boot**):

  | Cisco port | PCI bus | expected OPNsense |
  |---|---|---|
  | Gi0/6 | 3 | em0 |
  | Gi0/4 | 4 | em1 |
  | Gi0/2 | 5 | em2 |
  | Gi0/0 | 6 | em3 |
  | Gi0/7 | 7 | em4 |
  | Gi0/5 | 8 | em5 |
  | Gi0/3 | 9 | em6 |
  | Gi0/1 | 10 | em7 |
  | Management0/0 | 18 | em8 |
- **SSD written on a desktop PC (balenaEtcher) and fitted; ASA still booted Cisco from internal flash and warned it may build a RAID on the SSD → powered off at once.** Lesson: with the SSD fitted, always press **Esc** at ROMMON until the boot order is changed.
- **BIOS setup NOT reachable over the console:** F2 (and Del) tried with PuTTY keyboard modes SCO, VT100+, Xterm R6 - no menu. Community reports (Hackaday homelab, Cisco Community) used the **internal VGA pin header** + USB keyboard: F2 → boot order SSD first, **disable ROMMON boot**. → Lid-off photo (5 Nov, board PCBA 800-36786-02): **VGA CONN = populated 2×8 (16-pin, 2.54 mm) header** next to the unpopulated J1 iBMC/JTAG 2×10. Cable: **"IDC 16-pin to VGA" motherboard bracket cable** (~£5–10); check the community pinout (github.com/Axon07/Cisco-ASA-VGA-Pinout) matches before powering on. BIOS (USB keyboard, F2/Del): **BOOT → "ROMMON Boot" → Disabled** (space bar), SSD first, save. Do all 4 units in one session.
- **DIY cable (no ready-made cable found, 5 Nov):** community pinout (Axon07) - header pin → VGA DB15 pin, same numbers: **1 red, 2 green, 3 blue, 10 sync ground, 13 H-sync, 14 V-sync**; 4–9, 11, 12, 15 not connected; **pin 16 absent (gap = orientation mark)**. Parts: 6× female-to-male Dupont jumpers + a **VGA DB15 female screw-terminal breakout**; the monitor's normal VGA cable plugs into the breakout. Board silkscreen shows 15/16 at the right-hand end - confirm against the missing pin before wiring.
- **Checked 2026-11-06 (unit 2, header J9):** silkscreen 2 top-left, 16 top-right, 15 bottom-right; **the empty position is bottom-left (silk 1)**. The community guide numbers the *opposite* way (its pin 1 top-right, its missing pin 16) → its pin N = board silk (17−N). **Wire by position** (board held with "VGA CONN" readable below the header):

  | VGA signal → breakout terminal | Header position | Board silk |
  |---|---|---|
  | Red → 1 | top row, 1st from right | 16 |
  | Green → 2 | bottom row, 1st from right | 15 |
  | Blue → 3 | top row, 2nd from right | 14 |
  | Ground → 10 | bottom row, 5th from right | 7 |
  | H-sync → 13 | top row, 2nd from left | 4 |
  | V-sync → 14 | bottom row, 2nd from left | 3 |
  Optional check: the ground pin should beep to the chassis on a multimeter.
- **WORKED 2026-11-06 (UNIT 3, not unit 2 — corrected):** wired with a cut VGA cable (colours not standard - verify with a meter or swap the two sync wires if no picture). BIOS = **AMI Aptio, entered with F2**, no password. **Boot tab:** Quiet Boot Disabled, Setup Prompt Timeout 1, **ROMMON Boot → Disabled** (set by Minda), default order 1st eUSB-HDD (Cisco internal flash) / 2nd USB-HDD / 3rd HDD / 4th Network IBA GE / 5th USB-ODD. **Advanced → SATA Configuration:** Port0 = **Micron_M550_MT (128.0GB)** (the ASA5500X-SSD120), Port1 not present, **SATA mode AHCI**. Set 1st Boot = HDD, 2nd = eUSB-HDD; save = **F4**.
- **First OPNsense boot (2026-11-06, live mode from SSD):** OPNsense 26.7 amd64 runs; defaults LAN em0 192.168.1.1/24 (+DHCP) - **clashes with HQ Starlink 192.168.1.x → no network cables until reassigned**. `ifconfig` MACs **88:5a:92:87:ed:af…b7** - *not* unit 2's 188b.9d72.a28f… → **confirmed by Minda: this is UNIT 3** (V02, Lic FCH1802J4Y9, chassis FGL1804407Y, → Beverley `bev-fw`). Port map **confirmed** (same MAC offsets as unit 2's `show version` + PCI-bus prediction):

  | OPNsense | MAC (this unit) | Cisco label |
  |---|---|---|
  | em0 | …ed:b7 | Gi0/6 |
  | em1 | …ed:b6 | Gi0/4 |
  | em2 | …ed:b5 | Gi0/2 |
  | em3 | …ed:b4 | Gi0/0 |
  | em4 | …ed:b3 | Gi0/7 |
  | em5 | …ed:b2 | Gi0/5 |
  | em6 | …ed:b1 | Gi0/3 |
  | em7 | …ed:b0 | Gi0/1 |
  | em8 | …ed:af | **Management** |
- Live image cannot install onto its own disk → install from a USB stick onto the SSD (ada0); never the ~8 GB eUSB.
- All ports Intel 82574L (`em` driver). Board also has an ASPEED VGA chip (no external port) and the Cavium crypto card (unused by OPNsense).

## 1. Download (Minda's PC)
- Current stable: **OPNsense 26.7** (released 15 Jul 2026). Use the newest 26.7.x installer offered on the download page.
- Page: https://opnsense.org/download/ → Architecture **amd64** → Image type **serial** (the ASA has no screen, only the console port) → mirror in the UK (e.g. mirrorservice.org).
- Download **four** files into one folder:
  1. `OPNsense-26.7-serial-amd64.img.bz2` (the image)
  2. `OPNsense-26.7-checksums-amd64.sha256` (checksums)
  3. `OPNsense-26.7-serial-amd64.img.bz2.sig` (signature)
  4. `OPNsense-26.7.pub` (OPNsense public key)
  (Exact names may carry a point-release number, e.g. `26.7.x` — keep them as downloaded.)

## 2. Verify — never install an unverified image
In **Git Bash** (comes with Git for Windows; has `openssl` and `sha256sum`), in the download folder:
```
sha256sum OPNsense-26.7-serial-amd64.img.bz2
```
- Compare with the line for the same file in the `.sha256` file **and** with the checksum in the official 26.7 release announcement (opnsense.org blog / forum). All three must match.
```
openssl base64 -d -in OPNsense-26.7-serial-amd64.img.bz2.sig -out image.sig
```
```
openssl dgst -sha256 -verify OPNsense-26.7.pub -signature image.sig OPNsense-26.7-serial-amd64.img.bz2
```
- Must print **`Verified OK`**. Anything else → stop, re-download from another mirror, tell Eugene.
- Send Eugene a photo/paste of both outputs (no secrets in them).

## 3. Write the installer
- Unpack the `.bz2` with 7-Zip → `OPNsense-26.7-serial-amd64.img`.
- Write it to a **separate** USB stick (not the Cisco backup stick) with **Rufus** (choose "DD image mode" if asked) or **balenaEtcher**.

## 4. Fit the SSD (when the ASA5500X-SSD120 arrives)
- Power off and unplug. Pull the blank filler from the front drive bay; slide the SSD in until it clicks.
- Power on and watch the boot text: the BIOS/POST lines should now list the extra SATA disk.

## 5. Boot the installer — the one bench unknown
The ASA's normal path is BIOS → ROMMON → Cisco image on the internal flash. To boot OPNsense we need the BIOS to start from USB (or later from the SSD).
- **First, the ROMMON check** (still open on unit 2): power on, press **Esc** at "Use BREAK or ESC", then type `dev` and send Eugene the list. It shows which devices ROMMON can see.
- **Then the BIOS:** on power-up, watch for a "Press … to enter setup / boot menu" line in the first seconds (before "Booting system, please wait"). Send Eugene a photo of the first screen — he will tell you which key to press (it differs by BIOS build; do not guess).
- In the BIOS boot menu choose the USB stick (installer) once. After installing, set the **SSD as first boot device** so the internal flash (Cisco) is never touched.
- **Fallback if the BIOS cannot boot USB:** write the same `.img` straight onto the SSD from the PC with a USB-to-SATA adapter (Rufus/Etcher, same as step 3), then fit the SSD and set it as first boot device. The image is a live system that can install onto itself.

## 6. Console speed
- The ASA console is **9600**. The OPNsense serial image normally talks at **115200**.
- If the PuTTY screen turns to garbage when OPNsense starts loading: close PuTTY, reopen it at **115200** on the same COM port.
- After installing, set it back to one speed: OPNsense → System → Settings → Administration → Serial console speed **9600** (so BIOS, ROMMON and OPNsense all match).

## 7. Install
1. At the login prompt: user **`installer`**, password **`opnsense`** (the published installer login — not a secret).
2. Keymap: UK. Choose **Install (UFS)** — simpler on a single SSD (ZFS is fine too; UFS recommended here).
3. **Pick the SSD as the target disk** (about 120 GB, shown as `ada…`). **Never pick the ~8 GB disk** — that is the Cisco flash.
4. Set the **root password** → generate and store it in **1Password** (Minda). Never type it into chat.
5. Complete, remove the USB stick, reboot. Set the BIOS to boot the SSD first.

## 8. First boot on the bench (no live cables!)
- Console menu → **1) Assign interfaces**. OPNsense lists the ports by MAC. Unit 2's MACs (from `show version`):
  | Cisco label | MAC |
  |---|---|
  | Gi0/0 | 188b.9d72.a294 |
  | Gi0/1 | 188b.9d72.a290 |
  | Gi0/2 | 188b.9d72.a295 |
  | Gi0/3 | 188b.9d72.a291 |
  | Gi0/4 | 188b.9d72.a296 |
  | Gi0/5 | 188b.9d72.a292 |
  | Gi0/6 | 188b.9d72.a297 |
  | Gi0/7 | 188b.9d72.a293 |
  | Management0/0 | 188b.9d72.a28f |
  Send Eugene the OPNsense port list (name + MAC) — he maps each to the Cisco label so the sticker on the box matches the config.
- **Admin / bench LAN = the Management port** (OPNsense `em8`, MAC …a28f on unit 2) with `192.168.99.1/24` (a range not used anywhere in the estate). Laptop on the Management port → https://192.168.99.1. *(Changed 2026-11-05, Minda: Management port = dedicated admin port; Gi0/7 now spare.)* In the rack the Management port joins a small **out-of-band admin VLAN (9, 10.224.9.0/29)** — not VLAN 10, because the box will also own VLAN 10 after window 3 and can't have two interfaces in one subnet (see the HQ plan). Web GUI + SSH listen only on admin interfaces (System → Settings → Administration → Listen interfaces).
- Then: **System → Firmware → Update** to the latest 26.7.x · **2FA for admin** (TOTP in 1Password) · NTP (uk.pool.ntp.org) · hostname `hq-fw-a` / `hq-fw-b` (`bev-fw` for Beverley) · serial speed 9600.
- **Burn-in:** leave running 24 h; check System → Log Files for errors; ping test through a port.
- **Backup:** System → Configuration → Backups → download **with encryption** → Minda keeps it (contains secrets; never in git or chat). Eugene reviews redacted diffs only.

## 9. Done when (per unit)
- [ ] Cisco images backed up to USB (step 0)
- [ ] Image checksum + signature verified (step 2)
- [ ] OPNsense installed on the SSD, boots from SSD, internal flash untouched
- [ ] Ports mapped (OPNsense name ↔ Cisco label ↔ MAC) and labelled on the box
- [ ] Updated, admin 2FA, NTP, serial 9600, 24 h burn-in clean
- [ ] Encrypted config backup held by Minda

## Notes
- CPU is an Intel Xeon X3430 (no AES-NI): fine for firewall/routing at our line speeds; WireGuard unaffected; IPsec slower.
- All units on the **same OPNsense version** before any HA pairing.
- Sources: OPNsense 26.7 release (mirror README, 15 Jul 2026); verification method per docs.opnsense.org/manual/install.html.


## Per-unit status (2026-11-06)
| Unit | Role | Cisco images backed up | BIOS: ROMMON Boot off, HDD first | OPNsense |
|---|---|---|---|---|
| 1 (V03, FCH18187KX2) | HQ hq-fw-a | no | no | — |
| 2 (V04, FCH19267THV) | HQ hq-fw-b | **yes** (USB stick, 9.8(2)20 + ASDM 7.9(1)) | no | — |
| 3 (V02, FCH1802J4Y9) | Beverley bev-fw | no (unit 2's stick holds the same 9.8(2)20 image) | **yes** | **INSTALLED 2026-11-06, updated to 26.7.8** — OPNsense, UFS/GPT on ada0 (Micron M550), root fs /dev/gpt/rootfs, root password set by Minda (1Password) |
| 4 | spare | — | — | — |
MACs: unit 2 188b.9d72.a28f…a297; **unit 3 88:5a:92:87:ed:af…b7**.

### Lessons from unit 3 install (2026-11-06)
- Don't pre-write the image to the SSD: it boots the live image from the SSD (both disks carry label OPNsense_Install) and the installer then reports *"table 'ada0' is corrupt"* / *"Device busy"*. Do this instead: **SSD blank (or slid out), boot from USB stick (BIOS 1st Boot = USB-HDD), push SSD in, `camcontrol rescan all`, `gpart destroy -F ada0`, `dd if=/dev/zero of=/dev/ada0 bs=1m count=10`**, then installer → UFS → ada0 → GPT → swap 8 GB → destroy yes.
- Disks seen by the installer: ada0 Micron M550 119 GB (SSD) / da1 "USB DISK MODULE" 7 GB (Cisco eUSB flash — never touch) / da0 USB stick.
- After install: BIOS 1st Boot = HDD, stick out; OPNsense boots from `/dev/gpt/rootfs`. Console 115200.
- **Unit 3 bench config (6 Nov):** console option 1 → WAN none, **LAN = em8 (Management port)**; option 2 → LAN **192.168.99.1/24**, no gateway, no IPv6, DHCP 192.168.99.100–150, HTTPS kept, web GUI defaults restored. GUI: https://192.168.99.1 from a laptop on the MGMT port only.
- GUI reached from the HQ desktop PC (no RJ45 on the laptop). Wizard blocks on the WAN page when no WAN is assigned → skip wizard (click logo) and set **System → Settings → General**: hostname **bev-fw**, domain **fishbone.local**, Europe/London, DNS 1.0.0.1 + 8.8.8.8 (one per line) — saved 6 Nov. Temporary WAN for updates: **em3 (Gi0/0) → office socket**, DHCP got 10.224.11.72; ping 1.1.1.1 OK. Update offered: **26.7 → 26.7.8 (30 Oct 2026)**, security fixes (OpenSSH 10.6 regenerates ML-DSA host keys on reboot → SSH host key fingerprints change; StrongSwan IKEv1 deprecation — we use WireGuard/IKEv2 only). Backup: deferred by Minda to go-live (nightly config.xml pull → PBS). Root 2FA: deferred.

### Unit 2 install log (2026-11-10) — becomes `hq-fw-a`
- Console via DIY VGA cable on header J9 (works; wiring in the VGA section above). Serial FCH19267THV.
- Booted the OPNsense 26.7 USB stick straight into live mode (no SSD pre-wipe needed this time). Live-mode login is `installer` (factory default), not `root`.
- Installer → **Install (ZFS)** → stripe → **ada0 Micron M550 MTFDDAK128MAY** only (da1 "USB DISK MODULE" = eUSB, left alone). Unit 3 is UFS; unit 2 is ZFS — both fine, ZFS chosen this time (boot env snapshots).
- No root password was set in the installer → first login used the factory default; changed at once with `passwd` from the console shell. Password lives only in 1Password (Fishbone IT, "ASA unit 2 – OPNsense root").
- Boots from `zroot/ROOT/default`. Ports em0…em8 = MAC …a2:97 … …a2:8f, same order as unit 3 → **em8 = Management**, em3 = Gi0/0.
- Bench access (Minda's choice): **LAN = em8 as DHCP client on the office network** → got **10.224.11.73**; WAN = em3 (unplugged). This avoids a direct-cable laptop. Before go-live em8 moves to OOB VLAN 9 (10.224.9.2) per the HQ plan. Lesson: while em8 still had the factory 192.168.1.1 + DHCP server, the office cable was pulled until option 2 switched it to DHCP client (otherwise it would hand out 192.168.1.x on the office LAN).
- GUI: hostname **hq-fw-a**, fishbone.local, Europe/London, DNS 1.0.0.1 + 8.8.8.8; firmware update 26.7 → 26.7.8 started.
- Next: restore a **cleaned** copy of unit 3's config (no Tailscale identity, no Beverley addresses/VLANs/DHCP) — HQ build per `Plan-OPNsense-HQ-Translation-AWT-1069b.md`.
- **Stage 1–2 (10 Nov):** 26.7.8_2 confirmed. WAN (em3) unassigned; **lagg0 = em3 + em7 (Gi0/0 + Gi0/1), LACP**, "LACP to 3850". VLANs on lagg0: vlan01 250 transit, vlan02 21 guest, vlan03 11 inside, vlan04 12 cctv, vlan05 20 wifi, vlan06 10 mgmt, vlan07 13 telephony. Assigned: lan = **OOB** (em8, DHCP on office for the bench), opt1 TRANSIT 10.224.250.2/29, opt2 GUEST .21.252, opt3 INSIDE (no IPv4 until em8 leaves 10.224.11.0/24), opt4 CCTV .12.252, opt5 WIFI .20.252, opt6 MGMT .10.252, opt7 TELEPHONY .13.252 (/24). No CARP VIPs yet (added with unit 1, per window). 26.7 note: Assignments is now a grid — add rows with the red **+** bottom-right.
- **Lockout after Stage 2 Apply (10 Nov) — lesson:** after assigning the VLAN addresses the GUI stopped answering from the office PC. tcpdump on em8 showed the PC's pings arriving with source **10.224.10.10** (routed via the ASA, not the PC's own 10.224.11.70) and no replies: the box answered via its own **MGMT 10.224.10.252/24** connected route on the unplugged vlan06. Rule for bench work on the office network: **the bench box must hold no address in any subnet the admin traffic comes from** (here 10.224.10.0/24 and 10.224.11.0/24). Fix applied from the console: MGMT IPv4 → none; OOB em8 → static **10.224.11.245/24** (outside the ASA pool .50–.240), gateway **10.224.11.1** (LAN_GW), no DNS from gateway; reboot (console option-2 changes were saved but not live until reboot). Red herrings ruled out on the way: firewall rules (pfctl -d made no difference), reply-to, em8 link (active, 1000baseT). Side find: a device at **10.241.12.10** ARPs for 10.241.12.1 every second on the office segment — likely a mistyped static IP (10.224.12.x CCTV?) — to trace later.
- **Stage 3 (10 Nov):** gateway **ASA_TRANSIT** (TRANSIT, 10.224.250.1) created **Disabled**, monitoring off, not upstream — enable + tick upstream at go-live, after OOB leaves the office net (otherwise it can steal the default route and lock out the GUI). Host aliases: PVE1 .10.10, PBX .13.9, DOCUSEAL .10.60, PROXY .30.30, SSH_GW .10.9, CAT3850 .10.4, UNIFI .110.5; network alias RFC1918 (3 entries). Firewall reload test after the first alias: GUI stayed up (lockout fix confirmed). Admin traffic from Minda's office PC arrives via **Tailscale → PVE1 (10.224.10.10)**, which is why it is sourced from 10.224.10.10; ICMP over that path does not answer, HTTPS does.
- **Stage 4 (planned):** aliases TRUSTED_NETS (10.224.10/11/20/17/110/111/120.0/24 = ASA level-100 + Beverley + VM101 VPN), CCTV_NET, DMZ_NET; rules per HQ plan §3 (MGMT/INSIDE/WIFI pass any; CCTV block TRUSTED; TELEPHONY block TRUSTED + CCTV; GUEST pass DMZ, block RFC1918, pass any). No rules on TRANSIT/OOB.
- **Stage 4 done (10 Nov):** aliases TRUSTED_NETS, CCTV_NET, DMZ_NET added. Rules applied (26.7 unified rules view; order within each interface checked): MGMT/INSIDE/WIFI pass any; CCTV ✕ TRUSTED_NETS (log) → pass any; TELEPHONY ✕ TRUSTED_NETS (log) → ✕ CCTV net (log) → pass any; GUEST pass DMZ_NET → ✕ RFC1918 (log) → pass any. Gotchas: (1) a new rule with **Interface (rule) = any** lands in *Floating rules* and applies to every interface — always pick the interface; (2) new rules append at the bottom — move blocks above passes by ticking them and clicking ← on the pass row (first match wins, quick).
- **Remaining for hq-fw-a** (needs unit 1 / go-live): CARP VIPs (.1 per VLAN, transit .4), pfsync on Gi0/2 (em2) + XMLRPC sync to hq-fw-b, Kea DHCP HA per VLAN (pools/option 43 per plan §4), INSIDE + MGMT addresses once OOB moves to VLAN 9 (10.224.9.2), ASA_TRANSIT enable + upstream, GUI/SSH listen interfaces, encrypted config backup to 1Password.
