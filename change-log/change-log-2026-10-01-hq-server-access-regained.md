# Change-log — 2026-10-01 — HQ server: admin access regained and contractor routes closed

_Newest note at the top. Append-only. Minda executed every step at the console and in the web UIs;
Eugene guided step by step and checked each result from her photos. **No credential was written,
typed or held by Eugene.** All new passwords are in Minda's password manager (1Password)._

## Update 2026-10-01 ~23:00 UTC — **WIRED INTERNET + WIFI RESTORED** (service back)

After the switch-2 discovery, Minda found a **printed "Fishbone Network diagram"** giving the authoritative
access-port plan for both 3850s — and it matched every device we'd found live. Used it to apply the
reconstructed access-port config **live** on switch 1 (logged in as `recovery`), in batches, on the running
config; the EEM timer auto-saved it. Applied (Gi1/0/1-48): **1-16 → vlan 12** (CCTV cameras + recorder),
**17 → vlan 10** (iLo), **18-24 → vlan 11 + voice vlan 13** (IP telephony), **25-45 → vlan 11** (computers
& printers), **46-48 → trunk native vlan 5 (ubnt-mgmt), allowed 5,20,21** (Ubiquiti U7 APs).

**Result: wired internet LIVE and WiFi LIVE**, both verified by Minda. Save confirmed permanent
(`show startup-config | include switchport access vlan` shows the 12/10/11 assignments written to
startup). The full port plan + paste-ready config is in
`Runbooks/Runbook-HQ-Network-Core-Recovery.md` Part E.

**Still pending (daytime, non-urgent — internet is up):** **phones** need the **server 10G trunk
(Te1/1/4)** to carry vlan 13 to the PBX VM — defer until the trunk's VLAN list is read from
Proxmox/OPNsense (too risky to guess, could disturb OPNsense routing). Then switch 2's access config +
stack rebuild, remove the `SAVECFG` EEM timer via SSH to 10.224.10.4, restore redundancy, replace switch
1's faulty stack adapter. Port plan recorded in the runbook; the authoritative **printed diagram** is at
Unit 30-31 (photographed, in the session log).

## Update 2026-10-01 ~20:30 UTC — Catalyst 3850 **RECOVERED**: admin access regained, full config restored, network up

Minda at the console all evening, Eugene guiding. **Full admin control of the core switch is back.** This
was the hard one — it took most of the evening because of a hardware fault, not the method.

**End state (switch 1, standalone; switch 2 still powered off, stack cables out):**
- Logged in as our own **`recovery`** account (privilege 15); **`enable secret`** set; **`aaa authorization
  console`** added so `recovery` gets full rights on the console. Credentials **only in Minda's 1Password**
  — none held or written by Eugene.
- Full config restored (hostname **`Catalyst`**): `Vlan3 192.168.1.218 up/up`, **`Vlan10 10.224.10.4`**
  (mgmt SVI) `up/up`, **`Gi1/1/1` StarLink WAN uplink `up/up`**, **`Gi1/1/2` ASA uplink (Po1 member)
  `up/up`**. Network forwarding again.
- A **complete config backup is captured on Minda's laptop** (PuTTY log of `old_wifi_config`).

**The real blocker (diagnosed, Cisco bug CSCvj49423):** switch 1's StackWise adapter (`R0/0`) is faulty and
spews `%SIF_MGR-1-FAULTY_CABLE: Switch 1 R0/0: High hardware interrupt` **faster than the console accepts
input** — it is a driver-level print that `no logging console` does **not** suppress, and it **corrupted
every manual save** we tried. Removing the stack cable did not stop it (the fault is the adapter/port, not
the cable). This, not the password method, is why the night was long.

**Two more gotchas found along the way:**
- **PuTTY flow control XON/XOFF froze console input** (a stray XOFF in the flood wedged it). Fix: **Flow
  control = None**.
- **Correct bootloader variable is `SWITCH_IGNORE_STARTUP_CFG` (not `…CONFIG`)** — the `set` output showed
  `SWITCH_IGNORE_STARTUP_CFG=0` as the live one. Set **both** to 1 to ignore config, both to 0 to boot it.

