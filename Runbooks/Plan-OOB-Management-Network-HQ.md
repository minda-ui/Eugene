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

## Update 2026-11-14 — dedicated OOB switch arrived
- **Switch:** TP-Link **TL-SG1016(UN) Ver 15.0**, 16× 1G unmanaged, 1U rack, internal PSU 100–240 V 0.3 A, S/N 22B3E0002368. Bench test OK (power + port link lights).
- **Decisions (Minda):** **no uplink to the 3850** (fully independent OOB); powered from **UPS A** (same as the firewalls).
- **State before the move (11 Nov):** OOB = VLAN 9 on the 3850 — Gi1/0/45 hq-fw-a em8 (10.224.9.2), Gi2/0/45 hq-fw-b em8 (10.224.9.3), Gi1/0/46 laptop jump port; firewall OOB addresses are **/29** (10.224.9.0/29).
- **Move (Minda, ~10 min, office unaffected):** one firewall at a time, **hq-fw-b (backup) first**: move its em8 cable 3850 Gi2/0/45 → TP-Link; laptop on TP-Link 10.224.9.4/29 no gateway → https://10.224.9.3 loads; CARP status unchanged (a MASTER, b BACKUP). Then hq-fw-a (Gi1/0/45 → TP-Link) → https://10.224.9.2.
- **Then 3850 (quiet window):** `interface range Gi1/0/45 , Gi2/0/45 , Gi1/0/46` → `shutdown` + description "spare (OOB moved to TL-SG1016)" so nobody bridges the two by patching; keep `vlan 9`; `write memory`.
- **Then widen OOB to /24** on each firewall (Interfaces → OOB → IPv4 /24, per box, via the normal admin address 10.224.11.252 / .253), before adding iLOs (.21–.24, pve-ai iLO already 10.224.9.22/24) and UPS cards (.31/.32), one device at a time.
- **Move DONE (14 Nov, Minda):** hq-fw-b em8 then hq-fw-a em8 moved from 3850 Gi2/0/45 / Gi1/0/45 to the TL-SG1016; laptop on the TP-Link 10.224.9.4/29 → https://10.224.9.3 ✅ and https://10.224.9.2 ✅; CARP unchanged (hq-fw-a MASTER) ✅.
- **Note (14 Nov):** https://10.224.11.253 (hq-fw-b INSIDE) times out from a PC on staff Wi-Fi (10.224.20.x) — **asymmetric reply path**, not a fault: the request goes via the CARP master (hq-fw-a), hq-fw-b answers directly out of its own WIFI leg, hq-fw-a drops the half-seen connection. Same class as the 10/11 Nov lockouts. **Rule: open a firewall's GUI at its address in your own subnet** (from Wi-Fi: hq-fw-b = 10.224.20.253) **or via OOB** (10.224.9.2 / .3). .252 works because hq-fw-a carries both directions.
- **Widened to /24 DONE (14 Nov, Minda):** hq-fw-a (via .252) and hq-fw-b (via OOB 10.224.9.3) management interface /29 → /24; laptop "Ethernet 3" 10.224.9.4/24 no gateway → https://10.224.9.2 ✅ + https://10.224.9.3 ✅. Pending: 3850 Gi1/0/45, Gi2/0/45, Gi1/0/46 shutdown (lines above); iLOs / UPS cards one at a time (next: pve-ai iLO 10.224.9.22).
- **pve-ai iLO on OOB (14 Nov):** iLO port → TL-SG1016; https://10.224.9.22 loads from the OOB laptop ✅.
- **3850 old OOB ports shut (14 Nov, Minda):** Gi1/0/45, Gi2/0/45, Gi1/0/46 shutdown (description "spare - OOB moved to TL-SG1016"); `vlan 9` kept (unused). OOB now fully independent of the 3850.
- **Gen9 iLO on OOB (14 Nov, Minda):** iLO 4 IPv4 static 10.224.9.21/24, gateway 0.0.0.0, ping-gateway-on-startup off; cable moved 3850 **Gi1/0/17** → TL-SG1016; https://10.224.9.21 ✅. Gi1/0/17 now free.
- **UPS card 1 on OOB (14 Nov, Minda):** AP9631 MAC 00:C0:B7:EA:26:A5 (refurb, "fully reset"); never cabled before. Address given with APC **ARP + 113-byte ping** from the OOB laptop (`netsh interface ipv4 add neighbors "Ethernet 3" 10.224.9.31 00-c0-b7-ea-26-a5`, `ping 10.224.9.31 -l 113`), then made permanent: IPv4 Manual 10.224.9.31/24 gw 0.0.0.0. **http is off on this firmware — use https://10.224.9.31** (self-signed). Password changed by Minda (1Password). Correction: the 6 Nov plan said the cards were on VLAN 10 .31/.32 — wrong (those are CT 200 Fishbone AI and pve-bev); the cards had never been on the network.
- UPS card 1 (10.224.9.31, MAC 00:C0:B7:EA:26:A5) is in the **top UPS** (SUA2200RMI2U JS0727011051). Card 2 (MAC 28:29:86:25:56:98, S/N 5A1931T39112, bottom UPS) did **not** take the ARP+ping address — likely old settings from a previous owner; next: LED check / office-port DHCP lease / factory reset.
