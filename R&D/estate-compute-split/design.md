# RND-20 — Split the estate: phones to the R710, DL380 becomes a dedicated brain (evaluation)

_R&D evaluation (git-primary; creative mode, 2026-10-26, Minda's idea). Status: **spark — evaluation**.
Touches **production** (the PBX serves both sites' phones), so this is **guide-only + careful planning**;
nothing moved until decided, planned into a maintenance window, and proven with the old copy still intact.
§3 unchanged._

> **⚠️ SUPERSEDED on the PBX destination (updated 2026-10-28).** This note's original idea was "PBX → the
> R710." Later decisions evolved the plan and this is **no longer where the PBX goes:** (1) the **Gen10**
> became the **storage + PBS + production-PBX spine** (`gen10-r710-replacement.md`); (2) the **R710** is now
> the **near-air-gapped 3rd backup copy** — pull + powered-off between pulls (OI-26) — which **can't host the
> live phones.** So the **PBX moves to the always-on Gen10 spine** (not the R710), the **Gen9 becomes the
> pure brain**, and the **R710 = Copy 3**. The *reasoning* below (removing the PBX frees the Gen9 for
> flat-out models + free power-cycles) still stands — only the PBX's new home changed from R710 → Gen10.
> Until the Gen10 is up, the PBX stays on the Gen9 (hence Saturday's power-down window is still a phones
> window). Left as-is below for the honest record.

## The idea (Minda, overnight)
Move **FusionPBX (VM 105)** off the **HP DL380 Gen9** onto the **Dell R710 (`pve-nas`)**, and leave the
**DL380 as a pure AI brain** (P40s + the 256 GB RAM + models).

## Why it's a good instinct — it kills the dream's biggest constraint
Every RND-2/14/19 design has been shackled by one rule: *"the PBX lives on this box — never starve it,
snapshot before every change, no free power-cycles."* That rule is why the models run in capped LXCs and
why fitting a P40 or RAM risks a phone outage. **Remove the PBX and the DL380 can:**
- run models **flat-out** (no cap, no cpuunits yielding to phones),
- **power-cycle freely** for GPU/RAM fits and experiments with **zero phone impact**,
- be the no-holds-barred brain the whole estate-intelligence vision wants.

**Sequencing win (timely):** you're about to fit the 256 GB RAM — which needs a power-down. If the PBX
moves **first**, that RAM fit (and every future GPU/RAM/experiment power-cycle) becomes a **zero-outage**
job instead of a phone-risk one. The relocation is the natural *enabling* step before the brain work.

## What it takes (all proven-ish; one switch change is the real new bit)
| Step | Detail | Status |
|---|---|---|
| **Migrate the VM** | VM 105 → R710 via **PBS backup + restore** (already proven: backed up to `pbs-nas` + restore-tested to VM 999, round-trip OK). The VM keeps its identity, IP `10.224.13.9`, FreeSWITCH config, dialplan. | path proven |
| **Switch port = TRUNK** | ⚠️ **The real change.** The R710's uplink **Gi1/0/44 is `switchport access vlan 10`** today. The PBX lives on **VLAN 13** (`10.224.13.9`). So Gi1/0/44 must become a **trunk carrying vlan 10 (mgmt) + vlan 13 (PBX)** [+ any other VLAN the PBX NIC needs], and the R710's `vmbr0` set **VLAN-aware** with the PBX NIC `tag=13`. 3850 config — guide-only, Minda at the console. | new, straightforward |
| **ASA path unchanged** | The ASA NATs to `10.224.13.9` regardless of which host it sits on — the OI-8 trunk/NAT/dialplan fix carries over untouched once VLAN 13 reaches the R710. | no change |
| **Backup topology flips** | PBS lives **on** the R710. If production moves there too, backup-on-the-same-box isn't real 3-2-1. → back the PBX up **off the R710**: to the **Beverley replica** (off-site, RND-3) and/or PBS on the DL380. | needs re-plan |
| **Both sites keep service** | PBX serves HQ + Beverley; nothing site-specific changes — same VM, same trunk. | no change |

## Bonus Minda spotted: the split also frees the DL380's GPU slots (card redistribution)
The split isn't just about *workload* — it fixes the DL380's **slot contention** too. The box is
"card-heavy" (P840 + stand-up NICs), and the one open check on the 2× P40 fit is "are the GPU-riser slots
clear of the P840/NICs?" (`R&D/local-models/parts-list.md`). As a **pure brain** the DL380 needs far less
networking, so cards can move **to where they belong**:
- **10G NIC (562SFP+, 727055-B21) — STAYS in the brain. AS-BUILT 2026-10-30:** at the build, **both P40s fit
  with the 10G card left in place** — **no slot contention** after all, so no need to move it. The brain
  **keeps its 2× 10G** (cross-stack LACP, HQ 3850 **Po4 "SERVER-DL380"**) — better for it (model pulls,
  host/VM traffic). ~~Earlier plan: move it to the storage box to free a GPU slot~~ — unnecessary,
  **reversed** (this is the correction to the former "move to R710/Gen10" plan + PR #30).
- **Consequence:** the **Gen10 storage spine needs its OWN 10G NIC** later — the 3850 stack's only 2× 10G
  ports are now the brain's.
- **331i LOM + 366FLR (FlexLOM) + 331T** — spare on the brain; not needed (the 10G carries it).
- **P840 stays** (the DL380's own OS/ZFS + model disks), in a slot clear of the P40s.
**Net (as built): PBX off + 2× P40 + 256 GB + PSU in, 10G kept — the riser slots were clear enough for both
P40s alongside the 10G. One opening did it all.**
_⚠️ Gotcha hit at the build: adding the P40s **renamed the 10G NIC** (ens3f*→ens6f*), which broke the OVS
bond — see `change-log/change-log-2026-10-30-hq-buildday-storage-brain-live.md` + OI-28._

## The wrinkle (my honest flag)
**The R710 is the oldest box, and this makes it production-critical.** Today the phones run on the Gen9
(2016); the R710 is ~2009 Westmere, has a **known disabled DIMM (B3 MEMBIST)**, and would be doing
**triple duty** (storage + backup + phones). None of that is disqualifying — the PBX is *light*, the R710's
12c/24t·24 GB is ample, and the ZFS mirror gives disk redundancy — but putting the **business phones on the
oldest box doing the most jobs** is the one thing to be deliberate about. Mitigations: **fix/replace the B3
DIMM first**, keep a **tested off-site restore at Beverley**, and keep the DL380 copy until the R710 PBX has
proven itself for a week.

## Options
- **A — Minda's idea: PBX → R710.** Zero cost (owned kit), proven migration path, frees the DL380 now.
  Cost: R710 age + triple-duty + the backup flip + the one switch change.
- **B — PBX → a dedicated small modern box** (a used mini-PC / SFF, ~£100–200). The *textbook* split: phones
  on reliable dedicated modern hardware, DL380 = pure brain, R710 = pure storage/backup. Cleanest, tiny
  spend, best long-term reliability for the most critical service.
- **C — status quo:** PBX stays on the DL380; accept the AI constraint. (The thing we're trying to escape.)

## Recommendation
**Do the split — the instinct is right.** For **right now, zero cost**, **Option A** is a strong move and
I'd back it, *provided* we treat the R710 as production (fix B3, off-site backup, keep the old copy till
proven). If you'd rather the phones sit on their own reliable modern box long-term, **Option B** is the
cleaner end-state for ~£100–200 — and the R710 goes back to being pure storage/backup. **Either way, do the
move before the RAM/GPU fits**, so the brain work becomes outage-free.

My lean: **A now** (it's free and unblocks you immediately), with **B as the tidy upgrade later** if the
R710-as-phone-host ever feels fragile.

## Phased plan (guide-only; Minda executes; maintenance window; old copy kept)
1. **Prep:** fix/verify the R710 B3 DIMM; confirm R710 headroom; pick a phones-quiet window.
2. **Switch:** make Gi1/0/44 a trunk (vlan 10 + 13 …); set R710 `vmbr0` VLAN-aware. Verify VLAN 13 reaches
   the R710 (a test VM pings `10.224.13.1`/the ASA).
3. **Migrate:** PBS-restore VM 105 onto the R710 (new VM, NIC `tag=13`, same `10.224.13.9`); **keep the
   DL380 copy powered off, not deleted.**
4. **Prove:** internal call, outbound, **inbound** (the OI-8 path), two-way audio; `sngrep`/registration
   green. Run for a few days.
5. **Backup flip:** point the PBX's nightly backup off-box (Beverley replica + DL380), tested restore.
6. **Free the brain:** once proven, the DL380 has **no production VM** → fit the RAM/GPUs freely, uncap the
   models. Only then delete the old DL380 PBX copy.
7. (Later, optional) **Option B:** move the PBX to a dedicated mini-PC; R710 → pure storage/backup.

---
_Guide-only; production-critical; nothing moved until planned + proven with the old copy intact. Unblocks
RND-2/14/19 (the unconstrained brain). Pairs with RND-3 (R710/backup), OI-8 (trunk path carries over),
OI-17 (backup topology)._
