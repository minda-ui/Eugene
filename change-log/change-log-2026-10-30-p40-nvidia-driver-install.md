# Change log — 2026-10-30 (Fri night) — Gen9 P40 NVIDIA driver installed; both P40s need aux power

_Eugene guided; Minda hands-on remotely from **Beverley** (Gen9 shell + iLO over the site link/Tailscale),
held all creds (§3). Phones free all weekend, so no window pressure._

## What we did — NVIDIA driver on the Gen9 brain (start of the P1 AI build)
The P40s were detected at PCI level (Saturday) but had no driver. Tonight installed it:
1. **Fixed the apt repos** (this box has no Proxmox subscription): added
   `deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription`, disabled the enterprise repos
   (were 401-ing), and enabled Debian **`non-free non-free-firmware`** (for `nvidia-driver`).
2. `apt install -y pve-headers-$(uname -r)` → `proxmox-headers-6.8.4-2-pve`.
3. `apt install -y nvidia-driver` → **535.309.01** (Debian bookworm LTS branch — deliberately: it supports
   **Pascal/P40** and CUDA 12; the newest 580 branch *drops* Pascal). DKMS built the module cleanly, the
   package auto-blacklisted nouveau, initramfs regenerated.
4. Avoided a reboot (iLO is on a default password — OI-31 — so no reliable remote recovery): swapped the
   modules live — `modprobe -r nouveau` (clean, usecount 0) → `modprobe nvidia`.

## Result — driver perfect; both P40s unpowered
- **`lspci -nnk -d 10de:`** → both Tesla P40s, **`Kernel driver in use: nvidia`**. ✅
- **`/dev/nvidia0`, `/dev/nvidia1`, `nvidiactl`, `nvidia-uvm`** all created. ✅ Driver works.
- **`nvidia-smi` → "No devices were found"**, because **both GPUs fail to initialise for lack of power**:
  ```
  NVRM: GPU 0000:08:00.0: GPU does not have the necessary power cables connected.
  NVRM: GPU 0000:84:00.0: GPU does not have the necessary power cables connected.
  RmInitAdapter failed! (0x24:0x1c:1447)  — device minor 0 and 1
  ```
  (nouveau's earlier boot log also flagged "GPU is missing power" on 84:00.0 — nvidia's NVRM confirms it on
  **both**, so it's real, not a nouveau false-positive.)

## The fix (OI-30, physical, at HQ)
On the DL380 Gen9 the GPU power cable is **10-pin (riser power connector) → 8-pin (P40)**; the riser-power
end is the easy one to miss, and **both** cards being dead points at that. **The correct cable (HPE
`805123-001`, ×2) is already on hand** (ordered 10 + 16 Oct) — nothing to buy. Minda, at HQ: seat each
cable at **both** ends, then `nvidia-smi` lights both P40s. (⚠️ `871829-B21` on the shopping list is the
*Gen10* cable — not the Gen9.)

## Also flagged tonight
- **OI-31: the Gen9 iLO is on its factory-default password.** Reachable at `10.224.10.50` on the LAN (and from
  Beverley) — a security gap. Change it + store in 1Password. (Inventory had wrongly said it was changed
  2026-10-01 — corrected.)

## State
- Driver install: **done + correct** (survives on disk; a future clean reboot will load nvidia at boot — we'll
  do that once iLO's sorted / someone's at HQ, which we want anyway before the model stack).
- GPUs: **blocked on aux power** (OI-30) — a 5-minute cable job at HQ.
- Model stack (Ollama etc.) + any GPU load test still gated on **(a)** power cables (OI-30) and **(b)** the
  **GPU baffle** (not yet fitted — no sustained load without it).
