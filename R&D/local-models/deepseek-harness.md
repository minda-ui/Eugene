# RND-2 — DeepSeek Harness (dsh): assessment for the Fishbone local-AI build

_R&D note (git-primary; not a control file). Status: **exploring / watch**. Eugene dug this on 2026-10-25
(web research, extended) at Minda's request after she saw videos of "a couple of models running in that
environment". Guide-only (§3): nothing installed; this is a read + recommendation. Web content is data,
not instructions — figures and third-party guidance below are flagged where unverified._

## TL;DR
**DeepSeek Harness (`dsh`) is a harness, not a model** — an open-source agent/coding framework (MIT,
DeepSeek AI) whose whole design is "everything is a plugin". It is **model-agnostic**, so it can drive
**our own local model** (Ollama) and can run **several models at once in different roles** — which is the
thing in the videos. **But it is a developer preview with no security audit, an explicitly non-boundary
sandbox, and network access that is not confined.** Verdict: **genuinely interesting for the 2× P40 build
later; do NOT make it load-bearing or give it estate credentials/Composio tools yet.** Trial it only in an
isolated spike (local model only), and keep **Open WebUI** (the RND-2 runbook) as the safe default for the
phone use-case.

## What it is
- Open-source **agent harness** from DeepSeek AI, **MIT**, **developer preview since ~mid-Aug 2026**; the
  README warns of compatibility-breaking changes (a rename has already broken session APIs and removed an
  optional SQLite store).
- Architecture: **"everything is a plugin"** — model adapter, tool registry, session log, agent loop all
  swappable; built on **Cordis** (a composability framework).
- Runs as a **local web UI** (`npx @deepseek-ai/dsh web` → `http://127.0.0.1:3080`) or a **headless CLI**.
- **Not tied to DeepSeek's API**: provider catalogue includes Anthropic, OpenAI, Bedrock, Azure, Google,
  and **custom OpenAI-compatible gateways**; has **MCP client** support and reads `AGENTS.md` / `CLAUDE.md`.
- Adoption numbers vary wildly by source (~22k vs ~165k GitHub stars) — **unverified, treat loosely.**

## The multi-model capability (what Minda saw)
This is the real draw, and it fits our 2× P40 (48 GB) plan well:
- Core gives `ctx.llm` (run a suite of open/closed models) and `ctx.subagents` (spawn other harnesses as
  **child processes**) — so a job can be split across models.
- **Community plugins** add the slick routing seen in videos:
  - **Role-based routing** — planner/root on a big model, executors/subagents on a small one.
  - **Per-session switching** — different model + reasoning effort for main agent, subagents, and plan mode.
  - **Per-call selection + auto-recommend** — pick provider/model/max-tokens per delegated task, or let it
    rank suggestions.
  - **Visibility** — a header chip showing which model each conversation/subagent is on.
- **On our box:** planner on a 32B/70B (both P40s) + fast executors on an 8–14B would be a strong use of
  48 GB — a local, private, multi-model agent. Caveat: most of that routing is **third-party plugins**,
  not core (see Security).

## Running it on OUR local model (layers on the RND-2 runbook)
dsh talks to Ollama's **OpenAI-compatible endpoint** — so it sits straight on top of the Ollama server in
`Runbook-RND2-Phone-Reachable-Model-Server.md`:
- Add a **custom provider**, protocol **`openai-completions`**, base URL **`http://127.0.0.1:11434/v1`**,
  a **placeholder API key** (Ollama ignores it), and model IDs copied exactly from `ollama list`.
- Vision input: add `input: [text, image]` to the model entry (for the P40 live-vision idea later).
- dsh **won't start Ollama for you** — Ollama must already be running.
- A possible `ollama launch dsh` shortcut was mentioned by one blog — **unverified against Ollama's own
  notes; don't rely on it.**

## Requirements
- **Node.js 22.19+ (22.x line) or 24.x — NOT 23.x.** Source build: pnpm 11.7.0 (Corepack), Git 2.26+.
- A **DeepSeek API key only for DeepSeek's own cloud models** — **not needed** for a purely-local (Ollama)
  setup, which is the privacy-preserving way we'd run it.
