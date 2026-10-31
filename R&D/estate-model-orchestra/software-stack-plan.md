# RND-30 — Software stack for the local AI (P40 + V100)

_R&D plan (creative mode, 2026-10-31). Guide-only (§3): Minda runs installs on the hosts; Eugene writes the
runbooks, version register and checks. Facts below from web sources 2026-10-31 (see Sources)._

## The two facts that shape everything
1. **Drivers:** NVIDIA's **R580 branch is the last** to support Pascal (P40) and Volta (V100); from R590 they
   move to legacy. **CUDA 12.x is the last toolkit** that builds for them (CUDA 13 removed offline compilation for
   them). → our GPUs live on a **frozen stack: R580 driver + CUDA 12.x**, for both card types.
   ⚠️ **Correction:** the 2026-10-30 note said "580 drops Pascal, so 535". Wrong — **580 still supports Pascal**; it's
   the *last* branch that does. 535 works today; **580 is the better long-term pick** (newer, covers P40 + V100).
2. **Engines:** **vLLM doesn't support Pascal**, and V100 support is unreliable → **not for us**. **Ollama** is drifting
   away from old cards (reports of Volta dropped in newer versions) → only **pinned** to a known-good version.
   **llama.cpp built from source** (CUDA 12.x, architectures `61;70`) supports both — **our main engine**.

## The stack
| Layer | Choice | Notes |
|---|---|---|
| Host OS | **Proxmox VE** (as across the estate) | GPU host |
| Kernel | **pinned** (`proxmox-boot-tool kernel pin`) | a kernel update can break the NVIDIA module — update deliberately, not automatically |
| Driver | **NVIDIA R580** on the host (DKMS) | same on HQ (V100) and Beverley (P40) |
| CUDA | **12.x** (pinned) | last toolkit for both cards |
| Model engine | **llama.cpp `llama-server`**, built from source for `61;70`, one instance per role (OpenAI-compatible) | GGUF models; mixed sizes; RAM+GPU offload for the 480B; RPC not used (we route, not split) |
| Pilot shortcut | **Ollama, pinned** to a version known to work on P40/V100 | only for the staff-questions pilot on the Gen9; replaced by llama.cpp at the AI-server stage |
| Gateway | **LiteLLM** | role names, privacy lanes, keys, budgets, logs (RND-14) |
| Chat page | **Open WebUI** (pip install, no Docker) | logins, groups, document collections (RND-24/29) |
| Document search | Open WebUI built-in for the pilot → dedicated vector store later if needed | embeddings model on CPU |
| Night jobs | small scheduler (cron/systemd timers) + heartbeats to the watchtower | RND-15 + RND-6 |
| Containers | **unprivileged LXCs**, GPU shared from the host; **no Docker-in-LXC on ZFS** (known trap) — a VM for any Docker-only app | one LXC per job: models · gateway · chat · batch |

## Container layout (AI server)
| LXC | Runs | GPU | Network |
|---|---|---|---|
| `ai-models` | llama.cpp servers (generalist, coder, eyes, receptionist) | all V100s | private only |
| `ai-gateway` | LiteLLM | — | private; reachable by chat + AI employees |
| `ai-chat` | Open WebUI | — | Tailscale-only (RND-29) |
| `ai-batch` | night scheduler, 480B runs | shared | private |
| models storage | read-only share from the Gen9 over the private 10G triangle + local SSD cache | — | triangle |

## Keeping it working (the update routine)
- **Version register** (one table in git): component · version · why pinned · date checked. Nothing upgrades silently.
- **Monthly window:** Open WebUI, LiteLLM, llama.cpp rebuild, OS security patches. Backup first (PBS snapshot).
- **Beverley = staging:** try updates on the Beverley node first; HQ a week later if healthy.
- **Driver/kernel:** only with a reason (security fix in R580, or a needed feature); always on Beverley first; roll-back = previous pinned kernel.
- **Config as files in git** (no secrets); secrets in the server's secret store (RND-29).
- **Models:** official publishers only, checksums in the register (RND-29).

## Life-span
The R580 branch keeps these cards usable for years, but they're frozen: no new driver features, CUDA 12 only.
That's fine because the AI server is **isolated** (no internet, RND-29) and **monitored** (RND-6). Plan a
**hardware review around 2028**: newer GPUs (Ampere or later) when budget and need justify it — the stack above
carries over unchanged except the driver line.

## Decisions for Minda
1. Move the Gen9 from driver 535 to **580** at the next maintenance window? (Not urgent: the P40s are unpowered until the cables are sorted.)
2. Pilot on **pinned Ollama** (quick) and switch to llama.cpp at the AI-server stage — OK?
3. **Beverley as the staging site** for updates — OK?

## Sources
- Phoronix: NVIDIA confirms 580 Linux driver is the last for Maxwell/Pascal/Volta
- Tom's Hardware / Overclock3D: R580 last branch for Maxwell, Pascal, Volta; CUDA 12.x last
- localaimaster.com "Pascal GPUs after CUDA 13"; computingforgeeks "best used datacenter GPU for local AI";
  runaihome FlashAttention on Pascal/Volta — engine support (blog sources; check official Ollama/vLLM docs before relying)
