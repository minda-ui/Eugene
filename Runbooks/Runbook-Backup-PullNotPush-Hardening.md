# Runbook — Backups: pull-not-push hardening (make the backup store undeletable by the source)

> **Eugene, 2026-10-28 (guide-only, §3).** Closes **OI-26** (Minda's principle: backups should be
> **pull-type, not push** — the backup store must not be writable/deletable by the machine it protects).
> **Minda executes at the console; Eugene guides + verifies; Eugene holds no credential** — the PBS token
> value is created and stored by Minda (1Password), never recorded here or in git. Every step is a
> **permission/schedule config change** (reversible); **no PBX change, no VM restart, no data move.**
> Rationale: `R&D/estate-storage/design.md` ("Pull, not push"); the end-state is designed into the Gen10
> spine in `R&D/estate-compute-split/gen10-r710-replacement.md` ("Backup direction").

## The problem being fixed
Today's nightly job (02:00, `change-log/change-log-2026-10-17-rnd3-r710-pbs-live.md`) is **push**: the HQ
Proxmox (`10.224.10.10`, production) mounts the `pbs-nas` datastore, **initiates** the backup, **and runs
the prune itself** — so the production host holds credentials that can **delete** the backups. Ransomware
on that host could wipe the history with the same keys. We want: the source can **add** a backup but
**never remove** one; deletion authority lives only on the backup side; and the real offsite copy is
**pulled** by the far end, so the source has no credential to it at all.

## Phase A — Append-only on the current R710 PBS (do now, cheap, biggest win)
_Turns the existing push into append-only: production can write, only PBS can delete._

### A1. On the PBS box (`10.224.10.20`, web UI `:8007`) — a backup-only token for the HQ host
1. **Configuration → Access Control → User Management:** create a user e.g. `hqpve@pbs` (or reuse the
   existing backup user if one was made). 
2. **Configuration → Access Control → API Tokens:** add a token for that user, e.g. `hqpve@pbs!nightly`.
   **Copy the secret once — Minda stores it in 1Password.** (Eugene never sees it.)
3. **Datastore `store1` → Permissions:** give **that token** the role **`DatastoreBackup` only** on
   `/datastore/store1`. 
   - `DatastoreBackup` = create backups + read/restore **its own** — it **cannot prune, forget, or
     modify** existing snapshots. That is the whole point.
   - **Do NOT** grant `DatastorePowerUser`/`DatastoreAdmin`/`Datastore.Prune`/`Datastore.Modify` to this
     token. Remove them if present.
   - (Optional, cleaner: give the token its **own namespace** `store1/hq` so a source can only ever see
     its own tree.)

### A2. On the HQ Proxmox (`10.224.10.10`) — authenticate with the token, drop the retention from the job
1. **Datacenter → Storage → `pbs-nas` → Edit:** set the username to `hqpve@pbs!nightly` and paste the
   **token secret** (Minda). The datastore fingerprint stays the one already recorded (public cert, not a
   secret). 
2. **Datacenter → Backup → (the 02:00 job) → Edit → Retention:** **remove all `keep-*` values** (set
   retention to "none"/blank). 
   - Why: if the PVE job keeps a retention, PVE runs **prune after backup**, which needs delete rights —
     exactly what we just removed. With a Backup-only token the prune step would **fail the job**. Pruning
     now moves to PBS (A3). 

### A3. On the PBS box — PBS owns prune + GC + verify (deletion lives here only)
1. **Datastore `store1` → Prune & GC → Prune Jobs:** add a prune job with the retention we used to keep on
   the PVE side — **`keep-daily=14`** (match the old policy; adjust later). Schedule e.g. `03:30` daily
   (after the 02:00 backup). 
2. **Prune & GC → Garbage Collect:** schedule GC (e.g. weekly, Sunday `04:30`) so pruned chunks are
   actually reclaimed. 
