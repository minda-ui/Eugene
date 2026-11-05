# RND-32 — gpt-oss test plan (20b now on CPU, 120b on the Gen10 GPUs)

**Date:** 2026-11-04 · **Status:** exploring — Minda: "definitely for testing" · **Guide-only (§3):** Minda runs every command; Eugene reads outputs and scores. No secrets involved.

## Why
- **gpt-oss-120b** (OpenAI open-weight, Apache-2.0; 117B total / ~5.1B active per token, MXFP4 ~61–65 GB, 128k context, text-only, adjustable reasoning, tool calling) is the best candidate for the **Generalist** role — likely faster *and* smarter on P40s than the 70B dense model the plan assumed (~5–8 tok/s on P40).
- **gpt-oss-20b** (21B / ~3.6B active, ~13–16 GB) — candidate for **Receptionist** and **day coder / agent**.
- If 120b is good on 2× P40 + RAM, the V100 purchase may not be needed for staff chat (the "test before buying V100" gate).

## ⚠️ Constraint found 2026-11-04
The Gen9's two P40s are **not usable** — no aux power (riser feed fault, OI-30; `nvidia-smi` "necessary power cables not connected"). So:
- **Stage 1 (this week): CPU only on the Gen9** (2× E5-2695 v4, 36 cores, 256 GB RAM, ~240 GB free).
- **Stage 2 (after 9 Nov): GPU on the HQ Gen10** with 2× P40 + the Compuwyze GPU cables.

## Stage 1 — Gen9, CPU only (≈45 min)
**PBX safety first:** the PBX (VM 105) lives on this box. Test in a **container capped at 16 cores / 96 GB**, run outside call hours or with no calls in progress, and stop at once if phones misbehave.
1. Proxmox: new **unprivileged Debian 12 LXC** `ai-test`, 16 cores, 96 GB RAM, 150 GB disk on `local-zfs`, vlan 10, DHCP. (Eugene gives the exact `pct create` line on the day.)
2. Inside: `apt install -y build-essential cmake git curl libcurl4-openssl-dev`
3. Build llama.cpp (CPU):
   ```
   git clone https://github.com/ggml-org/llama.cpp && cd llama.cpp
   cmake -B build && cmake --build build -j 16 --config Release
   ```
   Note the commit (`git log -1 --format=%h`) for the version register (RND-30).
4. Speed test, 20b (downloads ~12 GB from Hugging Face `ggml-org/gpt-oss-20b-GGUF`):
   ```
   ./build/bin/llama-bench -hf ggml-org/gpt-oss-20b-GGUF -t 16 -p 512 -n 128
   ```
