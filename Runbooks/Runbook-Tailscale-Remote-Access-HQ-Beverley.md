# Runbook — Remote access to HQ + Beverley via Tailscale (split-tunnel, no firewall change)

> **Purpose:** give Minda reliable remote admin access to **both** site LANs (HQ + Beverley) while away
> for ~3 weeks, from laptop + phone — without opening any inbound firewall port and without full-tunnelling
> her internet (the failure of the old Fishbone VPN). **Graduates RND-5.**
>
> **Status:** active build, created 2026-10-11. Minda leaves in ~3 days → **build + fully test on-site now.**
> **Guide-only (§3):** Eugene wrote this; **Minda executes every step on the live kit and holds every
> secret** (Tailscale account + auth keys). No secret in git.

## How it works (1 paragraph)
Tailscale is a WireGuard mesh. We put one **"subnet router"** node at each site that advertises that site's
LAN subnets into your private tailnet. Your laptop/phone join the same tailnet and reach those subnets
directly. It's **split-tunnel** (only the `10.224.x.x` estate subnets go over it — your normal internet is
untouched) and it **NAT-traverses outbound**, so there is **nothing to open on either ASA**. Traffic is
end-to-end encrypted; Tailscale's servers broker the connection but can't read it.

## Site subnets each router advertises (confirmed from Infra-Inventory + Beverley device-map)
| Site | Advertise routes | Reaches |
|---|---|---|
| **HQ** | `10.224.10.0/24,10.224.13.0/24,10.224.20.0/24` | Proxmox `10.224.10.10:8006`, iLO `.78`, 3850 `.4`, PBX `10.224.13.9`, phones, WiFi |
| **Beverley** | `10.224.110.0/24,10.224.111.0/24` | Beverley Proxmox `10.224.111.199`, Cloud Key `10.224.110.5`, ASA/3850/UniFi |
> ⚠️ Before finalising, glance at each site's UniFi/ASA for any extra VLAN/subnet you want to reach and add
> it to that site's list. CCTV VLAN is deliberately **excluded** (isolated).

---

## Part 0 — Account (do first)
1. Create a **dedicated Fishbone Tailscale account** at tailscale.com — sign in with **Google
   (minda@fishboneconstruction.co.uk)**. (Not a personal account — this is estate infra.)
2. **Turn on MFA** on that login.
3. Admin console → **Settings → Keys** → generate an **auth key** for enrolling the routers:
   **Reusable**, **Ephemeral = OFF**, set a **tag** `tag:router` (optional). This key is a **secret —
   Minda-held**, used only during setup, not stored in git.

## Part A — HQ subnet router
Pick ONE host to run it on (resilience order): **(a) the Proxmox host directly** (recommended — always-on
Debian, survives guest reboots), or (b) a dedicated small Debian VM/LXC, or (c) a spare Pi/old laptop on
the LAN. For an LXC you must pass through `/dev/net/tun` (see Notes); the host or a VM avoids that.

On the chosen HQ host (Debian/Proxmox shell — Minda runs):
```bash
# 1. install
curl -fsSL https://tailscale.com/install.sh | sh

# 2. enable IP forwarding (needed to route LAN traffic)
printf 'net.ipv4.ip_forward = 1\nnet.ipv6.conf.all.forwarding = 1\n' | sudo tee /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# 3. bring up as the HQ subnet router (advertise HQ subnets; keep your own DNS)
sudo tailscale up \
  --advertise-routes=10.224.10.0/24,10.224.13.0/24,10.224.20.0/24 \
  --accept-dns=false \
  --hostname=hq-subnet-router
```
(Authenticate the node when prompted — browser link, or `--authkey=<the key>`.)

## Part B — Beverley subnet router
Same, on an always-on host at Beverley (the recovered Beverley Proxmox is ideal):
```bash
curl -fsSL https://tailscale.com/install.sh | sh
printf 'net.ipv4.ip_forward = 1\nnet.ipv6.conf.all.forwarding = 1\n' | sudo tee /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
sudo tailscale up \
  --advertise-routes=10.224.110.0/24,10.224.111.0/24 \
  --accept-dns=false \
  --hostname=bev-subnet-router
```

