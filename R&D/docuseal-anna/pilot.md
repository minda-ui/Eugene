# RND-8 — DocuSeal hosting pilot (sketch)

_Status: exploring (2026-10-06). **Guide-only**: Eugene drafts the compose/config/runbook and verifies;
**Minda executes** every live step (Proxmox, firewall, DNS) and **holds every secret** — none in git, none
typed by Eugene (§3). This is an R&D sketch, not yet a production runbook._

## Goal
Prove, with least risk first, that **Anna can auto-send a RAMS for signature via a self-hosted DocuSeal**
and get a signed PDF + audit trail back — then expose it safely for external subbies.

## The one hard gate
External subbies open signing links from the open internet, so Phase 3 needs a **public HTTPS endpoint
through the ASA** — the same class of change as OI-8, and best done **after** the firewall/remote story is
settled (ties to OI-8 + RND-5). **Phases 0–2 need none of that** — we get most of the confidence before we
ever touch the perimeter.

---

## Phase 0 — prove the flow, zero infra (optional, ~1 hr)
On **DocuSeal Cloud** (free trial) or a throwaway: tag a RAMS with the signature fields, create a submission
to `minda@` + one external Gmail, confirm the link → signing → signed PDF + audit trail. Validates the UX
and **Anna's text-tag template** without touching our kit. Throw it away after.

## Phase 1 — self-host, internal-only (no firewall exposure)
Stand up DocuSeal in its **own LXC/VM on the Proxmox box**, reachable only on the LAN/VPN.
- **Isolation + resource cap** so the PBX (VM 105) is never starved (OI-7 lesson): ~2 vCPU, 2–4 GB RAM,
  20 GB + a data volume.
- **Postgres** (match production) + **disk storage** volume.
- **SMTP** for the signing emails — a dedicated sender (Google Workspace SMTP relay or an app-password
  account). **SMTP creds = secret Minda holds.**
- Reach it at `http://<lxc-ip>:3000` on the LAN/VPN; create the admin account; get the **API token** (secret).

Draft `docker-compose.yml` (illustrative — Minda fills the `.env`, which is **git-ignored**):
```yaml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: docuseal
      POSTGRES_USER: docuseal
      POSTGRES_PASSWORD: ${DB_PASSWORD}        # secret, in .env
    volumes: [ "pg:/var/lib/postgresql/data" ]
  docuseal:
    image: docuseal/docuseal:latest
    depends_on: [ postgres ]
    environment:
      HOST: ${PUBLIC_HOST}                     # e.g. sign.fishboneconstruction.co.uk (Phase 3)
      SECRET_KEY_BASE: ${SECRET_KEY_BASE}      # secret: openssl rand -hex 64
      DATABASE_URL: postgresql://docuseal:${DB_PASSWORD}@postgres:5432/docuseal
    volumes: [ "data:/data" ]
    ports: [ "3000:3000" ]                     # LAN-only until Phase 3
volumes: { pg: {}, data: {} }
```
SMTP is set in DocuSeal's own settings UI (or via env) — configure + send a test email.

**Exit test:** two internal people (over LAN/VPN) receive the email, sign, and the signed PDF + audit trail
is produced and downloadable.

## Phase 2 — wire Anna (still internal)
- Minda adds a **DocuSeal connection** in **Anna's** Composio (base URL = the internal DocuSeal, **API
  token** = the Phase-1 secret). Wiring Anna is via **Anna's own env / `Raw/`**, not Eugene editing her KB.
- Anna's RAMS template carries **text-tags** at the signature blocks, e.g.:
  ```
  Issued By — Mindaugas Gaudiesius      Signature: {{MD Signature;role=MD;type=signature}}  Date: {{MD Date;role=MD;type=date}}
  Sign-off sheet, per operative row:    {{Op1 Signature;role=Operative1;type=signature}}    {{Op1 Date;role=Operative1;type=date}}
  ```
- Anna calls `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` with the DOCX + the submitters list
  (name+email+role). DocuSeal auto-detects the tags, emails each signer a link.
- **Exit test:** from an Anna session, one API call creates a real submission; internal signers sign;
  Anna/Eugene fetch the signed PDF via `DOCUSEAL_GET_SUBMISSION`.

## Phase 3 — go public (the firewall gate; after OI-8/RND-5)
- **Caddy** reverse proxy in front (auto Let's Encrypt TLS):
  ```
  sign.fishboneconstruction.co.uk {
      reverse_proxy docuseal:3000
  }
  ```
- **DNS:** `sign.fishboneconstruction.co.uk` → our FTTB public IP (`62.105.119.118`).
- **ASA:** NAT/ACL so only **:443 inbound** reaches the Caddy host; DocuSeal :3000 never exposed directly.
  (Guide-only — Minda at the ASA; this is OI-8-class work, do it when the firewall is settled.)
- **Exit test:** an external subbie on **4G** opens the link and signs **with no Google/DocuSeal account**.

## Phase 4 — graduate
- **Webhook receiver** (small endpoint) for `form.completed` → auto-fetch the signed PDF → **file to the
  project folder / Nextcloud (RND-7)**. (Needs a public receiver too — or poll `GET_SUBMISSION` as an
  interim.)
- **Backups:** DocuSeal Postgres + storage into the RND-3 / PBS backup set.
- Write the **production runbook** + a Hub task; decide unattended-send vs human-"go".

---

## Secrets (all Minda-held, never in git, never typed by Eugene)
`DB_PASSWORD`, `SECRET_KEY_BASE`, SMTP creds, the **DocuSeal API token**, any TLS/DNS credentials. The
compose reads them from a git-ignored `.env`.

## Risks / notes
- **Don't starve the PBX** — resource-cap the LXC (OI-7).
- **Public exposure** = attack surface; keep only :443 in, keep DocuSeal patched, strong admin creds in
  Minda's vault.
- **AGPL**: we only *run* DocuSeal (no code embedding) — fine.
- **Dependency:** Phase 3 waits on OI-8/firewall being healthy + the RND-5 remote story (so we can admin it
  safely from anywhere).

## What Eugene can do next (guide-only, no live change)
Draft the full `docker-compose.yml` + `.env.example` + a Caddyfile + the exact Anna text-tag RAMS template
and the `CREATE_SUBMISSION_FROM_DOCX` call, all ready for Minda to deploy when she chooses — or run Phase 0
on DocuSeal Cloud first to prove the flow this week.