**The method that finally worked — flood-immune auto-save via EEM:**
1. Boot ignoring config (`switch:` → `SWITCH_IGNORE_STARTUP_CFG=1` + `SWITCH_IGNORE_STARTUP_CONFIG=1` →
   `boot`) → quiet `Switch>` → `enable`.
2. While quiet, set `username recovery privilege 15 secret …` and an EEM applet that saves on a timer:
   `event manager applet SAVECFG authorization bypass / event timer watchdog time 150 / action 1 cli
   command "enable" / action 2 cli command "write memory"`. EEM runs **internally**, so the console flood
   can't corrupt the save.
3. Load the config, then let the timer save it: `copy flash:old_wifi_config running-config` → wait ~5 min
   (EEM auto-saves running→startup every 150 s).
4. Reboot, clear the flags (`switch:` → both vars `=0` → `boot`), log in as `recovery`.

**Important mistake + recovery (documented honestly):** the first EEM attempt set the timer **before** the
config was loaded, so it fired while running-config was still minimal and **overwrote `nvram_config` AND
`nvram_config_bkup`** with an empty config — their startup config was wiped. **Recovered** because
`flash:old_wifi_config` (an Oct 2024 full backup the contractor left) was still on flash; its `username
admin` hash `$1$HTHO$…` matches the current one, so it was current enough. Restored from it, in the correct
order this time. **Lesson: never arm an EEM/kron auto-save before the real config is in running-config —
`write memory` writes both nvram copies and will destroy startup if running is empty.** Keep an off-box
config backup so this is never fatal (now have one on the laptop).

