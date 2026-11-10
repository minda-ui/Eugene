# Plan — automated config backups for the switches and firewalls (v0.1)

**Date:** 2026-11-10. **Author:** Eugene. **Status:** draft for Minda; nothing is built until she approves.
**Guide-only (§3):** Minda creates every account, key and password (1Password, vault Fishbone IT) and runs every live step. Eugene writes the config and checks the result. No secret ever goes into this repo.

## Why
Tonight's swap showed it: a firewall config changes several times in one evening, and the only copy was a manual download. One dead SSD or a bad click and the work is gone. Switch configs (HQ 3850 stack, Beverley home-sw) have never been backed up at all.

## Design — pull, versioned, on our own kit
Same rule as OI-26: **the backup host pulls; devices never push and hold no credentials to the store.**

| Part | Choice | Why |
|---|---|---|
| Collector | **Oxidized** in a small Debian LXC **`netbackup`** on **pve-ai** (HQ, always on; will also hold the primary PBS once the shelf moves) | Open source, built for exactly this, supports IOS-XE, ASA and OPNsense, keeps every version in a **local git repo** with diffs ("what changed last Tuesday?") |
| Schedule | Every night ~02:30 + on demand | After the 02:00/03:00 VM backups start, quiet time |
| Storage | Local git repo inside the LXC — **never pushed to GitHub** (configs contain password hashes, keys, PSKs) | Secrets stay on our hardware |
| Copies | The LXC is in the nightly PBS job → PBS copies → Beverley + R710 (3-2-1 like everything else) | No extra plumbing |
| Alerting | Oxidized marks a device red when a pull fails; later: a daily "last good backup" check in the read-only health routine | Silent failures are the real risk |

## Devices and how each is read (read-only where the device allows it)
| Device | Address | Method | Account |
|---|---|---|---|
| HQ 3850 stack | 10.224.10.4 | SSH, `show running-config` | local user `oxidized`, SSH key only, ACL: only from `netbackup` |
| Beverley home-sw 3850 | 10.224.110.4 | same, over the radio | same |
| hq-fw-a / hq-fw-b | OOB / MGMT addresses after go-live | **OPNsense API** `GET /api/core/backup/download/this` (encrypted export if supported) | dedicated API user with **only** the backup privilege, key+secret |
| bev-fw | 10.224.10.254 (HQMGMT) | same API | same |
| HQ ASA 5550 (until retired) | 10.224.10.1 | SSH, `more system:running-config` | read-only-ish user, retire with the box |

Notes:
- Cisco `show running-config` needs privilege 15 to show the full config; the `oxidized` user is restricted by **SSH key + source ACL + no password login**, and its use is visible in the switch log.
- OPNsense API user: no GUI login, no shell; firewall rule on each box allows HTTPS from `netbackup` only.

## Steps (when approved)
1. Minda: create LXC `netbackup` on pve-ai (Debian 13, 1 core, 1 GB, 8 GB disk, VLAN 10 address, e.g. 10.224.10.40), add it to the nightly backup job.
2. Eugene: install script + Oxidized config (device list, models, schedule) — reviewed here before Minda runs it.
3. Minda per device: create the `oxidized` user / API key (secrets typed straight into the LXC with `read -rs`, stored in 1Password).
4. First pull, check every device shows green and the git log has one commit each.
5. Test restore drill on the bench box (old ASA unit 4 or a spare): take a pulled OPNsense config, restore it, confirm it boots.

## Open for Minda
1. OK to run it on **pve-ai** (recommended) — or on pve-bev?
2. Keep the HQ ASA in the list until it is retired? (Eugene: yes.)
3. Nightly is enough, or also every 6 h during busy weeks like this one?
