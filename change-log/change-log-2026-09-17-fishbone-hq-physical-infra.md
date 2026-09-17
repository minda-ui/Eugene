# Change log — 2026-09-17 — Fishbone HQ physical infrastructure documented; OI-7 raised

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4._

## 2026-09-17 — First physical/on-prem inventory built; critical finding on the phone system

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** New territory for Eugene: everything in `Infra-Inventory/` up to now has been cloud/
Workspace state. Minda began photographing the physical rack and site equipment at **Fishbone HQ**
(Unit 30–31, Point Pleasant Industrial Estate, Wallsend NE28 6HA) for Eugene to document properly.

**Walkthrough.** Identified piece by piece from photos and Minda's direct answers: an HP ProLiant
server; 2× Cisco ASA 5500-series firewalls (active/standby HA pair); 2× stacked Cisco Catalyst
3850-48 PoE+ switches with a full port map read from the site's own printed "Fishbone Network diagram"
(CCTV/CCTV Recorder/iLO/IP Telephony/Computers+Printers/WiFi AP ranges); a site floor plan; 5 indoor +
1 outdoor Ubiquiti UniFi AP; a multi-band cellular signal repeater with an outdoor donor antenna; 2×
Ubiquiti airFiber AF-5 radios on the same mast (1 active, 1 spare); 2× Yealink T48S IP phones; a Xerox
VersaLink C415 MFP; a meeting-room AV setup (Surface Pro 6 "MeetingRoom" + Samsung WA65C + USB mic); a
Hikvision DS-9632NI-M8 32-channel NVR with 16 cameras; an Openreach ADVA FSP150 WAN termination (1Gb/1Gb
leased line); 2× APC Smart-UPS 2200 covering the whole rack; and a Starlink dish as WAN backup.

**Second site discovered.** The airFiber bridge (583m, link "FISHBONE") turned out to be a **private
link to Fishbone's registered address, 6 Beverley Place, Wallsend NE28 7BH — Minda's home** — not a
commercial WAN circuit. That site has its own 1Gb FTTP fibre, a small server rack, hosts the UniFi
controller, and runs IP telephony too. A separate **IPsec VPN between servers at both ends** provides a
resilient fallback if the wireless bridge drops.

**Critical finding — OI-7.** The HQ ProLiant is confirmed running **FusionPBX** (self-hosted, Debian
12, `10.224.13.9`) — the entire company's phone system for both sites — with **no backup and no
support contract**. Genuine single point of failure for company-wide telephony. Investigated the access
situation in detail: Minda has full FusionPBX application-level access (not a total lockout), but no
OS-level (SSH/console) access. Gave prioritised, credential-free recovery guidance (ask the original
contractor first, then check for an HPE iLO default-password tag on the chassis). Confirmed via console
observation (no login) that the OS is Debian 12 — standard, well-documented, not exotic. **Ruled out a
built-in-backup shortcut**: walked through FusionPBX's Advanced menu, Applications menu, and the
55-module Modules page — no Backup feature exists on this install at all. OI-7 now narrows to a single
blocker: getting OS-level access, after which Eugene drafts the actual Debian/FusionPBX backup runbook.

**Governance note.** Minda asked whether Eugene could take over servicing the ASA firewalls directly.
Answered honestly: no, on two counts — Eugene has no network-device connector at all (no SSH/CLI/ASDM),
and even if he did, firewall changes are squarely "guide-only for live systems" territory (charter §3),
arguably more sensitive than the DNS/Google Admin changes that boundary already covers. Minda confirmed
she's the hands-on executor for network changes going forward (she built this entire network herself
under remote guidance from a contractor); Eugene stays on documentation/advisory/runbook-drafting, same
division as everything else.

**Walkthrough closed out.** Remaining open items resolved one by one: mast antenna confirmed as the
cellular repeater's donor antenna (the airFiber radios are separate, on the same mast); CCTV confirmed
at 16 cameras (13 building + 3 outside), remote-viewable via the Hikvision app over VPN only, on its own
isolated VLAN with no local-network access; two SSIDs confirmed — `FSG0218` (full access, restricted to
Minda + Andrejus) and `Fishbone` (limited access, general use) — superseding the older floor-plan
legend's apparent three-zone scheme; UPS confirmed covering the whole rack, not just the WAN/NVR shelf.

**Produced.** `Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md` (v1) — full record for both
sites: rack-by-rack inventory at HQ, the inter-site link, a WAN table, and a dedicated "security
posture" section calling out the several sound design choices observed (HA firewalls, three independent
WAN paths, VLAN-isolated CCTV, VPN-gated remote camera access, a restricted admin SSID, a spare radio,
inter-site VPN fallback) rather than just listing facts neutrally. `open-issues.md` OI-7 raised, then
escalated to critical, then narrowed to its current single blocker, across several updates through the
day. `external-source-register.md` gained SRC-10 (FusionPBX), SRC-11 (UniFi Controller), SRC-12 (Cisco
ASAs), all marked guide-only — Eugene holds no connector to any of them.

**Governance.** Documentation and advisory only throughout — no live-system change made or attempted by
Eugene. Personal data handled carefully: a home address (6 Beverley Place) was recorded because Minda
disclosed it herself for the express purpose of documenting real network infrastructure at that
location; unrelated personal items spotted incidentally in photo backgrounds (mail addressed to someone
else, business cards) were explicitly not transcribed.

**Next.** Outstanding: (1) OI-7 — Minda pursues OS-level access to the ProLiant (contractor or iLO tag),
Eugene drafts the backup runbook once there's visibility; (2) Beverley Place rack — full device-level
inventory still to do, same depth as HQ; (3) WAN failover mechanism (automatic vs manual across
Openreach/Starlink/Beverley-Place-fibre) — not yet confirmed.
