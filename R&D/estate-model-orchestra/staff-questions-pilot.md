# RND-24 flow 1 — Staff questions over our own documents (pilot plan)

_R&D (creative mode, 2026-10-31, Minda: "staff questions first"). Guide-only (§3): Minda runs every live
step and holds every login/OAuth; Eugene writes + verifies. Reuses two runbooks already written and not yet
run: `Runbooks/Runbook-RND2-Phone-Reachable-Model-Server.md` (Open WebUI + Ollama, capped LXC, PBX-safe)
and `Runbooks/Runbook-A1-Drive-to-NAS-Sync.md` (read-only Drive → NAS mirror)._

## What staff get
A private chat page (phone or PC) where they ask "what's the RAMS for working at height on the X job?",
"what's our policy on…?", "where's the method statement for…?" — and get an answer **with the source
document named**, or "I can't find that in our documents".

## Keep it simple for the pilot
| Piece | Pilot choice | Why |
|---|---|---|
| Chat page + users + document search (RAG) | **Open WebUI** (built-in "Knowledge" collections, user groups, per-collection access) | one app does UI + logins + document search; no Docker (runbook installs via pip) |
| Model engine | **Ollama** | simplest; swap later |
| Model | **CPU now:** ~8–14B (slow but works) → **P40s:** 27–32B (e.g. Qwen3 32B / Gemma 3 27B) | can start before the genuine cables arrive |
| Document embeddings | small embedding model (e.g. bge-m3 / nomic-embed) on CPU | finds the right paragraphs |
| Documents | **A1 read-only mirror** of chosen Drive folders on the NAS | Drive never touched; staff see only what we choose |
| Access | **Tailscale** (already live) — staff device joins the tailnet, nothing public | no firewall change |
| Gateway (RND-14) | **not yet** — Open WebUI talks to Ollama directly | add the gateway when flow 2 arrives |

## Rules baked in (system prompt + setup)
1. **Answer only from our documents; always name the source; if not found, say so** — never guess.
2. **Read-only.** It can't send, edit or change anything.
3. **Local only** — no cloud model connected, so nothing leaves the building.
4. **Collections by group:** site staff see H&S/RAMS/method statements/project docs; **no finance, HR or
   personal data** in the pilot at all.
5. Every chat is logged (Open WebUI history) so answers can be checked.

## Pilot steps
| # | Step | Who | Needs |
|---|---|---|---|
| 1 | Pick **2–3 pilot staff**, **1–2 document folders**, and how they'll ask (phone browser) | Minda | — |
| 2 | Collect **~20 real questions with known answers** (the test set) | Minda + staff (Anna can help) | — |
| 3 | Mirror those folders to the NAS (A1 runbook, read-only) | Minda runs, Eugene verifies | NAS pool, Drive OAuth (Minda) |
| 4 | Stand up the LXC + Ollama + Open WebUI (RND-2 runbook, CPU) | Minda runs, Eugene verifies | Proxmox |
| 5 | Create the Knowledge collection, groups, users; set the rules prompt | Minda + Eugene | — |
| 6 | Run the 20-question test → score right / wrong / "not found" | Eugene | — |
| 7 | 2-week pilot with the staff; collect thumbs up/down | staff | Tailscale on their phones |
| 8 | Move the model onto the P40s (bigger model, faster) — re-run the test | Minda + Eugene | genuine cables (AWT-1061) |

**Pass mark to widen it:** ≥ 17/20 right or honestly "not found", **0 made-up answers**.

## Open questions for Minda
1. Which 2–3 staff, and which document folders first? (suggest: H&S/RAMS + company policies)
2. Their devices — phones (Android/iPhone)? OK to install Tailscale on them?
3. Has the A1 Drive → NAS mirror been run yet, or is that step 3 for real?
