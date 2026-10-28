# Runbook — AI machine P1 test: code task (coder model on the P40)

> **Eugene, 2026-10-28 (guide-only, §3).** The fourth P1 smoke test: a small coding request → **working**
> code. Unlike the vision/speech/text tests you don't just read the answer — you **run it to verify**, so this
> proves the **coder model + the generate→run→check dev loop** on the P40. The real-time foundation for the
> RND-19 software foundry (the heavy 480B batch builder comes later). **Minda runs it on the box; Eugene
> guides + verifies. Local only. The model writes + tests code; a HUMAN reviews before any generated code
> touches a live system — never auto-run against anything real (§3).** Assumes **Ollama is up** (serving-layer
> step, as in the P1 vision runbook).

## Prerequisites
- [ ] Ollama running on the P40s (from the vision runbook Step 2).
- [ ] A **scratch dir** to run generated code safely: `mkdir -p ~/code-test && cd ~/code-test`.

## Step 1 — Pull the coder model
A ~30–32 B coder at Q4 fits one 24 GB P40:
```bash
ollama pull qwen3-coder:30b        # Qwen3-Coder 30B-A3B (MoE, fast); or:
ollama pull qwen2.5-coder:32b      # proven, strong alternative
```
*(RND-2 shortlist = "Qwen3-Coder-30B" — verify the exact tag on `ollama.com/library`. `qwen2.5-coder` is the
well-worn fallback. `:7b` for a quick tiny check.)*

## Step 2 — Ask for a small, verifiable script (the test = it must RUN)
Give it a real, bounded, checkable task. Example (estate-relevant, safe):
```bash
cd ~/code-test
# a tiny sample input so we can actually verify the output:
printf 'name,qty,unit\nboards,20,ea\nscrews,500,box\nboards,12,ea\ncement,8,bag\nscrews,2,box\n' > materials.csv

ollama run qwen3-coder:30b "Write a Python script 'totals.py' that reads materials.csv (columns: name,qty,unit)
and prints the total qty per item name, sorted, as 'name: total unit'. Use only the standard library. Output
ONLY the code. /no_think" > totals.py

# strip any stray markdown fences, then RUN it — this is the real proof:
sed -i '/^```/d' totals.py
python3 totals.py
```
**Expected (verify by hand):** `boards: 32 ea`, `cement: 8 bag`, `screws: 502 box`. If the numbers are right,
the coder works end-to-end.

**API (how a pipeline would call it):**
```bash
curl -s http://localhost:11434/api/generate -d '{"model":"qwen3-coder:30b","prompt":"Write a self-contained Python function ... Output only code.","stream":false}' \
  | python3 -c "import sys,json;print(json.load(sys.stdin)['response'])"
```

## What good looks like, and iterate
- **Pass =** the generated script **runs first or second try** and gives the **correct** result, using real
  (not invented) library calls. Try 3–4 tasks: a CSV cruncher (above), a small file-rename script, a regex
  extractor, a tiny API-call snippet.
- **The dev loop:** generate → run → if it errors, paste the error back to the model ("this failed with: …,
  fix it") → re-run. A good coder closes that loop in 1–2 turns.
- **Speed/fit:** `nvidia-smi` — model on one P40 (~18–22 GB), stable temps; time a generation.
- Compare `qwen3-coder:30b` vs `qwen2.5-coder:32b` on the same tasks; keep the better one.

## If it fails
- **OOM:** use `qwen3-coder:30b` (MoE, lighter active) or a smaller quant / `OLLAMA_SCHED_SPREAD=1`.
- **Code won't run / hallucinated APIs:** feed the error back (the dev loop); tighten the prompt ("standard
  library only", "output only code"); drop to a known-good task to isolate model vs prompt.
- **Markdown fences in the output:** strip them (`sed -i '/^```/d'`) or ask "output only the code, no fences".

## ⚠️ Safety for the code test (§3)
- Run generated code **only in the scratch dir**, never against live systems, the PBX, the NAS data, or
  production config. A **human reads it first.** (Same rule as Eugene's charter: the model writes + tests;
  a human deploys.)
- Keep it offline — the coder works on local inputs; nothing it writes reaches a live system without review.

## Next after this passes
→ This proves the **real-time coder** (interactive help, small scripts/tools for the estate). The **RND-19
software foundry** then runs the **big 480B model in batch** overnight for larger code-gen/refactor jobs —
same idea, heavier model, human-reviewed before anything is used. See `estate-intelligence-software-buildlist.md`.

---
_Guide-only (§3): Minda runs it on the box + holds all creds; Eugene guides + verifies. Local only; generated
code is human-reviewed before any live use. Fourth of the P1 proofs (vision · speech · text · code). Verify
model tags at ollama.com. Pairs with RND-19 (foundry) + RND-2 (brain)._
