# R&D ideas log — Eugene

_One row per spark. Status: **spark** → **exploring** → **prototyped** → **graduated** / **parked** /
**dropped**. Nothing is deleted — a dropped idea stays as a record (archive-never-trash). See
`README.md` for the flow._

| RND | Date | Idea | Status | Notes / where it went |
|---|---|---|---|---|
| RND-1 | 2026-10-04 | The R&D pool + "Creative mode" trigger itself | **graduated** | First thing stood up — the pool, the hook, and the graduation flow. See `graduation-register.md`. |
| RND-2 | 2026-10-04 | Run AI models on the HQ local server (private, no per-token cost, data-sovereign) | **exploring** | Minda: "not leaving my mind." Feasible today on CPU for small quantized LLMs (Ollama/llama.cpp), local RAG/embeddings, Whisper, batch OCR/vision — in a resource-capped LXC so the production PBX is never starved. GPU (Tesla P40 24GB / RTX A4000 into the DL380, or a dedicated mini-box/Mac mini) unlocks real-time + heavier vision. **Specs confirmed from POST:** DL380 Gen9, 2× E5-2695 v4 (36c/72t, AVX2), **128 GB RAM**. Phased pilot: headroom check → capped Ollama 8B benchmark → RAG over the KBs → GPU decision. Guide-only. Working notes: `R&D/local-models/notes.md`. |
| RND-3 | 2026-10-04 | Estate self-hosted storage + backup foundation (NAS + Drive/OneDrive-like) | **exploring** | Minda: "main foundation — data storage, then backup." Design: one **ZFS pool** (TrueNAS SCALE VM, HBA passthrough) with two faces — **SMB/NFS** (mapped NAS drive) + **Nextcloud** (Drive/OneDrive: web, desktop sync, mobile photo auto-upload, share links). Backup **3-2-1**: ZFS snapshots → **Proxmox Backup Server** for the VMs (**fixes OI-7**) → off-site `zfs send/recv` **replica at Beverley Place** over the IPsec VPN → encrypted cloud/USB disaster copy. Foundation for RND-2 + the Telegram evidence mirror. Hardware checkpoints: DL380 disks/bays, **P440ar → HBA mode** (ZFS wants raw disks), Beverley Place replica box. Diagram `R&D/estate-storage/architecture.mmd`; notes `design.md`. Guide-only. |

<!-- Add new rows at the bottom, next free RND number. Keep it one line each; detail goes in R&D/<slug>/. -->
