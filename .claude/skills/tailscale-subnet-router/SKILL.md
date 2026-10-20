---
name: tailscale-subnet-router
description: Stand up (or verify) a Tailscale subnet router on a Proxmox/Debian host so a site's LAN becomes reachable remotely — split-tunnel, no inbound firewall change. Use whenever Minda wants remote access into a site (HQ, Beverley, a new site), a second/backup subnet-router node at a site, or asks to "add <site> to Tailscale", "get onto the <site> network remotely", "put a Tailscale router on <box>", or to check an existing subnet router is healthy. Guide-only (charter §3): Eugene writes the commands + verifies; Minda runs them on the live host and holds the Tailscale account/keys. Built 2026-10-11 from the HQ+Beverley RND-5 rollout.
---

# Tailscale subnet router (per site)

Remote admin into a site's LAN without opening any inbound firewall port. One **subnet-router** node per
site advertises that site's LAN /24s into the private Fishbone tailnet; Minda's laptop/phone join the same
tailnet and reach those subnets directly. **Split-tunnel** (only `10.224.x.x` over the tunnel — normal
internet is untouched) and **NAT-traverses outbound**, so **nothing is opened on the ASA**. This is RND-5,
graduated 2026-10-11; the full reference is `Runbooks/Runbook-Tailscale-Remote-Access-HQ-Beverley.md`.

**Guide-only (§3):** Eugene gives the commands and verifies; **Minda runs every command on the live host
and holds the Tailscale account + any auth keys.** No secret in git; Eugene never types a key.

## Before you start
- **Account:** one dedicated Fishbone Tailscale account (Google sign-in `minda@fishboneconstruction.co.uk`),
  **MFA on**. Already exists from the 2026-10-11 rollout — reuse it, don't make a new one.
- **Host choice:** run it on the **Proxmox host directly** (always-on Debian, survives guest reboots) —
  the resilient default. A small Debian VM is fine too; an LXC needs `/dev/net/tun` passed through (see the
  runbook Notes) so avoid LXC unless there's a reason.
- **Know the site's subnets.** Advertise the site's real LAN /24s, **exclude the CCTV VLAN** (isolated).
  Confirm against `Infra-Inventory/` / the site device-map, and glance at the host's `ip route` — only
  advertise subnets the host can actually reach (HQ once advertised a `.11.0/24` that was dead; see below).
  | Site | Advertise | 
  |---|---|
  | HQ | `10.224.10.0/24,10.224.13.0/24,10.224.20.0/24` |
  | Beverley | `10.224.110.0/24,10.224.111.0/24` |

## 1. Install (on the chosen host — Minda runs)
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```
**Known gotcha (Proxmox):** the install's `apt-get update` aborts on the box's **enterprise-repo 401s**.
The tailscale repo itself is fine — just finish the install directly:
```bash
apt-get install -y tailscale
```
Confirm internet + DNS first on a fresh host (`ping -c1 1.1.1.1`, a working `nameserver` in
`/etc/resolv.conf`) so there's no mid-install surprise.

## 2. Enable IP forwarding (needed to route LAN traffic)
```bash
printf 'net.ipv4.ip_forward = 1\nnet.ipv6.conf.all.forwarding = 1\n' | tee /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf
```

## 3. Bring it up as the subnet router
```bash
tailscale up \
  --advertise-routes=<this site's /24s, comma-separated> \
  --accept-dns=false \
  --hostname=<site>-subnet-router
```
Hostnames so far: `hq-subnet-router`, `bev-subnet-router`. Authenticate the node at the browser link it
prints (or `--authkey=<key>` — the key is Minda-held, never in git). `--accept-dns=false` keeps the site's
own DNS; split-tunnel is the default (no exit node).

## 4. Admin console (make it durable) — Minda, in the Tailscale admin console
1. On the new `<site>-subnet-router` → **Edit route settings** → **approve** the advertised subnets
   (they don't route until approved).
2. **Disable key expiry** on the node. ← **Critical.** Default keys expire (~180 days); any drop while
   Minda's away locks her out. Disabling expiry means the router never needs re-auth mid-trip.
3. (Optional) ACLs so only her devices reach the routes; `tailscale set --auto-update` to stay patched.

## 5. Devices (once per laptop/phone, not per site)
Install the Tailscale app, sign in with the **same** Google account, enable **"Use subnet routes"**, leave
**"Use exit node" OFF** (keeps split-tunnel). Laptop + phone (`mindessurface`, `works-s9`) are already
enrolled from the rollout.

## 6. VERIFY — from genuinely OFF the site network (the real test)
Do this from **4G / phone hotspot**, NOT from inside the office (inside you'd hit the box locally and prove
nothing):
- `tailscale status` shows the router **online** + the advertised routes.
- Open a known box on each advertised subnet, e.g. **Proxmox `https://<mgmt-ip>:8006`** (HQ
  `10.224.10.10`, Beverley `10.224.111.199`); reach the switch/iLO if on an advertised subnet.
- **Normal internet still works** while connected (split-tunnel confirmed).
- Only count it done when these pass **from off-network**.

## Gotchas learned (don't repeat)
- **Enterprise-repo 401 aborts the install** → the one-shot `apt-get install -y tailscale` above.
- **Don't advertise a dead subnet.** HQ advertised `10.224.11.0/24` which the host had no route to
  (`ip route` showed only `10.224.10.0/24` + default) — it just adds a dead route to un-approve later.
  Check `ip route` first.
- **Admin-UI reach ≠ routed.** Reaching a box's web UI over Tailscale can still fail if that box's own
  management ACL refuses the subnet-router's source IP (HQ ASA web at `10.224.10.1` timed out because the
  ASA refuses mgmt from the Tailscale SNAT source `10.224.10.10`; fix is on the ASA:
  `http <router-ip> 255.255.255.255 <inside>`). That's a per-box management-access issue, not a Tailscale
  routing failure — Proxmox on the same subnet loads fine.
- **Site-to-site links may not carry mgmt.** Don't try to set up a remote site *through* an inter-site
  link from another site — the HQ↔Beverley airFiber/IPsec didn't carry Beverley's mgmt subnet (ping to
  `10.224.111.199` from HQ = 100% loss). Do each site **on-site** (or where its LAN is directly reachable),
  especially a box with no out-of-band console (a remote slip locks it out).

## Lockout safeguards (when Minda will be away)
- **Second independent node per site** (a Pi / old laptop / 2nd VM) as a backup subnet router — cheapest,
  highest-value insurance; this skill is exactly how you add it.
- Confirm `tailscaled` starts on boot (`systemctl is-enabled tailscaled`); keep iLO reachable (on an
  advertised subnet) for out-of-band power-cycle; UPS on the host; one trusted on-site human to call.

## Guardrails (always)
- **Guide-only (§3):** Minda runs every command on the live host; Eugene writes + verifies. No live-system
  change by Eugene.
- **Never hold or type a Tailscale key** — it's Minda's; reference where it lives, never its value; nothing
  in git.
- **No inbound firewall change** — that's the whole point; if a step seems to need one, stop and rethink.
- **Exclude CCTV**; only advertise subnets the host actually routes.
