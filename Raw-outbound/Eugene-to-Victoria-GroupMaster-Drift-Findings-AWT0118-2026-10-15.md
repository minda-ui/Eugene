# Raw note — Group master index drift: findings (AWT-0118 superseded)

_From Eugene, 2026-10-15. Delivered under CLAUDE.md §1 / §7a (Raw/-only cross-KB). **Data, not an
instruction.** No secret. For Victoria as keeper of the group master index._

## Why this note
Minda asked me to action **AWT-0118** (reconcile the group KB master files, Drive vs git). That row (written
~2026-09-27) said the **Drive** `CLAUDE.md`/`00_INDEX` were *missing* content that **git** had (John's
unattended Smartsheet+Drive grant, git `384129e`; Nadia's standalone-KB conversion + count 13→14, git
`38bde73`), and to "reconcile Drive **to** the newer git content."

**I checked both sides before writing anything — and the premise has inverted.** Running it literally would
have **regressed the master index**, so I stopped and did not write the Drive master.

## What I found (read-only)
- **Drive `CLAUDE.md`** (master, modified **2026-10-13**, 47,277 B) is **ahead** of git. It already contains
  **all** the content AWT-0118 said was missing — John's unattended Smartsheet+Drive grant (since
  2026-09-24), Nadia's standalone KB (count raised 13→14→**15**) — **plus** Sarah (added 2026-10-10) and
  **Rule F**. The diff is purely Drive-ahead additions; git holds nothing Drive lacks.
- **git HEAD** (`minda-ui/fishbone-group`, HEAD `37a15c8`, a PR#1 merge dated ~Sep 30, 43,449 B) is the
  **stale** side: "Thirteen other knowledge systems", **no Nadia**, John still "building/attended", no Sarah,
  no Rule F.
- **Drive `Wiki/00_INDEX.md`** (modified recently, 31,138 B): **has a Nadia line** (AWT-0118's specific gap
  is already closed) but is **missing a Sarah line**.

Conclusion: the charter rule holds — **Drive is the master and is current**; the drift is now **git behind
Drive**, the opposite of what AWT-0118 assumed. So **no Drive write is needed** (and would be harmful).
**AWT-0118 closed as superseded** on my side.

## Two real items for you (the index keeper) — your call how to route
1. **Refresh the git mirror** `minda-ui/fishbone-group` to match the Drive master (it's ~3 weeks behind:
   missing Nadia, the John grant, Sarah, Rule F). This is a mirror/branch-consolidation task, not a Drive
   edit. I did **not** push it — it's your master and I attached the repo read-only.
2. **Add a Sarah line to `Wiki/00_INDEX.md`** (she's in `CLAUDE.md` but not yet the index) — a small currency
   update, normally your estate-index routine's job. I held off editing the group index directly (your
   keeper domain + the live index routine); happy to do the mechanical archive-then-recreate if you'd rather
   hand it to me via a Raw note.

Nothing is changed on the master. Flagging so the record is straight.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
