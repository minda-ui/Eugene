---
name: opnsense-site-cutover
description: Plan and guide a site firewall cutover from a Cisco ASA to OPNsense, window by window, with exact lines, tests and roll-back for each step. Two modes - A, a straight swap of one box (Beverley-style, one ASA to one OPNsense); B, a phased per-VLAN migration behind the old firewall through a transit VLAN to a CARP pair (HQ-style, then Step B moves the WANs and retires the ASA). Use whenever Minda says "swap the firewall", "cut over to OPNsense", "move VLAN X to the new firewall", "HQ window N", "Step B", "retire the ASA", "put the WANs on the pair", or plans a new site's firewall replacement. Guide-only (charter section 3) - Minda runs every live step in an agreed window and holds every credential; Eugene writes the exact lines and the roll-back, then reads the output and verifies. Built 2026-11-11 from the Beverley swap (10 Nov) and HQ windows 0-4 (11 Nov).
---

# OPNsense site cutover (ASA → OPNsense, one window at a time)

Sources of truth (read the one for the site before writing any lines):
`Runbooks/Plan-OPNsense-Beverley-Translation-AWT-1069c.md` (Mode A, SWAP LOG at the end),
`Runbooks/Plan-OPNsense-HQ-Translation-AWT-1069b.md` (Mode B, §10–§11 window log),
`Runbooks/Plan-OPNsense-HQ-StepB-WANs.md` (Step B), `Runbooks/Runbook-OPNsense-Install-ASA5525X.md` (box build).

**Guide-only (§3).** Minda clicks/types every live step in a window she agreed; Eugene dictates screen by
screen, writes the ASA/3850 lines **and their roll-back before the window**, reads every output, and
logs it. Eugene never holds a secret — CARP passwords, root, PPPoE, SIP and config backups live in
Minda's 1Password; the plan names the 1Password entry, never the value.

## Pick the mode
| | **Mode A — straight swap** | **Mode B — phased behind the old firewall** |
|---|---|---|
| When | One firewall, small site, a short outage is fine | HA pair wanted, many VLANs, phones/servers can't all go at once |
| Shape | Build the box on the bench with the full config → move the cables → test | ASA keeps internet/NAT/DMZ; new **transit VLAN** (e.g. 250, /29: ASA .1, fw-a .2, fw-b .3, **CARP .4**); each window moves VLANs onto the pair (CARP **.1** = same gateway, boxes **.252/.253**) and the ASA routes them to `.4` |
| Roll-back | Power off new box, cables back (2 min); old box kept 30 days | Per window: un-shut the ASA sub-interface, re-enable its DHCP, swap NAT/route back, remove VLAN from the pair's trunk |
| Finish | Old box out, 30 days on a shelf | **Step B:** WANs + DMZ onto the pair, ASA off (30 days), then archived |

## Pre-check (every mode, before the first window — read-only)
1. **Live re-read of the ASA (Rule C):** `show run interface`, `show route`, `show nat`, `show run dhcpd`,
   `show run access-list`, `show failover` (HQ's prompt `…/sec/act` = secondary unit active). Diff against
   the export the plan was written from; rewrite lines if anything drifted.
2. **Switch:** `show etherchannel summary`, `show interfaces trunk`, `show ip interface brief` — **list every
   SVI in every VLAN you'll address, at BOTH sites if the VLAN is bridged** (Beverley↔HQ VLANs 10/11 ride
   the radio). Any `.252/.253` (or other planned box address) already used → pick another first.
3. **Admin path plan:** write down how Minda reaches each box's GUI **after** this window (see traps 7–9).
   Never rely on a path that runs through the VLAN being moved.
4. **Box hygiene:** Dnsmasq **disabled** (Services → Dnsmasq) on every box; Kea is the only DHCP.
   NTP on. Gateways defined (upstream/priority deliberate — lower number wins).
5. **Source NAT** (26.7: Firewall → NAT → **Source NAT**, Automatic/Hybrid): confirm which interfaces got
   auto rules (see trap 1–2).
