# Change log — 2026-11-10 (Tue, Minda at Beverley) — bev-fw remote access + password reset into 1Password

_Guide-only (§3). Minda generated and holds every secret (1Password vault **Fishbone IT**); Eugene never saw a value._

- **bev-fw (unit 3) on Tailscale:** `os-tailscale` plugin, single-use auth key (1Password), IP **100.84.154.117**, key expiry disabled. tailscale0 assigned as opt1 TAILSCALE; rule pass TCP 100.64.0.0/10 → This Firewall :443. webGUI verified from the phone on mobile data → bench build can be done remotely. Gotchas: "Interface (origin)" only for out-rules; `/10` dropped into Source Port.
- **New passwords (all generated in 1Password, changed on device, tested in a private window):** pve-ai root, pve-bev root, pve-nas root (+PBS :8007), Gen9 `pve` root, **Gen9 iLO** (login name is `root`, display name "Administrator"; reset in-band with `ipmitool user set password 1` → **OI-31 resolved**), bev-fw root (+ encrypted config backup attached with its own key), Fishbone AI admin (reset in the Open WebUI DB; web-shell paste added hidden codes on the first try).
- **Moved into Fishbone IT:** PBS tokens gen9-backup + pveai-backup, BT Business hub admin (were in the phone's Samsung Secure Folder).
- Gen9 iLO address corrected in the inventory: static **10.224.10.21** (not .50).
- **bev-fw bench build stages 2–6 DONE remotely over Tailscale** (lagg0 em7+em2, 6 VLAN interfaces, Kea DHCP 4 subnets + 4 reservations, 6 routes to HQ via HQ_RADIO, 7 rules + RFC1918 alias, auto source NAT, gateways BT_BUSINESS 10 / BT_RESIDENTIAL 200 / HQ_RADIO 250 + WAN_FAILOVER group). Final encrypted config backup in 1Password (template for units 1, 2, 4). Details: Plan AWT-1069c bench-build log.
- Still open: pve-ai iLO (BJL) password + pve-bev iLO setup at next on-site visit; bev-fw **swap** at Beverley (quiet window): Po1 cables → Gi0/1+Gi0/2, monitoring + gateway switching on, tests, old ASA kept 30 days.
