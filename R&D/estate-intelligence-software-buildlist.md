# On-site AI machine — software build list (tests to prove, in order)

> **Eugene, 2026-10-28 (guide-only, §3).** The software to **build and run on the on-site AI machine** once
> the hardware is in (RND-2 brain + RND-3 storage). Ordered **prove-it-first**: smallest provable test →
> pipelines → heavy/later. Each maps to an organ design (`estate-intelligence-map.mmd`). **Eugene writes +
> tests the code; a human reviews every action that leaves the box; nothing auto-sends/files (§3).** All
> local — the data-egress wall (RND-14/18) means site photos + estate docs never leave the estate.
>
> **Models (RND-2 shortlist):** real-time on the **P40s (48 GB)** — **Qwen3.6 27B** (general),
> **Qwen3-VL** (vision), **Qwen3-Coder-30B** (code); batch on **CPU + 256 GB RAM** — **480B-A35B Q4** (the
> foundry brain). **Priority:** 🔴 P1 first proofs · 🟠 P2 the "couple of tests" · 🟡 P3 knowledge+records ·
> 🔵 P4 heavy/later.

---

## Foundation first (before any test) — the serving layer
| ✓ | Build | What it is | Proves |
|---|---|---|---|
| ⬜ | **Model server + API** (Ollama or vLLM) | Serves the models over the tailnet, phone-reachable (runbook exists), PBX-safe | The machine answers a prompt at all |
| ⬜ | **Open WebUI** (chat front door) | Human chat UI for Minda/staff; model switching | A person can talk to it |
| ⬜ | **Inference gateway skeleton** (RND-14) | One entry point + the **data-egress wall** (nothing leaves the estate) + per-use logging | The sovereignty guarantee is real, not assumed |

## 🔴 P1 — first proofs (single-model smoke tests, no pipeline)
_Point a model at one input, read the answer. Prove the GPU + each model before wiring anything._
| ✓ | Build | Model | Input → output | Proves | RND |
|---|---|---|---|---|---|
| ⬜ | **Photo describe + H&S flag** | Qwen3-VL | one site photo → "what's here? any hazard (no hard hat, blocked exit)?" | vision on the P40 works | 16 |
| ⬜ | **Text summarise** | Qwen3.6 27B | a pasted chat log → 3-line summary | the LLM + the 48 GB fit | 21 |
| ⬜ | **Code task** | Qwen3-Coder-30B | a small script request → working code | the coder model + dev loop | 19 |

## 🟠 P2 — the "couple of tests" (the Telegram pilot pipeline, RND-21)
_Wire P1 into a real feed on one project group. This is the pilot Minda green-lit._
| ✓ | Build | What it does | Depends on | RND |
|---|---|---|---|---|
| ⬜ | **Telegram ingest bridge** | read one project group → mirror messages + **photos** to storage → Anna's feed | storage (RND-3), Anna's inputs (AWT-1035), privacy sign-off (AWT-1036) | 21 |
| ⬜ | **Site-vision sentinel** | run each photo through vision → progress tags, H&S flags, read delivery notes | P1 vision, the bridge | 16 |
| ⬜ | **Daily update summariser** | "what happened on FC2611 today" from the message stream | the bridge | 21 |
| ⬜ | **Request extractor** | "need 20 boards Thursday" → a structured action for Anna (draft, human-approved) | the bridge | 21 |

## 🟡 P3 — knowledge + records (the machine becomes useful daily)
| ✓ | Build | What it does | Depends on | RND |
|---|---|---|---|---|
| ⬜ | **Estate RAG / knowledge base** | index the drawings, procedures, project folders on the NAS → ask questions, cite the source doc | storage, embeddings model | 7/14 |
| ⬜ | **Per-project record writer** | fold the day's photos/updates/requests into each job's structured record | P2 pipeline, RAG | 7 |
| ⬜ | **Approvals desk hook** | AI proposes → Minda approves → applied → logged (the human gate, reusable) | gateway | 9/18 |

## 🔵 P4 — heavy / later (needs the full brain + more trust)
| ✓ | Build | What it does | Needs | RND |
|---|---|---|---|---|
| ⬜ | **Software foundry** | overnight batch code-gen / refactor on the big model | 480B-A35B on CPU+256 GB (RAM fitted Sat) | 19 |
| ⬜ | **Night-shift batch** | scheduled estate analysis (summaries, flags, digests) while idle | foundry/gateway | 15 |
| ⬜ | **Voice interface** | speak to the estate brain (STT + TTS local) | serving layer | 17 |
| ⬜ | **Failover drill** | prove Beverley's node can run the full brain if HQ is down | Beverley Gen10 + 2× P40 | 18 |

---

## Where to start (the single best first test)
**The photo describe + H&S flag (P1, Qwen3-VL).** One site photo in, a useful answer out — it proves the
GPU, the vision model, and the headline use-case (eyes on site) in one shot, with zero pipeline to build.
Then the text summarise, then wire the Telegram bridge (P2) to make it a real feed for Anna.

## Guardrails (every build)
- **Local only** — photos + estate docs never leave the estate (RND-14/18 egress wall).
- **Human gate** — anything that would send, post, order or file is **drafted for a person**, never auto-done (§3).
- **Privacy** — the Telegram/site-chat data needs Minda + Victoria's lawful-basis + notice **before P2 goes live** (AWT-1036).
- Eugene writes + tests; Minda runs it on the machine + holds all creds.

---
_Guide-only (§3). Software counterpart to `estate-intelligence-map.mmd` + the RND-14..21 organ designs.
Models per RND-2; hardware per RND-2 (brain) + RND-3 (storage) + the Beverley node (failover)._
