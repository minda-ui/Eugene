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

### ⚠️ RESOLVED 2026-10-11 (from DocuSeal's own GitHub README) — the DOCX-tags API is **Pro**
Checked the official README directly. The split that matters for us:
- **FREE (self-hosted):** basic **REST API + webhooks**, PDF form-field builder, multiple signers, SMTP,
  automatic PDF eSignature + verification, user management. → Anna **can** create submissions against an
  **already-built template** and get the signed PDF back by webhook, for £0.
- **PRO:** **"Template creation with PDF or DOCX and field-tags API"**, HTML-API template creation,
  embedded signing form, SSO, bulk-send, reminders, white-label.
**Impact:** Anna's planned flow (generate a fresh RAMS DOCX with `{{Signature}}` text-tags → push via the
DOCX-tags API → auto-detect fields) relies on the **Pro** DOCX-field-tags API. The **basic** submit-against-
an-existing-template API is free. So the decision is now:
- **A — Free + fixed template:** build one RAMS template in the UI, Anna fills `[[variables]]` + fires
  submissions (£0; only if RAMS fit a reusable template shape).
- **B — Pro (~$20/user/mo ≈ £16/mo):** unlocks DOCX-field-tags → Anna's fresh-RAMS-every-time vision.
- **C — Phase 0 cloud trial (recommended):** empirically test what the free/trial API does with a DOCX+tags
  before committing to A or B. Don't guess from the README — prove it.
Pricing page to confirm per-user/per-doc figures: https://www.docuseal.com/pricing

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

## Governance decision (Minda, 2026-10-11) — approval gate, then unattended
**The human gate is on the inputs, not the send.** Once BOTH (a) the **RAMS document** and (b) the
**recipient list** are approved (RAMS carries director approval), Anna may **send and collect signatures
fully unattended** — no per-send human "go". So:
- **One approval step, upfront:** the RAMS content + the signer list are signed off before anything goes out.
- **After approval → unattended loop:** create submission → DocuSeal emails the signing links → collects
  signatures → webhook returns the signed PDF → filed. No human in the mechanical middle.
- **Maps onto RND-9 (Approvals Desk):** this *is* "AI proposes → human approves (doc + recipients) →
  action applied (send+collect) → outcome logged (signed PDF + audit trail)". The approval can be a Hub
  Approvals row or Anna's existing RAMS director-approval step; the point is it's **explicit and before
  the send**, after which automation is authorised.
- **§3 stays intact:** the external send is through DocuSeal's approved automated channel after a human
  approved exactly what/who — not Eugene sending ad-hoc email. This graduates as a **routine** (unattended),
  gated by the approval, not a per-run guided step.

## Phase 0 RESULT (2026-10-11) — ✅ DOCX-field-tags auto-detect WORKS
Minda uploaded `phase0/Sample-RAMS-DocuSeal-Phase0.docx` to a DocuSeal (Cloud) account. **Every text-tag
auto-detected into the correct field, grouped by submitter:** Director → signature + `datenow` auto-date;
Operative 1 (blue) + Operative 2 (yellow) rows → signature + date + name + company each, colour-coded per
role. **The template-design unknown is settled — Anna's `{{…;role=…}}` approach produces the right signing
layout with no manual field placement.**
- **Caveat (free-vs-Pro still open):** a DocuSeal **trial usually bundles Pro**, and the README lists the
  DOCX-field-tags API as **Pro**. So this proves the *mechanism*, not that it's *free forever*. To settle:
  check the account's **plan/billing page** (Trial vs Pro) + any "Pro only" badges. If DOCX-tags needs Pro
  → **Option B (~£16/mo)** for the fully-automated route, or **Option A** (hand-build a fixed template on
  free) if RAMS fit one shape.
- **Phase 0 COMPLETE (2026-10-11) — full loop proven end-to-end.** Minda assigned the 3 roles to real
  mailboxes (minda@, irina@fishboneproperties, info@fishboneconstruction), sent, and signed. Confirmed
  from Gmail (`info@docuseal.com`):
  - **Signing invites delivered** to all 3 signers ("You are invited to sign a document"). ✅ email path.
  - **"Your document copy"** (to all parties) with **two attachments**: `Sample-RAMS-DocuSeal-Phase0.pdf`
    (completed, **signed**) + **`Audit Log - RAMS.pdf`** (audit trail). ✅ signed PDF + audit trail returned.
  - **Verdict:** the entire Anna loop — DOCX+tags → auto-detect → send → collect → signed PDF + audit —
    works on DocuSeal Cloud. Mechanism fully validated.
  - Footer says "Sent using DocuSeal free document signing" (suggestive, not proof — trials bundle Pro).

## Phase 1 RESULT (2026-10-11) — ✅ SELF-HOSTED DOCUSEAL LIVE on the HQ box + free-vs-Pro SETTLED
Built and deployed self-hosted DocuSeal on the HQ Proxmox, over Tailscale (guide-only; Minda executed every
step on the live kit, Eugene guided and verified; no secret held — the `.env` `DB_PASSWORD`/`SECRET_KEY_BASE`
appeared on screen and were deliberately **not** recorded).

