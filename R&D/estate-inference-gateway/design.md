# RND-14 — The Estate Inference Gateway (design sketch v1)

_R&D design (git-primary; creative mode, 2026-10-25). Status: **spark → exploring**. The piece that's
needed **first** — it turns "a local model" into "the estate's AI utility" and is where the sovereign /
failover promises (RND-18) are actually enforced. Guide-only (§3): keys are Minda's, never held; config
references secrets by env, never raw values in git; tailnet-only, nothing public._

## The one-sentence idea
**One private endpoint** on the tailnet that every client asks by **role name** (`estate-brain`,
`estate-vision`, `estate-coder`…), while the gateway quietly decides **which model on which node** serves
it — so models can be added, swapped, load-balanced, failed-over, and policed **without any client ever
changing.**

## Why it's the keystone
Today a client must know "Ollama at 10.224.10.30:11434, model llama3.1:8b". That's brittle — every
client hard-wired to a model and a box. The gateway inverts it:
- **Clients ask for a capability, not a model.** The phone UI, the whole AI workforce (via Composio's
  custom-provider), the vision sentinel (RND-16), the voice front-end (RND-17) and the foundry (RND-19)
  all point at **one URL** and ask for `estate-brain` / `estate-vision` / `estate-coder`.
- **The estate decides behind the curtain** — which node, which model, what to do if it's busy or down,
  whether a request is even allowed to touch the cloud. Swap Qwen3.6 for whatever's best next quarter and
  **not one client changes.**

## The engine
**LiteLLM Proxy** (open-source, OpenAI-compatible) in a small capped LXC on HQ, bound to the tailnet.
It already does everything we need: fronts **Ollama + cloud providers** behind one OpenAI API, **model
aliases**, **load-balancing + fallback chains**, **virtual keys with budgets/rate-limits/allow-lists**,
and **per-call logging**. Config is a single YAML (in git — references secrets by env, holds no raw keys).

## The clean abstraction — role aliases
Define friendly names that map to real backends + fallback order:

| Alias | Primary | Fallback | Cloud fallback? |
|---|---|---|---|
| `estate-brain` | Qwen3.6 27B / 70B on **HQ P40s** | Beverley P40 (smaller) | optional, policy-gated |
| `estate-vision` | Qwen3-VL on **HQ P40s** | Beverley P40 | **no** (images stay in-building) |
| `estate-coder` | Qwen3-Coder-30B on P40s; 480B on the RAM box (batch) | — | **no** (code + KB stay private) |
| `estate-fast` | 8–14B on CPU / Beverley | HQ | optional |
| `estate-sovereign` | local only, pinned | local only | **never** — the private lane (RND-18) |

## Topology (route the work, not the model)
```
  Phone UI ─┐
  Workforce ├─(Composio custom provider)─┐
  Sentinel ─┤                            ▼
  Voice ────┤                 ┌───────────────────────┐        ┌─ HQ node: 2× P40  (brain, vision, coder)
  Foundry ──┘                 │  LiteLLM GATEWAY (HQ)  │───────▶├─ Beverley node: 1× P40 (failover / fast)
                              │  tailnet-only, 1 URL   │        ├─ HQ CPU / RAM box (batch, 480B)
   one endpoint, one key each │  aliases · keys · logs │        └─ CLOUD (only if a key's policy allows)
                              └───────────┬───────────┘
                                          ▼  per-call log → observability (RND-6) + cost view
```
**Across sites it routes the request, never splits a model** (per the local-models notes): HQ is primary;
Beverley takes independent requests as overflow/failover. Only prompt+answer cross the airFiber link — so
the slow hop doesn't matter (same reason the phone works from 4G).

## The three jobs the gateway does for us
1. **Decouple + swap.** Models change monthly (RND-2 shortlist will be stale by P40-fit time); clients
   never notice. One place to upgrade.
2. **Resilience (RND-18 failover).** If the HQ node is busy/down, `estate-brain` falls to Beverley, then —
   only if that key's policy permits — to cloud. The estate keeps thinking.
3. **The egress wall (RND-18 sovereign lane).** This is the lovely bit: the gateway is **where "restricted
   data → local only, never cloud" is actually enforced.** A client using the `estate-sovereign` key (or
   `estate-vision`) *cannot* have its data fall out to a cloud provider, because the gateway has no cloud
   backend on that alias. The privacy promise stops being a policy on paper and becomes a **config that
   physically can't do otherwise.**

## Governance (virtual keys = the control panel)
One virtual key per client — phone, each AI employee, sentinel, foundry — each with:
- **model allow-list** (the sentinel only gets `estate-vision`; a finance task only gets `estate-sovereign`),
- **budget + rate-limit** (caps any cloud-fallback spend; stops a runaway loop),
- **cloud policy** (on/off per key — the sovereign lane is just "cloud: off"),
- **logging** — who called what, how many tokens, which backend served it → feeds RND-6 and gives a cost
  view even though local inference is free (the point is to watch the *cloud* spend and spot anomalies).
Keys are secrets → **Minda holds them**; the YAML references them by env var; **Eugene never holds a
value** (§3). Review the key table like a firewall ruleset — it *is* one, for data.

## Honest edges
- **The gateway is itself a single point of failure.** Mitigate: it's **stateless and disposable** (config
  in git, rebuild in minutes), can run a **second instance** (HQ + Beverley) behind the same tailnet name,
  and clients can be given a **direct-to-Ollama fallback** if the gateway is down. Design it to fail open
  to "still works, just no fancy routing."
- **It concentrates trust** — one box that sees every prompt and holds the cloud keys. So: tailnet-only,
  no public port, keys in env not git, logs access-controlled, and treat its config changes as
  security-reviewable (an Approvals-Desk action type, RND-9).
- **Local-first, always.** Cloud is opt-in per key and off by default; the default estate is fully private
  and only reaches out when a key explicitly says it may.

## Phasing
- **P0:** gateway LXC fronting the **single HQ Ollama**, one alias `estate-brain`, one key for the phone
  UI. Proves the indirection with zero new hardware (works on the CPU model today).
- **P1:** add aliases (`vision`, `coder`, `fast`, `sovereign`) + per-client virtual keys + logging.
- **P2:** add the **Beverley node** → load-balance + failover for `estate-brain`/`estate-fast`.
- **P3:** add **cloud fallback** with per-key policy → the sovereign lane becomes real (some keys can reach
  cloud, `sovereign`/`vision` never can).
- **P4:** point the **AI workforce** at it (Composio custom OpenAI-compatible provider) → the whole estate
  shares one private, policy-controlled inference layer.

## Graduation
First real step pairs with the P40 build: stand up P0 (gateway → the existing Ollama) alongside the
phone-server runbook, so from day one clients talk to the gateway, not a raw model — then the stable,
nodes and policies grow behind it without ever breaking a client. Cross-KB (pointing each employee at it)
goes through their Raw/ + Minda's approval. Keys always Minda's.

---
_Guide-only; the gateway is the estate's inference utility AND its data-egress wall. Keys are Minda's,
referenced by env, never in git. Pairs with RND-2 (models), RND-18 (sovereign/failover), RND-16/17/19
(clients), RND-6 (logs), RND-9 (config changes as reviewed actions)._
