# Plan — HQ Step B: internet lines onto the OPNsense pair, retire the ASA (v0.1)

**Date:** 2026-11-11. **Author:** Eugene. **Status:** draft for Minda — nothing changes until she picks a day.
**Guide-only (§3).** Minda runs every live step; Eugene writes the lines and checks results. No secrets here.
**Builds on:** `Plan-OPNsense-HQ-Translation-AWT-1069b.md` (Step A complete 11 Nov: all internal VLANs on hq-fw-a/b).

## 1. What the ASA still carries (live read 11 Nov)
| VLAN | ASA nameif | ASA address | What it is | Step B |
|---|---|---|---|---|
| 2 | outside_sl | 192.168.1.254/24 | **StarLink**, behind the StarLink router (private) | → pair, CARP easy (private range) |
| 3 | outside_vf | 192.168.3.254/24 | **Vodafone**, behind the Vodafone router (private) | → pair, CARP easy |
| 4 | outside_bt | 81.143.32.194/29 | old BT Business via the radio — **dead** since BT moved direct to bev-fw (track 4 down 5 weeks) | **drop** |
| 6 | outside_fttb | **62.105.119.118/30**, gw .117 | **FTTB, main line** — /30 = only ONE usable public address | → pair, see §2 |
| 30 | dmz (sec 30) | 10.224.30.1/24 | DMZ: `proxy` 10.224.30.30, `opnsense_wan` (VM 101 IPsec) | → pair (internal VLAN) |
| 5 | ubnt_mgmt (sec 0) | 192.168.5.1/24 | airFiber radio management (Beverley routes 192.168.5.0/24 to HQ) | → pair (internal VLAN) |
| 250 | transit | 10.224.250.1/29 | link to the pair | removed at the end |

DMZ NATs today: proxy 443 on **bt + vf**, proxy 80 on **bt + vf** (none on FTTB → proxy is not reachable on the main line today); VM 101 IPsec UDP 500/4500 on **bt + vf + fttb**; dmz PAT on vf/sl/bt/fttb.

## 2. The FTTB question — one public address (/30)
CARP normally needs 3 addresses per line (a, b, shared). FTTB has only one. Options:
- **A. Ask the provider for a routed /29** (5 usable) → classic CARP on FTTB. Cleanest; may cost a little / take days.
- **B. CARP with private interface addresses + the public .118 as CARP VIP** (interface addresses e.g. 172.31.6.2/.3 /29 on VLAN 6, VIP 62.105.119.118/30, gateway 62.105.119.117 marked *far gateway*). Works with today's /30, full failover, no provider change. Eugene's pick if A is slow.
- C. FTTB on hq-fw-a only (no failover for the main line) — not recommended.

### New line on order (Raw/ screenshot, 11 Nov 13:37)
Giacom order **5020640**: **Sky Ethernet 1 Gb/1 Gb**, **/30 IP range**, managed router **Cisco C1111-8P**, site comms room ground floor Unit 32 (HQ), order category **Cat 1.1** (no indicative excess construction charges), next update in 10 working days (~25 Nov). Customer name on the order: "RMT Accountants & Business Advisors Ltd", end user "Fishbone drylining" — Minda to confirm the account name is intended.
**Consequence:** a /30 behind a provider router again gives ONE usable address → same problem as FTTB. **Cheapest moment to ask for a /29 (or /28) is now, before install.** If the /29 is granted, the Sky line can be the CARP-native tier-1 WAN and option B is only needed for FTTB.
**11 Nov:** Minda has asked the provider for a /29 — awaiting reply.
**12 Nov:** the /29 request is for the **new Sky line**: contract "Fishbone Drylining Fully managed Leased Line Service 1GB" with **RMT Technology** (signed via DocuSign 11 Nov; 5-year term per Minda) = Giacom order 5020640. RMT (Ben Caygill / Megan Hindmarch) asked for the reason (sent 12 Nov) and a provider change-request form; Eugene filled sections I-IV (/29 instead of /30 at installation, no downtime) and left it as a draft in minda@ for Minda to send. Wavenet FTTB (62.105.119.118/30) is unchanged — option B still applies to it. If the /29 is granted, the Sky line is the CARP-native tier-1 WAN.

## 3. Shape after Step B
- Gateway group (Minda 7 Nov order): **FTTB tier 1** (monitor 8.8.4.4) → **Vodafone tier 2** → **StarLink tier 3** (monitor 1.1.1.1); BT dropped. HQ ↔ Beverley backup path via bev-fw over VLAN 10 (BT Business at Beverley) — tier 4, later.
- Port forwards on FTTB: DocuSeal 80/443 → 10.224.10.60; PBX UDP 5080 → 10.224.13.9. Proxy + VM 101 IPsec only if still needed (§4).
- Outbound NAT hybrid on each WAN; MSS clamp 1452 (as ASA). Default deny inbound.
- ASA powered off, kept 30 days as roll-back, then archived.

## 4. Questions for Minda (before the day)
1. FTTB: option A (ask provider for /29) or B (private + far gateway)?
2. **proxy 10.224.30.30** (public 80/443 on BT/VF only today) — still used? If not, retire with the ASA.
3. **VM 101 IPsec** (UDP 500/4500 open on FTTB) — believed unused (OI-33). Power VM 101 off for a week first, then drop the forwards.
4. Admin logins for the StarLink and Vodafone routers (to check their LAN side / DHCP) — in 1Password?
5. A quiet day (office empty) — Step B takes the whole internet for ~10–20 min per line.

## 5. Same day: DS2246 shelf into the freed ASA slot (Minda, 11 Nov — reason: power + space)
- HQ ASA 5550 pair (2× 1U, below the 3850s) comes out after Step B → DS2246 (2U) goes into that space; ASAs kept 30 days on a shelf.
- pve-ai (Gen10 BJL, top of rack): free **slot 3** (primary riser, CPU1, x8, full-height) and slot 6 (secondary riser) under the P40s → **CP400e into slot 3** (check bracket is full-height). Check card temp in iLO after.
- SAS cable SFF-8644→QSFP **3 m**: ASA slot → pve-ai is ~10U (~45 cm) → reaches easily; route up the rack side with velcro, no tight bends.
- Shelf ~25–30 kg with 24 drives → needs rails or a support shelf (check the DS2246 rail kit is on hand).
- Order still open: R710 IT-mode HBA + 6 disks (size from the PBS datastore usage).
