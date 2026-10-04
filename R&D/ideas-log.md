# R&D ideas log — Eugene

_One row per spark. Status: **spark** → **exploring** → **prototyped** → **graduated** / **parked** /
**dropped**. Nothing is deleted — a dropped idea stays as a record (archive-never-trash). See
`README.md` for the flow._

| RND | Date | Idea | Status | Notes / where it went |
|---|---|---|---|---|
| RND-1 | 2026-10-04 | The R&D pool + "Creative mode" trigger itself | **graduated** | First thing stood up — the pool, the hook, and the graduation flow. See `graduation-register.md`. |
| RND-2 | 2026-10-04 | Run AI models on the HQ local server (private, no per-token cost, data-sovereign) | **exploring** | Minda: "not leaving my mind." Feasible today on CPU for small quantized LLMs (Ollama/llama.cpp), local RAG/embeddings, Whisper, batch OCR/vision — in a resource-capped LXC so the production PBX is never starved. GPU (Tesla P40 24GB / RTX A4000 into the DL380, or a dedicated mini-box/Mac mini) unlocks real-time + heavier vision. Phased pilot: headroom check → capped Ollama 8B benchmark → RAG over the KBs → GPU decision. Guide-only (Minda at the Proxmox shell). Working notes: `R&D/local-models/notes.md`. |

<!-- Add new rows at the bottom, next free RND number. Keep it one line each; detail goes in R&D/<slug>/. -->
