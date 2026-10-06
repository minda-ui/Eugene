# RND-8 — Self-hostable e-signature options (DocuSeal + alternatives)

_Status: exploring (2026-10-06). Minda: "dig for more digital signature software, ideally like DocuSeal,
which can run on our server." Guide-only; no live change; no secret held (§3). Companion to `notes.md`._

## The field (all run on our own server; all give signed PDF + audit trail)

| Tool | Licence / cost | Stack / deps | Signer needs account? | API + webhooks | Composio connector | Field placement | Notable |
|---|---|---|---|---|---|---|---|
| **DocuSeal** | AGPL-3.0 free; Pro ($20/user/mo) only for branding/SSO/bulk/embed | Ruby; **SQLite or Postgres**; SMTP; ~1–2 GB | **No** (email link) | Yes | **Yes** (`DOCUSEAL_*`) | Drag-drop **or text-tags** `{{Signature;role=…}}` auto-detected | Lightest; simplest to host; text-tags ideal for Anna |
| **Documenso** | AGPL-3.0 **Community** free; **embedding/white-label = paid Enterprise (EE)** | **Node 22 + Postgres**; SMTP; signing cert | **No** (email link) | Yes (REST/tRPC + webhooks: document.signed/completed) — Community | **Yes** (`DOCUMENSO_*`) | UI/API, **X/Y coordinates**, PDF-centric (no docx text-tags) | Most polished; embedded signing is an **EE (paid)** feature, not free — see `head-to-head.md` |
| **OpenSign** | AGPL-3.0 free | Node + **MongoDB**; docker-compose | **No** (email link) | Yes (REST + webhooks) | No (direct API) | Drag-drop fields, reusable templates | OTP verify, completion cert; extra DB (Mongo) to run |
| **LibreSign** | AGPL free (Nextcloud app) | **Nextcloud** (PHP) + root signing cert | ⚠️ tends to need a Nextcloud login | Yes (Nextcloud API) | No (direct API) | Placement step in Nextcloud UI | **Free if we deploy Nextcloud (RND-3)**; clunkier for external subbies |

Sources: sliplane "5 OSS DocuSign alternatives" (https://sliplane.io/blog/5-open-source-docusign-alternatives);
Documenso docs (https://docs.documenso.com/); OpenSign (https://blog.elest.io/opensign-free-open-source-alternative-to-docusign/);
LibreSign (https://help.nextcloud.com/t/electronic-signature-openotp-libresign-eideasy/132203);
ossalt guide (https://ossalt.com/guides/best-open-source-alternatives-to-docusign-2026).

## Shared truths
- **All four are free, AGPL, self-hostable on the Proxmox box, produce a signed PDF + audit trail.**
- **All need a public HTTPS endpoint** for external signers (subbies open links from the open internet) —
  the same firewall/OI-8 dependency regardless of which we pick. The RND-5 mesh does NOT remove this
  (external people aren't on the mesh).
- AGPL copyleft only matters if we embed their *code* in a proprietary product — we won't; we just run them.

## Read for Fishbone
- **Anna-automation shortlist = DocuSeal vs Documenso** (both have Composio connectors → Anna drives them
  natively; OpenSign/LibreSign would need direct HTTP API calls).
  - **DocuSeal** — lightest, **text-tags in Anna's template**, simplest host. **Front-runner.**
  - **Documenso** — heavier (Node), PDF-centric with **coordinate-based** fields (brittle for a RAMS that
    reflows). Its embedded-signing SDK is a **paid Enterprise** feature self-hosted, not free. Weigh it only
    if we go **portal-first** and will pay EE. See `head-to-head.md` for the full scorecard — **DocuSeal wins
    for the Anna/RAMS goal** (docx-native + text-tags).
- **OpenSign** — capable (OTP, cert) but adds a **MongoDB** to run and has no Composio tool; less
  compelling than the two above for our stack.
- **LibreSign** — the "**free with the storage**" option: if we stand up **Nextcloud for RND-3**, signing is
  just an app we switch on. Great for **internal** sign-offs (Fishbone staff with Nextcloud accounts);
  weaker for one-off external subbies (account/login friction) and not Anna-native.

## Secrets / boundary (all options)
Whatever we pick, its **API key / signing cert is a secret Minda holds** (lives in Anna's env like the
Composio key); Eugene never types it. Wiring Anna is done via her own env / `Raw/`, not by Eugene editing
her KB (§3, cross-KB rule).

## Suggested next step (when hosting/firewall ready)
Keep **Google eSignature** for manual/now. For the automated future, **prototype DocuSeal first**
(lightest, text-tags, Composio) — and if a **project portal (RND-7)** becomes the goal, **trial Documenso**
in parallel for its embedded signing. **LibreSign** rides along free the moment Nextcloud (RND-3) exists —
worth enabling then for internal sign-offs.