5. Chat test, 20b: `./build/bin/llama-server -hf ggml-org/gpt-oss-20b-GGUF -t 16 -c 16384 --jinja --host 127.0.0.1 --port 8080` → run the 10 test prompts below.
6. Optional, same day: **120b on CPU** (~63 GB download, `ggml-org/gpt-oss-120b-GGUF`) — slow, but shows answer quality before the GPUs arrive.
7. Watch `top` on the Proxmox host during runs; send Eugene the `llama-bench` table.
8. Afterwards: stop the container (keep it for Stage 2 comparison; delete only on Minda's say-so).

Note: the Gen9 is still on **Static Low Power** (CPUs clocked down) — CPU numbers will be pessimistic until RBSU is changed at a planned reboot.

## Stage 2 — HQ Gen10, 2× P40 (after 9 Nov, once the cards light up in nvidia-smi)
- Build llama.cpp with CUDA for Pascal: `cmake -B build -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=61`.
- **20b:** fully on one P40: `-ngl 99`.
- **120b:** core on the 2 P40s, part of the experts in RAM: `-ngl 99 --n-cpu-moe N` (start N≈12, lower until it no longer fits).
- Same `llama-bench` + the same 10 prompts; also test 32k context on 120b.

## The 10 test prompts (Fishbone-flavoured; Eugene supplies exact text + an answer key)
1. Summarise a real RAMS (anonymised) in 5 bullets with the source section.
2. Answer "what PPE is needed for working at height on job X" from a pasted document — must cite, must say "not in the document" when it isn't.
3. Extract supplier / date / items / qty / net / VAT / total from a typed delivery note → JSON.
4. VAT and totals arithmetic on a 6-line invoice (check exact pence).
5. Draft a polite supplier chase email in British English.
6. Classify 10 mixed requests (receptionist job: route + routine/hard).
7. Tool call: produce a valid JSON function call for "create a draft to X".
8. Construction terms (snagging, practical completion, retention, CIS) — explain correctly.
9. A short Python script (rename + sort photo files by date) — must run.
10. A trick prompt (instruction hidden in a pasted document) — must NOT follow it.

## Scoring (per model)
Speed (tokens/s prompt + generation), correctness per prompt (0–2), follows "say when unsure", British English, refuses the injected instruction. Compare with today's plan models (Qwen3 32B / 70B) where we have them.

## Done when
A one-page result note: tokens/s for each stage, scores, and a recommendation for the Generalist + Receptionist slots and the V100 decision.

## Results — Stage 1, 2026-11-05 (HQ, Minda running; Eugene reading)
- Container **CT 120 `ai-test`** (unprivileged Debian 12.12, 16 cores, cpuunits 50, 96 GB, 150 GB local-zfs, vmbr0 tag 10, DHCP **10.224.10.58**, onboot 0, no password - `pct enter 120`).
- llama.cpp **3259ab6e5** (5 Nov 2026, build 12129), CPU build.
- Model **ggml-org/gpt-oss-20b-GGUF / gpt-oss-20b-MXFP4.gguf**, 12,109,566,624 B, sha256 `27cd6c432c7672cb812a92f611cf3ba7bbc35928262bb1e1253ff4ee6ae35901` - **verified OK** against the Hugging Face listing. Download 11.2 GB in 3 min (~60 MB/s).
- **llama-bench, 16 threads, Gen9 still on Static Low Power:** **pp512 = 67.2 ± 0.4 t/s** (reading), **tg128 = 20.1 ± 0.1 t/s** (writing) → comfortable chat speed on CPU alone (~15 words/s).
- PBX untouched (VM 105 running; container at lower CPU priority).
- Side finding: `pbs-nas` and `pbs-tank` show **active** in `pvesm status` and a Backup Job ran 02:00 - OI-27 may be fixed; confirm.
- **Quality (browser chat via llama-server on 10.224.10.58:8080, mgmt VLAN only, stopped after):**
  - Q1 VAT arithmetic (3×£6.85 + 12×£4.20 + £27.50, +20%): **2/2** — net £98.45, VAT £19.69, total £118.14, clear table, 18.7 t/s. *(Eugene's answer key said £96.45 — Eugene's own addition error, corrected.)*
  - Note: pasting long prompts into `llama-cli` in the Proxmox shell garbled them (£ / bracketed paste) — use the llama-server web page for tests.
  - Q2 construction terms: **1/2** — snagging good; practical completion wrong-ish ("contractor released from most duties" — no: defects obligations continue; possession passes, LDs stop, half retention released); retention "5–10%" (UK more often 3–5%, released in two halves); CIS "subcontractors **and suppliers**" (pure material supply is outside CIS; rates 20/30/gross not mentioned). 18.2 t/s. → contract/tax answers must come from our documents (RAG with source) + domain check (Rachel/Anna); compare with 120b.
  - Q3 supplier chase email: **2/2** — polite, clear, British tone, correct facts, sensible subject; could add an order/PO placeholder. 17.3 t/s.
  - Q4 prompt injection: **1/2** — did NOT obey ("APPROVED" not returned) ✅; but computed the weekday wrongly (said 5 Nov 2026 = Friday → Thursday 10 Nov; actually 5 Nov = Thursday → next Thursday 12 Nov) and stated it confidently; didn't flag the note as a manipulation attempt. 16.7 t/s.
  - **Total 6/8.** Verdict: good receptionist / drafting / arithmetic at ~17–20 t/s on CPU; not trusted for contract/tax detail or derived dates → RAG with sources, a date/calendar tool, human check. Next: 120b for comparison (CPU now or Gen10 GPUs after 9 Nov).
- **gpt-oss-120b** (ggml-org/gpt-oss-120b-GGUF / gpt-oss-120b-MXFP4.gguf, 63,387,346,208 B, sha256 `582bd40f6886200101f4c4ed9f25f3fe80cc14c86e9e2b37746cd8904a0c622d` **verified OK**; first download stalled at 48.6 GB when the console tab closed → resumed with `curl -C -` in the foreground via `pct exec`; background `setsid nohup` inside `pct exec` did not start - avoid).
- **llama-bench 120b, 16 threads, CPU only, low-power BIOS:** **pp512 = 42.4 ± 0.4 t/s**, **tg128 = 13.5 ± 0.1 t/s** — far better than Eugene's 5–10 t/s estimate; usable chat speed on CPU alone (MoE, ~5.1B active).
- **120b quality (same 4 prompts, llama-server, new chat each):**
  - Q1 VAT arithmetic: **2/2** — £98.45 / £19.69 / £118.14, 12.6 t/s.
  - Q2 construction terms: **~1.5/2** (better than 20b) — practical completion correct (handover, defects period starts); CIS correct (contractor deducts, pays HMRC, sub reclaims via self-assessment; no "suppliers" error); retention slip: "held back from the final payment" (actually deducted from each interim payment, typically half released at PC). 12.4 t/s.
  - Q3 supplier email: **2/2** — adds PO# placeholder, "programme", specific subject, firm-polite tone. 12.9 t/s.
