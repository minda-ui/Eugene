# Change log — 2026-10-11 — DocuSeal self-hosted LIVE on the HQ box (RND-8 Phase 1); free-vs-Pro settled; Pro license acquired → Option B

_Guide-only (§3): Eugene wrote the deploy kit + guided every command live; Minda executed on the live
Proxmox/VM and holds the Tailscale account + the DocuSeal `.env` secrets. When `DB_PASSWORD` /
`SECRET_KEY_BASE` appeared on screen Eugene deliberately did **not** record them — references where they
live (the VM's `/opt/docuseal/.env`), never their values; none committed to git._

## What went live
- A **dedicated VM (VM 106)** on the **HQ Proxmox** — Debian, **static `10.224.10.60/24`** gw `10.224.10.1`
  DNS `1.1.1.1`, net0 on **VLAN 10** (`tag=10`). Docker Compose, **overlay2 natively** (no storage-driver
  workaround needed on a VM).
- **Stack:** `docker compose` with **DocuSeal + Postgres 16** (the deploy-kit `docker-compose.yml` at
  `R&D/docuseal-anna/deploy-kit/`); both containers **Up**; admin account created (initial-setup →
  dashboard) at **http://10.224.10.60:3000**.
- **Reachable remotely over Tailscale** — the dashboard loaded from off-site (Beverley) via the new
  `hq-subnet-router`, proving the RND-5 remote-admin path carries the DocuSeal admin UI.

## Why VM, not LXC (lesson baked into the deploy-kit README)
Docker-in-LXC-on-ZFS failed four ways: (1) unprivileged port sysctl denied → privileged; (2) overlay-on-ZFS
permission denied → `storage-driver: vfs`; (3) `remount-propagation MS_PRIVATE: permission denied` even with
`lxc.apparmor.profile: unconfined`; (4) still MS_PRIVATE denied → **abandoned LXC, switched to a VM** where
overlay2 works out of the box. For Docker on this Proxmox: use a **VM**.

## Install gotchas hit + fixed (all now in the kit/runbook)
- **Wrong VLAN on first VM:** net0 tag wasn't 10 → the VM landed on VLAN 13's DHCP (`10.224.13.12`), no
  egress, "Bad archive mirror". Fix: set net0 `tag=10`.
- **VM silently on DHCP (`10.224.10.52` not `.60`):** host couldn't ping `.60` — looked like an OVS L2
  issue, but `cat /etc/network/interfaces` showed `iface ens18 inet dhcp` (VLAN-10 DHCP handed out `.52`).
  Minda caught it ("worth checking it's not on DHCP"). Fix: rewrote `/etc/network/interfaces` to static
  `10.224.10.60/24` gw `10.224.10.1`, `echo nameserver 1.1.1.1 > /etc/resolv.conf`, `systemctl restart
  networking`, reconnect on `.60`.
- **Can't paste into the Proxmox noVNC console** → SSH from the host shell (`ssh root@10.224.10.60`, after
  `PermitRootLogin yes` + restart ssh) where paste works.

## Free-vs-Pro — SETTLED definitively (on the live self-host)
On the **free** self-hosted DocuSeal, the template-upload UI **only accepts PDF or images — not `.docx`**
(Minda tried the tagged `Sample-RAMS-DocuSeal-Phase0.docx`: "not allowing to choose .docx file, only pdf or
pictures"). This confirms empirically: **DOCX-field-tags auto-detection is a Pro feature**; free self-host
does manual field placement on a PDF/image (plus the basic submit-against-a-template API). Phase 0's DOCX
auto-detect worked only because a **Cloud trial bundles Pro**.

## Decision — OPTION B (Pro license acquired 2026-10-11)
Minda **acquired the DocuSeal Pro license** ("I got license, that is next"). So the DOCX-field-tags route is
the chosen one (Anna generates a fresh tagged RAMS `.docx` each time → DOCX-tags API → auto-detect). Option A
(free fixed template) is moot. **Next:** apply the license key to the self-host → confirm DOCX upload +
field-tags unlock on the box → SMTP + a full internal sign test → wire Anna (via her `Raw/`) → optional
public exposure → graduate.

## Governance recap (unchanged, §3)
Everything remains guide-only; Minda holds every secret (Tailscale keys, DocuSeal `.env`, Pro license key,
Anna's future API key). The automation Anna will eventually run is gated by the approval decided 2026-10-11
(RAMS doc + recipient list approved up front → unattended send+collect) — not Eugene sending ad-hoc email.

## Artefacts
`R&D/docuseal-anna/notes.md` (Phase 1 result + free-vs-Pro settled + Option B), `R&D/docuseal-anna/deploy-kit/`
(the compose/`.env.example`/Caddyfile/README used), ledger row 99. The self-host runs on HQ VM 106
(`10.224.10.60:3000`), reachable over Tailscale.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
