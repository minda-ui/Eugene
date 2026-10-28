# How the estate operates — the operating model (people + two AI brains + the infrastructure)

> **Eugene, 2026-10-28 (guide-only, §3).** The synthesis of how it all works together — the companion to the
> estate map. Not a machine OS; the *operating model* of the whole estate: who does what, how the two AI brains
> divide the work, the governance spine, and the day-to-day flows. Pairs with the map, the storage roadmap,
> the backup design, and the AI-machine build list._

## In one line
**Humans decide and do the real-world work; the AI workforce (cloud) drafts, coordinates and keeps the
records; the on-site brain (local) does the private, file-heavy, sovereign work; the infrastructure keeps it
fast, backed-up and reachable — and nothing irreversible or outward happens without a human.**

## The four actors
| Actor | What it is | What it does | Where it runs |
|---|---|---|---|
| **Humans** | Minda + staff + site teams | decide, approve, author CAD/docs, run every live-system/outward change | the real world + HQ/sites |
| **Cloud AI workforce** | the Claude Code employees — Anna (construction), Peter (inbox/data), Rachel (finance), Victoria (governance), Alex (ops), Eugene (IT), John (properties), Helen, Nadia, Darius, Sarah | read, draft, propose, reconcile, triage, coordinate — the "office staff" | claude.ai (cloud), via Composio connectors |
| **On-site brain** | the local AI machine (Gen9 + P40s, local models) | vision on site photos, RAG over estate docs, summaries, overnight code/analysis — private + sovereign | HQ (soon Beverley too), on the estate's own data |
| **Infrastructure** | storage, backups, network, phones | keeps data fast + safe + reachable | HQ + Beverley |

## The two brains — and why both
They **complement**, they don't compete:
| | **Cloud brain** (Claude Code employees) | **Local brain** (on-site AI) |
|---|---|---|
| Strengths | broad knowledge, the web, connectors, drafting, coordination | private, sovereign, local, fast on big files/photos |
| Best for | email, documents, finance, governance, web research, running the workflows | site-photo vision, confidential-drawing RAG, bulk/overnight work, anything that must not leave |
| Data path | through Anthropic (cloud) | never leaves the estate |
| Reached via | claude.ai + Composio | tailnet / Open WebUI / local API |

**Rule of thumb:** if it's office/coordination/drafting → a cloud employee; if it's private or photo/file-heavy
or must stay on-estate → the local brain. Over time (A1→D1) more shifts local.

## The governance spine (the one rule everything obeys)
**AI proposes / drafts → a human reviews & approves → it's executed → it's logged.**
No AI makes an irreversible or outward-facing change on its own — no sending external email, no payment, no
filing, no live-system change, no holding of secrets (each employee's charter §3). The human is always the gate
on anything that leaves the estate or can't be undone. (This is the Approvals-Desk pattern, RND-9.)

## Where things live (the data plane)
- **Google Drive** — today the shared file surface: humans + the cloud workforce work off it; the NAS mirrors
  it (A1); the local brain reads the local copy. *(Trajectory: the NAS becomes primary, then Drive is dropped — A1→D1.)*
- **Smartsheet "AI Workforce Hub"** — the coordination board: tasks & requests, the roster, achievements, help
  & lessons. How the AI employees (and Minda) hand work to each other and track it.
- **Each employee's KB** (Drive + a git mirror) — its charter + four control files + change-log = its memory
  and its rules. Cross-KB messages go via a `Raw/` folder + a Hub row, never a direct edit.
- **The NAS** — the estate's own storage: project files, the brain's working data, the backup target.
- **The on-site brain** — local models serving vision/RAG/summaries/code over the estate's data.

## A day in the life (how work actually flows)
- **A site photo** is posted in a project chat → (the Telegram bridge) → the **local brain** tags progress +
  flags H&S + reads the delivery note → **Anna** surfaces it → a **human** acts.
- **A drawing is revised** (CAD) → saved to Drive (now) / the NAS (later) → mirrored → the brain re-indexes it
  for RAG so it can be asked about.
- **An email arrives** → **Peter** triages + labels + drafts a reply → **Minda** sends it.
- **An invoice / VAT question** → **Rachel** reconciles QuickBooks against HMRC → flags anything off to Minda.
- **An IT/build task** → **Eugene** writes the runbook/code + verifies → **Minda** executes the live step.
- **Overnight** → backups run (primary → **pulled** by Beverley + the R710 → snapshots); the brain can run
  batch work on the big model.
- **Minda away** → reaches both sites over **Tailscale**; the phones + services keep running on their own kit.

## Resilience (why it keeps working)
- **Two sites** (HQ + Beverley) on an airFiber link + IPsec VPN fallback; a spare radio.
- **Backups = 3-2-1(-1), all pull** — HQ primary, Beverley off-site, the R710 near-air-gapped local 3rd, plus
  an encrypted offline copy. No compromised box can delete the backups.
- **Remote access** — two always-on Tailscale anchors per site (never the brain) so a reboot can't lock Minda out.
- **Phones** on the estate's own PBX, backed up off-box for the first time.

## The direction of travel (increasing self-reliance)
The whole estate is moving **from cloud-dependent to sovereign**: the local brain takes on more; storage moves
on-estate (A1 → … → D1); backups and remote access already run on the estate's own kit. The end state is an
estate that **runs its own compute, storage, backups and phones, with the cloud used by choice, not necessity**
— with the human always the decision-maker.

---
_Guide-only (§3): the humans decide and execute; the AI drafts, coordinates and keeps records; the local brain
does the private/heavy work; nothing irreversible or outward happens without a human. Synthesis of the estate
map + the storage/backup/compute designs. Living doc — updated as the build progresses._
