# Runbook — DocuSeal self-host: SMTP (Workspace relay) + wire Anna (closes OI-21 a+c)

> **Purpose:** finish the two remaining OI-21 items so Anna can run the RAMS→sign→signed-PDF loop for
> real on our own box: **(a) SMTP** so DocuSeal actually emails signing links, and **(c) wire Anna**
> (API base URL + key into her env, via her `Raw/`).
>
> **Guide-only (§3):** Eugene wrote this; **Minda executes every console/host step and holds every secret**
> — the Workspace **app password**, the DocuSeal **API key**, admin/DB creds. None go in git or the KB.
> Eugene references *where* they live, never their values.
>
> **Decisions taken (Minda, 2026-10-12):** relay = **Google Workspace SMTP relay** (`smtp-relay.gmail.com`);
> FROM = **info@fishboneconstruction.co.uk** (a live Workspace mailbox → SPF/DKIM already correct).
>
> **Status:** READY 2026-10-12. Public signing already LIVE at `https://sign.fishbonegroup.co.uk`
> (ledger 102). DocuSeal self-host on HQ **VM 106** (`10.224.10.60`, admin reachable over Tailscale).

---

## Part A — SMTP via the Google Workspace relay

### A1. Configure the relay in the Workspace Admin console (Minda, as super-admin of `fishboneconstruction.co.uk`)
`admin.google.com` → **Apps → Google Workspace → Gmail → Routing** → **SMTP relay service** → **Configure / Add**:
- **Name:** `DocuSeal self-host relay`
- **Allowed senders:** **Only addresses in my domains** (DocuSeal sends as `info@fishboneconstruction.co.uk`).
- **Authentication:** tick **Require SMTP Authentication** (works regardless of which WAN the office egresses
  on — robust to the FTTB/StarLink/BT failover seen in OI-8). *Optional belt-and-braces:* also tick **Only
  accept mail from the specified IP addresses** and add the FTTB egress **`62.105.119.118/32`**.
- **Encryption:** tick **Require TLS encryption**.
- **Save.** (Admin-console changes usually apply in minutes, can take up to ~24h.)

### A2. App password for the sender (Minda — the one secret here)
The relay's "Require SMTP Authentication" needs a login for `info@fishboneconstruction.co.uk`. With 2-Step
Verification on that account, generate an **App password**: Google Account → **Security → App passwords** →
create one named `DocuSeal` → copy the 16-char value → **store in 1Password**. Eugene never sees it (§3).
(If 2SV isn't enabled on that mailbox, enable it first — it's required for app passwords.)

### A3. Point DocuSeal at the relay — in-app UI (preferred; no container restart)
Self-host admin UI (`http://10.224.10.60:3000` internally over Tailscale, **or** `https://sign.fishbonegroup.co.uk`)
→ **Settings → Email / SMTP**:
| Field | Value |
|---|---|
| SMTP host / address | `smtp-relay.gmail.com` |
| Port | `587` |
| Security / encryption | **STARTTLS (TLS)** |
| Authentication | `plain` (or `login`) |
| Username | `info@fishboneconstruction.co.uk` |
| Password | *the A2 app password* (Minda pastes) |
| From / default sender | `info@fishboneconstruction.co.uk` |
| HELO / domain (if asked) | `fishboneconstruction.co.uk` |

Save → use **Send test email** to a mailbox you control.

