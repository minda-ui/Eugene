# RND-8 — DocuSeal self-host deploy kit (HQ DL380 Gen9)

_Guide-only. **Eugene drafts; Minda executes every live step and holds every secret** (§3). No real
secret in git. This is still an R&D sketch — it becomes the production runbook when RND-8 graduates._

**Prereq decision:** settle **free-vs-Pro** first (the billing-page check). This kit works for either —
Pro just adds the `LICENSE_KEY` line + unlocks the DOCX-field-tags API Anna uses. If you stay free, you
build one reusable RAMS template in the UI instead (Option A).

---

## The target: a dedicated DocuSeal VM on the HQ box

Host: **HQ ProLiant DL380 Gen9**, Proxmox (`10.224.10.10:8006`). Chosen because the public endpoint
(FTTB IP `62.105.119.118` + the ASA) lives here — external subbies' signing links must resolve to it.

**New VM — "docuseal" (sized small, capped so it never touches the PBX / VM 105 — OI-7 lesson):**
| Setting | Value |
|---|---|
| vCPU | **2** |
| RAM | **4 GB** (min 2 GB; DocuSeal ~1–2 GB, Postgres + headroom) |
| Disk | **20 GB** system + a **separate data volume** (20–40 GB) for uploads/signed PDFs |
| OS | Debian 12 (or Ubuntu 22.04 LTS) minimal |
| Network | its own IP on the server VLAN; **not** sharing with VM 105 (PBX), 101 (OPNsense) |
| Proxmox | set CPU/RAM **limits** on the VM so a spike can't starve the PBX |

> The VM-level cap is the primary guard; the `mem_limit`/`cpus` in compose is belt-and-braces.

---

## Deploy steps (Minda runs; Eugene verifies each)

### 1. Create + prep the VM (Proxmox)
- Create the VM per the table above; install Debian minimal; `apt update && apt upgrade`.
- Install Docker + compose plugin (`get.docker.com`), enable the service.
- Snapshot the clean VM before going further (easy rollback).

### 2. Drop the stack on the VM
- Copy this `deploy-kit/` folder to the VM (e.g. `/opt/docuseal/`).
- `cp .env.example .env` and **fill `.env` with real secrets** (Minda) — `DB_PASSWORD`,
  `SECRET_KEY_BASE` (`openssl rand -hex 64`), `PUBLIC_HOST`. The real `.env` **stays on the VM, never
  committed**.
- Pin the DocuSeal image to a real version tag in `docker-compose.yml` (not `:latest`).

### 3. First boot — INTERNAL ONLY (no firewall yet)
- For the internal test, temporarily publish the app port instead of going through Caddy: either run
  only `docker compose up -d postgres docuseal` with a temporary `ports: ["3000:3000"]`, **or** let
  Caddy serve its internal CA. Reach it at `http://<vm-ip>:3000` over the LAN/VPN.
- Create the **admin account**; in **Settings → Email**, configure **SMTP** (dedicated sender; creds
  Minda-held) and send a test email.
- **Exit test:** two internal people (LAN/VPN) get the email, sign, and the **signed PDF + audit trail**
  download. (This is the Phase-0 loop, now on our own box.)

### 4. Go public (the firewall gate — OI-8-class; do when settled)
- **DNS:** add `sign.fishboneconstruction.co.uk` → `62.105.119.118` (A record).
- **ASA:** NAT + ACL so only **:443 (and :80 for ACME)** inbound reach the **DocuSeal VM's Caddy** —
  nothing else. DocuSeal :3000 and Postgres :5432 stay internal. *(Guide-only — Minda at the ASA; mirrors
  the OI-8 inbound NAT pattern. Snapshot the ASA config first; one change at a time; packet-tracer to
  prove before/after.)*
- Bring up the full stack: `docker compose up -d` → Caddy auto-fetches the Let's Encrypt cert.
- **Exit test:** an **external** phone on 4G opens a signing link and signs with **no account**.

### 5. Collect results + back up
- Confirm the signed PDF + `Audit Log` come back (and, for Anna, the webhook or `GET_SUBMISSION`).
- **Back up** the `pg_data` + `docuseal_data` volumes into the **RND-3 / Proxmox-Backup-Server** set.

---

## What's exposed (keep this tight)
- **Public:** only `:443` (+`:80` ACME) → Caddy, on the DocuSeal VM.
- **Internal only:** DocuSeal `:3000`, Postgres `:5432` (never published).
- **Outbound:** SMTP (send links) and the webhook (if used) — no inbound hole needed for those.

## Secrets (all Minda-held, never in git, never typed by Eugene)
`DB_PASSWORD`, `SECRET_KEY_BASE`, SMTP creds, the DocuSeal **API token** (for Anna), the **Pro licence
key** (Option B), any TLS/DNS creds. All live in the VM's `.env` / DocuSeal settings / Minda's vault.

## Files in this kit
- `docker-compose.yml` — the 3-service stack (Caddy + DocuSeal + Postgres).
- `.env.example` — secret template → copy to `.env` on the VM and fill.
- `Caddyfile` — TLS reverse proxy for the public host.
- `anna-integration.md` — the RAMS text-tag template + the exact Composio `CREATE_SUBMISSION` call.

## Dependencies / notes
- **Free-vs-Pro** decides the Anna path (DOCX-tags API = Pro, or fixed UI template = free).
- **Firewall (step 4)** is required only for **external** signers (see the firewall Q&A in `../notes.md`).
- **AGPL:** we only *run* DocuSeal (no code embedding) — fine.
- **Graduation:** once internal (step 3) passes on our box, this is ready to put to Minda as RND-8's
  graduation → production runbook + Hub task, with Anna wired via her `Raw/`.
