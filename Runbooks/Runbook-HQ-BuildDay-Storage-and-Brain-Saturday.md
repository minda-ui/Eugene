# Runbook — HQ build day (Saturday): storage pool + Gen9 brain, in the safe order

> **✅ EXECUTED 2026-10-30 (guided live).** PART 1 (storage pool `tank`, 12.9 TB) ✅ · PART 2 (all 6 Gen9 VMs
> backed up + local snapshots) ✅ · PART 3/4 (256 GB + 2× P40 + PSU; phones verified) ✅. **Deviations:**
> drives were NetApp **X423, 512n** (no reformat); the **10 G NIC was KEPT in the brain** (both P40s fit —
> decision reversed); fitting the P40s **renamed the 10 G NIC → broke the OVS bond** (fixed, reboot-proven,
> OI-28); the R710 **PERC 6/i threw a transient fault** (cleared by cold boot — watch, no recurrence yet).
> **Still open:** pve-nas network-isolated (cable in wrong port, OI-27, Minda finishing); **PART 5 DocuSeal
> not started** (needs the Workspace SMTP relay first). Full record:
> `change-log/change-log-2026-10-30-hq-buildday-storage-brain-live.md`.

> **Eugene, 2026-10-28 (guide-only, §3).** One checklist for Saturday's HQ build. **Minda does the
> hands-on; Eugene guides + verifies; holds no credential.** Two builds in one day, deliberately ordered
> so the **zero-risk** work (R710 storage) comes first and its PBS then **protects** the **phones-risk**
> work (opening the live PBX host) — **plus PART 5, finishing DocuSeal** (SMTP + wire Anna, OI-21), done
> while DocuSeal is up (it's a VM on this Gen9). Sources: `R&D/estate-storage/design.md` +
> `Runbook-RND3-Estate-Storage-Build.md` (storage), `R&D/local-models/parts-list.md` (P40 fit),
> `R&D/software-foundry/ram-upgrade-spec.md` (RAM), `Runbook-Backup-PullNotPush-Hardening.md` (append-only
> PBS, OI-26), `Runbook-DocuSeal-SMTP-and-Wire-Anna.md` (DocuSeal finish, OI-21 a+c).

## ⚠️ The one difference that sets the order
- **R710 storage = separate box, phones untouched → zero risk.** Do it first.
- **Gen9 DL380 = the LIVE PBX host (VM 105).** Fitting RAM + P40s + PSU means **powering it down = a planned
  phones-outage window.** Back up its VMs to the new PBS first; verify phones back up before you finish.

## Pre-flight (before you start)
- [ ] **Parts in hand:** SAS cable ×2 (delivered ✅), 1400 W PSU (delivered ✅), 2× P40 + both risers + both
      power cables (dry-fitted ✅), high-perf fans (fitted ✅), **128 GB RAM kit — arriving Fri** (4× 840758-091).
- [ ] ⚠️ **GPU baffle/shroud** — the one outstanding item (`parts-list.md`). The P40s are **passively cooled**;
      without the baffle they **overheat under load**. **If it's not here by Saturday:** you can still do the
      full mechanical fit, but **don't run the GPUs under sustained load** (no model burn-in) until it's in.
      Idle/seated P40s are fine; it's load that cooks them.
- [ ] **Pick the phones-outage window** (evening/quiet period). Tell anyone who needs to know phones are down.
- [ ] Keyboard that works in a boot shell (the plain-keyboard lesson), labels/torch, anti-static.

---

## PART 1 — R710 storage pool (zero phone risk) — do first
**SHELF-ONLY build (DECIDED, Minda 2026-10-29):** the 24 DS2246 shelf drives on the CP400e (both in hand).
**No internal HBA** — the R710's 8 internal bays are **not** used for data this build; **those drives are kept
for the Gen10** (which has its own E208i-a HBA). So nothing to buy for Saturday's storage. Full detail in
`Runbook-RND3-Estate-Storage-Build.md`. Order that matters:
1. [ ] **Fit the CP400e HBA → boot → confirm IT mode FIRST:** `sas3flash -list`. If it reports **IR/RAID**,
       crossflash to **9300-8e IT** firmware *before* building any pool. This is the check that can stop the
       day — do it before cabling the shelf.
2. [ ] **Cable SFF-8644 (HBA) → QSFP/SFF-8436 (DS2246 IOM A).** (Second cable to IOM B later for multipath.)
3. [ ] **Boot the storage OS → confirm all 24 shelf bays enumerate.** Drives are Seagate ST900MM0006 **512n**,
       so **skip the `sg_format` 520→512 step** — not needed.
4. [ ] **Build the pool:**
       - **`tank` (shelf, CP400e):** **4× 6-wide RAIDZ2 ≈ 11.6 TB** — the whole store (~3× the 3-yr need).
       - **Boot:** 2× internal mirror (`rpool`) — already built (stays on the PERC as-is).
       - Enable **ZFS snapshots** (hourly/daily/weekly). _(The other 6 internal bays stay empty — those
         drives go to the Gen10.)_
5. [ ] **SMB/NFS share → map a test drive** from an office PC, write a test file.
6. [ ] **Stand up PBS** on the box — and wire it **append-only from the start** (don't retrofit OI-26):
       - PBS token for the HQ Proxmox = **`DatastoreBackup` only** (no Prune/Modify).
       - **Prune + GC + verify scheduled on the PBS box**, not on the PVE job.
       - A short **ZFS snapshot** history of the PBS datastore (`rpool/pbs-store`).
       (Steps in `Runbook-Backup-PullNotPush-Hardening.md` Phase A.)

---

## PART 2 — Back up the Gen9 production VMs to the new PBS (the safety net)
Before touching the Gen9 hardware, get a fresh backup of what's on it — so the "brain surgery" is reversible.
1. [ ] On the HQ Proxmox, **run a backup now** of **VM 105 (FusionPBX)**, **VM 106 (DocuSeal self-host)** +
       the other production VMs to the new `pbs-nas` datastore → **TASK OK** on each. _(VM 106 runs on this
       Gen9, so it goes down in PART 3 too — the backup covers it; the DocuSeal finish work is PART 5.)_
2. [ ] (Belt-and-braces) take a **Proxmox snapshot** of VM 105 as well.
This is the synergy of doing storage first: the pool you built this morning now protects the phone server.

---

## PART 3 — Gen9 power-down window: do ALL the internal work in ONE box-opening
Open the DL380 **once** — fit RAM **and** P40s **and** the PSU together, not three separate outages.
1. [ ] **Graceful-shutdown** the Gen9 (stop VMs cleanly, then power off). Phones are now down — window open.
2. [ ] **RAM → 256 GB (8× 32 GB).** Add the 4× new **840758-091** to the 4× existing **809083-091**.
       - Both are **32 GB 2Rx4 RDIMM** → mixing is fine (never mix RDIMM+LRDIMM); all run at **2400**.
       - **Populate one DIMM in every channel = 4 per CPU, mirrored on both CPUs** → all **8 channels at
         1 DPC** = full bandwidth at 2400 (the config CPU inference wants). Follow the **HPE slot-population
         order** silk-screened on the board / in iLO (fill each channel's first slot before any second slot).
3. [ ] **PSU:** fit the **1400 W** (720620-B21). (It replaces the eBay pair that failed testing. Ideally run
       **2× for redundancy** if you have both; one 1400 W will power the box but gives no PSU redundancy.)
4. [ ] **P40s + risers** (already dry-fitted): seat both cards, connect **each P40's 8→10-pin power cable**,
       confirm the P840/NICs clear the double-wide heatsinks (per the 2026-10-16 dry-fit).
5. [ ] **Baffle:** fit it if you have it. If not → cards stay seated but **no load test today** (see pre-flight).
6. [ ] **BIOS on fit day:** enable **"Above 4G Decoding"** (+ large/≥ MMIO if present) so both 24 GB P40s map.

---

## PART 4 — Power up + verify (close the window properly)
1. [ ] **POST / iLO:** confirm **256 GB** at **2400 MT/s**, both CPUs, both P40s detected.
2. [ ] **Boot Proxmox → start the VMs → VERIFY PHONES:** internal call, **outbound**, and **inbound** (the
       OI-8 path) all work with two-way audio. **Don't call the window closed until phones are confirmed.**
3. [ ] **GPUs:** `nvidia-smi` lists **2× Tesla P40**, each 24 GB. (Install/confirm the driver.)
4. [ ] **Only if the baffle is in:** a short load test (watch `nvidia-smi` temps). Otherwise defer.
5. [ ] If anything's wrong with the PBX after boot → you have the PART-2 backup + snapshot to restore from.

## PART 5 — Finish DocuSeal (close OI-21 a+c; DocuSeal must be UP)
The DocuSeal self-host (**VM 106**, `10.224.10.60:3000`, public `sign.fishbonegroup.co.uk`) runs on **this
Gen9**, so it's **down during the PART-3 window**. Do this part while it's up — **best in the morning
alongside PART 1** (storage, zero phone risk, DocuSeal still live), or else **after PART 4** once the Gen9 is
back. Full detail + exact fields in **`Runbook-DocuSeal-SMTP-and-Wire-Anna.md`** — this is just the Saturday
checklist and order.

- [ ] ⚠️ **Day before (de-risks propagation):** configure the **Workspace SMTP relay** (`admin.google.com` →
      Apps → Gmail → Routing → **SMTP relay service**: in-domain senders, **Require SMTP Auth + TLS**) and
      generate the **App password** for `info@fishboneconstruction.co.uk` (1Password). Admin-console changes
      can take **up to ~24h** — doing this Friday means it's live for Saturday's test. (Runbook Part A1/A2.)
- [ ] **Point DocuSeal at the relay** — admin UI `http://10.224.10.60:3000` (over Tailscale) → Settings →
      Email/SMTP: host `smtp-relay.gmail.com`, port `587`, STARTTLS, user `info@fishboneconstruction.co.uk`,
      the app password (Minda pastes), FROM `info@fishboneconstruction.co.uk` → **Send test email**. (Part A3.)
- [ ] **Full internal sign test on our own box:** create a submission from the tagged
      `Sample-RAMS-DocuSeal-Phase0.docx` → signing-link email **lands** → sign → DocuSeal returns the
      **signed PDF + audit log**. This is the gate that proves the box is ready for Anna. (Part A4.)
- [ ] **Wire Anna:** generate the DocuSeal **API token** (Settings → API → 1Password); Minda sets
      `DOCUSEAL_API_BASE_URL=https://sign.fishbonegroup.co.uk` + `DOCUSEAL_API_KEY` in Anna's env. Eugene's
      Raw/ hand-off (AWT-0589) already tells Anna the flow; **Anna wires herself**. (Part B.)
- [ ] **Verify from an Anna session:** `DOCUSEAL_CREATE_SUBMISSION_FROM_DOCX` succeeds → signer emailed →
      Anna retrieves the signed PDF + audit log. Then **graduate RND-8** and mark **OI-21 (a)+(c) done**.
- [ ] Secrets (app password, API token, admin/DB creds) are **Minda-held in 1Password, never in git/KB** (§3).

## After the day
- Update `Infra-Inventory/` (256 GB, 2× P40, the storage pool + PBS), the change-log + ledger, and
  `R&D/` statuses (RND-2 brain hardware in; RND-3 storage live; RND-19 RAM fitted; **RND-8 DocuSeal graduated**).
  Mark OI-7 context and **close OI-21 (a)+(c)**.
- **Friday's Gen10 order** is separate (confirm the 24SFF SAS expander, add 64 GB 2933 RAM, 865408-B21 PSUs).

---
_Guide-only (§3): Minda does the hands-on and holds all creds; Eugene guides + verifies. Order = zero-risk
storage first, then its PBS protects the phones-risk Gen9 work. Baffle gates GPU load, not the fit. Pairs
with RND-2/3/19 + the OI-26 append-only PBS hardening._
