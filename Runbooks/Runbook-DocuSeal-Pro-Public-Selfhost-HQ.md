# Runbook — DocuSeal **Pro** self-host, public HTTPS on `sign.fishbonegroup.co.uk` (HQ VM 106)

> **Purpose:** take the already-running self-hosted DocuSeal (free, internal) up to **Pro** (licensed EE
> image → DOCX-field-tags API) **and expose it publicly over HTTPS** so external subbies can sign RAMS from
> the open internet. Graduates **RND-8** (Option B, Pro license acquired 2026-10-11).
>
> **Guide-only (§3):** Eugene wrote this; **Minda executes every DNS / firewall / host step and holds every
> secret** — the DocuSeal **license token** (the `ee.docuseal.com/‹token›/…` URL), the DB password, the
> `SECRET_KEY_BASE`, registrar + ASA creds. **None of these go in git or the KB.** Eugene references *where*
> they live, never their values.
>
> **Status:** active build, 2026-10-11. Pre-flight facts marked **‹CONFIRM›** must be filled before the ASA
> step. ⚠️ This opens a **new inbound :443** on the live HQ ASA just before a ~3-week absence — apply only
> once each verify step passes; rollback in §7.

## Where we start (already done, 2026-10-11)
- **VM 106** on HQ Proxmox: Debian, static **`10.224.10.60/24`**, gw `10.224.10.1`, DNS `1.1.1.1`, net0 VLAN 10.
- Docker + Compose, overlay2 native. **Free** DocuSeal + Postgres 16 currently **Up** on port 3000, admin
  account created, reachable over Tailscale. We now **replace** this with the Pro stack.

## Architecture (public Pro)
```
Internet → sign.fishbonegroup.co.uk (DNS A → HQ public IP ‹CONFIRM: 62.105.119.118 FTTB/Wavenet›)
        → HQ ASA  (static NAT :80,:443  outside_fttb → 10.224.10.60 ; ACL permit)
        → VM 106 (10.224.10.60)  DocuSeal Pro compose: bundled Caddy (auto Let's Encrypt) :80/:443
                                  → DocuSeal EE app  → Postgres
Admin/testing meanwhile stays available internally over Tailscale.
```
Caddy (in the vendor compose, driven by `HOST=`) fetches + renews the TLS cert automatically **once :80 and
:443 reach the VM from the internet and the DNS name resolves to our public IP.**

---

## Pre-flight — the three facts to confirm first
1. **Public IP** for inbound. Working assumption **`62.105.119.118`** (the FTTB/Wavenet public IP, our side,
   from the OI-8 telephony work — business fibre, static). ‹CONFIRM it's the live primary egress and is static›.
2. **:80 and :443 inbound are free** on that public IP (nothing else published on them). ‹CONFIRM›.
3. **Where DNS for `fishboneconstruction.co.uk` is managed** (registrar / Google / 1&1-IONOS) and that Minda
   can add an **A record** there. ‹CONFIRM›.

## Step 1 — DNS (registrar; Minda)
- Add **A record**: `sign` (→ `sign.fishbonegroup.co.uk`) → **‹public IP›**, **TTL 300** (low, so a
  mistake is quick to fix; raise later).
