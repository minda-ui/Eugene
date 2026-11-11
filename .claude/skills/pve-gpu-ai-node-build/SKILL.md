---
name: pve-gpu-ai-node-build
description: Build (or rebuild, or extend) a Proxmox GPU AI node end to end — hardware/BIOS checks, Proxmox install, NVIDIA R580 driver on kernel 7.x, a GPU LXC with CUDA 12.9 and llama.cpp for Pascal (sm_61), llama-swap plus Open WebUI (login-only, date-aware prompts), auto-start and nightly PBS backup, then benchmarks. Use whenever Minda says "build the AI server", "install NVIDIA drivers on Proxmox", "set up llama.cpp / Open WebUI", "add a GPU / P40", "the Beverley AI node", "rebuild ai-lab", or a GPU container won't start after a backup or reboot. Guide-only (charter §3): Eugene writes the commands and reads the output; Minda runs every command on the live host and holds every password (1Password, hidden entry only). Built 2026-11-11 from the pve-ai (HQ Gen10) build on 9 Nov.
---

> **Verify before relying on (not in the 9 Nov notes verbatim):** the exact `blacklist-gpu.conf` lines, the `nvidia-devices.service` unit text, `pct set -devN` passthrough syntax, the `cuda-toolkit-12-9` package name and the `ENABLE_OLLAMA_API` / `OPENAI_API_KEY` env lines were reconstructed, not copied from the live host. Check them against pve-ai (`cat` the real files) the first time this skill is used, then update this skill.

# Proxmox GPU AI node build (pve-ai pattern)

The reference build is **`pve-ai`** (HQ DL380 Gen10 S/N 2M20130BJL, 10.224.10.30) with **2× Tesla P40**,
serving **"Fishbone AI"** from **CT 200 `ai-lab`** (10.224.10.31). Full history:
`change-log/change-log-2026-11-09-gen10-arrived-pve-ai-p40s-live.md`, `R&D/local-models/notes.md`,
`R&D/local-models/gpt-oss-test-plan.md`, inventory row in `Infra-Inventory/Fishbone-HQ-Physical-Network-Inventory.md`.
Next users of this skill: the **Beverley node** (`pve-bev`, BGN) and a **3rd P40**.

**Guide-only (§3):** Minda does every physical, BIOS and shell step; Eugene gives exact commands and
checks the output/photos. **Eugene never asks for, sees or writes a password or token** — root, iLO, PBS
and Open WebUI admin passwords are typed by Minda (hidden entry: `read -rs`, `getpass`) and live in
**1Password only**. No secret in git, the change-log or the Hub.

