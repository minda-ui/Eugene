# RND-35 — DeepSeek Harness: desk research (Stage 1)

**LAB item — not evidence, not a Hub result. Advice only, not to be built to.**
Eugene, 2026-11-12, Lab mode (released by Minda). Source read: the public code itself,
`github.com/deepseek-ai/deepseek-harness` at commit `e8f7b93a3` (11 Nov 2026), cloned read-only into a
scratch folder. Nothing installed or run. No estate data used.

## Verdict
**Worth a Stage 2 trial, with three settings fixed before first start.** It can drive our own gpt-oss on
pve-ai, it has a real read-only sandbox mode, and it denies tool calls nobody approves. But by default it
can send session content to DeepSeek, so the trial container must have telemetry off **and** no internet.

## What it is
- Open-source agent harness ("dsh") from DeepSeek, **MIT licence**, "developer preview — there will be
  compatibility-breaking changes". Very active (updated 11 Nov).
- Everything is a plugin (Cordis framework): model adapter, tools, sandbox, session store, agent loop.
- Runs as a web UI on `127.0.0.1:3080` (also CLI, desktop app). Needs **Node.js 24.9+** and pnpm 11.
- Its own SAFETY.md: **no security audit, not production-ready**; can run model-generated commands,
  load third-party plugins, reach the network and any files/credentials it is given. Advises a
  disposable VM/container, least privilege, backups.

## Can it use our model? — Yes
The `llm-pi-ai` adapter serves **"hand-declared gateways"**: a custom route with a `baseURL` for any
OpenAI-compatible endpoint. Our llama-swap on pve-ai is one, so gpt-oss-120b/20b can be the model with no
DeepSeek account and no API key. (DeepSeek's own API is just the default route.)

## What it sends out (all found in code) — the important part
| What | Default | When it sends | Our setting |
|---|---|---|---|
| **Session telemetry** (`session-telemetry-otel`, in the base bundle = web + CLI) | **ON, mode FEEDBACK_ONLY**, to `dsh-otel-collector.deepseeksvc.com` | When a user clicks a rating or sends feedback: uploads that session **including its context** | `DSH_TELEMETRY_MODE=DISABLED` |
| **Product analytics** | ON in the **Desktop** app, no user control | UI events + machine details | Don't use Desktop; web UI does not load it |
| **Reasoning translation** (experimental plugin) | Provider **Bing** (or Google/DeepSeek) | When the thought panel is opened with translation on | Leave it unloaded / off |
| **Web search** | DeepSeek API | When the agent searches | Not configured (no key) + no internet |
| Plugin inventory to DeepSeek | Only on DeepSeek's own model route | Each request to api.deepseek.com | Not used (we route to gpt-oss) |

Belt and braces: even with all of the above off, the container gets **no internet** (firewall: only
pve-ai's model port), so a missed setting cannot leak anything.

## Safety controls it does have
- **Sandbox modes:** `read-only`, `workspace-write`, `danger-full-access`. Linux backend confines
  subprocesses. It shares the host kernel — "same-world only" — so the container is still the real wall.
- **Approval prompts:** a tool call set to "ask" needs a one-time yes; **no answer = denied**.
- Guards against stuck loops and hung tools (on by default).

## Supply-chain notes
- Installing with `npx @deepseek-ai/dsh` pulls the latest npm build — **don't**. Install from the git
  checkout **pinned to a reviewed commit**, `pnpm install --frozen-lockfile`, then build.
- 287 lines of third-party notices: large dependency tree. Install needs internet once (npm); cut the
  internet **before** first start.

## Stage 2 plan (Minda executes, ~30-45 min; needs her go)
1. New LXC on pve-ai (Debian 13 amd64, 4 cores, 8 GB, 20 GB, VLAN 10), no secrets in it.
2. Node 24 + pnpm; clone pinned commit; `pnpm install --frozen-lockfile && pnpm run build`.
3. Firewall: container may reach **only** the llama-swap port on pve-ai; then `pnpm dsh web --no-open`
   with `DSH_TELEMETRY_MODE=DISABLED`, `DSH_TELEMETRY_OTLP_URL` pointed at nothing reachable.
4. Custom route → gpt-oss-120b. Sandbox `read-only`. Workspace = a cleaned copy of estate facts
   (charters, registers, inventory; no personal or financial data) prepared by Eugene from git.
5. Test: same task as 12 Nov — review AI Workforce Plan v5.1 + framework v0.5. Score vs the plain
   Fishbone AI answer: invented facts (count), real gaps found (count), time.
6. Check the container's firewall log: zero outbound attempts outside the model port = pass.

## Not checked
Live behaviour (nothing was run); DeepSeek's website text (the code was read instead); whether
llama-swap's streaming format needs a tweak in the custom route; Node 24 availability on Debian 13.
