# Plan — Beverley ASA 5550 (`home-asa`) → OPNsense `bev-fw` (ASA 5525-X unit 3) — v0.1

**Hub:** AWT-1069 part (c). **Date:** 2026-11-07. **Author:** Eugene. **Status:** draft for Minda; nothing live changes until she approves the swap window.
**Source:** masked export `Infra-Inventory/exports/bev-asa-2026-11-01-export-MASKED.txt` + notes `bev-asa-2026-11-01-notes.md`. Box: unit 3, OPNsense 26.7.8, port map in `Runbook-OPNsense-Install-ASA5525X.md`.
**Guide-only (§3).** Beverley is a **straight swap** (single ASA → single OPNsense, no Step A/B), so this is the pilot.

## 1. Physical — same cabling as today
| Today (ASA 5550) | bev-fw (5525-X) | OPNsense |
|---|---|---|
| Gi0/0 + Gi0/1 → **Port-channel1, LACP active** → 3850 (trunk "uplink to catalyst") | **Gi0/0 + Gi0/1** (same two cables move across) | **lagg0 = em3 + em7, LACP** |
| Gi0/3 `office-lan` 10.224.11.113 (link down, unused) | — | **dropped** |
| Management0/0 (unused) | **Management** | **em8 = admin** (192.168.99.1 bench → OOB later) |
No change on the Beverley 3850: the existing port-channel and allowed VLANs stay.

## 2. Interfaces (VLANs on lagg0)
| ASA nameif (sec) | VLAN | Address | OPNsense name | DHCP (same pools) |
|---|---|---|---|---|
| outside (0) | 6 | 192.168.1.111/24, gw 192.168.1.254 (BT router) | **WAN** | — |
| office_mgmt (50) | 10 | 10.224.10.254/24 (bridged with HQ over the radio) | **HQMGMT** | none (HQ serves VLAN 10) |
| ap_mgmt (20) | 110 | 10.224.110.1/24 | **APMGMT** | .10–.248 |
| inside (100) | 111 | 10.224.111.1/24 | **LAN** | .10–.248 (statics .2–.5 Loxone/printer stay outside the pool) |
| wifi (100) | 120 | 10.224.120.1/24 | **WIFI** | .10–.248 |
| wifi_iot (10) | 121 | 10.224.121.1/24 | **IOT** | .10–.248 |
DHCP DNS: 1.0.0.1, 8.8.8.8 (as today; Unbound on the box later). Same gateway addresses → **no client changes**.
**DHCP reservations to add (new, fixes the AWT-1063 problem natively):** Miniserver, Audio Server, Intercom, printer (MACs in the notes) — even though they are static now.

## 3. Routes
- Default → **192.168.1.254** via WAN (BT router). Later: BT Business public IPs (OI-24) + **HQ Wavenet over the radio as backup** (gateway group).
- HQ networks via **10.224.10.1** on HQMGMT (copy all 11 lines): 10.224.5.0/24, 10.224.10.32/27, .64/26, .128/26, .192/27, .224/28, 10.224.11.0/24, 10.224.12.0/24, 10.224.13.0/24, 10.224.30.0/24, 192.168.5.0/24.
  (The odd /27–/28 pieces exist because 10.224.10.0/24 is also directly connected — keep them as they are.)

