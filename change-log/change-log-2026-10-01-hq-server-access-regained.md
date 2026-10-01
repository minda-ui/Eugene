# Change-log — 2026-10-01 — HQ server: admin access regained and contractor routes closed

_Newest note at the top. Append-only. Minda executed every step at the console and in the web UIs;
Eugene guided step by step and checked each result from her photos. **No credential was written,
typed or held by Eugene.** All new passwords are in Minda's password manager (1Password)._

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
