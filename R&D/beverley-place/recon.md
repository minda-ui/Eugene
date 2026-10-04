# RND-4 — Regain control of Beverley Place (castle #2)

_R&D working notes (git-primary). Status: **exploring**. Prerequisite for RND-3's off-site replica.
Guide-only — recon is read-only; Minda executes every live step; Eugene never holds a credential.
Legitimate recovery: Minda owns the site (6 Beverley Place, the registered address / her home)._

## Situation
Second Fishbone site, VPN + airFiber-linked to HQ; own 1 Gb FTTP; small server rack; hosts the UniFi
controller; runs IP telephony. **No access codes held — except the Ubiquiti UniFi controller.** Same
contractor-lockout pattern as HQ (which we recovered 2026-10-01/02). Needed to host the RND-3 off-site
ZFS replica.

## The foothold: the UniFi controller = the map
Even with no device passwords, the controller enumerates the whole LAN:
- **Devices** (UniFi gateway/switches/APs): models, IPs, port status, uptime.
- **Clients** (wired + wireless): hostname, IP, **MAC vendor** (→ HPE/Dell/Synology/QNAP = server/NAS),
  uplink. Identifies the **server rack contents** and any **management interfaces** (iLO/IPMI, NAS web
  UI, switch admin IP) to target.
- **Topology** + whether existing storage hardware could be the replica NAS, or we bring a box.

## Recon plan (read-only, before any visit)
1. **UniFi controller** — export/screenshot Devices + Clients; build the Beverley Place device map.
2. **From HQ over the VPN** — gentle, read-only discovery (ping/ARP/known-host checks) of reachable
   Beverley Place hosts to cross-check. No scanning that trips IDS; nothing changed.
3. Identify: the server/NAS, its mgmt interface, the switch(es), the gateway, the telephony endpoint.

## Assault (HQ playbook, on-site, when Minda visits)
Physical/console access → document running config → reset credentials into Minda's password manager →
back up. Then stand up / confirm the RND-3 replica NAS and the `zfs send/recv` over the VPN.

## Graduation
When Minda commits, this graduates to a real **recovery runbook** (`Runbooks/`) + an **OI-<n>** (same as
the HQ recovery), not an R&D note. Until then: recon only.

## Links
Prerequisite for RND-3 (off-site replica). Related: OI-7 (backups), HQ recovery change-logs 2026-10-01/02.
