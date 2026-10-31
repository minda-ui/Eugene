# RND-24 — The estate model orchestra: who plans, who works, who controls

_R&D design (creative mode, 2026-10-31, Minda: "we will use a couple of models — how will they work
together, and who will plan and control them?"). Builds on RND-14 (inference gateway), RND-15 (night
shift), RND-19 (480B foundry), RND-9 (approvals desk), RND-23 (brain hardware). Guide-only (§3)._

## The one rule
**Frontier models plan and check. Local models do the volume. Plain code directs the traffic. Humans approve.**
No model controls another model on its own authority — the *flow* is set by code and policy, so it is
predictable, logged, and can't "decide" to do something new.

## The five layers
| Layer | Who / what | Job | Runs on |
|---|---|---|---|
| **1. Owner** | **Minda** | sets goals, approves anything irreversible (Approvals Desk, RND-9), reads the morning brief | — |
| **2. Managers (planners + checkers)** | the **AI workforce** — Eugene, Anna, Rachel, Peter, Alex… (frontier Claude) | understand the request, break it into steps, pick which lane each step goes to, **check** the local models' output, escalate | cloud (Anthropic) |
| **3. Traffic control** | **the gateway** (LiteLLM, RND-14) + **the scheduler** (night shift, RND-15) — *software, not a model* | route each call by role name to the right model/box; enforce the private lane; fallbacks; budgets; log every call | small LXC at HQ |
| **4. Workers** | **local models** by role (table below) | do the actual reading, drafting, summarising, coding, OCR — fast, private, no per-use cost | AI server (V100s + RAM) |
| **5. Guardrails** | drafts-only, Approvals Desk, per-call logs, the "sovereign" no-cloud lane | nothing leaves, sends, pays or deploys without a human | everywhere |

## The worker roles (role names, not model names — models can be swapped any month)
| Role | Typical model size | What it does | Where (DL380 Gen10 + 3× V100 + 384 GB RAM) |
|---|---|---|---|
| `estate-fast` (the receptionist) | 8B | sorts and routes: "what kind of request is this, how hard, who owns it?" | GPU (small) or CPU |
| `estate-brain` (the generalist) | 70B dense or ~120B MoE | everyday answers, drafts, summaries, Q&A over our documents | GPU |
| `estate-vision` (the eyes) | ~30B vision | site photos, delivery notes, drawings, OCR | GPU |
| `estate-coder` (day) | ~30B coder | quick code/scripts | GPU |
| `estate-foundry` (night) | **480B coder (MoE)** | big overnight builds, as PRs for review | RAM + GPU, batch |
| `estate-memory` (the librarian) | small embedding model | indexes our files so the others can find facts (RAG) | CPU |

GPU memory check (Q4): brain 70B ≈ 42 GB + vision ≈ 20 GB + day-coder ≈ 20 GB + fast ≈ 5 GB ≈ **87 GB of 96 GB**
→ all four day roles can stay loaded at once on 3× V100. The 480B swaps in at night from RAM.

## Three example flows
**1. Delivery note at a site (Telegram photo → books)**
`photo → estate-vision reads it → estate-brain drafts the bill entry → Rachel (frontier) checks it against the PO → Minda approves → entered.`
Local models did ~95 % of the tokens; the frontier model only checks; the human only approves.

**2. A staff question ("what's the RAMS for the Beverley job?")**
`question → estate-fast: "document lookup, easy" → estate-memory finds the file → estate-brain answers with the source.`
If estate-fast scores it **hard / risky / low confidence** → it goes up to the owning AI employee (frontier).

**3. A new internal tool (the foundry)**
`Eugene (frontier) writes the spec + tests → night scheduler hands it to estate-foundry (480B) overnight → tests run automatically → Eugene reviews the PR in the morning → Minda merges.`

## Who decides "local or frontier?" — the escalation ladder
1. **Policy first (code):** private data (HR, finance, site photos) → **sovereign lane, local only, never cloud**.
2. **Difficulty (estate-fast scores it):** routine → local; hard / multi-step / judgement → frontier manager.
3. **Confidence (the checker):** if the local answer fails a check (tests, totals, citations), it escalates instead of being sent.
4. **Stakes (Approvals Desk):** anything irreversible → a human, whatever model produced it.

## Who controls the whole thing
- **Minda** owns the policy (what's private, what needs approval, spend limits).
- **Eugene** maintains the gateway config, the role→model map and the night schedule (§2b — config/code in git,
  reviewed like any change); proposes model swaps; Minda approves.
- **Each AI employee** decides, per task, which lane to use — within the policy.
- **No local model** can call the cloud, send email, or change a live system — it only returns text to whoever asked.

## Where DeepSeek Harness fits (2026-10-31, Minda asked)
**Seat: the local agent workbench inside layer 4** — a harness where a local planner model (480B / 70B)
drives smaller local models through multi-step jobs (read → edit → run tests → retry). **Best job: the
night foundry** (spec + tests from Eugene → dsh runs the loop overnight → PR for review). **Not** a manager
(layer 2 stays frontier), **not** traffic control (it sits *behind* the gateway so policy still applies),
**not** the staff chat (Open WebUI). Still **parked** (preview, unaudited, non-boundary sandbox — see
`R&D/local-models/deepseek-harness.md`). Conditions if used: own locked-down LXC, local models only via the
gateway, MCP/web/Composio off, works on a copy of the repo only, official repo + pinned version.
Revisit at the foundry stage; compare with other agent harnesses then.

## Phasing (works with today's hardware first)
- **P0 (Gen9 + P40s, once the genuine cables land):** gateway + `estate-brain` (27–32B) + `estate-memory`. One flow: staff Q&A over our documents.
- **P1:** add `estate-vision` → delivery-note flow with Rachel checking.
- **P2 (DL380 Gen10 + V100s):** 70B/120B brain, all day-roles loaded together; night shift + 480B foundry.
- **P3:** Beverley P40s as the failover lane (gateway falls back automatically).

## Open questions for Minda
1. Which flow first — staff Q&A, delivery notes, or the foundry?
2. What counts as "never leaves the building" (the sovereign list)?
3. Spend limit for frontier calls per month (so escalations stay predictable)?
