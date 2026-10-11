# RND-8 — Anna integration (RAMS text-tags + the Composio call)

_How Anna fires a signing request against the self-hosted DocuSeal, once it's up. Guide-only.
Wiring Anna is done via **Anna's own env / `Raw/`** (cross-KB), not Eugene editing her KB. The DocuSeal
**API token + base URL** are **Minda-held secrets** in Anna's environment — Eugene never types them (§3)._

## Governance gate (decided 2026-10-11)
The human approval is on **(a) the RAMS document** and **(b) the recipient list**. Once both are approved
(director sign-off), Anna may **send + collect unattended**. So the call below only fires **after** that
approval — it is the "action applied" step of propose → approve → act → log (RND-9).

## 1. The RAMS template carries DocuSeal text-tags
Anna already builds RAMS with python-docx; the tags are just literal text at the signature blocks. Syntax
(confirmed working in Phase 0 — fields auto-detected):

```
{{Director Signature;type=signature;role=Director}}
{{Director Date;type=datenow;role=Director}}          # auto-fills signing date, read-only
{{Operative 1 Name;role=Operative 1}}                 # no type = text field
{{Operative 1 Signature;type=signature;role=Operative 1}}
{{Operative 1 Date;type=date;role=Operative 1}}       # signer picks the date
```
- Attributes are **semicolon-separated**; `role=` names the submitter (a real string, not empty).
- One `role` per person; repeat the block per operative row.
- The canonical reference template is `../phase0/make_sample_rams.py` (proven in Phase 0) — reuse its tag
  layout in Anna's real RAMS template.

## 2. Anna creates the submission (Composio)
Composio exposes DocuSeal tools; the DOCX route (needs **Pro** per the free-vs-Pro finding):
`DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` — pass the tagged DOCX + the approved submitter list.

Illustrative payload (shape — confirm exact Composio arg names at wire-up):
```json
{
  "name": "RAMS — <project> <docno>",
  "documents": [ { "file": "<base64 or URL of the tagged RAMS .docx>" } ],
  "submitters": [
    { "role": "Director",    "name": "Mindaugas Gaudiesius", "email": "minda@fishboneconstruction.co.uk" },
    { "role": "Operative 1", "name": "<name>",               "email": "<subbie email>" },
    { "role": "Operative 2", "name": "<name>",               "email": "<subbie email>" }
  ],
  "send_email": true
}
```
- Base URL = the self-hosted DocuSeal (`https://sign.fishboneconstruction.co.uk`); token = Minda-held.
- DocuSeal auto-detects the tags, emails each signer a link, collects signatures.

**Free-tier fallback (Option A, no Pro):** build ONE RAMS template in the DocuSeal UI (fields placed
once), then Anna calls the basic **create-submission-from-template** with just the submitter list +
`[[variables]]` for the changing content. Works on free; less flexible than fresh-DOCX-per-job.

## 3. Collect the signed result
Two ways (no inbound firewall hole needed for either):
- **Webhook** `form.completed` → a small internal receiver fetches the signed PDF + audit log → files it
  into the project folder (→ RND-7 project brain / RND-3 storage). (Pro feature set.)
- **Poll** `DOCUSEAL_GET_SUBMISSION` / `..._GET_SUBMISSION_DOCUMENTS` on a schedule until complete, then
  fetch the signed PDF + audit log. Simpler; works on the basic API; good enough to start.

## 4. File + log
- Store the **signed PDF** + **Audit Log PDF** in the project folder (and the estate backup, RND-3).
- Log the action (who approved doc+recipients, when sent, when completed) — the "outcome logged" step,
  feeds the RND-9 Approvals Desk record.

## Secrets (Minda-held; never in git; never typed by Eugene)
DocuSeal **API token**, base URL, SMTP creds, Pro licence key. They live in Anna's environment / the VM,
delivered to Anna via her own setup / `Raw/`.
