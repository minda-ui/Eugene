# Plan — HQ out-of-band (OOB) management network — v0.1 (2026-11-06)

**Asked by:** Minda ("the 3850 has the same management port — do the same as the ASA"). **Status:** draft, nothing changed. **Guide-only (§3).** Ties to AWT-1069 (OPNsense), AWT-1064/1065 (UPS cards), OI-33.

## Idea
One small **separate** network that only carries admin access to the boxes themselves — so the switches, firewalls, servers and UPS can still be reached when the office network or a firewall is broken or mid-change.

## Why a separate small switch (not a VLAN on the 3850)
If the OOB network lived on the 3850, a 3850 fault would take the OOB network down with it — exactly when it's needed. A small 8-port switch (~£20–40, unmanaged is fine; managed with VLANs not needed) keeps it independent. Ideally on a UPS outlet.

## Who joins (subnet 10.224.9.0/24, name `oob`)
| Device | Port | Address |
|---|---|---|
| 3850 stack sw1 | Gi0/0 (already in `Mgmt-vrf`, unconfigured) | 10.224.9.11 |
| 3850 stack sw2 | Gi0/0 (only the active member's port answers; cabling both covers a switchover) | — (shared .11) |
| hq-fw-a (OPNsense) | Management port (em8) | 10.224.9.2 |
| hq-fw-b (OPNsense) | Management port (em8) | 10.224.9.3 |
| Gen9 iLO | iLO port (today 10.224.10.21 on VLAN 10) | 10.224.9.21 (move later) |
| Gen10 iLOs (HQ + Beverley-bound unit while at HQ) | iLO port | 10.224.9.22 / .23 |
| R710 iDRAC | iDRAC port (if fitted/enabled) | 10.224.9.24 |
| UPS 1 / UPS 2 (AP9631) | card network port | 10.224.9.31 / .32 (instead of VLAN 10 .31/.32) |
| **Jump point:** Gen9 Proxmox host | a spare onboard 1G port (eno1–eno4 are DOWN today) as bridge `vmbr-oob` | 10.224.9.10 |

**Access:** from the Gen9 (already on Tailscale) → the OOB network. No gateway to the internet, no route to the office VLANs. Works even if both firewalls are down. On-site fallback: laptop into the OOB switch, or the console cables.
Corrects the 5 Nov note (VLAN 9 on the 3850, /29): a separate switch + /24 is cleaner.

## 3850 lines (Minda applies later, in a quiet window; Eugene re-checks)
```
interface GigabitEthernet0/0
 ip address 10.224.9.11 255.255.255.0
 no shutdown
```
(`vrf forwarding Mgmt-vrf` is already there.) SSH over the OOB address works through the vty lines; NTP/syslog/AAA added later need `vrf Mgmt-vrf` on each line. No default route needed (no internet on OOB).

## Order
1. Buy the small switch (+ 6–8 short patch leads).
2. Gen9: enable `eno1` as `vmbr-oob` 10.224.9.10 (Proxmox network change — planned window, phones-safe: it doesn't touch bond0/vmbr0).
3. 3850 Gi0/0 → OOB (lines above).
4. UPS cards → OOB directly (instead of VLAN 10).
5. OPNsense pair → Management ports into OOB when racked.
6. iLOs → OOB one at a time (each change re-addresses iLO; keep the VLAN 10 address until the OOB one is proven).

## Open
- Beverley: same idea later (smaller: 3850 Gi0/0, bev-fw Management, UPS, Proxmox mini-PC as jump).
- Switch model + whether it sits on UPS A or B feed.
