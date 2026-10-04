# Estate vision — one picture (RND-2 + RND-3 + RND-4)

_R&D synthesis, 2026-10-04 (Creative mode). The private, two-site, self-hosted estate: storage +
backup + AI, all on kit Fishbone owns. Diagram: `estate-vision.mmd` (rendered to Minda). Still
research — each layer graduates to a real runbook + OI on Minda's go. Guide-only throughout; no secret
held; production PBX never at risk._

## How to read it
- **Inputs (left):** office PCs on a mapped drive; **site phones auto-uploading photos**; clients via
  share links; the **Telegram site-evidence mirror** — all land in one store.
- **HQ (the keep):** one **ZFS pool** with two faces — **SMB/NFS** (NAS) + **Nextcloud** (Drive/
  OneDrive-like). **Backup chain:** ZFS snapshots (instant undo) + **Proxmox Backup Server** for the VMs
  (**fixes OI-7**). **AI:** **2× Tesla P40 = 48 GB** running a **70B estate brain + live vision**, fed by
  the store via **RAG + photo tagging**, fronted by a **LiteLLM gateway**.
- **Beverley Place (the second castle, RND-4):** **replica NAS** (ZFS receive) + **1× P40** as the
  **AI failover / local vision** node.
- **Between sites:** the existing **airFiber bridge + IPsec VPN** carries **ZFS replication** (off-site
  backup) and **AI request routing/failover** — pooled *within* a box, routed *across* sites.
- **Disaster copy:** encrypted cloud (Backblaze B2) or off-site USB.

## The shape of it
- **Data: 3-2-1** — pool → off-site replica → encrypted disaster copy (+ snapshots + PBS).
- **AI: 2-site redundancy** — HQ 70B brain; Beverley failover; if one castle falls, the other keeps
  thinking and the data's already there.
- **All private** — estate data never leaves the buildings; no per-token bills; nobody can switch it off.

## The build order (when it graduates)
1. **RND-4** — recover Beverley Place (start: UniFi-controller recon).
2. **RND-3** — storage + backup foundation, both sites (the first real brick).
3. **RND-2** — local AI: CPU first, then 2× P40 at HQ + 1 at Beverley, routed via the gateway.

```mermaid
flowchart TB
  subgraph PEOPLE["People & inputs"]
    direction LR
    WIN["Office PCs<br/>mapped Z: drive"]
    MOB["Site phones<br/>photo upload"]
    CLIENT["Clients<br/>share links"]
    TG["Telegram<br/>site-evidence mirror"]
  end
  subgraph HQ["HQ - Unit 30/31  ·  DL380 Gen9 · Proxmox · 128GB"]
    direction TB
    POOL[("ZFS pool<br/>TrueNAS VM")]
    SNAP["ZFS snapshots<br/>instant undo"]
    SMB["SMB / NFS<br/>NAS drive"]
    NC["Nextcloud<br/>Drive / OneDrive-like"]
    PBS["Proxmox Backup Server<br/>VMs - fixes OI-7"]
    PBX["FusionPBX phones<br/>+ other VMs"]
    GPUHQ["2x Tesla P40 · 48GB<br/>70B estate brain + vision"]
    GW["LiteLLM gateway<br/>routes + failover"]
    POOL --> SMB
    POOL --> NC
    POOL --> PBS
    POOL -.-> SNAP
    PBX --> PBS
    NC -->|"RAG + photo vision"| GPUHQ
    GPUHQ --> GW
  end
  subgraph BP["Beverley Place · 2nd site  (recover first - RND-4)"]
    direction TB
    REPLICA[("Replica NAS<br/>ZFS receive")]
    GPUBP["1x Tesla P40 · 24GB<br/>failover + local vision / 8-14B"]
  end
  subgraph DR["Disaster copy"]
    CLOUD["Encrypted cloud (Backblaze B2)<br/>or off-site USB"]
  end
  WIN --- SMB
  MOB --> NC
  CLIENT --- NC
  TG --> NC
  POOL ==>|"ZFS send/recv · airFiber + VPN · OFF-SITE"| REPLICA
  GW <==>|"AI requests · airFiber + VPN · failover"| GPUBP
  REPLICA -.->|encrypted| CLOUD
```
