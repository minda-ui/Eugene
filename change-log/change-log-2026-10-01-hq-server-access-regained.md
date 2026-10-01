# Change-log — 2026-10-01 — HQ server: admin access regained and contractor routes closed

_Newest note at the top. Append-only. Minda executed every step at the console and in the web UIs;
Eugene guided step by step and checked each result from her photos. **No credential was written,
typed or held by Eugene.** All new passwords are in Minda's password manager (1Password)._

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