6. Inventory to hand: DHCP pools + options (e.g. option 43 UniFi), MAC reservations (`show dhcpd binding`),
   static routes, port-forwards, which nets are NATed and which must not be.
7. Encrypted config backup of every box → 1Password before the window.

## Mode A — straight swap recipe (Beverley, 10 Nov)
1. **Bench build** all of it (LAGG, VLANs with the same gateway addresses, Kea pools + reservations,
   routes, rules, Source NAT, gateways + priorities, Tailscale for remote admin). Eugene reviews screenshots.
2. Photo + label the old box's cabling (which cable is Po1 member A/B).
3. Power off old ASA → move the port-channel cables to the LAGG members → power on new box.
4. Run the test matrix. 5. Roll-back if a core test fails: power off, cables back, power on old box.
6. Close-out the same evening: gateway switching ON (System → Settings → General) + monitor IPs; tighten
   temporary admin rules; shut + label freed switch ports (`write memory`); backup → 1Password.

## Mode B — per-window recipe (HQ, 11 Nov)
**Window 0 — transit only, nothing moves.** 3850: `vlan 250`; `interface Po<ASA>` / `switchport trunk
allowed vlan add 250`; new Po per box (LACP active), **trunk allowed 250 only** (adding a not-yet-moved
VLAN would make the pair's CARP .1 clash with the ASA's .1). ASA:
```
interface Port-channel1.250
 description transit to OPNsense
 vlan 250
 nameif transit
 security-level 100
 ip address 10.224.250.1 255.255.255.248 standby 10.224.250.5
```
Pair: TRANSIT .2/.3, CARP .4, gateway ASA_TRANSIT (.1; not upstream at first, monitoring off), a TRANSIT
pass rule for ICMP + the ASA-side nets alias. Test: ASA pings .2/.3/.4. Check `show etherchannel summary`
— all members `(P)`, Po `SU` (HQ: 3 of 4 legs first landed in the wrong ports).

**Windows 1…N — one VLAN group each** (rehearse with guest first; phones last, phones-free slot):
1. *Pair first (no traffic yet):* interface address .252/.253, CARP VIP .1 (VHID = VLAN id), Kea subnet
   (pool, routers = **CARP .1**, DNS, lease), rules (block rows above pass rows), Source-Routing gateway
   ASA_TRANSIT on pass-to-internet rules where the default route isn't the ASA yet. Apply on a; sync to b.
2. *ASA lines* (Eugene writes them from the live config that morning):
```
no dhcpd enable <nameif>
interface Port-channel1.<vlan>
 shutdown
route transit 10.224.<x>.0 255.255.255.0 10.224.250.4
no nat (<nameif>,outside_<w>) source dynamic <net_obj> interface      ! per WAN
nat (transit,outside_<w>) source dynamic <net_obj> interface          ! per WAN
```
   Port-forwards/object NATs for hosts in that VLAN move to `(transit,outside_*)` / `(outside_*,transit)`;
   add a matching TRANSIT pass rule on the pair (e.g. UDP any → PBX 5080, TCP → DocuSeal 80/443).
   Routes the ASA had *via* that VLAN (e.g. Beverley nets via 10.224.10.254) move to the pair as gateways +
   static routes; the ASA keeps them `route transit … 10.224.250.4`.
3. *3850:* `interface Po5` / `switchport trunk allowed vlan add <vlan>` (and Po6). Confirm no SVI for that
   VLAN on the 3850 that would duplicate the gateway.
4. *Kick ARP:* CARP toggle (Interfaces → Virtual IPs → Status → Temporarily Disable → Enable) to send
   GARPs; from the far site ping the moved gateway **from the right source** (e.g. bev-fw → PBX via HQMGMT).
5. *Test matrix* (below). Backup box checks: all VIPs **BACKUP** on fw-a or fw-b as designed.
6. *Only after tests pass:* `write memory` on ASA + 3850; encrypted backup of fw-a → 1Password.
   `no interface Port-channel1.<vlan>` only after 7 days stable — keep the saved lines in the change-log.