## Part C — Your devices (laptop + phone)
1. Install Tailscale (Windows/macOS app, or iOS/Android app), sign in with the **same** Google account.
2. **Accept subnet routes** so you can reach both LANs:
   - Laptop (Linux): `sudo tailscale up --accept-routes`
   - Windows/macOS app: toggle **"Use Tailscale subnet routes"** ON.
   - Phone app: enable **"Use subnet routes"** in settings.
3. Leave **"Use exit node" OFF** → stays **split-tunnel** (internet local, only estate subnets over Tailscale).

## Part D — Admin console (approve + make it durable)
In the Tailscale admin console (**Machines**):
1. On **hq-subnet-router** and **bev-subnet-router** → **Edit route settings** → **approve** the advertised
   subnets (they don't route until approved).
2. On **BOTH routers** → **Disable key expiry.** ← **Critical.** Default keys expire (~180 days) but any
   drop while you're away locks you out — disabling expiry means the routers never need re-auth mid-trip.
3. (Optional, recommended) set **ACLs** so only your devices can reach the routes (least privilege).

---

## Part E — Lockout safeguards (you're away 3 weeks, nobody on-site) — DO THESE
1. **Second independent node per site.** Put Tailscale on a **second always-on device** at each site (a
   Pi, an old laptop, a second LXC) as a backup subnet router. If the primary host reboots/dies, the
   backup keeps you in. Cheapest, highest-value insurance.
2. **Start-on-boot confirmed:** `sudo systemctl enable --now tailscaled` (install does this; verify). A
   `tailscale up` config persists across reboots.
3. **Keep iLO reachable** (`10.224.10.78`, on the advertised HQ subnet) → out-of-band way to power-cycle
   the HQ box remotely if a guest hangs.
4. **UPS** on each subnet-router host (power blip shouldn't end your access).
5. **One trusted on-site human** (a number you can call) who could physically power-cycle a box in a true
   emergency.
6. **Auto-updates:** `sudo tailscale set --auto-update` on the routers (stay patched while away).

## Part F — VERIFY before you leave (the real test)
Do this from **genuinely off the office network** (laptop on phone hotspot / 4G), NOT from inside:
- [ ] `tailscale status` shows both routers **online** + the subnet routes.
- [ ] **HQ:** open `https://10.224.10.10:8006` (Proxmox), SSH the PBX host, reach the 3850 `.4`, iLO `.78`.
- [ ] **Beverley:** open the Beverley Proxmox `https://10.224.111.199:8006`, Cloud Key `10.224.110.5`.
- [ ] Your **normal internet still works** while connected (split-tunnel confirmed).
- [ ] Repeat the key HQ+Beverley checks from your **phone**.
- [ ] Reboot each subnet-router host once and confirm access **comes back by itself** (proves durability).
- [ ] (If built) kill the primary router and confirm the **backup node** still gets you in.

Only count this done when all boxes are ticked **from off-network**.

---

## Security notes
- Dedicated Fishbone Tailscale account, **MFA on**, devices named clearly (`hq-subnet-router`,
  `bev-subnet-router`, `minda-laptop`, `minda-phone`).
- Split-tunnel (no exit node) = your browsing never routes through the estate.
- Optional ACLs restrict who reaches what. Auth keys are **secrets — Minda-held, never in git**.
- This reaches internal admin UIs over an encrypted tunnel — still use strong per-box creds (the ones set
  during the recoveries), kept in the vault.

## Rollback / teardown (after you're back, or to undo)
- Per router: `sudo tailscale down` (stops routing) or `sudo tailscale logout` (de-enrols the node).
- Remove the machines in the admin console. Uninstall: `apt remove tailscale`.
- Nothing was opened on the ASAs, so there is **no firewall change to reverse** — that's the whole point.

## Why not the alternatives (recorded)
- **ASA native VPN:** old 5550s, AnyConnect licensing unknown, and it's the setup that full-tunnelled +
  broke internet before. **Self-hosted Headscale (RND-5 sovereign):** better long-term, but more to build
  + harden than is safe to rush into a 3-week unattended window. **Plan: Tailscale now → migrate to
  Headscale later** when there's runway (keeps the own-the-estate goal alive).

## Notes — Tailscale in a Proxmox LXC (if you choose that over host/VM)
Unprivileged LXC needs the tun device. Add to the container's `.conf`:
```
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file 0 0
```
then restart the container. (Running on the Proxmox host directly, or in a small VM, avoids this.)
