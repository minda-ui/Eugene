# RND-2 — Local AI models on the HQ server

_R&D working notes (git-primary; not a control file). Status: **exploring**. Guide-only — Minda runs
anything at the Proxmox shell; Eugene specs/benchmarks. Safety §3 unchanged: no live change without
Minda executing; the production PBX is never put at risk._

## Why
Private (estate data stays in-building — ideal for site-evidence + finance), no per-token cost,
always-on, sovereign. We now control the network, so this is the payoff.

## The platform
- HQ server: **DL380 Gen9**, Proxmox VE 8.2.2. Runs **FusionPBX (VM 105) = production phones**, plus
  OPNsense (101) and others. **Hard rule: model work lives in a resource-capped LXC/VM; the PBX keeps
  priority and is never starved.**

## Feasible on CPU today
- Small/mid **quantized LLMs** (Llama 3.1 8B, Qwen2.5 7–14B, Mistral, Phi) via **Ollama/llama.cpp** —
  a few tok/s; good for async/batch (summarize, draft, tag, classify).
- **Local RAG** — small embedding model + vector index over KBs/project docs ("ask the estate").
  Best value / lowest effort.
- **Whisper** (voice notes) and **batch OCR**; **batch vision** tagging of progress photos (overnight).

## Needs a GPU (real-time / bigger / live vision)
- **Path A:** add a GPU to the DL380 — used **Tesla P40 (24GB)** or **RTX A4000**; needs GPU riser kit,
  power, cooling shroud (server GPUs passively cooled).
- **Path B:** dedicated small box — mini-PC + RTX, or **Mac mini M-series** (great perf/watt, silent).
  Leaves production server untouched.

## Phased pilot (zero risk to phones)
1. **Headroom check** (Minda, Proxmox shell): `lscpu`, `free -h`, `df -h`, `lspci | grep -i vga`.
2. **Prove it:** capped LXC → Ollama → pull an 8B → benchmark tok/s.
3. **RAG pilot:** index the KBs/project docs; small internal query endpoint.
4. **GPU decision:** only if the earning use cases (live vision tagging, real-time) justify it.

## Sizing inputs still needed (the 4 numbers)
CPU model · total RAM + free-after-VMs · free disk · any GPU present.

## Links to other sparks
Pairs with the Telegram→Drive evidence stream (RND cluster): local models = private photo tagging,
delivery-note OCR→QuickBooks, sign-in OCR, RAG over the whole project record.
