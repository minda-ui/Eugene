# Change log — 2026-10-10 — Beverley Place: full on-site recon + Proxmox box recovered & secured

_Guide-only, on-site (Minda at Beverley Place — her home / the registered address; executing every step,
Eugene guiding and verifying, no credential held). This graduates **RND-4** out of R&D into a real
recovery (new **OI-20**). Legitimate recovery: Minda owns the site._

## How we got here
Minda went to Beverley Place to do the planned **UniFi recon** (RND-4). The UniFi Cloud Key password
turned out **not to be held** either (same careful-contractor lockout as HQ) — so the recon pivoted to a
**physical/photo survey**, which gave the full map, and then Minda chose to **start the recovery** on-site.

## Device map (confirmed on-site) — the HQ stack in miniature
- **Cisco ASA 5550** (single, serial MX1512L0FD) — **same model as HQ**.
- **Cisco Catalyst 3850, 48-port** + **C3850-NM-2-10G** (2×10G uplink) — **same model as HQ**, single (no stack).
- **Lenovo mini-PC running Proxmox** (no iLO).
- **UniFi Cloud Key Gen2** @ `10.224.110.5` (UniFi OS; manages WiFi APs only; password not held).
- **APC UPS** (healthy).
- **ASA ↔ 3850: two patch cables** (likely a 2-link LACP port-channel, as HQ).
- Management subnets: `10.224.110.x` (Cloud Key) and `10.224.111.x` (Proxmox). Patch panel Philex/Cat.5e.
- Full detail: `R&D/beverley-place/device-map.md`.

## Proxmox box — RECOVERED + SECURED ✅
- **Access regained:** monitor + keyboard → **systemd-boot** menu (not GRUB) → highlight "Proxmox Virtual
  Environment", `e`, appended **`init=/bin/bash`** to `root=ZFS=rpool/ROOT/pve-1 boot=zfs`, Enter → root
  shell → `mount -o remount,rw /` → **`passwd root`** (Minda set a new password, saved in 1Password:
  "Beverley Proxmox root — 10.224.111.199 (root@pam)") → `exec /sbin/init` → normal boot → logged in as
  root. (Editor was not locked; no GRUB/ZFS passphrase.)
- **Secured:** `/root/.ssh/authorized_keys` held **one contractor `ssh-rsa` key** — backed it up to
  `authorized_keys.removed-2026-10-10` and **emptied the live file** (verified empty via `cat`). Changing
  the password alone would NOT have locked him out; removing the key does. New password is now the only way in.
- **State of the box:** kernel **6.17.2-1-pve**; ZFS `rpool` **117G total / 2.1G used / 115G free /
  ONLINE**; single NIC `nic0` → bridge `vmbr0 = 10.224.111.199/24`; **no VMs, no containers** (empty host).
  So our reboots impacted nothing — and it's **empty and ready to be the RND-3 off-site replica node**.

## Gremlins + lessons (folded into the map / runbook-to-write)
- A **flaky USB mouse** spammed the console (kept re-enumerating) → unplugged it; `dmesg -n 1` also silences.
- The **"gaming" keyboard did not work** in the minimal boot shell → swapping to a **plain USB keyboard**
  fixed it. **Bring a basic keyboard** for console recovery.
- Proxmox here uses **systemd-boot**, not GRUB (edit the entry with `e`, Enter to boot).
- `exec /sbin/init` cleanly resumes a normal boot from `init=/bin/bash` (no power-cycle).
- **Back up `authorized_keys` before emptying it** (reversible).

## UPDATE (same evening) — ASA 5550 + Catalyst 3850 ALSO recovered → ALL THREE BOXES DONE ✅
Minda had a console cable after all, so we finished the pair the same night (guide-only, one box at a time).

**ASA 5550 (`home-asa`) — recovered + secured.** Console dropped to `home-asa>` but enable pw unknown →
**ROMMON**: power-cycle → `Esc`/Break → `rommon #0>` → `confreg 0x41` (ignore startup) → `boot` → default
`ciscoasa>` → `enable` (blank) → `copy startup-config running-config` (real config back) → new **enable** +
**admin** passwords (Minda, 1Password) → **removed the contractor's `ssh authentication publickey`** on the
priv-15 `admin` account (his SSH back door; SSH was allowed from HQ mgmt subnets `10.224.10/5/11.0`) →
`config-register 0x1` → `write memory [OK]`. Internet confirmed back. ASA SW 9.1, ROMMON 1.0(11)5.

**Catalyst 3850 (`home-sw`) — recovered + secured + reboot-verified.** Console at `home-sw>` but enable
unknown → **Mode-button → `switch:` bootloader** → booted ignoring startup config → default `Switch>` →
`enable` (blank) → `copy startup-config running-config` (12625 B → `home-sw#`, VLANs/trunks up, site
online) → new **enable secret** + changed the contractor **`admin` (priv 15)** password (Minda, 1Password)
→ `no system ignore startupconfig switch all` → `write memory [OK]`. **Controlled reload confirmed clean**:
came back as `home-sw`, prompted login, `LOGIN_SUCCESS [user: admin]` with the new password — so the
ignore-flag is cleared and the new creds work. SSH was password-only (no key back door). **Minor:** boot
log shows `SIF_MGR-1-FAULTY_CABLE` (faulty StackWise adapter, same class as HQ's CSCvj49423) — **cosmetic on
a single switch** (StackWise unused), a replace-someday item.

**Result: all three Beverley core boxes (Proxmox, ASA, 3850) recovered, secured, new creds in 1Password,
contractor back doors removed, site fully online. Beverley Place is back under Fishbone control** — in one
evening, on top of the morning's OI-8 marathon. Guide-only throughout; Eugene held no credential.

**Security notes (flagged to Minda):** the same password was reused across boxes and was visible in a couple
of recovery photos → recommended distinct per-box passwords (all in 1Password). Still to do: fuller sweep
for other users/cron/tunnels on each box; stand the Proxmox box up as the RND-3 off-site replica + backups;
replace the 3850's faulty StackWise adapter (cosmetic); the Cloud Key (WiFi only) left as-is.

## Runbook
`Runbooks/Runbook-Beverley-Place-Recovery.md` to be written from this now-proven sequence (it mirrors HQ).

## Follow-ups
- **OI-20** (new) — Beverley Place network recovery (Proxmox DONE; 3850 + ASA pending a console cable).
- Fuller security sweep on the Proxmox box next login: other login users, cron/reverse-tunnels, sshd
  `PermitRootLogin` — the two main vectors (password + root key) are closed; this is belt-and-braces.
- Set up the box as the **RND-3 off-site backup/replica** (empty, 115G free) + automated Proxmox backups
  (ties to **OI-17**).
- Pre-write `Runbooks/Runbook-Beverley-Place-Recovery.md` for the Cisco boxes before the next visit.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