## 0. Before you start — decide and record
- Hostname, mgmt IP (VLAN 10), switch port, iLO IP (OOB, no gateway), which CT id/IP for the AI container.
- GPUs: how many, which slots, which **power cable part** (Gen10: 869820-001). **Meter-check the GPU
  power cable before first power-on** (HL-0110 — pve-ai's were plugged before checking).
- Add a ledger row + `Infra-Inventory/` entry as you go; serials yes, passwords never.

## 1. Hardware + BIOS (Minda, at the box; Eugene checks POST photos)
- **RAM in the white slots, one per channel** first (DL380 Gen10: 12 white = 1 DPC). A DIMM error that
  follows the *slot* across two sticks = slot/CPU fault, not the stick (BGN P2 DIMM 5 → warranty).
- **Both CPUs populated** — the GPU risers hang off **CPU2**. ⚠️ BGN (Beverley) has a CPU2 slot fault:
  confirm the riser slot works there before buying/fitting a card.
- **Above 4G Decoding / MMIO above 4 GB ON** — without it the P40's 24 GB BAR won't map.
- **PSU wattage:** P40 ≈ 250 W each, passive → 2× 1600 W for two cards (1+1 redundant); high-perf fans.
- Workload profile **General Throughput Compute**; UEFI. Set iLO static IP; iLO password → 1Password.
- Controller in pass-through (E208i-a with **no arrays** = disks go straight to the OS for ZFS).

## 2. Proxmox install
- **ZFS mirror (RAID1)** on the two boot SSDs.
- Static IP, gw `10.224.10.1`, **DNS `1.1.1.1` (+ `8.8.8.8`)** — the old ASA serves **no** DNS; first pve-ai
  install used `.1` and apt failed.
- Repos: enterprise **off**, `pve-no-subscription` **on**; `apt update && apt full-upgrade`.
- Check the clock (`date`; `chronyc sources`) — BGN came up ~45 h behind → apt "Not live until" errors.
- Target kernel **7.0.14-28-pve** (known good with 580.196.07). Pin it **after** `nvidia-smi` works (stage 3).

## 3. NVIDIA driver on the host (R580 .run — not Debian's package)
Debian's packaged driver (550) **fails on kernel 7.0**; Pascal is capped at **R580**, and has **no open
kernel module** → proprietary module via DKMS.
```bash
apt install -y pve-headers-$(uname -r) build-essential dkms pkg-config
cat > /etc/modprobe.d/blacklist-gpu.conf <<'EOF'
blacklist nouveau
options nouveau modeset=0
blacklist nova_core
EOF
update-initramfs -u -k all && reboot
# after reboot: lsmod | grep -E 'nouveau|nova' -> must be empty
sh NVIDIA-Linux-x86_64-580.196.07.run --dkms -m=kernel
nvidia-smi        # expect every P40, 23040 MiB each, no "power cables not connected"
proxmox-boot-tool kernel pin 7.0.14-28-pve && proxmox-boot-tool refresh
```
Download the .run from nvidia.com (data-centre driver) and check its checksum on the box.

### Device nodes before guests start (the `/dev/nvidia1` trap)
`/dev/nvidia*` are created on **first use**, not at boot — so an onboot GPU container can fail to start.
`/etc/systemd/system/nvidia-devices.service`:
```ini
[Unit]
Description=Create NVIDIA device nodes + persistence before guests
After=systemd-modules-load.service
Before=pve-guests.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/nvidia-smi -pm 1
ExecStart=/usr/bin/nvidia-modprobe -c=0 -c=1 -u
[Install]
WantedBy=multi-user.target
```
`systemctl daemon-reload && systemctl enable --now nvidia-devices.service` (one GPU → `-c=0` only).
This replaces any `@reboot` persistence cron. Emergency fix if a CT won't start: `nvidia-smi -L` then
`nvidia-modprobe -c=0 -c=1 -u`, then `pct start <id>`.

## 4. Model storage + GPU LXC (CT 200 `ai-lab` pattern)
- Model pool on spare disks (pve-ai: 6× 900 GB SAS as 3 mirrors, lz4, `recordsize=1M`, `atime=off`);
  dataset e.g. `models/gguf`, `chown 100000:100000` (unprivileged root).
- **Unprivileged Debian 12** CT: cores/RAM to suit (pve-ai: 32 cores, 256 GB, 64 GB rootfs on local-zfs),
  static IP, **DNS 1.1.1.1**, bind mount the dataset at `/models`.
- Pass the devices (check majors with `ls -l /dev/nvidia*`):
```bash
pct set 200 -dev0 /dev/nvidia0 -dev1 /dev/nvidia1 -dev2 /dev/nvidiactl \
            -dev3 /dev/nvidia-uvm -dev4 /dev/nvidia-uvm-tools
pct set 200 -onboot 1
```
- Inside the CT: **same driver version, userspace only**:
  `sh NVIDIA-Linux-x86_64-580.196.07.run --no-kernel-modules` → `nvidia-smi` shows the cards.

## 5. CUDA + llama.cpp (inside the CT)
- **CUDA toolkit 12.9** (NVIDIA apt repo, `cuda-toolkit-12-9`). **Not CUDA 13 — it drops sm_61 (Pascal).**
  (Host `nvidia-smi` reporting "CUDA 13.0" is just the driver ceiling — fine.)
```bash
apt install -y build-essential cmake git curl libcurl4-openssl-dev libssl-dev
git clone https://github.com/ggml-org/llama.cpp && cd llama.cpp
cmake -B build -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=61 -DLLAMA_OPENSSL=ON
cmake --build build -j --config Release
git log -1 --format=%h      # record the commit (pve-ai: a0ad695cb) in the version register
```
- `export LLAMA_CACHE=/models` so `-hf` downloads land on the pool; give them stable names via
  symlinks in `/models/live/` (e.g. `gpt-oss-120b.gguf`). Verify size + sha256 against Hugging Face.
- HF naming: `ggml-org/gpt-oss-20b-GGUF`, `ggml-org/gpt-oss-120b-GGUF`, vision =
  **`unsloth/Qwen3-VL-30B-A3B-Instruct-GGUF:Q4_K_M`** (pulls the mmproj; the ggml-org name doesn't exist → 401).
- Long downloads: run in the foreground via `pct exec`; resume a stall with `curl -C -`.
  `setsid nohup` inside `pct exec` did **not** start — avoid.

## 6. Serving: llama-swap + Open WebUI
- **llama-swap** (`/usr/local/bin`, checksum checked) → `/etc/llama-swap/config.yaml`, systemd
  `llama-swap.service`, **listen `127.0.0.1:9000` only** (never the LAN). Swaps one model at a time.
  Best 120b line on 2× P40:
  `--n-cpu-moe 12 -ts 23/13 -t 12 -c 32768 -b 2048 -ub 2048 --jinja`; 20b: `-ngl 99`.
- **Open WebUI** (pip venv `/opt/open-webui`, data `/var/lib/open-webui`, systemd `open-webui.service`,
  **port 3000**, login required). Environment:
```ini
OPENAI_API_BASE_URL=http://127.0.0.1:9000/v1
OPENAI_API_KEY=local          # placeholder, not a secret
ENABLE_OLLAMA_API=false
ENABLE_SIGNUP=false
DEFAULT_USER_ROLE=pending
ENABLE_COMMUNITY_SHARING=false
ENABLE_PERSISTENT_CONFIG=false   # env always wins over the DB
CUDA_VISIBLE_DEVICES=            # empty: UI on CPU, GPUs stay with the models
WEBUI_NAME=Fishbone AI
```
  Its `WEBUI_SECRET_KEY` is generated and kept on the server only. Minda creates the admin account
  (first sign-up) → password into 1Password → then sign-ups stay off.
- Per model (Admin → Models): friendly name (**Fishbone Generalist / Quick / Eyes**), visible to logged-in
  users, system prompt starting **`Today is {{CURRENT_WEEKDAY}}, {{CURRENT_DATE}}.`** (models get weekdays
  wrong without it) + an "say 'unclear', never guess" rule for Eyes.

### Admin password reset (only if locked out)
Inside the CT, Minda runs a Python one-liner using `getpass` → bcrypt →
`UPDATE auth SET password=? WHERE lower(email)=?` on `/var/lib/open-webui/webui.db`, then
`systemctl restart open-webui`. **Gotcha:** pasting into a hidden prompt in the Proxmox web shell can add
bracketed-paste codes (`\x1b[200~` / `\x1b[201~`) → strip them in the script and print **only `len()`** to
check; never echo the value. Clear browser autofill before logging in. New password → 1Password only.

## 7. Auto-start + backup
- `pct set <id> -onboot 1`; `systemctl is-enabled nvidia-devices llama-swap open-webui` inside/outside.
- **Datacenter → Backup → job**: the CT, daily 03:00, **Snapshot** mode, to `pbs-nas` (triangle address
  `10.99.23.2` on pve-ai), keep-daily 7 / keep-weekly 4, backup-only PBS token (OI-26). The bind-mounted
  `/models` is excluded (re-downloadable). Click **Run now** on the job to test.
- **Never** use the container's own "Backup now" button: it defaulted to `local` + **stop** mode, took
  Fishbone AI offline (9 Nov 13:25) and then hit the `/dev/nvidia1` trap.

## 8. Verify + benchmark (Eugene reads the output)
```bash
nvidia-smi; systemctl status nvidia-devices --no-pager      # host
pct exec 200 -- nvidia-smi -L
./build/bin/llama-bench -hf ggml-org/gpt-oss-20b-GGUF -ngl 99 -p 512 -n 128
ss -ltnp | grep -E ':9000|:3000'     # 9000 on 127.0.0.1 only; 3000 on the LAN
```
- Expect (2× P40): **20b ≈ 1419 pp512 / 61 tg128 t/s**; **120b ≈ 137 pp512 / 26 tg128**, real chat
  ~22–26 t/s writing and **~200 t/s reading** with `-b 2048 -ub 2048`. Eyes: ~60 t/s writing.
- Incognito browser → `http://<ct-ip>:3000` shows **"Sign in" only** (no sign-up).
- Ask "what is today and what date is next Thursday?" → correct weekday + date.
- Reboot test (planned window): host reboot → CT comes up by itself, `nvidia-smi` works inside.
- Log results in the change-log, ledger, inventory and the R&D notes (commit, driver, CUDA, numbers).

## Traps hit on pve-ai (don't repeat)
| Trap | Symptom | Fix |
|---|---|---|
| ASA serves no DNS | apt/install fails, names don't resolve | DNS 1.1.1.1 / 8.8.8.8 on host **and** CT |
| Debian nvidia-driver 550 | won't build on kernel 7.0 | NVIDIA .run R580 (580.196.07), `--dkms -m=kernel` |
| nova_core (kernel 7.0) | grabs the card | blacklist **nova_core** as well as nouveau |
| Kernel update | driver breaks silently | `proxmox-boot-tool kernel pin 7.0.14-28-pve`; test new kernels deliberately |
| `/dev/nvidia1` missing | CT won't start after stop-mode backup / reboot | `nvidia-devices.service` (`Before=pve-guests`) |
| CUDA 13 | no sm_61 → can't build for P40 | CUDA **12.9** |
| No OpenSSL in llama.cpp | `-hf` https download fails | `libssl-dev` + `-DLLAMA_OPENSSL=ON` |
| `-no-cnv` | flag no longer exists in llama-cli | use `llama-server` / `llama-bench` (web page for chat tests) |
| Wrong HF repo | 401 on `ggml-org/Qwen3-VL…` | `unsloth/…-GGUF:Q4_K_M` |
| `-ncmoe` with even split | OOM on GPU 1 (CPU-expert layers are the first N) | `-ts 23/13` gives GPU 0 more layers |
| `-t 32` | 120b writing collapses to ~6 t/s (cross-socket) | `-t 12` |
| Long prompt pasted in Proxmox shell | garbled £ / bracketed-paste codes | use the web UI; strip `\x1b[200~` in scripts |
| CT "Backup now" | stop mode + local disk, service down | Datacenter → Backup job only |
| GPU cable unchecked | risk of wrong pinout | meter-check before first power-on (HL-0110) |

## Guardrails (always)
- **Guide-only (§3):** Minda runs every command on the live host; Eugene writes and verifies.
- **Never hold, ask for or type a secret** — passwords via hidden entry, stored in 1Password; Eugene
  references *where* they live. `OPENAI_API_KEY=local` is a placeholder, not a secret.
- **Model server never on the LAN** (127.0.0.1:9000); only the login-gated UI is exposed, mgmt VLAN only.
- **Don't starve production:** never build this on the PBX host (Gen9) without a capped container.
- **Models are drafters, not deciders:** dates by code, references matched by code, a human checks
  contract/tax/safety outputs.
- Delete old CTs, archives or branches only on Minda's say-so.