- **Where:** a **dedicated VM** (VM 106) on the HQ Proxmox — Debian, static **`10.224.10.60/24`** gw
  `10.224.10.1` DNS `1.1.1.1`, net0 on **VLAN 10** (`tag=10`). Docker (Compose) with **overlay2 natively**
  (no storage-driver workaround needed on a VM).
- **Why VM not LXC:** Docker-in-LXC-on-ZFS failed four ways — unprivileged port sysctl denied → privileged;
  overlay-on-ZFS permission denied → `storage-driver: vfs`; then `remount-propagation MS_PRIVATE: permission
  denied` even with `lxc.apparmor.profile: unconfined`. **Abandoned LXC → VM** (overlay2 works out of the box).
  Lesson baked into the deploy-kit README: for Docker on this Proxmox, use a **VM**, not an LXC-on-ZFS.
- **Stack:** `docker compose` with **DocuSeal + Postgres 16** (the deploy-kit `docker-compose.yml`); both
  containers **Up**; admin account created (initial-setup page → dashboard) at **http://10.224.10.60:3000**.
- **Reachable remotely over Tailscale** — the dashboard loaded from off-site (Beverley) via the new
  `hq-subnet-router`, proving the RND-5 remote-admin path carries the DocuSeal admin UI. (External *signers*
  still need the public HTTPS endpoint — Caddy + an ASA :443 rule — not built yet; that's the OI-8-ish bit.)

### Free-vs-Pro — SETTLED (definitive, on the live self-host)
The open question is now closed. On the **free self-hosted** DocuSeal, the template-upload UI **only accepts
PDF or images — it will not accept a `.docx`** (Minda tried the tagged `Sample-RAMS-DocuSeal-Phase0.docx`:
"not allowing to choose .docx file, only pdf or pictures"). This confirms the README split empirically:
**DOCX-field-tags auto-detection is a Pro feature**; free self-host does **manual field placement on a
PDF/image** (or submit-against-an-already-built template via the basic API). Phase 0's DOCX auto-detect
worked only because a **Cloud trial bundles Pro**.

**Decision taken — OPTION B (Pro license acquired 2026-10-11).** Minda has the Pro license, so the
DOCX-field-tags route is the one we build: Anna generates a fresh tagged RAMS `.docx` each time and pushes it
via the DOCX-field-tags API — no hand-built fixed template. Option A is moot now.
- ~~**Option A — free, fixed template**~~ — not taken (would have meant one pre-built PDF template + variables).
- **Option B — Pro — CHOSEN:** unlocks the **DOCX-field-tags API** → Anna's "fresh tagged RAMS every time,
  no pre-built template" vision, fully automated. **License in hand; apply it to the self-host next.**

Everything mechanical is proven both ways now (Phase 0 = the whole send→sign→signed-PDF+audit loop on Cloud;
Phase 1 = the self-host runs and is remotely reachable). The only remaining decision is A-vs-B, which is
about **how Anna's RAMS vary**, not about the technology.

## Next steps (A-vs-B now decided = B; resumable remotely over Tailscale)
1. **Apply the Pro license** to the self-host (enter the licence key in the DocuSeal admin → confirm the
   DOCX-upload + field-tags API unlocks on the box; re-try the tagged `Sample-RAMS-DocuSeal-Phase0.docx`
   upload the free UI refused → it should now auto-detect the fields). ← **the "that is next" step.**
2. **SMTP** on the self-host (so signing links actually send) + one full internal sign test end-to-end on
   our own box (mirror of the Phase-0 Cloud loop, now on our kit).
3. **Wire Anna** (Minda adds the DocuSeal API base URL + key to Anna's env; test
   `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX`; confirm the webhook returns the signed PDF). Cross-KB: Anna is
   wired via her own `Raw/`, not by Eugene editing her KB. Minda holds the key; Eugene never types it (§3).
4. **Public exposure** (Caddy on `sign.fishbone…` + an ASA :443 rule) **only if external signers** are
   needed — until then it's internal/Tailscale-only, which is enough to prove the loop.
5. **Graduate** → self-host pilot runbook + Hub task once the above are proven on the box.

## Open question still to settle
- ~~Free-vs-Pro~~ **SETTLED 2026-10-11** (DOCX-tags = Pro; see Phase 1 above). ~~A-vs-B business choice~~
  **DECIDED 2026-10-11 = Option B** (Minda acquired the Pro license). No technical unknowns remain — the
  path is: apply the license → SMTP + self-host sign test → wire Anna → (optional) public exposure → graduate.
- **Graduation status:** both phases proved out; the self-host is live. Ready to put to Minda for full
  graduation (self-host pilot runbook + Hub task + Anna wiring) once A-vs-B is chosen and SMTP is on.