- Verify from anywhere it resolves: `nslookup sign.fishbonegroup.co.uk` → the public IP.
  **Do not proceed to Caddy/TLS until this resolves publicly** (Let's Encrypt checks it).

## Step 2 — Prepare VM 106 (Minda, on `ssh root@10.224.10.60`)
- Stop the free stack so ports :80/:443 are free and there's no confusion:
  ```bash
  cd /opt/docuseal
  docker compose down            # keeps named volumes; our throwaway admin isn't worth migrating
  cp docker-compose.yml docker-compose.yml.free-bak
  ```
- (Optional clean slate — only if we want a fresh DB: `docker volume ls` then remove the old `*_pg`/`*_data`
  volumes. The Pro compose brings its own DB; a clean start avoids schema mismatch. Decide at this step.)

## Step 3 — Get the Pro compose (Minda; **token is a secret**)
From DocuSeal **Billing → Pro Installation Instructions** (the page in the screenshot):
```bash
cd /opt/docuseal
curl https://ee.docuseal.com/<YOUR-TOKEN>/docker-compose.yaml > docker-compose.yml
```
- **The `<YOUR-TOKEN>` is the license** — Minda pastes her own URL; it is **never** recorded here or in git.
- Open the file and review it: it bundles **Caddy + the `ds-ee` app + Postgres**. Set/confirm a **strong DB
  password** and a **`SECRET_KEY_BASE`** (Minda generates, e.g. `openssl rand -hex 64`) wherever the file
  references them — **Minda holds both**; Eugene does not see them.

## Step 4 — ASA inbound NAT (the firewall step — guide-only; Minda at the ASA; ⚠️ live change)
> Backup first, prove with packet-tracer, then `write memory`. Mirrors the OI-8 discipline.
- **Backup:** save running-config to a dated file (e.g. `asa-pre-docuseal-443-2026-10-11.cfg`) **before any edit**.
- Add object NAT static (port-forward) for **:443** and **:80**, outside_fttb → `10.224.10.60`, and an ACL
  permit on the outside interface. Exact object/ACL names to match the live config — read the current config
  first, don't guess. Shape:
  ```
  object network DOCUSEAL-HOST
    host 10.224.10.60
  object network DOCUSEAL-443
    host 10.224.10.60
    nat (inside,outside_fttb) static interface service tcp 443 443
  object network DOCUSEAL-80
    host 10.224.10.60
    nat (inside,outside_fttb) static interface service tcp 80 80
  access-list outside_fttb_access_in extended permit tcp any object DOCUSEAL-HOST eq 443
  access-list outside_fttb_access_in extended permit tcp any object DOCUSEAL-HOST eq 80
  ```
  (If the outside ACL is already `permit ip any any`, no ACL line is needed — check first, as in OI-8.)
- **Prove before trusting:** `packet-tracer input outside_fttb tcp 8.8.8.8 12345 62.105.119.118 443` → expect
  ALLOW with UN-NAT to `10.224.10.60:443`. Repeat for :80.
- **Persist:** `write memory` (both units if the pair is active/standby).
- **Note:** config access to the active HQ ASA is needed here — Minda applied/`write memory`'d the OI-8
  twice-NAT on both units on 2026-10-10, so that access is in hand.

## Step 5 — Bring up Pro (Minda, on the VM)
```bash
cd /opt/docuseal
sudo HOST=sign.fishbonegroup.co.uk docker compose up -d
docker compose ps        # all services Up
docker compose logs -f caddy   # watch Caddy obtain the Let's Encrypt cert (needs :80 reachable + DNS live)
```
- First boot: Caddy provisions the TLS cert. If it loops on ACME, re-check DNS resolves publicly + :80/:443
  reach the VM (the ASA step).

## Step 6 — VERIFY (from genuinely off-network — 4G/hotspot, not the office LAN)
- [ ] `https://sign.fishbonegroup.co.uk` loads with a **valid padlock** (real Let's Encrypt cert).
- [ ] Create the **admin account** on first load (strong password → 1Password; Eugene doesn't see it).
- [ ] **Pro proof:** make a template, **upload `R&D/docuseal-anna/phase0/Sample-RAMS-DocuSeal-Phase0.docx`**
      — the free UI refused `.docx`; **Pro must accept it and auto-detect the fields.** ← this confirms the
      license is active.
- [ ] Normal internet still works; admin UI also still reachable internally over Tailscale (`10.224.10.60`).

## Step 7 — Rollback (if anything misbehaves)
- **App:** `docker compose down` on the VM → public endpoint goes dark; `docker compose -f
  docker-compose.yml.free-bak up -d` brings the internal free stack back.
- **Firewall:** remove the two NAT objects + ACL lines added in Step 4 and `write memory` (restore from
  `asa-pre-docuseal-443-2026-10-11.cfg` if needed). **Nothing else on the ASA was touched.**
- **DNS:** delete the `sign` A record.

## Step 8 — After it's live (not blocking the signing path)
- **SMTP** so signing links actually send (DocuSeal → SMTP settings, or env in the compose). One full
  internal sign test end-to-end on our own box.
- **Wire Anna:** Minda adds the DocuSeal **API base URL + API key** to Anna's environment; test
  `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX`; confirm the webhook returns the signed PDF. **Cross-KB: via Anna's
  own `Raw/`, not Eugene editing her KB.** Minda holds the key; Eugene never types it (§3).
- **Harden the public exposure:** strong admin creds (done), consider restricting the **admin** path to the
  Tailscale/LAN source while leaving the **signing** links public; keep the EE image updated
  (`docker pull ee.docuseal.com/<token>/ds-ee` → `docker compose up -d --force-recreate`); confirm backups
  of the DocuSeal DB + data volume (ties to RND-3).
- **Graduate** RND-8 → mark in `R&D/graduation-register.md`, add a Hub task for the Anna wiring.

## Security notes
- The **license-token URL**, **DB password**, **`SECRET_KEY_BASE`**, **admin password**, **Anna API key**,
  registrar + ASA creds are **all secrets — Minda-held, never in git/KB** (§3).
- Public exposure = anyone on the internet can reach the signing UI. That's intended (external subbies), but
  it is a new attack surface: keep the EE image patched, admin creds strong, and review access periodically.
- Inbound :80/:443 is the **only** firewall change; everything else stays as-is. Rollback is clean (§7).

---
_Created 2026-10-11. Pairs with `R&D/docuseal-anna/deploy-kit/` (the earlier internal free kit — its hand-rolled
Caddyfile is superseded by the vendor's `HOST=` bundled-Caddy approach here)._
