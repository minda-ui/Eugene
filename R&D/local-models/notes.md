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

### GPU capacity in the HQ DL380 Gen9 (2U)
Max **2× double-wide GPUs** → **2× P40 = 48 GB** (P40 is dual-slot/FL/~250W; a 3rd DW won't fit in 2U).
Needs: HPE Gen9 **GPU enablement kit** (risers+power cables), **high-wattage PSUs** (2 cards ≈ 500W GPU),
high-perf heatsinks + GPU air shroud, **both CPUs populated** (✅). 48 GB = exactly the 70B tier, so the
box tops out at the single-strong-model sweet spot. 3 P40s across the estate (2 HQ pooled + 1 Beverley
independent). 4–8 GPUs in one box = a dedicated GPU chassis (Apollo 6500 / Supermicro 4U / GPU
workstation), not a DL380 — future play only.

### GPU adds: VRAM decides which models run FAST (Q4 ≈ 0.6 GB/billion params)
| VRAM | Fast on-GPU | Unlocks |
|---|---|---|
| 16 GB (Tesla T4 70W / P100 / RTX A4000) | up to ~14B; 8B at 40–80 tok/s | real-time small/mid chat, fast RAG, Whisper-large, light vision |
| **24 GB (Tesla P40 / RTX 3090/4090)** ⭐ | up to ~32B; Mixtral 8×7B; 70B hybrid | real-time strong reasoning, **live site-photo vision**, LoRA fine-tune |
| 48 GB (2× 24 GB) | **70B/72B fully** (Llama 3.3 70B, Qwen2.5 72B) | top open models "GPT-4-class" at home, big context, fine-tuning |

Speed: 8B ~10→50+ tok/s, 70B ~2→10–20 tok/s (GPU vs CPU). **Start: one P40 (24 GB).** 2× P40 = run 70B.
DL380 Gen9 fit: datacenter **passive** cards (not consumer RTX) + HPE **GPU enablement kit** +
high-wattage PSUs; ≤~250 W/card; both CPUs populated (needed, ✅). Power/heat → UPS (OI-7).
Beyond speed: **live vision tagging** of the Telegram evidence, **LoRA fine-tune on Fishbone data**,
image-gen if ever wanted. Dedicated RTX 3090/4090 box = faster+cheaper/GB than P40, better for
fine-tuning, leaves the production server untouched.

## Phased pilot (zero risk to phones)
1. **Headroom check** (Minda, Proxmox shell): `lscpu`, `free -h`, `df -h`, `lspci | grep -i vga`.
2. **Prove it:** capped LXC → Ollama → pull an 8B → benchmark tok/s.
3. **RAG pilot:** index the KBs/project docs; small internal query endpoint.
4. **GPU decision:** only if the earning use cases (live vision tagging, real-time) justify it.

## Sizing inputs still needed (the 4 numbers)
CPU model · total RAM + free-after-VMs · free disk · any GPU present.

## Multi-GPU & multi-site: pool vs route (Minda Q, 2026-10-04)
"Share power" = two different things:
- **Same machine (2× P40 HQ): YES pool** → 48 GB, run a full 70B (Q4) via llama.cpp/vLLM tensor split
  over PCIe (P40 = no NVLink, PCIe P2P fine for inference). Combined VRAM + compute for one model.
- **Across the two sites (HQ pair + Beverley P40): NOT for one model.** Model-parallel swaps activations
  every token; inside a box that's PCIe (~tens of GB/s, µs latency), between sites it's the airFiber+VPN
  (~1 Gbps, WAN latency, wireless hop) — 100s× slower → chokepoint. Tools exist (llama.cpp RPC, vLLM+Ray,
  exo) but it crawls. Cross-node pooling needs 10/25 GbE / InfiniBand, not a site bridge.
- **Right design: independent nodes, share the WORK not the MODEL.** HQ = 2× P40 → 70B estate brain;
  Beverley = 1× P40 → failover + local vision / fast 8–14B. A **gateway/router (LiteLLM)** load-balances
  independent requests + fails over — works fine over the slow link (only prompt+answer cross it, not
  per-token activations). Gives AI the same 2-site redundancy as the RND-3 storage.
- One giant model on all 3 cards would require them in one machine (or a fast local link), not the WAN.

## Links to other sparks
Pairs with the Telegram→Drive evidence stream (RND cluster): local models = private photo tagging,
delivery-note OCR→QuickBooks, sign-in OCR, RAG over the whole project record.