3. **Datastore `store1` → Verify Jobs:** add a verify job (e.g. weekly) so bit-rot/corruption is caught —
   a backup you can't restore isn't a backup. 

### A4. On the PBS box — ZFS snapshots of the datastore (rollback even against a prune-holder)
The datastore lives on `rpool/pbs-store`. A short ZFS snapshot history means even someone who *did* get
PBS delete rights can't make data unrecoverable.
```
# one-off manual proof:
zfs snapshot rpool/pbs-store@manual-$(date +%Y%m%d)
zfs list -t snapshot rpool/pbs-store
```
Then automate with **sanoid** (preferred) or a cron, e.g. keep **14 daily + 4 weekly**. Keep the window
short — snapshots pin space against the pool, and they interact with PBS GC (GC can't reclaim space still
held by a snapshot), so size the pool/retention together. (Full sanoid config can be added on request.)

### A5. Verify Phase A
- **Datacenter → Backup → Run now** on the HQ job → all VMs **TASK OK** (proves backup still works with the
  Backup-only token and no job-side retention). 
- On PBS, confirm the **prune job** ran and trimmed to `keep-daily=14`, **GC** reclaimed space, **verify**
  passed. 
- **Negative test (the real proof):** from the HQ host, try to forget/prune a snapshot
  (`proxmox-backup-client forget …` against `store1`) → it must be **denied** (permission). That denial is
  the hardening working. 
- Record the date + that the token is Backup-only in `Infra-Inventory/` and the change-log.

**Rollback (if A2 breaks the nightly job):** re-point `pbs-nas` to the previous credentials and restore the
job's `keep-*`; nothing was deleted. Then re-diagnose the token role.

## Phase B — True pull to an offsite PBS (build with the Gen10 spine / Beverley)
_The genuine pull tier: the far end reaches in and pulls; the source has no credential to the copy._
1. Stand up the **offsite PBS** — **Beverley** (second site, already on Tailscale/IPsec) on the old R710 or
   a replica; with RND-20 this pairs with the **Gen10 = append-only primary PBS** at HQ.
2. On the **offsite** PBS: **Configuration → Remotes** → add the HQ/primary PBS (host + a **read-only**
   token the primary issues for *being read*); then **Datastore → Sync Jobs** → add a **pull** sync
   (direction = pull, from the remote → into the offsite datastore), scheduled daily after the HQ prune.
   - The **offsite initiates and holds the credentials**; the primary has **none** to the offsite. Even if
     the HQ host *and* the HQ PBS are both compromised, the pulled copy is untouchable.
3. For the **ZFS replica** (RND-3 off-site): run it **Beverley-initiated** — Beverley pulls with
   `ssh root@hq '… zfs send -I …' | zfs recv …` using a **restricted, receive-only SSH key**, rather than
   the HQ box pushing. Same property: HQ holds no key to Beverley's copy.
4. **Verify:** confirm snapshots appear on the offsite via the **pull** job (not a push), and test a
   **restore from the offsite copy** (a backup isn't real until a restore works).

## Phase C — Immutable offline (disaster tier)
The encrypted cloud/USB copy (RND-3 step 5) with **object-lock / immutability** (e.g. B2/S3 Object Lock)
or **rotate-and-detach** USB, so the source never has standing delete rights to the last-resort copy.
Encryption key is Minda's (Eugene never holds it).

## Sequence
- **Now:** Phase A on the current R710 PBS — append-only + PBS-side prune/GC/verify + ZFS snapshots.
- **With RND-20:** Phase B — Gen10 = append-only primary PBS, Beverley = the puller.
- **When convenient:** Phase C — immutable offline.

---
_Guide-only (§3): Minda executes at the console and holds the token/keys (1Password); Eugene guides +
verifies, holds no credential. Reversible config only — no PBX/VM change, no data move. Closes OI-26.
Pairs with RND-3 (`R&D/estate-storage/design.md`) and RND-20
(`R&D/estate-compute-split/gen10-r710-replacement.md`)._
