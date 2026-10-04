# RND-4 — Regain control of Beverley Place (castle #2)

_R&D working notes (git-primary). Status: **exploring**. Prerequisite for RND-3's off-site replica.
Guide-only — recon is read-only; Minda executes every live step; Eugene never holds a credential.
Legitimate recovery: Minda owns the site (6 Beverley Place, the registered address / her home)._

## Situation
Second Fishbone site, VPN + airFiber-linked to HQ; own 1 Gb FTTP; small server rack; hosts the UniFi
controller; runs IP telephony. **No access codes held — except the Ubiquiti UniFi controller.** Same
contractor-lockout pattern as HQ (which we recovered 2026-10-01/02). Needed to host the RND-3 off-site
ZFS replica.

## Confirmed kit (Minda, from memory, 2026-10-04) — SAME as HQ
- **Cisco ASA** (firewall) · **Cisco Catalyst 3850** (switch) · **UPS** · **Ubiquiti UniFi controller**
  (held) · **small server running Proxmox**.
- **This is the HQ stack in miniature.** The entire HQ recovery playbook + hard-won lessons apply
  directly — Beverley should be far faster than HQ (we were *learning* at HQ; here we're *executing*).

### HQ playbook → Beverley (device by device)
| Device | Proven HQ method to reuse |
|---|---|
| Catalyst 3850 | bootloader password-recovery; watch for StackWise `CSCvj49423` console flood; EEM timer auto-save to beat it; rebuild access VLANs from the UniFi/diagram map |
| ASA | read-only failover check first; gain config via controlled failover (no traffic drop); folink/statelink; `write memory` replicates |
| Proxmox server | iLO/console reset, remove contractor SSH keys, **back up VMs first**, then reset root; check what it hosts (telephony? storage?) |
| UPS | inventory/label; fold into the backup-power picture (OI-7) |
| UniFi controller | already held — use it for the recon map (below) |

### Readiness for next weekend (Minda on night shifts next week)
- **Pre-stage:** Eugene drafts `Runbooks/Runbook-Beverley-Place-Recovery.md` (mirror of the HQ runbook,
  Beverley specifics filled from the UniFi recon) **before** the weekend — so it's execution, not
  figuring-out.
- **Step 1 (any quiet moment):** UniFi controller → screenshot Devices + Clients → build the device map,
  name the Proxmox server + its mgmt IP, confirm the ASA/3850 mgmt addresses.
- **Then on the visit:** work the table above, document → reset creds to Minda's vault → back up.
- This also delivers the **RND-3 off-site replica node** (the Proxmox server there becomes the ZFS
  replica + the Beverley AI node, RND-2).

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