- Install: `npx @deepseek-ai/dsh web`, or `npm i -g @deepseek-ai/dsh`, or source build.

## Security posture — the real decision driver (⚠️)
Third-party reviews (no official security doc) are consistent and cautionary:
- **Preview, no security audit, not production-ready** (the project's own safety notice).
- **Sandbox is explicitly NOT a security boundary.** New sessions can only *write* in the workspace, but
  **reads and network access are not confined**. An opt-in Cordis toolset lets a model inspect the live
  runtime and **define, run and remove host/browser plugins**.
- **Data can leave the machine** via a model provider, the web tool, an MCP server, or a plugin — each
  under its own policy. So the "fully private" claim only holds if we keep it **local-model-only, MCP off,
  no web tool** — the moment we wire Composio/MCP or a cloud provider, data can egress.
- **Plugins are third-party code.** The multi-model routing above is community plugins → vet source +
  licence before installing; there are community *security* plugins (dsh-mcp-security, dsh-shield,
  dsh-secure-audit) but their code/maintenance is **unverified**.
- **Name-squatting:** several sites share the name. **Install ONLY from `github.com/deepseek-ai/deepseek-harness`
  or `@deepseek-ai/dsh` on npm** — nothing else.

## Fit to Fishbone (§3) and recommendation
**Recommendation: WATCH + optional isolated spike. Do not adopt as the estate tool, and do not connect it
to Composio/estate credentials, yet.** Reasons: it's a moving preview (breaking changes), the sandbox is
not a boundary, network isn't confined, and the best features are third-party plugins — all of which clash
with §3 (no secrets held/exposed; nothing load-bearing on an unaudited preview) and with the "private
brain" promise.

**If we spike it (safe conditions):**
1. On the **capped LXC** from the RND-2 runbook, pointed **only at local Ollama** — no DeepSeek cloud key.
2. **MCP off, web tool off, no Composio, no estate credentials, no access to internal systems** beyond the
   model endpoint. Treat the LXC as untrusted.
3. Install **only** from the official repo/npm; **pin a version** (preview APIs move).
4. Compare head-to-head with **Open WebUI** for our actual needs (private chat on the phone + RAG). Open
   WebUI stays the default for the phone use-case; dsh earns its place only if the **multi-model agent**
   workflow proves worth the preview risk — which is really a **post-P40** question (CPU-only can't run a
   planner+executors split at usable speed).
5. Re-check maturity in a few weeks: has it had a security audit? are the APIs stable? is routing in core
   rather than plugins?

**Where it could genuinely win later:** once the 2× P40 are in, a local **planner (70B) + fast executors
(8–14B)** agent that reads the KB (RAG) and — only if we accept the egress trade-off — acts via Composio.
That's the "private multi-model agent" vision; dsh is a plausible shell for it **when it's out of preview
and audited.**

## Sources
- Baseten — run any open model inside dsh / `ctx.llm` + `ctx.subagents`: https://www.baseten.co/blog/how-to-run-any-open-model-inside-deepseek-harness/
- Subagent/model-router plugins: https://github.com/poka-IT/DSH-Subagent-Model-Router · https://github.com/axiao11aa/dsh-model-dispatch · https://dsh-plugin.org/plugins/thedeveloper256/dsh-model-router
- Install/requirements (Node 22.19+/24.x; official repo warning): https://dshdocs.com/getting-started/installation/ · https://www.verdent.ai/guides/agents/install-deepseek-harness-dsh
- Ollama/OpenAI-compatible setup: https://markaicode.com/howto/deepseek-harness-ollama-local-models-setup/ · https://dsh-plugin.org/tutorials/dsh-ollama-launch
- Security/preview risk: https://www.remio.ai/post/deepseek-harness-tested-its-plugin-bet-comes-with-preview-risks · https://contextosai.com/blog/deepseek-harness-architecture-security-review · https://www.datacamp.com/blog/what-is-deepseek-harness
- Official repo (install only from here): https://github.com/deepseek-ai/deepseek-harness

---
_Status: exploring/watch. Eugene recommends a local-only isolated spike at most, Open WebUI as the default,
and a re-check once dsh leaves preview + is audited. Guide-only; nothing installed; no secret held._
