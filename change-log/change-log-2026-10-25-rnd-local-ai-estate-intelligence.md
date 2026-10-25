# Change log — 2026-10-25 — R&D session: the local-AI "estate intelligence" (RND-2 + RND-14..19)

## Summary
A long R&D/creative-mode session exploring the private local-AI build. Started from Minda's questions
(which models can the project machine run? can I use it from my phone? what's DeepSeek Harness? which
model when the P40s are in?), then — in Creative mode — dreamed the whole thing out as a coherent
"estate intelligence" organism and sketched each organ. **All work is R&D (exploring), guide-only, §3
intact: nothing installed, no live change, no secret held, images/audio/code stay in-building in the
designs, every output a draft for human sign-off.** Kept out of the control files per Creative-mode rule;
this entry is the §4 session record, not a graduation.

## What was produced (all in `R&D/`, git + Drive)
- **Phone-reachable model server — runbook** `Runbooks/Runbook-RND2-Phone-Reachable-Model-Server.md`:
  capped unprivileged LXC on HQ Proxmox, Ollama + Open WebUI via pip (no Docker — avoids the
  LXC-on-ZFS trap), reachable from Minda's phone over the existing Tailscale subnet router, no public
  exposure, PBX-priority. CPU-first (works today); GPU/RAG/Composio as later phases.
- **DeepSeek Harness assessment** `R&D/local-models/deepseek-harness.md`: it's a harness (agent framework),
  not a model; model-agnostic multi-model routing (the "couple of models" from Minda's videos); layers on
  local Ollama. Dev preview, no security audit, sandbox not a boundary, network not confined, routing is
  3rd-party plugins → **Minda's decision: PARK as watch until the P40s are fitted**; Open WebUI stays the
  default.
- **48 GB model shortlist** (in `R&D/local-models/notes.md`, web check, verify at fit-time): brain =
  Qwen3.6 27B @ Q8 / 70B-class; vision = Qwen3-VL; coder/executor = Qwen3-Coder-30B. Key shift: 27–32B@Q8
  now rivals 70B@Q4 at 48 GB and leaves room for vision. Also captured: the 480B-A35B is a RAM problem not
  a GPU problem (~250 GB resident; Mac Studio 512 GB or big-RAM CPU if ever wanted).
- **The organism — five organs sketched (RND cluster), each `R&D/<slug>/design.md`:**
  - **RND-14 inference gateway** (nervous system) — LiteLLM one-endpoint utility + role aliases + per-key
    policy = the data-egress wall that enforces the sovereign lane (RND-18).
  - **RND-16 site vision sentinel** (eyes) — local VLM over the Telegram photo stream: progress tags +
    doc reading + advisory H&S hazard flags; privacy/retention flagged to Minda/Victoria.
  - **RND-19 software foundry** (hands) — RAM-grown 480B coder builds Fishbone's own tools overnight via a
    propose→review→deploy loop; human gate is the design.
  - **RND-15 night shift** — idle P40s do the day's batch → drafts + a morning brief.
  - **RND-17 estate voice** — local STT→brain→TTS from the van; ask/draft only, never execute.
  - **RND-18 sovereign/failover lane** — enforced by the gateway (restricted data local-only; cloud
    fallback only per key).
- **One-page organism map** `R&D/estate-intelligence-map.mmd` (Mermaid) tying it all together, with the
  human review gate structurally in the middle of every action path.
- **ideas-log** updated: RND-14/15/16/17/19 logged; RND-14/15/16/17/19 → exploring; RND-18 spark.

## Housekeeping notes
- Drive syncs for R&D files used the strict-subset / own-lineage check (origin/main lags the branch and
  some R&D files were git-ahead of Drive); one stale sync caught up `R&D/local-models/notes.md` (missing a
  07-Oct GPU-checklist block). An accidental duplicate `site-vision-sentinel` Drive folder was renamed +
  moved to Archive (never trashed).
- Branch `claude/lucid-mayer-nsoili` = 11 commits ahead of `main`; PR raised at wrap-up.

## Nothing graduated
Everything stays R&D (exploring/watch/parked). The whole cluster shares one re-trigger: **revisit when the
2× P40 are fitted** (baffle + "Above 4G Decoding" + slot-seat). No Hub tasks closed today; no control-file
policy changed.
