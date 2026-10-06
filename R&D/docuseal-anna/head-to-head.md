# RND-8 — DocuSeal vs Documenso, head-to-head (for Fishbone)

_Status: exploring (2026-10-06). Scored for OUR use case: Anna auto-sends RAMS, self-hosted on the
Proxmox box, external subbie signers, maybe a project portal later (RND-7). Guide-only; no secret held (§3)._

## Scorecard (✅ better for us / ⚠️ caveat / ❌ weaker)

| Dimension | DocuSeal | Documenso |
|---|---|---|
| Licence (self-host free tier) | ✅ AGPL; Pro only for branding/SSO/bulk/**embedding** | ⚠️ AGPL **Community**; **embedding + white-label are paid Enterprise (EE)** |
| REST API + webhooks (free self-host) | ✅ yes | ✅ yes (Community) |
| Composio connector (Anna-native) | ✅ `DOCUSEAL_*` | ✅ `DOCUMENSO_*` |
| Input format | ✅ **DOCX**, PDF, HTML | ⚠️ **PDF-centric** (Anna must convert docx→PDF first) |
| Field placement | ✅ **text-tags** `{{Signature;role=…}}` in the doc — survive layout/rev changes | ❌ **X/Y coordinate %** — brittle when the RAMS reflows; or fixed-template coords |
| Signer needs account | ✅ no (email link) | ✅ no (email link) |
| Host footprint / ops | ✅ Ruby; **SQLite or Postgres**; auto cert; ~1–2 GB | ⚠️ **Node 22 + Postgres**; signing-cert setup; heavier |
| Audit trail / signed PDF | ✅ PKCS#7 + audit log | ✅ cert-signed + audit log |
| Embedded signing in our own portal | ⚠️ Pro feature | ⚠️ **EE (paid)** feature |
| Polish / momentum | ✅ clean UI, light | ✅ very polished, YC-backed, big community |

## Why DocuSeal wins *for the RAMS-automation goal*
1. **DOCX-native + text-tags = the robust Anna workflow.** Anna already builds RAMS with python-docx; she
   drops `{{Signature;role=OperativeN}}` literal tags at each sign-off row and the Issued-By line, hands the
   DOCX to DocuSeal, and the fields land correctly **even when the RAMS layout changes rev to rev**.
   Documenso wants a **PDF + coordinate positions** — so Anna would convert to PDF *and* pin field
   coordinates (or maintain a fixed-coordinate template), which breaks whenever the document reflows. For a
   living document like a RAMS, text-tags are decisively better.
2. **Lighter to host** (Ruby + SQLite/Postgres, auto cert) vs Node 22 + Postgres + manual signing cert.
3. **Embedding isn't needed** for the "Anna sends a link, lads sign on their phone" flow — and where
   embedding *is* wanted later (a portal), note **both** charge for it (DocuSeal Pro / Documenso EE), so it
   isn't a free Documenso advantage.

## When Documenso would be the better pick
- We decide to build a **polished Fishbone signing/project portal** and are willing to **pay for Enterprise**
  to embed the signing experience white-labelled inside it (RND-7 productised).
- We standardise on **fixed PDF templates** with stable layouts (coordinates stop being brittle) and value
  Documenso's UI/ecosystem.
- We want the largest community/most active roadmap and don't mind the heavier Node stack.

## Verdict
- **Pilot DocuSeal** for Anna-automated RAMS signing. It fits Anna's DOCX/python-docx reality, survives
  revisions via text-tags, is lightest to run, and is Composio-native. **Clear front-runner.**
- **Keep Documenso on the bench** as the upgrade path *if* a paid, embedded, white-labelled project portal
  (RND-7) becomes a real goal — re-evaluate then, budget included.
- **LibreSign** still rides along free with Nextcloud (RND-3) for **internal** sign-offs.

## Correction to earlier note
`alternatives.md` implied Documenso's embedding fits an RND-7 portal "free" — **corrected: embedding is a
paid Enterprise feature self-hosted.** The free Community Edition gives core signing + API + webhooks only.

## Still true for both (the real gate)
Either needs a **public HTTPS endpoint** for external subbies (OI-8/firewall dependency), its **API key/cert
is a secret Minda holds** (Eugene never types it), and Anna is wired via her own env/`Raw/` (cross-KB, §3).