**Roll-back (keep it written in the window block, valid until `write memory`):** 3850 `allowed vlan remove
<vlan>` on Po5/Po6; ASA sub-interface `no shutdown`, `dhcpd enable <nameif>`, `no route transit …`, remove
the transit NATs, restore the original NATs; set the VLAN interface on the pair to IPv4 None.

**After the last VLAN:** Kea HA (Control Agent + HA peers, add Kea to XMLRPC sync — trap 13), OOB VLAN,
tightening (one change at a time, a week later), outside-ACL clean-up, then **Step B**: WANs onto the pair
(CARP on private-range WANs; a /30 public line needs a routed /29 or CARP-VIP-public + private interface
addresses with a far gateway), DMZ + ubnt_mgmt as internal VLANs, port-forwards, MSS clamp 1452, gateway
group per Minda's tier order, ASA off 30 days. Whole internet drops ~10–20 min per line → office-empty day.

## Test matrix (per window — tick each, both directions where relevant)
| Test | How |
|---|---|
| DHCP from Kea, right gateway/DNS | client shows gw = CARP **.1**, DNS as planned; lease visible in Kea |
| Internet | browse/ping 1.1.1.1 from each moved VLAN |
| Isolation | guest/IoT can't reach mgmt (e.g. 10.224.10.x); blocked nets stay blocked |
| East-west | office ↔ servers (PVE :8006, Fishbone AI), CCTV live view, staff Wi-Fi |
| Cross-site | Beverley → moved subnet and back (ping from bev-fw / pve-bev) |
| Public forwards | DocuSeal from a phone on mobile data; other forwards from outside |
| Phones (SIP) | internal call, **outbound**, **inbound to the company number** (2-way audio), Beverley ext; **re-test inbound after 5 min** |
| HA | backup box all VIPs BACKUP; later: pull fw-a power → fw-b takes over, call stays up |
| Admin | GUI reachable on the planned admin path after the window |
| Logs | firewall live log: no unexpected blocks; switch `show logging` no `%IP-4-DUPADDR` |

## Post-steps (every window)
Change-log entry with lines applied + roll-back + test results; update the plan's window log;
`processed-items-ledger.md` row; `Infra-Inventory/` (addresses, VIPs/VHIDs, ports, Po numbers);
1Password backup confirmed; Hub row Response/Status; any new trap → this table.

