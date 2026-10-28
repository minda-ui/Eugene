# Runbook — AI machine P1 test: text summarise (general LLM on the P40)

> **Eugene, 2026-10-28 (guide-only, §3).** The third P1 smoke test: a chat log / block of text → a tight
> summary. Proves the **general LLM** runs on the P40 and the **48 GB fits a ~27–32 B model at Q4**, and that
> it summarises your real content usefully. **Minda runs it on the box; Eugene guides + verifies. Local only;
> the summary informs a human — it triggers nothing on its own (§3).** Assumes **Ollama is already up** (the
> serving-layer / foundation step, same as the P1 vision runbook); if not, do that first.

## Prerequisites
- [ ] Ollama running with the P40s (from `Runbook-AI-Machine-P1-Test-Photo-HS-Vision.md` Step 2) — `ollama run llama3.2:1b "hi"` works on GPU.
- [ ] A **real sample**: paste a day's **site chat log** (or an email thread / a transcript from the Whisper test) into `~/log.txt`.

## Step 1 — Pull the general model
A ~27–32 B Qwen3 at Q4 fits one 24 GB P40 (~18–22 GB):
```bash
ollama pull qwen3:32b          # dense, strong; or:
ollama pull qwen3:30b-a3b      # MoE — faster (fewer active params), similar quality
```
*(RND-2 shortlist named "Qwen3.6 27B" — use the closest available ~27–32 B Qwen3 at Q4; verify the exact tag
on `ollama.com/library/qwen3`. For a quick first check, `qwen3:8b` is fast and tiny.)*

## Step 2 — Summarise a real log (the test)
**CLI:**
```bash
ollama run qwen3:32b "Summarise this construction site chat for a site manager. Give:
1) a 3-line summary of what happened today;
2) decisions made;
3) open requests / materials or actions still needed;
4) anything urgent or a blocker.
Use ONLY what's in the text. Be concise. /no_think

$(cat ~/log.txt)"
```
**API (how the pipeline will call it):**
```bash
LOG=$(cat ~/log.txt)
curl -s http://localhost:11434/api/generate -d "$(python3 -c '
import json,sys
log=open("/home/minda/log.txt").read()
prompt=("Summarise this construction site chat for a site manager. Give: "
        "1) a 3-line summary; 2) decisions; 3) open requests/materials/actions; "
        "4) anything urgent or a blocker. Use ONLY what is in the text. Be concise.\n\n"+log)
print(json.dumps({"model":"qwen3:32b","prompt":prompt,"stream":False}))
')" | python3 -c "import sys,json;print(json.load(sys.stdin)['response'])"
```
`/no_think` (or a non-thinking setting) keeps Qwen3 from printing its reasoning — you want just the summary.

## What good looks like, and iterate
- **Pass =** the summary is **accurate** (captures the real decisions + the open requests, names materials/
  people/numbers correctly) and **invents nothing**. Test 3–4 logs: a busy day, a quiet day, one with a clear
  action ("order 20 boards"), one with a blocker.
- **Speed/fit:** watch `nvidia-smi` — the model sits on one P40 (~18–22 GB), stable temps; time a response.
- **Tighten the prompt** to the shape Anna actually wants (e.g. always output the 4 headed sections). That
  prompt becomes the P2 **daily summariser**.
- Try `qwen3:30b-a3b` vs `qwen3:32b` on the same logs — compare speed vs quality; pick the daily driver.

## If it fails
- **OOM:** `qwen3:32b` too big for one card → use **`qwen3:30b-a3b`** (MoE, lighter active), a smaller quant,
  or let Ollama split (`OLLAMA_SCHED_SPREAD=1`).
- **Vague / rambling or shows its "thinking":** add **`/no_think`**, tighten the instruction, lower it to the
  4 fixed sections.
- **Slow:** the MoE `30b-a3b` is faster; or `qwen3:14b` if you need snappier at some quality cost.

## Next after this passes
→ This is the engine behind the **P2 daily update summariser** ("what happened on FC2611 today") over the
Telegram feed, and it summarises the **Whisper transcripts** too. Pair it with the **request extractor**
(same model, different prompt). See `estate-intelligence-software-buildlist.md`.

---
_Guide-only (§3): Minda runs it on the box + holds all creds; Eugene guides + verifies. Local only; the
summary informs a human. Third of the P1 proofs (vision · speech · text · code). Verify model tags at
ollama.com. Pairs with RND-21 (site feed) + RND-2 (brain)._
