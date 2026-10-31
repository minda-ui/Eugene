# RND-29 — Security of the local AI setup

_R&D plan (creative mode, 2026-10-31). Guide-only (§3): Minda owns every account, key and policy decision;
Eugene designs, configures with Minda, and reviews. Applies to the staff chat page (Open WebUI), the gateway,
local models, the document copy, and any Composio "hands"._

## Ten layers
| # | Layer | What we do | Pilot? |
|---|---|---|---|
| 1 | **Who can log in** | One account per person (never shared). Later: **sign in with Google Workspace** (their normal work login + 2-step) so leavers lose access when their Workspace account is disabled. | individual accounts ✅ · Google sign-in later |
| 2 | **Who sees what** | Groups (site / office / admin). Each document collection is shared only with the right group. **No HR, finance or personal data in the pilot at all.** | ✅ |
| 3 | **What never leaves the building** | A written **sovereign list** (draft below, Minda approves). The gateway enforces it: those requests go to local models only, never cloud. | ✅ (pilot is local-only anyway) |
| 4 | **Network** | Chat page reachable **only over Tailscale**; Tailscale rules let staff phones reach **only the chat page**, not servers. AI server and storage on the server VLAN / private triangle. **AI server has no general internet** — only updates and model downloads from an allow-list (makes "never leaves the building" physical, not just a setting). | ✅ Tailscale rule · egress block with OPNsense |
| 5 | **Every call logged** | Who asked, which model, when, size. Kept **90 days** (proposal) on the Gen9, readable by Minda + Eugene only. Monthly: Eugene summarises anything unusual. | ✅ |
| 6 | **Tricked by content** ("prompt injection") | Documents, emails and web pages are treated as data. Local models **only return text** — they can't send, delete or change anything. Any Composio access is per-worker, **exact tool allowlist, read-only, Proxy Execute off, sandbox off**. | ✅ (no tools in pilot) |
| 7 | **Secrets** | Composio/cloud API keys live only in the server's secret store, set by Minda; never in git, chat or documents; rotated if exposed. | ✅ |
| 8 | **Safe models** | Download only from official publishers (Hugging Face official orgs, Ollama library); safe formats (GGUF/safetensors); record name + checksum; pin versions. | ✅ |
| 9 | **Updates** | Monthly window: Open WebUI, Ollama, OS, drivers; version-pinned; backup first. | after pilot |
| 10 | **People + plan** | One-page **acceptable-use note** for staff (what to ask, what never to paste, answers can be wrong). **Kill switch:** stop the gateway / chat page in one command; revoke keys. | ✅ note · kill switch |

## Draft sovereign list (for Minda to approve)
**Never leaves the building (local models only):**
- HR files, payroll, staff personal details, health info
- Finance: bank, accounts, invoices with personal data, VAT/HMRC material
- Personal data of clients, tenants, neighbours (names + addresses + contacts together)
- Site photos showing people or faces; CCTV
- Contracts and tenders under negotiation
- Anything with passwords, keys, access codes (never pasted anywhere, local or cloud)

**May use cloud models (frontier AI employees), via the gateway and logged:**
- General drafting, public information, technical questions without personal data
- Documents already public or approved for sharing

## GDPR note
Keeping personal data on local models reduces risk (no third-party processor). Still needed: a short record of
what the AI processes and why, the 90-day log retention, and staff told in the acceptable-use note. (Peter/Sarah
compliance may want this — hand-off via Raw/ when it graduates.)

## Pilot minimum (before any staff use)
Individual accounts + groups · H&S/policy collections only · local models only (no cloud connected) ·
Tailscale rule (chat page only) · logging on · acceptable-use note shared · kill switch tested.

## Decisions for Minda
1. Approve / edit the sovereign list.
2. Google Workspace sign-in for the chat page (yes/later)?
3. Log retention: 90 days OK?
4. Who besides Minda + Eugene may read the logs?

## DECISIONS (Minda, 2026-10-31)
1. **Sovereign list: approved as drafted** (HR/payroll/staff, finance incl. VAT/HMRC, client/tenant personal data, site photos with people + CCTV, contracts/tenders under negotiation, anything with secrets → local models only).
2. **Log retention: 1 year** (not the 90-day proposal) — on the Gen9, Minda + Eugene only; state it in the privacy/acceptable-use note; auto-delete after 365 days.
3. **Cloud-AI spend cap: £100/month** — gateway (LiteLLM budget) stops cloud calls at the cap and alerts Minda.
4. **NVIDIA driver: R580** on the new HQ Gen10 (fresh install); Gen9 driver removed when the P40s move.
5. **Pilot: Minda only for the first 2 weeks**, then add 2–3 staff once reliable.
6. **Software:** pilot runs at **HQ only** for now (pinned version); **Beverley-first update staging later**, once the Beverley server is running.
7. **Firewall Step B public IPs:** open — **Minda to check what HQ has now (tomorrow, 1 Nov)**, then decide.
