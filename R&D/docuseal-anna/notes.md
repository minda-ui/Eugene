# RND-8 — Automated RAMS signing: DocuSeal + Anna (working notes)

_Status: **exploring** (spark 2026-10-06). Guide-only; no live change; no secret held (charter §3).
Creative-mode R&D — stays out of the control files until it graduates._

## The idea in one line
Self-host **DocuSeal** so **Anna** can fire a signature request the moment she finishes a RAMS — fully
hands-off — instead of a person clicking "send" in Google eSignature. Unlimited signers, own-the-estate,
signed PDF + audit trail back by webhook.

## Why it beats Google eSignature *for automation*
Google Workspace eSignature (set up 2026-10-06, live, free) is **UI-only** — a human must click send, and
it caps at 10 signers. Great for now. But it has **no API**, so Anna can't trigger it. DocuSeal is
**API-first**, so the RAMS→sign→file loop can run with no human in the middle. Keep Google for manual/now;
DocuSeal is the automated future.

## How DocuSeal works
- **Fields** are defined by a drag-drop builder **or by text-tags embedded in the document** —
  `{{Signature;role=Operative1;type=signature}}`, `{{Date;role=MD}}`, `[[variable]]` for dynamic content —
  auto-detected on upload. (v2.2+ can also auto-detect fields via a CV model, needs ≥1 GB RAM.)
  Ref: field-tags — https://cdn.jsdelivr.net/npm/docuseal@1.0.4/skills/docuseal-cli/references/field-tags.md
- A **submission** assigns **submitters** (name+email+role); DocuSeal emails each a **signing link**;
  signer opens it in a browser, **no account**, signs on a phone.
- On completion → **signed PDF + audit trail** (PKCS#7) and a **webhook** fires with the result.

## Where it runs
- **Self-hosted Docker** on the Proxmox box (fits RND-3). SQLite (small) or **Postgres** (production);
  needs **SMTP** to send links; ~1–2 GB RAM. Guide: https://sliplane.io/blog/how-to-self-host-docuseal
- **The one real catch: a public HTTPS endpoint + subdomain.** Signers are external subbies, so they must
  reach DocuSeal from the open internet — reverse proxy (Caddy/nginx + Let's Encrypt) on e.g.
  `sign.fishbone…`, exposed through the firewall. **RND-5's mesh does NOT cover this** (external people
  aren't on the mesh). This is the bit blocked by OI-8 / firewall fragility → a "when back + settled" job.
- **Cloud** (docuseal.com) avoids hosting but data leaves the estate + paid + API key. Against own-the-estate.

## Licence / cost
- Free self-hosted = **AGPL-3.0**. DocuSeal's **GitHub README lists "API and Webhooks for integrations"
  under the FREE version** — so programmatic use should be £0 self-hosted.
- **Pro** ($20/user/mo cloud; ~$240/yr per user on-prem) adds branding, SSO, bulk-send, embedded forms,
  SMS, reminders, conditional fields — **none needed for RAMS**.
- ⚠️ **To verify:** some third-party sources claim ~$0.20 per signed doc via API even self-hosted; the
  README contradicts this. Confirm on the official pricing page (egress-blocked for Eugene 2026-10-06)
  before relying on "free". AGPL copyleft only bites if we embed DocuSeal code in a proprietary product —
  we won't; we just run it.

## Integrating with Anna (the easy, exciting part)
Composio already exposes DocuSeal tools — `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX`, `..._FROM_PDF`,
`..._FROM_HTML`, `DOCUSEAL_GET_SUBMISSION`, `..._GET_SUBMISSION_DOCUMENTS`, `..._UPDATE_SUBMITTER`. So Anna
reaches DocuSeal through the same Composio Connect she already uses.

**Flow:**
1. Anna's RAMS **template carries text-tags** at the signature blocks (`{{Signature;role=MD}}` on Issued-By
   + the "person completing" line; one `{{Signature;role=OperativeN}}` + `{{Date}}` per sign-off row).
   Anna already builds RAMS with python-docx — tags are just literal text in the template.
2. Anna generates the RAMS → calls `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` with the signer list
   (names+emails).
3. DocuSeal emails everyone, collects signatures, and a **webhook** returns the **signed PDF** → Anna/Eugene
   file it into the project folder (and Nextcloud per RND-7).

**Secrets:** DocuSeal **API base URL + API key** live in Anna's environment (like the Composio `ck_` key) —
**Minda holds them; Eugene never types them** (§3). Cross-KB: wiring Anna is done via Anna's `Raw/` / her
own setup, not by Eugene editing her KB.

## Proposed pilot (guide-only, when the hosting/firewall story is ready)
1. **Spin up DocuSeal** in an LXC/VM on the Proxmox box (Docker + Postgres + SMTP), internal-only first.
2. **Reverse proxy + TLS** on a subdomain, exposed through the firewall (depends on OI-8 being settled /
   RND-5 story) — or trial on **DocuSeal Cloud** first to prove the Anna flow without hosting.
3. **Tag a RAMS template** with the signature fields; create one submission by hand in the UI → confirm
   signing link + signed PDF + audit trail.
4. **Wire Anna**: Minda adds the DocuSeal API key to Anna's env; test `CREATE_SUBMISSION_FROM_DOCX` from a
   session; confirm the webhook returns the signed PDF.
5. **Graduate** → a runbook + Hub task; fold the signed-PDF filing into RND-7 (project brain).

## Relationships
- **RND-7 project-brain:** the signed RAMS is one of the per-project records the brain indexes.
- **RND-3 storage:** DocuSeal + its signed PDFs live on the estate storage/backup.
- **OI-8 / RND-5:** the public HTTPS endpoint is the gating dependency; the mesh helps *admin* access but not
  *external signers*.

## Open questions for Minda
- Cloud-first trial (fast, proves the Anna flow, small cost) **or** straight to self-host (own-the-estate,
  needs the public endpoint)?
- Is auto-sending RAMS to operatives something she wants Anna to do unattended, or always with a human
  "go"? (Changes whether it's a routine or a guided step.)
