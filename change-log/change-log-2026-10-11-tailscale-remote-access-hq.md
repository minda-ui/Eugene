# Change log — 2026-10-11 — Remote access via Tailscale: HQ live (RND-5 graduated)

_Minda is away ~3 weeks (leaves in ~3 days) and needs remote admin into both site LANs. Chose Tailscale
over self-hosted Headscale (too much to rush) and the ASA native VPN (the one that full-tunnelled + broke
her internet before). Guide-only (§3): Eugene wrote the runbook + guided each command live; Minda executed
on the live Proxmox host and holds the Tailscale account + keys. No secret held by Eugene._

## What went live (HQ)
- Tailscale **1.104.1** installed on the **HQ Proxmox host** (`10.224.10.10`). (Install script aborted on
  the pre-existing Proxmox **enterprise-repo 401s** during `apt-get update`; fixed with a direct
  `apt-get install -y tailscale` — the tailscale repo itself fetched fine.)
- IP forwarding enabled (`net.ipv4.ip_forward=1`, v6 too).
- Brought up as **`hq-subnet-router`** advertising **`10.224.10.0/24, 10.224.13.0/24, 10.224.20.0/24`**
  (CCTV VLAN deliberately excluded), `--accept-dns=false`, split-tunnel.
- Admin console: **routes approved** (all three green) + **key expiry disabled** (critical for the
  3-week unattended window).
- Minda's **laptop (`mindessurface`, Win11)** and **phone (`works-s9`, Android)** were already enrolled on
  the tailnet — just need "use subnet routes" toggled (laptop done).
- **Verified from off-network (phone 4G hotspot):** `https://10.224.10.10:8006` (Proxmox) loads, routes
  green, normal internet still works (split-tunnel confirmed). **HQ remote access is live and proven.**

## Why this design (recorded)
- **No inbound firewall change** — Tailscale NAT-traverses outbound, so nothing opened on the ASA (vital
  while away, can't fix a broken rule remotely).
- **Split-tunnel** — only `10.224.x.x` over the tunnel; internet stays local. No repeat of the old VPN.
- Tailscale now; **self-hosted Headscale (sovereign, RND-5)** kept as the later migration.

## Beverley — DONE (on-site, later same day) ✅
Minda returned to Beverley and we set it up on-site (the right call — the box has no out-of-band).
- Tailscale **1.104.1** on the Beverley Proxmox host (`10.224.111.199`, **PVE 9.1.1 / Debian 13 trixie**).
  Internet + DNS confirmed first (`ping 1.1.1.1` ok, `nameserver 1.0.0.1`), so no DNS hiccup. Install one-shot
  (`curl install.sh | sh` then `apt-get install -y tailscale` to cover the enterprise-repo abort).
- IP forwarding on; brought up as **`bev-subnet-router`** advertising **`10.224.110.0/24,10.224.111.0/24`**.
- Routes **approved** + **key expiry disabled** in the console.
- **Verified from 4G: `10.224.111.199:8006` (Beverley Proxmox) loads.** ✅
- **BOTH SITES NOW LIVE** — full remote admin into HQ + Beverley before the ~3-week absence.

## (superseded) Beverley remote-from-HQ attempt — pending, on-site
Tried to set Beverley up **remotely from the HQ host** over the inter-site airFiber/IPsec link —
**`ping 10.224.111.199` = 100% loss**, so the link does not carry Beverley's management subnet to this
host (only the phone path). Not pursued remotely (the Beverley Proxmox has **no out-of-band console** —
a remote slip would lock it out). **Plan: do Beverley on-site** (it's Minda's home) with the same runbook
sequence (`--advertise-routes=10.224.110.0/24,10.224.111.0/24`, hostname `bev-subnet-router`).

## Follow-ups (not blocking)
- Phone: enable "use subnet routes".
- Optional perf: `ethtool -K mgmt0 rx-udp-gro-forwarding on rx-gro-list off` (+ persist) for the UDP-GRO warning.
- Lockout safeguards per the runbook: confirm tailscaled starts on boot (it does, enabled); consider a
  2nd independent node per site; reboot-recovery test before leaving.
- MFA on the Fishbone Tailscale account (flagged to Minda).

## Artefacts
`Runbooks/Runbook-Tailscale-Remote-Access-HQ-Beverley.md` (the runbook), `R&D/graduation-register.md`
(RND-5 graduated 2026-10-11), ledger row 97.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