**VLAN map recovered (from switch 2's `show vlan brief`, authoritative names):** 2 StarLink (WAN), 3
Vodafone (WAN), 4 BT (WAN), 5 ubnt-mgmt (Ubiquiti), 6 FTTB (WAN), 10 MGMT, **11 LAN (user network)**,
12 CCTV, 13 Telephony, 20 Main WLAN, 21 Guest_WLAN, 30 DMZ. The ASA is the L3 gateway for these
(inside 10.224.11.1, cctv .12.1, telephony .13.1, wifi .20.1 …), carried over Po1.

**Important reality found (switch 2):** switch 2's console is **clean** (no faulty-cable flood — confirms
the fault is switch 1's adapter). But switch 2's **saved startup-config is dated "Tue Jan 29 2019"** —
older than switch 1's 2024 `old_wifi_config` — and in **both** backups most access ports are default
(VLAN 1). So the **current port→VLAN / trunk assignments (which port is LAN, which trunks to the Ubiquiti
APs, CCTV, phones) are in neither backup** — they lived only in the running config that was lost when the
EEM timer wiped switch 1's nvram. `vlan.dat` (the VLAN database, Aug 2026) is current, so the VLAN
*definitions* survive; only the per-port assignments are gone. **Consequence: restoring internet/wifi is a
reconstruction job, not a config paste** — needs the physical port layout (trace the rack) + the VLAN map
+ any network documentation, done in daylight. Network left **down overnight** (no one working); admin
access and the core uplinks (StarLink Gi1/1/1, ASA Po1) are up, but edge ports are on the stale VLAN map.

**Config facts recorded** (from `old_wifi_config`, matches live): `aaa new-model` / `authentication login
default local` / `authorization exec default local`; `username admin privilege 15 secret 5 $1$HTHO$…`;
`Port-channel1` "ASA-1" trunk vlan 2,3,10,11,20; `Gi1/1/2` "TMP_ASA_LINK" `channel-group 1 mode active`;
`Gi1/1/1` "## Uplink to StarLink terminal ##" access vlan 2; `Gi1/0/48` "AP" access vlan 10; stack-power
pool **fishbone** redundant; `switch 1/2 provision ws-c3850-48p`. The file also carries the **old Cisco
Converged-Access wireless config** (pre-Ubiquiti) — inert now (no Cisco APs), to be stripped later.

**Still open (next session, all non-urgent — switch is up):**
- **Remove the `SAVECFG` EEM auto-save applet** — it keeps saving every 150 s (flash wear). Do it over
  **SSH to `10.224.10.4`** (clean session, no console flood), then `write memory`.
- **Replace/remove switch 1's faulty StackWise adapter** (CSCvj49423); firmware 16.3.6+ also fixes it. PSU
  **A** on switch 1 is also flapping (`FRU_PS`) — watch/replace.
- **Rejoin switch 2 / rebuild the stack** — switch 2 holds a synced config copy and its console is likely
  clean (the fault is switch 1's). Plan the StackPower reconnect in a window (resync reload expected).
- **Redo the ASA swap** (top unit to active) now that Port-channel1 bundles, then **fix the phones** (OI-8,
  ASA inbound SIP/RTP).
- Strip the defunct Cisco wireless config; reconcile against switch 2's current config.

## Update 2026-10-01 ~12:45 UTC — Catalyst 3850 stack: recovery attempted, defeated by StackPower; network restored

Minda at the console, Eugene guiding. **Config intact, no damage. Switch still locked.**

**The stack:** 2x **WS-C3850-48P**, StackWise **data + StackPower** cabled (one logical stack), IOS-XE
**16.09.05**, active = switch 1 (priority 15). Startup config lives in `flash:/nvram_config` (+ `_bkup`)
— not `config.text` (16.x convention). Console login is locked (`Username:`).

**What we did:** powered the whole stack off (all 4 cords), powered the top switch on holding **MODE** →
reached the `switch:` boot loader → `flash_init` → confirmed `nvram_config` present → set
`SWITCH_IGNORE_STARTUP_CONFIG=1` → `boot`. It came up blank (`Switch>`, no password) — **access gained**.

**Why it didn't complete:** **StackPower kept both switches alive from the top switch's one PSU**, so the
bottom switch (switch 2) also booted and the stack formed in a mismatched state. The moment we ran
`copy startup-config running-config`, the stack did a **resync reload** ("Reload peer command"). After the
reload it loaded the real config normally — **internet restored** — and returned to the locked `Username:`
prompt. The password was never changed; `nvram_config` was never overwritten.

**Lesson (switch recovery on a StackPower stack):** the single-switch ignore-config method is defeated
because StackPower powers the partner too, triggering a stack resync reload. To recover cleanly you must
**physically disconnect the StackPower cable** first so switch 1 boots truly alone, recover that one
switch, `write memory`, clear the flag, then reconnect StackPower and power switch 2 back on. Do it in a
planned window or hand to a Cisco engineer.

**Status:** all other systems recovered today (iLO, Proxmox, OPNsense, VM backups, ssh-gateway off, ASA
standby prepared). **Only the 3850 stack remains locked** — low risk, because the contractor's real
routes (server, hypervisor, OPNsense, ssh-gateway, firewall admin) are already closed or changed, so his
path to even reach switch management is cut.

**Remaining network-core work (planned, not today):**
1. 3850 stack — recover with StackPower disconnected (window or engineer).
2. Finish the ASA swap (needs the switch to bundle Port-channel1).
3. Fix the phones (ASA inbound SIP/RTP rule, OI-8).

## Update 2026-10-01 ~11:00 UTC — ASA pair: standby recovered; swap blocked on switch (fell back)

Minda at the console, Eugene guiding. **No credential held by Eugene.**

**Done on the secondary/top ASA (standby):**
- Disconnected its data + failover cables (bottom unit kept the internet up).
- ROMMON recovery: `confreg 0x41` → boot ignoring startup-config → `enable` (blank) → `copy startup-config running-config`.
- Set a **new enable password** and a **new admin password** (1Password), **removed the admin SSH public key** (a password-free contractor backdoor), `config-register 0x1`, `write memory`. Verified: `show running-config username admin` shows no key, new hash.

**Swap attempted, then rolled back:**
- Powered off bottom, moved cables to top. Internet dropped. Top's **Port-channel1 stayed down** — the ASA uplinks are an **LACP bonded link to the Catalyst switch**, and the switch won't bundle the top unit's ports without switch-side action. **The switches are still locked.**
- Fell back: top cables out, bottom powered back on. **Internet restored** on the bottom (old config). Confirmed the top unit's new config survived the fallback (no sync overwrite).

**State now:** bottom ASA serving (old config, contractor firewall backdoor still present there); top ASA fully prepared and isolated. Contractor is unreachable; backdoor has existed for weeks — acceptable short-term.

**Revised sequence (dependency discovered):**
1. **Recover the Catalyst 3850 stack first** — via Cisco's official 3850 password-recovery procedure or a Cisco engineer (Eugene is not scripting the switch steps).
2. **Redo the ASA swap** — will complete cleanly once the switch bundles the top unit's Port-channel1 (verify it comes **up** before relying on it).
3. **Then fix the phones** (ASA inbound SIP/RTP rule, OI-8).

**ASA interface / WAN map (from `show failover` / `show interface ip brief`, Po1 subinterfaces):**
| Interface | IP | Role |
|---|---|---|
| outside_sl | 192.168.1.254 | WAN leased line |
| outside_bt | 81.143.32.194 | WAN BT (public) |
| outside_fttb | 62.105.119.118 | WAN fibre (public) |
| outside_vf | 192.168.3.254 | WAN (third) |
| ubnt_mgmt | 192.168.5.1 | Ubiquiti mgmt |
| mgmt | 10.224.10.1 | management |
| inside | 10.224.11.1 | inside LAN |
| cctv | 10.224.12.1 | CCTV VLAN |
| telephony | 10.224.13.1 | phones VLAN |
| wifi / guest_wifi | 10.224.20.1 / 10.224.21.1 | WiFi / guest |
| dmz | 10.224.30.1 | DMZ (OPNsense WAN side) |
All on **Port-channel1** subinterfaces (Po1.2–Po1.30). Failover links: Gi0/3 (10.224.0.254 LAN), Gi1/3 (10.224.0.250 stateful). Software **9.1(7)32**, config-register **0x1**, VPN Premium licence. ASA accounts: `admin` (priv 15; key removed), `vpn2`, `vpn-user-1` (remote-access VPN — one is likely Minda's phone; identify before removing).

## Update 2026-10-01 ~08:15 UTC — Server side secured

| Step | Result |
|---|---|
| iLO 4 (`10.224.10.78`) | Found by network scan; default tag password worked; **changed** |
| Proxmox VE 8.2.2 host `pve` (`10.224.10.10`) | Root reset via systemd-boot `init=/bin/bash` → `passwd root`; **web login verified** |
| Proxmox users | Only `root@pam` |
| Proxmox root SSH keys | 3 keys: `root@pve` kept; **2 contractor keys removed** (original file kept on the laptop) |
| VM backups | First-ever backups (vzdump, local): **105 PBX (4.3 GB), 101 FW, 102 public-proxy, 104 ssh-gateway**; all **downloaded to the laptop** |
| VM 104 ssh-gateway | Backed up, then **shut down** (likely the contractor's remote route in; reversible) |
| VM 101 FW = **OPNsense 25.1.3** (LAN `10.224.11.11`, WAN `10.224.30.11`) | Root reset via single-user mode + `opnsense-shell password`; **web login verified**; **encrypted config backup downloaded** |
| OPNsense users | `root`, `vpnuser1`; root has no authorized keys; **vpnuser1 password changed** |
| OPNsense VPN | IPsec **Remote-access** (`vpn.fishboneholding…`; nobody connected at the time) and **PtP debian** (site-to-site, up, probably Beverley Place; untouched). WireGuard and OpenVPN instances empty |

**What we found:**
- Hypervisor: 6 VMs (100 test and 103 tftp stopped; 101 FW, 102 public-proxy, 104 ssh-gateway, 105 PBX).
- Networks: `10.224.10.x` management, `10.224.11.x` OPNsense LAN, `10.224.13.x` phones, `10.224.20.x` WiFi, `10.224.30.x` OPNsense WAN behind the ASA.
- Firewalls: ASA 5550 pair (end of support).
- A Cisco web login at `10.224.10.4` (probably the 3850 stack).
- The server's `/root` holds HP Smart Array firmware dated 16 Feb 2026, a sign of recent contractor activity.

**Still open:**
- Cisco Catalyst stack and ASA pair (console recovery, this evening).
- What 102 public-proxy publishes, and whether OPNsense SSH should be off.
- Off-box backup target (no USB drive or NAS yet).
- Proxmox and OPNsense updates; 2FA; iLO clock.
- Phones still down (OI-8: ASA inbound rule).

## Update 2026-10-01 ~06:20 UTC — Discovery
Server label photo (iLO tag), ASA 5550 pair identified (bottom active, top standby), console showed Proxmox.