**Alternative — env (only if the UI SMTP page isn't present on this image).** Add to the DocuSeal service in
`/opt/docuseal/docker-compose.yml` (or the `.override.yml`) then `docker compose up -d`:
```yaml
environment:
  SMTP_ADDRESS: smtp-relay.gmail.com
  SMTP_PORT: "587"
  SMTP_AUTHENTICATION: plain
  SMTP_STARTTLS: "true"
  SMTP_USERNAME: info@fishboneconstruction.co.uk
  SMTP_PASSWORD: "<app password — Minda sets on the box; never in git>"
  SMTP_DOMAIN: fishboneconstruction.co.uk
  SMTP_FROM: info@fishboneconstruction.co.uk
```

### A4. Verify (the gate for Part A)
- [ ] Test email from DocuSeal **arrives** (check Spam too; being an in-domain Google sender it shouldn't spam).
- [ ] **Full internal sign test on our own box** (mirror of the Phase-0 Cloud loop): create a submission from
      the tagged `Sample-RAMS-DocuSeal-Phase0.docx`, assign a signer to a mailbox you control, **confirm the
      signing-link email lands**, sign it, and confirm DocuSeal returns the **signed PDF + audit log**.
  Only once this passes is the box ready for Anna's live flow.

---

## Part B — Wire Anna (cross-KB via her `Raw/`; Minda holds the key)

Anna reaches DocuSeal through the **Composio DocuSeal tools** she can already call. She needs two things in
her environment and one handoff note:

### B1. Generate the DocuSeal API key (Minda, in the self-host admin UI)
Self-host admin → **Settings → API** → copy the **API token / X-Auth-Token** → **1Password**. This is the
key Anna authenticates with. Eugene never types it (§3).
- **API base URL:** `https://sign.fishbonegroup.co.uk` (public; the API lives under `/api`).

### B2. Add the two values to Anna's environment (Minda)
In Anna's session/routine environment (the same place her Composio `ck_` key lives):
- `DOCUSEAL_API_BASE_URL = https://sign.fishbonegroup.co.uk`
- `DOCUSEAL_API_KEY = <the B1 token>`  *(Minda sets; held in 1Password)*

### B3. Deliver the handoff into Anna's `Raw/` (Eugene) + a Hub Tasks row
Eugene drops `Anna-RawNote-DocuSeal-Wiring-2026-10-12.md` (staged at
`Raw-outbound/` in this repo) into **Anna's `Raw/` folder**, and raises a **Hub Tasks & Requests** row
naming the handoff. **Anna reads it and wires herself** — Eugene does not edit Anna's KB directly (§1/§3).
The note tells Anna: the env var names (B2), the Composio tools, the create→collect→fetch flow, and the
approval gate.

### B4. The loop Anna runs (reference — detail is in her Raw/ note)
1. **Inputs approved first** (RAMS content + signer list) — the single human gate (RND-8 governance,
   Minda 2026-10-11). After approval the rest is unattended.
2. `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` — push the fresh tagged RAMS `.docx` + signer list (name+email+role).
   *(DOCX-field-tags is the **Pro** feature we licensed — the free UI refused `.docx`; Pro accepts it.)*
3. DocuSeal emails each signer the link (via the Part-A relay), collects signatures.
4. **Get the result back** — either a **webhook** (if Anna has a reachable endpoint; set it in DocuSeal
   Settings → Webhooks) **or poll** `DOCUSEAL_GET_SUBMISSION` for status then
   `DOCUSEAL_GET_SUBMISSION_DOCUMENTS` for the **signed PDF + audit log**. *Polling is the safe default —
   no inbound endpoint needed for Anna.*
5. File the signed PDF into the project folder (and the project brain, RND-7).

### B5. Verify (the gate for Part B)
- [ ] From an Anna session: `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` succeeds against the box.
- [ ] Signer gets the email; after signing, Anna retrieves the **signed PDF + audit log**.
- [ ] Then **graduate RND-8** (`R&D/graduation-register.md`) and mark **OI-21 (a)+(c) done**.

---

## Notes / security
- Secrets (app password, DocuSeal API key, admin/DB creds) are **Minda-held, 1Password, never in git/KB** (§3).
- The relay sends **as a Workspace-domain address**, so SPF (`_spf.google.com`) and DKIM are already correct
  — unlike a `noreply@fishbonegroup.co.uk` sender, which would have needed its own SPF/DKIM first.
- OI-21 (b) **internal access** (NAT hairpin / split-DNS so `sign.fishbonegroup.co.uk` resolves to
  `10.224.10.60` on the LAN) stays a nice-to-have — for admin use `http://10.224.10.60:3000` over Tailscale.

## Related
`Runbooks/Runbook-DocuSeal-Pro-Public-Selfhost-HQ.md` (the public go-live + AS-BUILT), `R&D/docuseal-anna/notes.md`
(RND-8), `open-issues.md` OI-21, ledger 102.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