## 4. Firewall rules — faithful translation
ASA logic: `same-security-traffic permit inter-interface`; higher→lower allowed; lower→higher blocked **unless an interface ACL says otherwise**.
| From (OPNsense iface) | ASA behaviour today | OPNsense rule (in, stateful) |
|---|---|---|
| LAN (inside 100) | to anything (incl. wifi = same level) | **allow any** |
| WIFI (wifi 100) | to anything (incl. inside = same level) | **allow any** |
| HQMGMT (office_mgmt 50, ACL `allow-all`) | anything, **incl. inside/wifi** (ACL overrides levels) — this is how HQ reaches the Beverley phone (1006 on .111.10) and Proxmox | **allow any** |
| APMGMT (ap_mgmt 20, ACL `wmc`) | only Cloud Key **10.224.110.5 → any**, and .110.5 → 10.224.11.11 (VM 101) | **allow 10.224.110.5 → any**; **NEW (Minda 7 Nov): allow APMGMT net → !RFC1918 on TCP 443 + UDP 123 only** (UniFi firmware + NTP); block rest. (VM 101 line not needed — VM stopped.) |
| IOT (wifi_iot 10) | lower levels only → effectively **internet only** | **allow → !RFC1918 (internet)**; block all internal |
| WAN (outside, ACL permits ip any any + ICMP) | no port-forwards → nothing reachable | **default deny inbound** (OPNsense default). Optional: allow ICMP echo to WAN. |

## 5. NAT (outbound)
ASA: PAT to the outside address for **wifi, inside, ap_mgmt, wifi_iot** only — **office_mgmt is not NATed** (it reaches HQ, not the internet, via Beverley).
OPNsense: Firewall → NAT → Outbound → **Hybrid**: automatic rules cover the internal nets; add a **"do not NAT" for HQMGMT net** if automatic includes it, or Manual with the 4 nets above. No port-forwards (none today; Loxone uses Loxone Cloud).

## 6. Not carried over
- ASA inspections (dns/ftp/h323/rtsp/skinny/esmtp…) — not needed; **SIP inspection was already off** (good for ext 1006).
- `office-lan` Gi0/3 10.224.11.113 (unused), AnyConnect/IPsec (none), clock 2004 → **NTP on**.
- Local users / SSH from mgmt → OPNsense admin via Management port / HQMGMT only, root 2FA.

## 7. Swap window (Beverley, ~30 min, Minda + Eugene)
1. Before: bev-fw fully configured on the bench (sections 2–5), config reviewed by Eugene.
2. Photo the ASA cabling; label Gi0/0, Gi0/1.
3. Power off home-asa → move the two port-channel cables to bev-fw Gi0/0/Gi0/1 → power on.
4. Tests: inside client gets DHCP + internet; Wi-Fi + IoT internet; **ext 1006 registers + 2-way call with HQ**; Loxone app/cloud; Cloud Key manages APs; HQ → Beverley Proxmox (10.224.111.199) and phone reachable; IoT cannot reach 10.224.111.x.
5. **Roll-back (2 min):** power off bev-fw, cables back to home-asa, power on. home-asa stays untouched for 30 days.

## Minda's answers (2026-11-07)
1. **IoT stays as today** (internet only, blocked from inside).
2. AP internet: Eugene recommends **yes, narrowly** — APs (10.224.110.0/24 except .5) → internet on **HTTPS 443 + NTP 123 only**, so UniFi firmware downloads and time work; still blocked from all internal nets. **Minda: YES (2026-11-07).**
3. **Swap before the BT Business change** — work out the plan (section 8).

## Open for Minda (original)
1. OK to **block IoT → inside** exactly as today (yes by default)?
2. Should the **APs** (110.10–.12) get internet (firmware checks)? Today they don't.
3. Swap timing: before or after the BT Business line is extended (OI-24)? Eugene: before — same WAN as today, one change at a time.

