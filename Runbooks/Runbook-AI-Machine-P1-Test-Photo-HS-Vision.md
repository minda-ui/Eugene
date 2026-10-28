# Runbook — AI machine P1 start-here test: site-photo describe + H&S flag (Qwen3-VL)

> **Eugene, 2026-10-28 (guide-only, §3).** The **first** thing to run on the on-site AI machine once the
> **2× P40 + baffle** are fitted (Saturday + baffle). One site photo in → a description + health-&-safety
> flags out. It proves the GPU, the vision model, and the headline use-case (eyes on site) in **one shot,
> no pipeline.** **Minda runs it on the box; Eugene guides + verifies. Local only — the photo never leaves
> the estate. This is a TEST, not production: any real action stays a human's call (§3).**
> Source for model/driver facts: Ollama docs + the P40 model tier-lists (2026-10-28) — verify tags at
> `ollama.com/library/qwen3-vl` before pulling.

## Prerequisites (confirm first)
- [ ] **2× Tesla P40 fitted + GPU baffle in** (passive cooling), **"Above 4G Decoding"** on in BIOS.
- [ ] **NVIDIA driver 570+** installed (P40 = compute 6.1; Ollama needs driver **570 or newer** for ≤6.2).
- [ ] `nvidia-smi` lists **2× Tesla P40, 24 GB each**, temps sane. *(If temps climb under load → the baffle/airflow isn't right; stop.)*
- [ ] A **test site photo** on the box, e.g. `~/test-site.jpg` (grab one from a project folder / the FC2611 set on the NAS).

## Step 1 — Install the NVIDIA driver (if not already) — Minda runs
On the brain's host OS (Proxmox host, or a GPU-passthrough VM — decide which runs Ollama):
```bash
nvidia-smi   # if this already shows both P40s on driver 570+, skip to Step 2
```
If not present, install the 570+ driver for your distro, reboot, and re-check `nvidia-smi`.
⚠️ **Pascal/CUDA note:** CUDA 13 dropped Pascal; **stock Ollama still ships a CUDA-12 runner that supports the P40** — so it works today. Keep a known-good Ollama version; don't blind-upgrade onto a CUDA-13-only build later.

## Step 2 — Install Ollama + confirm it sees the GPUs
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama --version
# confirm GPU offload (not CPU): run a tiny model and watch nvidia-smi show VRAM use
ollama run llama3.2:1b "hi"      # quick 'is it alive + on GPU' check
```
`journalctl -u ollama` (or the server log) should say it found 2 CUDA devices. Keep the server bound to
**localhost / the tailnet only** — do **not** expose `:11434` to the internet (egress wall, RND-14).

## Step 3 — Pull the vision model
Start small, then the real one:
```bash
ollama pull qwen3-vl:8b        # ~5 GB — fast first smoke, fits easily
# then the better P40 fit (MoE, ~22 GB ≈ one full P40):
ollama pull qwen3-vl:30b-a3b   # verify this exact tag exists on ollama.com/library/qwen3-vl
```
*(If `30b-a3b` isn't listed, `qwen3-vl:32b` is the dense alternative — larger, may spread across both P40s.)*

## Step 4 — Run a site photo through it (the actual test)
**CLI (simplest):**
```bash
ollama run qwen3-vl:8b "You are a construction site safety assistant. Describe what is happening in this photo, then list any health & safety concerns you can see (missing PPE/hard hats, working at height without edge protection, blocked fire exits or access routes, trip hazards, unsafe loads). If a delivery note or sign is visible, read it. Be concise and only state what you can actually see. /home/minda/test-site.jpg"
```
(Ollama picks up the image path in the prompt.)

**API (how the pipeline will call it later):**
```bash
IMG=$(base64 -w0 ~/test-site.jpg)
curl -s http://localhost:11434/api/generate -d '{
  "model":"qwen3-vl:8b",
  "prompt":"Describe this construction photo, then list visible H&S concerns (PPE, working at height, blocked access, trip hazards). Read any delivery note/sign. Only state what is visible. Be concise.",
  "images":["'"$IMG"'"],
  "stream":false
}' | python3 -c "import sys,json;print(json.load(sys.stdin)['response'])"
```

## Step 5 — What good looks like, and iterate
- **Pass =** it correctly describes the scene and names at least the obvious real hazards (no hallucinated ones). Try 3–4 photos: a clearly-unsafe one, a clean one, one with a delivery note.
- Watch **`nvidia-smi`** during a run: VRAM used on a P40, GPU busy, **temps stable** (baffle working).
- If it's vague or wrong → **swap to `qwen3-vl:30b-a3b`** (much stronger) and tighten the prompt. Compare 8B vs 30B on the same photos — that comparison itself is a useful result.
- Time a response (first token + total) — that sets expectations for the real-time feed.

## If it fails
- **No GPU / runs on CPU (slow):** driver < 570, or Ollama didn't find CUDA → fix the driver, restart `ollama`.
- **OOM:** the model's too big for one card → use `qwen3-vl:8b`, or let Ollama split (`OLLAMA_SCHED_SPREAD=1`), or a smaller quant.
- **Garbled/hangs on Pascal:** you're on a CUDA-13-only Ollama build → install the last CUDA-12-runner version.

## Next after this passes
→ **Text summarise** (Qwen3.6 27B) and **code task** (Qwen3-Coder-30B) — the other two P1 smoke tests — then wire the **Telegram ingest bridge (P2)** so photos flow automatically to this same vision call (`estate-intelligence-software-buildlist.md`).

---
_Guide-only (§3): Minda runs it on the box + holds all creds; Eugene guides + verifies. Local only; the
photo never leaves the estate; any real action is a human's call. First test of the RND-2 brain / RND-16
vision. Verify model tags at ollama.com before pulling._
