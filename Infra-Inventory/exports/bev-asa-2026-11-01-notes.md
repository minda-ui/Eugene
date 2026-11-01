# Beverley ASA (`home-asa`) — export notes (2026-11-01, via Gen9 → 10.224.10.254, read-only; masked export alongside)

| Item | Value |
|---|---|
| Model / SW | ASA 5550, 9.1(7)32, single unit (no failover), serial JMX1512L0FD, VPN Premium |
| ⚠️ Clock | 2004 — no NTP |
| WAN | **one** WAN: `outside` vlan 6 **192.168.1.111/24 → gw 192.168.1.254** (behind a BT router, private IP — the BT Business /29 is **not** on this ASA) |
| VLANs | 10 `office_mgmt` .254 (sec 50, **bridged with HQ**) · 110 `ap_mgmt` 10.224.110.1 (20) · 111 `inside` 10.224.111.1 (100) · 120 `wifi` 10.224.120.1 (100) · 121 `wifi_iot` 10.224.121.1 (10) · Gi0/3 `office-lan` 10.224.11.113 (down) |
| DHCP | pools .10–.248 on 110/111/120/121; DNS 1.0.0.1, 8.8.8.8 |
| NAT | dynamic PAT only (wifi, inside, ap_mgmt, wifi_iot → outside). **No port-forwards** → nothing published |
| ACLs | outside ends `permit ip any any` (harmless today — no forwards); office_mgmt `allow-all`; ap_mgmt `wmc` (Cloud Key .110.5 to internet + to 10.224.11.11) |
| Routes | default → 192.168.1.254; all HQ subnets (10.224.10.x pieces, 11, 12, 13, 30, 5, 192.168.5) → HQ ASA 10.224.10.1 over the bridged vlan 10 |
| SSH allowed from | 10.224.10.0/24, 10.224.5.0/24, 10.224.11.0/24 on office_mgmt only (that's why the Beverley LAN timed out) |
| VPN | none on the ASA (IPsec lives on the OPNsense VM at HQ) |

## DHCP leases — for AWT-1063 (Loxone + printer fixed IPs)
`inside` vlan 111 (pool .10–.248 → statics go in **.2–.9**):
| IP | MAC | Likely |
|---|---|---|
| .11, .14, .15, .16, .17, .18, .77 | **50:4F:94:…** | **Loxone** (Loxone Electronics OUI) — Miniserver / Audio Server / Intercom / extensions; match by the MAC on each device label |
| .10 | 80:5E:C0:… | (Yealink phone?) |
| .12 | F8:0D:AC:… | to identify (printer candidate — compare with the M479dw's MAC on its config page) |
| .13 | 94:BB:AE:… | to identify |
| .32 | BC:0F:F3:… | to identify |
| .48, .49 | 3C:A8:2A:… (same device, 2 MACs) | to identify (printer candidate — Wi-Fi + wired?) |
`ap_mgmt` 110: .10 (1C:6A:1B), .11/.12 (8C:30:66) — APs/Cloud Key area. `wifi_iot` 121: several randomised-MAC IoT devices.
**Proposed fixed IPs (outside the pool):** Miniserver 10.224.111.2 · Audio Server .3 · Intercom .4 · printer .5 (ping-check each first).

## Beverley 3850
SSH from Gen9: 10.224.10.252 **refused**, 10.224.110.4 **timed out** (likely asymmetric return path: the switch answers out its own vlan-10 SVI). → Use the console cable on the next visit, or SSH from a host on 10.224.10.x/11.x that's directly on the switch. Port map already recorded from 2026-10-10.

### AWT-1063 matching (Minda, 2026-11-01)
| Device | MAC | Current DHCP IP | Planned static |
|---|---|---|---|
| **Loxone Miniserver** (MSC91A, panel "Schaltschrank") | 50:4F:94:A2:C9:1B | **10.224.111.77** | 10.224.111.2 (set **last**) |
| **Audio Server "Music Box"** | 50:4F:94:F0:C1:33 | **10.224.111.14** (Loxone Config 'Local Address' = this IP → why it breaks on DHCP change) | .3 — ON HOLD (device stayed on .14; re-adding 2026-11-01) |
| **Intercom "Home Intercom"** | 50:4F:94:E0:D6:FA | **10.224.111.11** (Loxone Config 'Network Address' = this IP) | .4 — ON HOLD (device stayed on .11; re-adding 2026-11-01) |
| **HP M479dw printer** (wired, SN CNCRNC55BR) | F8:0D:AC:D8:5C:63 | **10.224.111.12** | .5 |
Remote access uses Loxone Cloud (connect.loxonecloud.com) — no ASA port-forward needed; unaffected by the IP change.

Other Loxone leases (.15–.18) = 50:4F:94:F5:… — likely extensions/speakers; leave on DHCP unless they also drop.

→ Steps: `Runbooks/Runbook-Beverley-Fixed-IPs-Loxone-Printer.md`.
