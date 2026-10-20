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
- **ONE Cisco ASA** (not a pair) · **ONE Cisco Catalyst 3850** (not a stack) · **UPS** ·
  **Ubiquiti UniFi controller** (held) · **small server running Proxmox**.
- **This is the HQ stack in miniature — and the EASY version.** The two biggest HQ time-sinks DON'T
  apply here:
  - **Single 3850 → no stack, no StackWise cables, almost certainly no `CSCvj49423` console-flood bug.**
    Straightforward bootloader password recovery, then rebuild the access VLANs from the UniFi map.
  - **Single ASA → no failover pair.** Direct console password recovery; no controlled-failover needed
    to reach config.
- The entire HQ recovery playbook + hard-won lessons apply directly, minus the two hard parts — so
  Beverley should be markedly faster than HQ (we *learned* at HQ; here we *execute*).

### HQ playbook → Beverley (device by device)
| Device | Proven HQ method to reuse |
|---|---|
| Catalyst 3850 | bootloader password-recovery; watch for StackWise `CSCvj49423` console flood; EEM timer auto-save to beat it; rebuild access VLANs from the UniFi/diagram map |
| ASA | read-only failover check first; gain config via controlled failover (no traffic drop); folink/statelink; `write memory` replicates |
| Proxmox box (**small PC, NO iLO**) | **Direct keyboard+monitor** (no out-of-band). Same root reset as HQ: GRUB → `init=/bin/bash` → remount rw → `passwd root` → remove contractor SSH keys → reboot. **Back up VMs first.** iLO only mattered for *remote* access — not needed for an on-site recovery. Optional later: a **PiKVM / IP-KVM (~£100)** gives iLO-style remote console+power on a plain PC; Proxmox web UI is remote over the VPN once up. |
| UPS | inventory/label; fold into the backup-power picture (OI-7) |
| UniFi controller | already held — use it for the recon map (below) |

### Readiness for next weekend (Minda on night shifts next week)
- **Pre-stage:** Eugene drafts `Runbooks/Runbook-Beverley-Place-Recovery.md` (mirror of the HQ runbook,
  Beverley specifics filled from the UniFi recon) **before** the weekend — so it's execution, not
  figuring-out.
- **Step 1 (any quiet moment):** UniFi controller → screenshot Devices + Clients → build the device map,
  name the Proxmox server + its mgmt IP, confirm the ASA/3850 mgmt addresses.
- **Then on the visit:** work the table above, document → reset creds to Minda's vault → back up.
- This also delivers the **RND-3 off-site replica node** (the Proxmox box becomes the ZFS replica +
  the Beverley AI node, RND-2).
- **Small-PC implications (flag for RND-2/RND-3, not blockers):** a Tesla **P40 likely won't fit** an
  SFF/small case (big, hot, double-wide, server-airflow) — so Beverley's AI node is probably **CPU-only
  (small failover model)** or a **low-profile GPU** (e.g. RTX A2000); and **fewer drive bays** → the
  replica holds the *critical* data (which is what an off-site copy should be anyway). **Decide once we
  see the box** — a photo + the UniFi recon will tell us the case size, disks, and slots.

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