## 8. Plan to go-live (v0.1, 2026-11-07)
| # | Phase | Where | Who | Time | Done when |
|---|---|---|---|---|---|
| 1 | **Bench build** of sections 2–5 on bev-fw (LAGG, 6 VLANs, DHCP pools + 4 reservations, routes, rules, outbound NAT, NTP) | HQ desk, desktop PC on the MGMT port, console as backup | Minda clicks, Eugene dictates screen by screen | ~1.5 h | config matches this plan; Eugene reviews screenshots |
| 2 | **Bench test** with a small unmanaged switch or the OOB switch: laptop on a VLAN-tagged port is not needed — test one access VLAN via a spare port in a LAGG member, or skip and rely on review | HQ | Minda | 30 min (optional) | DHCP + ping on one VLAN |
| 3 | **Pre-swap checks at Beverley** (read-only): 3850 port-channel members + allowed VLANs (`show etherchannel summary`, `show interfaces trunk`), MACs of Loxone/printer still match, Cloud Key reachable, ext 1006 registered | Beverley, console | Minda | 15 min | outputs match the export |
| 4 | **Swap window** (section 7) — evening/weekend, phones quiet | Beverley | Minda + Eugene live | 30 min + tests | all 8 tests pass |
| 5 | **Watch 7 days**: firewall log for blocked traffic we didn't expect; Loxone/phone/Wi-Fi OK | remote (Tailscale) | Eugene reads, Minda screenshots | daily 5 min | no surprises |
| 6 | **Day 30**: home-asa retired (keep as cold spare/resell) | — | Minda | — | — |
| 7 | **Then** BT Business extension + WAN gateway group (BT primary, HQ Wavenet over radio as backup) | — | — | — | OI-24 |
Prerequisites: unit 3 Gi0/0 cable out of the HQ office socket; console cable + laptop at Beverley; Minda's 1Password entry for bev-fw root.

