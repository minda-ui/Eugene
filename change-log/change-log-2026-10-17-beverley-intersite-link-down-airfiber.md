# Change log — 2026-10-17 (evening) — Beverley↔HQ inter-site link down (airFiber antenna) + new Beverley network facts

_Guide-only (charter §3): Minda on-site at Beverley executing every console/physical step; Eugene
diagnosing + guiding. No credential held — Minda holds the airFiber, switch and ASA logins. **Status:
IN PROGRESS / UNRESOLVED at sign-off** — power + cabling fixed, RF link still re-locking, phone still
down. To finish next session._

## What happened
Minda reported the **Beverley IP phone (ext 1006) showing "No Service"**, and separately that she had no
UniFi controller login. Diagnosis showed the phone was only a symptom: **the whole Beverley↔HQ inter-site
link was down** — from the Beverley Proxmox (`10.224.111.199`) nothing at HQ was reachable
(`10.224.13.9` PBX, `10.224.10.10` Proxmox, `10.224.10.1` all 100% loss), while the Beverley gateway
(`10.224.111.1`) and the internet (`8.8.8.8`) were fine. So Beverley's own network + internet were
healthy; only the cross-site path was dead. (Tailscale still worked because it rides the internet via the
subnet routers — a separate path from the native radio/VPN.)

## Root cause + what was fixed
1. **The Beverley airFiber antenna had lost power** — the real fault. Minda re-powered it.
2. **Cabling error during the fix:** the antenna's **data cable had been plugged into `Gi1/0/2` (G2)**,
   which is **a member of `Po1`, the ASA uplink** (LACP to the ASA) — the wrong port. Moved it to the
   **correct port `Gi1/1/2`** (the SFP labelled `## AirFiber to office ##`, a trunk).
3. **ASA uplink confirmed intact:** `show etherchannel summary` → `Po1(SU)` with **both** `Gi1/0/1(P)` +
   `Gi1/0/2(P)` bundled. Firewall uplink is whole.
4. **`Gi1/1/2` came UP** (connected, trunk, a-1000 full) — so the Beverley dish now has power + Ethernet
   to the switch.

## Still open (next session)
- **The RF link Beverley↔HQ is not passing traffic yet.** `Gi1/1/2` (switch→dish) is up, but a ping to
  HQ (`10.224.10.10`) from the Beverley Proxmox still 100% loss after the port came up. So the wireless
  link between the dishes is still re-locking (or needs alignment, or the HQ end needs a look).
- **Next steps:** power-cycle the radio once and give it ~5 min to re-acquire; then check the **airFiber
  dashboard** (`https://192.168.5.20`, Minda holds the login) for RF link status / signal — reachable by
  putting a device on `192.168.5.0/24` or a temporary switch SVI. Once the RF link is up and HQ pings,
  **power-cycle the phone (ext 1006)** and confirm it registers.
- **Beverley phone (ext 1006) remains "No Service"** until the RF link is restored.

## New facts discovered (recorded in Infra-Inventory + the Beverley device-map)
- **Beverley Catalyst 3850 (`home-sw`) mgmt IP: `Vlan110 = 10.224.110.4`.** Also `Vlan10 = 10.224.10.252`
  and `Vlan11 = 10.224.11.252` — i.e. **VLANs 10 and 11 are bridged across the airFiber to HQ** (both
  sites share those subnets over the radio). This is why a Beverley host reaches HQ `10.224.10.x`
  natively over the link.
- **airFiber radio management IPs (first time recorded): Beverley `192.168.5.20`, HQ `192.168.5.21`**
  (own isolated `192.168.5.0/24` mgmt subnet, not routed from the data LAN).
- **Beverley 3850 port map (from `show interface status` / descriptions):**
  | Port(s) | Role |
  |---|---|
  | `Gi1/0/1` + `Gi1/0/2` | **ASA uplink `Po1`** (LACP; ASA-Gi0/0 + ASA-Gi0/1) |
  | `Gi1/0/3`–`39` | LAN ports (access vlan 111) |
  | `Gi1/0/40` | WiFi AP (vlan 110) |
  | `Gi1/0/44`–`46` | UniFi APs (UAP trunks) |
  | `Gi1/0/47` | UniFi Cloud Key (vlan 110) |
  | `Gi1/0/48` | **BT-router for office** (vlan 4) |
  | `Gi1/1/1` | **BT-router** (vlan 6) |
  | `Gi1/1/2` | **AirFiber to office** (trunk, SFP) ← the inter-site radio |

## BT fibre cancellation — new deadline (OI-24)
Minda flagged the **BT fibre at Beverley is being cancelled 27 Oct 2026, no replacement.** Beverley has
**two fibres (business + personal)**; only the BT one goes. So Beverley keeps internet — this is a
**redundancy loss, not an outage** — *provided* anything on the BT line is moved to the surviving fibre
first. At HQ the BT feed (delivered from Beverley over the radio, lands on vlan 4, `Gi1/0/48`/`Gi1/1/1`
at Beverley) is only a **backup** WAN, so HQ is unaffected (HQ runs on Wavenet FTTB). **Before the 27th:**
map what rides the BT line from the Beverley ASA config and re-point it to the other fibre (guide-only,
~10-min read + cutover). Tracked as **OI-24**.

## §3 / safety
Guide-only throughout; Minda executed every console/physical step and holds every credential (airFiber,
switch, ASA). No secret recorded. ASA uplink verified intact before leaving it. Nothing at HQ was touched.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
