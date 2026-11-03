# Runbook — Install OPNsense on a Cisco ASA 5525-X (bench, before any live network)

**Hub:** AWT-1069 part (a). **Version:** v0.2, 2026-11-03 (extends the Drive v0.1 bench runbook, id 1H6hbUSpkwQD8MG8wr9VHJPjDP1EzVxcO).
**Guide-only (charter §3):** Minda downloads, verifies, cables, installs and holds every password (1Password). Eugene writes, reads console output, verifies.
**Status of the hardware (3 Nov):** 2 of 4 units in hand. Unit 2 (V04, FCH19267THV) bench-checked OK: X3430 4-core, 8 GB, POST pass, ROMMON 2.1(9)8, ASA 9.8(2)20, no config. Unit 1 (V03, FCH18187KX2) not yet booted. SSDs (Cisco ASA5500X-SSD120) ordered, due 4–5 Nov.

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
- Bench LAN = **Gi0/7** with `192.168.99.1/24` (a range not used anywhere in the estate). Laptop on Gi0/7 → https://192.168.99.1.
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
