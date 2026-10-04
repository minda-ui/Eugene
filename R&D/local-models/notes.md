# RND-2 — Local AI models on the HQ server

_R&D working notes (git-primary; not a control file). Status: **exploring**. Guide-only — Minda runs
anything at the Proxmox shell; Eugene specs/benchmarks. Safety §3 unchanged: no live change without
Minda executing; the production PBX is never put at risk._

## Why
Private (estate data stays in-building — ideal for site-evidence + finance), no per-token cost,
always-on, sovereign. We now control the network, so this is the payoff.

## The platform (confirmed from POST, 2026-10-04)
- HQ server: **DL380 Gen9**, BIOS P89 v3.40 (2024), S/N CZJ64905NP, iLO4 `10.224.10.78`, UEFI.
- **2× Intel Xeon E5-2695 v4 @ 2.10 GHz** = **36 cores / 72 threads** (Broadwell, AVX2+FMA3, no AVX-512).
- **128 GB RAM** (HPE SmartMemory, Advanced ECC) — the headline: big models + big context + RAG index
  fit in RAM even with the VMs running.
- **2 sockets = 2 NUMA nodes** → pin one model per socket (numactl) or run two model servers for
  throughput; avoids the cross-socket memory-bandwidth penalty. CPU inference is **memory-bandwidth
  bound** (DDR4-2400, ~4 ch/socket, ~75 GB/s/socket).
- Runs **FusionPBX (VM 105) = production phones**, plus OPNsense (101) and others. **Hard rule: model
  work lives in a resource-capped LXC/VM; the PBX keeps priority and is never starved.**
- GPU: not shown on POST (confirm with `lspci | grep -i vga`); not needed to start.
- Power/thermal flag: 2× E5-2695 v4 ≈ 240 W CPU under load → extra heat + UPS draw (ties to OI-7).

## Expected CPU performance (Q4, honest ranges)
| Model | ~RAM | ~tok/s | Role |
|---|---|---|---|
| Llama 3.1 8B / Qwen2.5 7B | 5 GB | 8–12 | daily driver, RAG |
| Qwen2.5 14B | 9 GB | 5–8 | better reasoning |
| **Mixtral 8×7B (MoE)** | 26 GB | 6–10 | **sweet spot** — quality/speed |
| Qwen2.5 32B | 20 GB | 3–4 | heavier analysis |
| Llama 3.3 70B | 40 GB | 1.5–3 | overnight/batch |
| bge/nomic embeddings | tiny | instant | RAG index |
Great for async/batch + RAG; usable for chat; not GPU-fast. Verdict: **a real private estate AI is
feasible on this box today, zero hardware spend.** GPU only later for live vision / real-time.

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
