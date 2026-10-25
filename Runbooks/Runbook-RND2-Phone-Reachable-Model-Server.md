# Runbook — RND-2: phone-reachable private AI model server (HQ)

> **Eugene, 2026-10-25 (guide-only, §3).** Stand up a private LLM on the HQ DL380 Gen9 that Minda can use
> from her phone anywhere, over the existing Tailscale, with **no public exposure** and **no risk to the
> production PBX**. **CPU-only to start** — works today, no waiting on the 2× P40 fit (GPU upgrade path is
> Phase 7). Minda runs every shell step at the Proxmox host; Eugene wrote and verifies. No secret held.
>
> **Hard rule (from `R&D/local-models/notes.md`): the model lives in a resource-capped container; the PBX
> (VM 105) keeps priority and is never starved.**

## What you'll have at the end
A private chat page (Open WebUI) that looks like ChatGPT but runs your own model on the HQ box, reachable
from your phone's browser over Tailscale from anywhere — fully private for asking/reading; "managed hands"
only if you later wire Composio tools (Phase 8).

## Design decisions (why it's built this way)
- **Container, not the host:** a capped **unprivileged LXC** on HQ Proxmox (`10.224.10.10`). Caps stop it
  ever starving the PBX.
- **No Docker:** we hit *Docker-in-LXC-on-ZFS* failing four ways on the DocuSeal build (that's why DocuSeal
  went in a VM). So here: **Ollama native install + Open WebUI via pip** — no Docker, no overlay2-on-ZFS
  trap. (If you'd rather, the VM alternative is in the Appendix.)
- **Reachable over Tailscale by reusing the existing subnet router:** `hq-subnet-router` already advertises
  `10.224.10.0/24` on the tailnet (RND-5, live). The LXC just gets a normal `10.224.10.x` LAN IP, so your
  phone reaches it at that IP once the phone **accepts routes** — no second Tailscale node to install, no
  ASA/firewall change, nothing public.
- **Auth + private bind:** Open WebUI has its own login (first account = admin); we bind it to the LXC's
  LAN IP only. The box has no public inbound NAT, so it's LAN/tailnet-only by construction.

---

## Phase 0 — Pre-checks (5 min, no change made)
At the Proxmox host shell (`ssh root@10.224.10.10`, or over Tailscale):
```bash
free -h                 # RAM: confirm ≥ ~20 GB free after the VMs (128 GB box; 8B needs ~6, Mixtral ~26)
df -h /                 # disk: need ~15–20 GB free for models
pct list ; qm list      # see the PBX (VM 105) and others running — we won't touch them
nproc                   # 72 threads; we'll cap the LXC well below that
tailscale status | head # confirm hq-subnet-router is up and advertising 10.224.10.0/24
```
Stop if free RAM after VMs is under ~16 GB — tell Eugene the numbers and we'll size down.

## Phase 1 — Create the capped LXC (Minda)
From the Proxmox host. Pick a free CTID (example **130**) and a free LAN IP (example **`10.224.10.30`** —
confirm it's unused first with `ping -c1 10.224.10.30` → should get no reply).
```bash
# Debian 12 template (download once if not present)
pveam update && pveam available | grep debian-12
pveam download local debian-12-standard_12.7-1_amd64.tar.zst   # name may differ; use what 'available' lists

# Create an UNPRIVILEGED container, capped so the PBX is never starved
pct create 130 local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname ai-hq \
  --cores 8 --memory 16384 --swap 4096 \
  --rootfs local-zfs:40 \
  --net0 name=eth0,bridge=vmbr0,tag=10,ip=10.224.10.30/24,gw=10.224.10.1 \
  --unprivileged 1 --features nesting=1 --onboot 1 --cpuunits 50
pct start 130
pct exec 130 -- bash -c 'apt update && apt -y upgrade && apt -y install curl python3 python3-pip python3-venv'
```
Notes:
- **`--cpuunits 50`** gives the PBX (default 1024/100) far higher CPU priority under contention — the model
  yields to the phones. **`--cores 8`** caps it to 8 of 72 threads; **16 GB** RAM suits an 8B/14B. For
  Mixtral 8×7B later, raise to `--memory 32768` (`pct set 130 --memory 32768`).
- **net0 `tag=10`** puts it on the server VLAN (`10.224.10.0/24`) behind the subnet router, gw `.1` (the
  ASA — the HQ per-VLAN gateway is `.1`, not the 3850 SVI; lesson from the RND-3 build).

## Phase 2 — Ollama + a first model (CPU, Minda)
```bash
pct exec 130 -- bash
# inside the container:
curl -fsSL https://ollama.com/install.sh | sh
systemctl enable --now ollama
ollama pull llama3.1:8b        # ~5 GB; the daily driver. (Also good: qwen2.5:7b, qwen2.5:14b)
ollama run llama3.1:8b "Say hello in one line."   # smoke test; a few tok/s on CPU is expected
exit
```
Ollama listens on `127.0.0.1:11434` by default — leave it local; only Open WebUI (same container) talks to
it. Don't expose Ollama itself.

## Phase 3 — Open WebUI via pip (no Docker, Minda)
Inside the container (`pct exec 130 -- bash`):
```bash
python3 -m venv /opt/openwebui && source /opt/openwebui/bin/activate
pip install --upgrade pip
pip install open-webui
# run it bound to the LAN/tailnet IP, talking to local Ollama:
OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  open-webui serve --host 10.224.10.30 --port 3000
```
Confirm it starts and prints a listening line. Then **Ctrl-C** and make it a service so it survives reboot:
```bash
cat >/etc/systemd/system/openwebui.service <<'EOF'
[Unit]
Description=Open WebUI
After=network-online.target ollama.service
Wants=network-online.target
[Service]
Environment=OLLAMA_BASE_URL=http://127.0.0.1:11434
ExecStart=/opt/openwebui/bin/open-webui serve --host 10.224.10.30 --port 3000
Restart=on-failure
User=root
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload && systemctl enable --now openwebui
systemctl status openwebui --no-pager | head
exit
```
From the Proxmox host, confirm it answers on the LAN IP only:
```bash
curl -sS -o /dev/null -w '%{http_code}\n' http://10.224.10.30:3000   # expect 200
```

## Phase 4 — First login + lock it down (Minda, from a LAN browser or over Tailscale)
1. Open `http://10.224.10.30:3000`. **The very first account you create becomes admin** — create it now
   (strong password, in 1Password) so nobody else can grab admin later.
2. Admin → Settings: **turn OFF open sign-up** ("Enable New Sign Ups" off) so it's invite-only.
3. Leave the model as `llama3.1:8b`; you can pull more from the UI later.

## Phase 5 — Phone setup (Minda, one-time)
1. On the phone's **Tailscale app → turn ON "Use subnet routes" / "Accept routes"** (this is the one
   outstanding item from the Tailscale rollout — without it the phone can't reach `10.224.10.x`).
2. In the phone browser go to **`http://10.224.10.30:3000`**, log in with the account from Phase 4.
3. Browser menu → **"Add to Home screen"** → it installs like an app (full-screen, its own icon).

## Phase 6 — Verify from away (Minda)
- On **4G with WiFi off** (and Tailscale on), open the home-screen icon → log in → ask it something.
- You should get an answer in a few seconds of thinking + a slow-ish stream (CPU speed). That proves the
  private, from-anywhere path end to end. Tell Eugene it worked (or the error) and we log it.

## Security recap (all satisfied by the above)
- **No public exposure:** no ASA inbound NAT to this box; reachable only on the LAN and the tailnet. Never
  add a public port-forward for it.
- **Auth:** Open WebUI login; sign-ups off; admin account in 1Password.
- **Tailnet gate:** only your Tailscale devices can even reach `10.224.10.30`; keep **MFA on the Tailscale
  account** and key-expiry disabled (already done, RND-5).
- **PBX safety:** the LXC is CPU-deprioritised (`cpuunits 50`), core- and RAM-capped; the phones always win.

## Rollback (zero risk to the PBX)
If anything misbehaves, the whole thing is disposable:
```bash
pct stop 130 && pct destroy 130
```
Nothing else is touched — no host packages, no PBX, no network config.

---

## Phase 7 — later: the 2× P40 GPU upgrade (makes it fast + real-time)
Once the P40s are fitted (baffle + "Above 4G Decoding" BIOS toggle — see `R&D/local-models/parts-list.md`):
GPU into an LXC needs the NVIDIA driver on the **host** + the container's cgroup device passthrough
(`lxc.cgroup2.devices.allow` for the nvidia devices + `lxc.mount.entry` binds), then the CUDA build of
Ollama uses the cards automatically. 48 GB VRAM then runs **Llama 3.3 70B / Qwen2.5 72B** at ~10–20 tok/s,
and unlocks **live site-photo vision**. Eugene will write the GPU-passthrough steps when the cards are live.
(GPU passthrough is cleaner to a **VM** than an unprivileged LXC — if we go GPU, consider the VM variant.)

## Phase 8 — later: RAG over the KB, and Composio tools
- **RAG ("ask the estate"):** Open WebUI has built-in document RAG — point it at the markdown KB
  (`Raw/Wiki/Outputs`) so answers cite the real files. Embedding model pulled via Ollama (`nomic-embed-text`).
- **Composio tools (acting):** point the model at the Composio MCP server (the same `ck_` key the estate
  uses) so it can email/Drive/Smartsheet. Reminder: **thinking/reading = fully private; acting via Composio
  routes through Composio's cloud** ("private brain, managed hands").

## Appendix — VM alternative (if you prefer, or when going GPU)
Instead of the LXC: a small Debian **VM** on HQ Proxmox (2–8 vCPU, 16–32 GB, 40 GB disk, net0 VLAN 10,
static `10.224.10.30`), then the same Ollama + Open WebUI-via-pip steps. Heavier than the LXC but the
cleaner home for GPU passthrough later, and it matches the DocuSeal pattern (VM over LXC-on-ZFS for
container runtimes). Same caps logic applies (give the PBX priority; don't over-allocate RAM).

---
_Guide-only (§3): Minda runs the shell steps; Eugene verifies. CPU-only start = no spend, no wait, no PBX
risk; GPU + RAG + tools are later phases. Private by construction (tailnet-only, no public port). RND-2
(exploring)._