## Traps (all hit for real, Nov 2026)
| # | Trap | What to do |
|---|---|---|
| 1 | **Source NAT auto rules only exist for interfaces with an interface gateway** — Beverley WAN2 had none, so failover to it would have had no NAT | Interfaces → WAN2 → **IPv4 gateway rules** = its gateway; re-check Source NAT lists every WAN |
| 2 | The interface towards the other site (HQMGMT) **must NOT be NATed** — HQ must see real Beverley IPs | Confirm Source NAT has no rule on it; add a "do not NAT" if Hybrid adds one |
| 3 | **Only ONE DHCP server.** Dnsmasq holds UDP 67 on *all* interfaces even if set to one → Kea `DHCPSRV_OPEN_SOCKET_FAIL … Address already in use`, clients "Couldn't get IP address" | Disable Dnsmasq; put **Kea on every interface incl. MGMT** (bench subnet too) |
| 4 | **Kea silently won't start** (red service, *empty* log) if Interfaces = "Nothing selected" or Enabled not ticked | Settings → Interfaces + Enabled + lease → Apply; empty log = settings never saved |
| 5 | Kea **"Auto collect option data" ON** hands out the box's own `.252` as router/DNS → no failover | Turn it **off**; set routers = CARP .1 explicitly |
| 6 | **An un-moved / bridged VLAN must have NO address on the new boxes.** Pair's TELEPHONY .252 made a connected route into an un-trunked VLAN (PBX 100 % loss); home-sw SVIs Vlan10/11 = .252 duplicated hq-fw-a (`%IP-4-DUPADDR … lagg0 MAC`) | IPv4 None until its window; check every SVI at **both sites incl. bridged VLANs** before assigning; watch `show logging \| include DUPADDR` |
| 7 | **Admin lockout:** admin traffic arriving via Tailscale/PVE1 or another path, replies leave via the box's own address in the client's subnet (staff Wi-Fi 10.224.20.128 vs unit 2's WIFI .252) → asymmetric, GUI dead | Admin from a VLAN **already moved** (HQ used guest Wi-Fi + temp rule, deleted after) |
| 8 | Permanent fix for 7 | **OOB VLAN 9** /29, em8 of each box + a jump port, access ports with **no SVI** (isolated); laptop static, no gateway |
| 9 | Deleting the old admin gateway fails while referenced | Clear **IPv4 gateway rules** on that interface first; after the change confirm the box still has a default route (unit 2 lost it → `route add default` on console, then fix upstream) |
| 10 | **First-match rule order** — a pass above a block wins | Blocks above passes; read the whole interface list after each add |
| 11 | Interface (rule) = **any** lands the rule in **Floating**, not the interface tab | Pick the interface; check where it saved |
| 12 | 26.7 field traps: port typed into **Source Port** instead of Destination Port (twice); "Interface (origin)" must be empty on in-rules; Invert Source vs Invert Destination; **Source Routing gateway** field on pass rules (policy routing via ASA_TRANSIT); **IPv4 gateway rules** on the interface (NAT + reply-to) | Re-open the saved row and read it back every time |
| 13 | **Kea HA peer port = Control Agent port (8000)** → Kea red on both, `kea-dhcp4 -t` still passes | Peers on **8001**, CA on 8000; add Kea to XMLRPC sync; compare leases on both |
| 14 | Gateway priority: **lower number wins** — a new gateway at 200 beat BT_BUSINESS at 255 and nearly cut Tailscale | Set the primary lowest (10) before adding others |
| 15 | Clients/far routers keep stale ARP for the old gateway MAC | CARP toggle (Temporarily Disable → Enable); ping from the far site from the right source interface |
| 16 | Rule made on fw-a doesn't act on fw-a until **Apply on a**; sync applies it on b | Apply, then sync, then test |
| 17 | Cables landed in the wrong switch ports; a suspended (`s`) member | `show etherchannel summary` before + after — all `(P)`, Po `SU` |
| 18 | `write memory` too early kills the cheap roll-back | Save ASA + 3850 **only after** the test matrix passes |
| 19 | **SIP:** inbound needs **UDP 5080** forward (+ outside ACL permit) to the PBX; ASA `inspect sip` must stay **off** | Test internal / outbound / inbound, **re-test inbound after 5 min** (NAT/registration timers) |
| 20 | "0… fails, +44… works" looked like a fault — it's the **SIP provider's rule** (+44 only) | Not network; optional FusionPBX outbound-route rewrite 0→+44 (Minda's call) |
| 21 | SIP 403 after a re-patch = credentials, not the network | Path check (ping PBX), then reset the extension's SIP password (1Password) |
| 22 | Removing **`permit ip any any`** from outside ACLs can break what relied on it | Add explicit permits first (DocuSeal 80/443, PBX UDP 5080), then remove; test public forwards **and an outbound + inbound call** |
| 23 | Kea subnet typed as host address (10.224.13.252/24) | Subnet must be the network (10.224.13.0/24) |
| 24 | ASA failover pair: changes replicate; know which unit is active | `show failover`; write mem on the active unit |
| 25 | A /30 public WAN has one usable address — no classic CARP | Ask for a routed /29 *before* install, or CARP VIP = public + private interface IPs + far gateway |

## §3 / safety
Every live step is Minda's, in a window she agreed, with the roll-back written down first. Eugene never
holds or records secrets (only the 1Password entry name), never runs a change himself, flags anything
irreversible (`no interface …`, ASA retirement, deleting branches/boxes) for Minda, and keeps old hardware
30 days as roll-back — archive, never discard.
