# Runbook — HQ 2nd Tailscale subnet router on pve-nas/R710 (remote-access redundancy)

> **Eugene, 2026-10-28 (guide-only, §3).** Adds a **second, independent** Tailscale subnet router at HQ on
> **`pve-nas` (R710, `10.224.10.20`, Proxmox VE 9.2.2)**, as a backup to the existing **`hq-subnet-router`
> on the Gen9 (`10.224.10.10`)**. Today HQ's only remote-access node is on the Gen9 — the **brain**, which
> **powers down Saturday** (RAM/P40 fit) and power-cycles for experiments. One node = one lockout. This
> gives HQ the "2nd node per site" the Tailscale rollout flagged, so you keep remote access to HQ **even
> when the Gen9 is off.** Do it **before Saturday.**
> **Minda runs every command on the live host and holds the Tailscale account/keys; Eugene guides +
> verifies, holds no credential (§3).** No inbound firewall change. Based on the `tailscale-subnet-router`
> skill + `Runbooks/Runbook-Tailscale-Remote-Access-HQ-Beverley.md`.

## How redundancy works (why this is the right fix)
Two nodes advertising the **same** routes = Tailscale **active/standby failover**: it uses one as the
primary and **automatically fails over** to the other if it drops. So with `hq-subnet-router` (Gen9) and
this new node (pve-nas) both advertising the HQ subnets, HQ stays reachable if **either** box is up.

## Pre-flight
- [ ] Reuse the **existing Fishbone Tailscale account** (Google `minda@fishboneconstruction.co.uk`, MFA on) —
      don't make a new one.
- [ ] Run it **on the pve-nas Proxmox host directly** (always-on Debian, survives guest reboots).
- [ ] **Check the host actually routes the subnets first** (the dead-subnet gotcha): on pve-nas run
      `ip route` — you should see `10.224.10.0/24` + default via `10.224.10.1` (the ASA). The Gen9 node
      already advertises `10/13/20` successfully from the same VLAN/gateway, so pve-nas will too; advertise
      the **same three**, **excluding CCTV** (isolated).

## Steps (Minda runs on pve-nas `10.224.10.20`)

### 1. Install Tailscale
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```
**Proxmox gotcha:** the install's `apt-get update` aborts on the box's enterprise-repo 401s. The tailscale
repo is fine — finish directly:
```bash
apt-get install -y tailscale
```
(Confirm internet/DNS first: `ping -c1 1.1.1.1`, a working `nameserver` in `/etc/resolv.conf`.)

### 2. Enable IP forwarding
```bash
printf 'net.ipv4.ip_forward = 1\nnet.ipv6.conf.all.forwarding = 1\n' | tee /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf
```

### 3. Bring it up as the 2nd HQ subnet router
```bash
tailscale up \
  --advertise-routes=10.224.10.0/24,10.224.13.0/24,10.224.20.0/24 \
  --accept-dns=false \
  --hostname=hq-subnet-router-2
```
Authenticate at the printed browser link (or `--authkey=<key>` — Minda-held, never in git). Distinct
hostname `hq-subnet-router-2` so it's clear which is the backup.

### 4. Admin console (make it durable) — Minda, in the Tailscale admin console
1. On **`hq-subnet-router-2`** → **Edit route settings** → **approve** the advertised subnets (they don't
   route until approved). Both nodes advertising the same approved routes = the failover pair.
2. **Disable key expiry** on the node. ← critical; a drop while away locks you out.
3. (Optional) `tailscale set --auto-update`; ACLs to limit to Minda's devices.
4. Confirm it starts on boot: `systemctl is-enabled tailscaled` (should be `enabled`).

### 5. VERIFY — from genuinely OFF the site network (4G/hotspot, not inside the office)
- [ ] `tailscale status` shows **`hq-subnet-router-2` online** + the advertised routes.
- [ ] Reach a known HQ box, e.g. Proxmox **`https://10.224.10.10:8006`** (Gen9) and **`https://10.224.10.20:8006`** (pve-nas); normal internet still works (split-tunnel).
- [ ] **The real redundancy test:** briefly **stop the Gen9's router** (`tailscale down` on `10.224.10.10`,
      or it'll be off Saturday anyway) → confirm HQ `10.224.10.x` is **still reachable** via `hq-subnet-router-2`.
      Bring the Gen9 node back after. *(This proves you won't be locked out during Saturday's power-down.)*

## Gotchas (from the rollout — don't repeat)
- **Enterprise-repo 401 aborts the install** → the one-shot `apt-get install -y tailscale` above.
- **Don't advertise a dead subnet** — check `ip route` first (HQ once advertised a dead `10.224.11.0/24`).
- **Admin-UI reach ≠ routed:** reaching a box's web UI can still fail if *that box's* mgmt ACL refuses the
  router's SNAT source (the HQ ASA web at `10.224.10.1` refuses mgmt from the Tailscale source — per-box
  ACL issue, not a routing failure; Proxmox on the same subnet loads fine). If you want the ASA reachable
  via this node too, add `http 10.224.10.20 255.255.255.255 <inside>` on the ASA (guide-only, Minda).

## ⚠️ Not permanent — the anchor moves to the Gen10 later
pve-nas/R710 is the right 2nd node **now** because it's always-on as the interim storage/PBS. **But when
the R710 becomes the powered-off 3rd backup copy** (near-air-gapped, OI-26), it **can't be a remote-access
anchor** — a box that's dark between pulls is no lifeline. **Target state:** the permanent always-on anchor
is the **Gen10 storage spine** (24/7), with the **Gen9 as the secondary**. So when the Gen10 is up:
1. Add the subnet router to the **Gen10** (`hq-subnet-router` primary role), same steps.
2. **Remove** Tailscale from the R710 (or leave it only while the R710 is still kept powered on).
3. End state per site: **two always-on anchors that aren't the brain** — HQ Gen10 + Gen9; Beverley Gen10 +
   Lenovo — so neither site can lock you out when a box reboots.

---
_Guide-only (§3): Minda runs every command + holds the Tailscale account/keys; Eugene guides + verifies,
holds no credential. No inbound firewall change (split-tunnel, NAT-traversal). Interim 2nd HQ node on
pve-nas now → Gen10 becomes the permanent anchor. Pairs with the `tailscale-subnet-router` skill + RND-5._
