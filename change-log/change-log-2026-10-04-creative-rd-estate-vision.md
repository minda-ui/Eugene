# Change log — 2026-10-04 (evening) — Creative mode: the private two-site estate vision (R&D, parked)

_First real use of **Creative mode** (built earlier today). Research/ideation only — all content kept in
`R&D/` out of the control files, per the mode's rules. **Nothing graduated; no live change.** Guide-only
throughout; no secret held. Logged here for the end-of-day record; detail lives in `R&D/`._

## Headline
Minda entered **Creative mode** and we dreamed up a coherent **private, self-hosted, two-site AI +
storage estate** on kit Fishbone already owns. Captured as `RND-2/3/4` + a capstone vision, with
pictures, all in `R&D/` and mirrored to Drive.

## What was dreamed (all in R&D/)
- **RND-2 — local AI on the HQ server.** Specs confirmed from POST: DL380 Gen9, 2× E5-2695 v4 (36c/72t),
  **128 GB RAM**. CPU inference today (RAG, 8–70B batch); GPU unlock via **2× Tesla P40 (48 GB) = 70B
  brain** (DL380 maxes at 2 double-wide). Multi-site: **pool within a box, route across sites** (LiteLLM
  gateway, HQ brain + Beverley failover). The **markdown KB is the RAG fuel**; **Composio gives the
  local model hands** (private brain, managed hands).
- **RND-3 — storage + backup foundation.** One **ZFS pool** (TrueNAS VM) → **SMB/NFS + Nextcloud**;
  backup **3-2-1** (snapshots → Proxmox Backup Server [fixes OI-7] → ZFS replica at Beverley over the
  VPN → encrypted disaster copy). **Disk capacity solved** by a spare **NetApp DS2246** (24× 2.5" SAS
  JBOD) → the pool, via an external SAS HBA.
- **RND-4 — retake Beverley Place (castle #2).** Same kit as HQ but **single ASA + single 3850** (the two
  hardest HQ parts gone) + a **small Proxmox PC (no iLO)**. Foothold = the UniFi controller. HQ recovery
  playbook applies; **target: next weekend.**
- **Capstone:** `R&D/estate-vision.md` + rendered PNGs (estate + storage), on Drive.

## Pictures delivered (rendered via mermaid-cli → PNG, Android-friendly, in Drive R&D/)
`estate-vision.png`, `estate-storage/storage-architecture.png`.

## State left
Creative mode **still ON**. Everything saved in git (`minda-ui/Eugene`, branch
`claude/lucid-mayer-nsoili`) and Drive `R&D/` (incl. subfolders). Research only — nothing graduated,
no live change. **Next week (Minda on night shifts):** pre-stage `Runbook-Beverley-Place-Recovery.md`;
start Beverley recon from the UniFi controller; the dream is ready to polish and, piece by piece,
graduate. Earlier today (same date): OI-16 Rachel Dext guard (resolved, PR #4 merged), messaging-channel
research (parked), the R&D pool + Creative-mode build itself. Still open: OI-8 audio (RTP) + ASA
`write memory`; `main` consolidation.