## 9. Beverley internet resilience — three paths (Minda, 7 Nov)
Lines: **BT Business (5 public IPs, main)**, **BT residential (ends Jul/Aug 2027)**, **airFiber radio to HQ** (HQ has Wavenet FTTB + Starlink + Vodafone).
**Yes — HQ can be Beverley's backup internet over the radio.** bev-fw gateway group (OPNsense *System → Gateways → Group*), failover on packet loss/latency to a monitor IP:
| Tier | Gateway | Monitor | Note |
|---|---|---|---|
| 1 | **BT Business** (WAN, public IP) | 1.1.1.1 | main |
| 2 | **BT residential** (WAN2) | 8.8.4.4 | until it lapses 2027 |
| 3 | **HQ over the radio** — next hop 10.224.10.1 on HQMGMT (later a dedicated transit VLAN) | 9.9.9.9 | uses HQ's Wavenet → Starlink → Vodafone |
**HQ side needs (on today's ASA, later the HQ OPNsense pair):** NAT Beverley nets (10.224.110/111/120/121.0/24) out of HQ's internet; add the missing route **10.224.121.0/24 via 10.224.10.254**; allow from mgmt. ~6 lines, Eugene writes them.
**Caveats:** inbound to Beverley's public IPs (future WireGuard endpoint) does not fail over; radio ~415 Mb/s is ample; when the radio is down, tier 3 is simply unavailable. **Bonus:** the same idea in reverse lets HQ use Beverley's BT Business as a backup (today's `outside_bt` vlan 4 path) — tidy that up in HQ Step B.
**To check:** which BT router sits behind Beverley ASA `outside` (192.168.1.111 → 192.168.1.254) — Business or residential? The 5 public IPs are not on the ASA today, so the Business line is probably in router/NAT mode.

### 9b. Vice versa — HQ backed up by Beverley's BT Business (Minda, 7 Nov)
**Already half-built:** the HQ ASA has `outside_bt` on **VLAN 4 = 81.143.32.194/29, gw 81.143.32.198** — i.e. one of Beverley's **BT Business public addresses is carried over the radio straight to HQ** (Beverley 3850 Gi1/0/48 "BT-router for office"). It has had **0 hits** (no route uses it).
**Plan (HQ Step B, on the HQ OPNsense pair):** HQ gateway group = **Wavenet FTTB (1) → BT Business via radio, VLAN 4 (2) → Starlink (3) → Vodafone (4)**. Rationale: a fixed BT line with a public IP beats Starlink (CGNAT, latency) for phones/VPN. **Order confirmed by Minda 7 Nov.**
**No loop:** HQ's backup uses the **raw BT line on VLAN 4** (not Beverley's firewall), and Beverley's backup uses HQ's firewall, which only sends via BT if BT is up — so the two backups can never point at each other.
**Optional sooner:** on today's HQ ASA, add a tracked backup route via `outside_bt` + NAT for the inside nets (~6 lines, guided) — only if Minda wants it before the OPNsense HQ move.
**To confirm:** VLAN 4 is still patched end to end (Beverley BT router → 3850 Gi1/0/48 → radio → HQ 3850 → ASA) after the OI-24 line changes; the /29's remaining addresses (.193, .195–.197) are free for bev-fw / WireGuard.

### 9c. BT Business router and the 5 public IPs (Minda, 7 Nov)
Minda: the Business line has the **newer BT hub with no modem/bridge mode**; the residential line has an **older hub that has modem mode** → idea: swap hubs so the 5 IPs can be used for VPN.
**Eugene's view — don't swap yet:**
- **Modem mode may not be needed.** BT Business hubs have a **"Static IP" setting** (Advanced Settings → Static IP: on, router address = the block's gateway, mask /29 for 5 IPs); the hub then **routes the block to its LAN** and devices behind it use the public IPs directly. **Evidence it already works:** HQ ASA `outside_bt` = **81.143.32.194/29, gw 81.143.32.198** over the radio — a public IP of this block sitting *behind* the hub. So bev-fw can take e.g. **.193** on its WAN (gw .198) and run WireGuard there. The hub's own firewall must allow traffic to the static block (BT "pinholes" per address / allow-all for the static range).
- **Swapping hubs is risky:** hubs are tied to the account's login/provisioning; a residential hub may not authenticate as a Business line or may lose the static block; you could lose the IPs or the residential line during the swap.
- **Cleanest long-term:** if Beverley is **FTTP** (white Openreach ONT box on the wall) → bev-fw does **PPPoE directly** with the Business credentials, hub retired — BT allows third-party routers on Business lines with static IPs. If **FTTC** (phone socket) → a small VDSL modem in bridge mode (e.g. DrayTek Vigor 167, ~£80–120) + PPPoE on bev-fw.
**Need from Minda:** photo of the Business hub label (model) and of the line termination (ONT box or phone socket); the hub's Static IP page (no passwords). Then decide A (hub static-IP routing, no hardware) / B (PPPoE on bev-fw).
Sources: business.bt.com Smart Hub 2 multiple static IP guide; BT Business community threads on bridge mode / 3rd-party routers.
**Update 7 Nov (Minda's screenshots):** BT chat 23 Dec 2024 → Beverley Business line = **Full Fibre 900 (FTTP)**, PPPoE login on `…@hg7.btclick.com` (**credentials → Minda's 1Password only, never recorded here**), single static **81.150.11.69** (the line/session address). Hub page "Manage your Multi Static IP addresses" (Dec 2024) → **block 81.143.32.193–.197 enabled** (gateway .198 = hub); **.193 assigned to MAC b8:31:b5:38:03:33** (device to identify), .194 used by HQ ASA `outside_bt`, .195–.197 free. Note from the contractor at the time: the hub has **no "allow incoming connections to the static IPs" switch** → inbound to the block is limited by the hub → strengthens **option B (PPPoE on bev-fw, hub retired)**: then the block is routed straight to bev-fw and the hub firewall is out of the path. Still ask BT to confirm the block is routed to a third-party PPPoE router and whether a VLAN tag is needed.
Context (Minda, 7 Nov): the Dec 2024 hub screenshot + note came from the **original network engineer** (contractor who built the network); exposing the static block through the hub was an option they explored then and it stalled on the missing inbound switch. Option B (PPPoE on our own firewall) is the same goal by a route that avoids the hub.

### 9d. BT tests at Beverley — next week (Minda, 7 Nov: no BT contact for now)
Read-only / reversible, ~30 min, Minda on site, Eugene guiding:
1. Hub device list: identify **b8:31:b5:38:03:33** (holder of 81.143.32.193).
2. Hub Static IP page + firewall page screenshots (no passwords): what inbound options exist.
3. Inbound test to the block: from a phone on 4G, ping 81.143.32.193 / .194 (ping is allowed on the hub page) — confirms the block is live end to end.
4. Trace the BT cabling: Openreach box → hub → 3850 Gi1/0/48 (VLAN 4 "BT-router for office") and Gi1/1/1 (VLAN 6) — which hub feeds which VLAN, and which line the Beverley ASA `outside` (192.168.1.254) uses.
5. Optional, if time: bench PPPoE test from bev-fw on a spare port to the **residential** Openreach box? — no: do PPPoE tests only on the Business line in a planned window; skip in this visit.
Outcome decides: A (public IP behind the hub) vs B (PPPoE on bev-fw) for the swap.

### §9d results — 2026-11-09 evening (Minda at Beverley; read-only on home-sw)
| Test | Result |
|---|---|
| Gi1/0/48 (VLAN 4, "BT-router for o…") | Hub A: `b86a.f17f.3000` (+ `ba6a.f17f.3000/3001` = same device, locally-administered variants) — connected a-1000 |
| Gi1/1/1 SFP (VLAN 6, "BT-router") | Hub B: `0470.565a.f13e` / `…f13f` — connected a-1000 — feeds the old ASA outside (192.168.1.x) |
| VLAN 4 over the radio Gi1/1/2 (HQ side) | `76ac.b96f.108b`, `76ac.b96f.1916`, `dcce.c1e4.feb1` (HQ ASA .194 expected among these) |
| `.193` holder `b8:31:b5:38:03:33` | **not seen on home-sw at all** → not on VLAN 4/6 here: either plugged straight into a hub LAN port, or gone/stale in the hub's assignment |
| Working conclusion | Hub A (VLAN 4) = **BT Business** (the /29 block; HQ uses .194 through it); Hub B (VLAN 6) = Beverley's current internet for the old ASA. To confirm on the hub pages (test 2). |
| Test 2a — hub B page (the hub feeding the old ASA, VLAN 6) | Connected now: only `home-asa` 192.168.1.111 (static), MAC 50:3D:E5:1E:B2:DC, hub LAN port 1. Full device history export (Minda, CSV, not stored in git — contains household device names): ~55 past devices incl. Loxone, UniFi APs, Yealink, home devices, some on 192.168.50.x via port 3 → this hub once served the house LAN directly. **Hub A's MAC `B8:6A:F1:7F:30:00` appears in hub B's history** (once on hub B port 1). **The .193 holder `b8:31:b5:38:03:33` is NOT in hub B's history** → the /29 assignment lives on hub A. Still to confirm: which hub is Business vs residential (hub status page / broadband username). |
| **Confirmed (Minda, 2026-11-09)** | **Hub B (VLAN 6, Gi1/1/1, feeds the old ASA 192.168.1.111) = RESIDENTIAL hub.** ⇒ Beverley's internet today runs on the **residential line** (ends Jul/Aug 2027), not the Business line. **Hub A (VLAN 4, Gi1/0/48) = BUSINESS hub** (the /29; HQ uses .194 through it over the radio). **Impact on the swap (§1–§2, §9):** bev-fw primary WAN must move to the **Business** line — VLAN 4 / hub A, option A (a public /29 address behind hub A, e.g. .195) or option B (PPPoE) — with residential (VLAN 6, 192.168.1.111) as the second WAN until 2027. §2's "VLAN 6 = WAN" becomes WAN2. Next: hub A pages (device list → .193 holder, Static IP page, firewall). |
| Hub A access | Hub A (Business) sits in the **garden-house rack**; its **Wi-Fi is OFF**; Minda's laptop has no RJ45 and the HP desktop is in the house → hub A's pages (device list / Static IP / firewall / ifconfig.me) **deferred**: next visit with a USB-RJ45 adapter, or via unit 3 on hub A during the bench build. Test 3 (4G ping .193/.194/81.150.11.69) can be done any time from a phone on mobile data. |
