# Change log — 2026-10-28 (covers 26–28 Oct): RAM bought, Gen10 storage decided, HMRC VAT build kicked off, RND-21 Telegram pilot scoped

_Newest note at top. One dated file per session (`CLAUDE.md` §4). Guide-only throughout (§3): Minda
holds every credential/OAuth, buys/fits all hardware, executes all live-system steps; Eugene scopes,
builds + verifies. Nothing installed, nothing filed, no secret held. This file catches up the 26–28 Oct
work that had not yet been written into the change-log/ledger/current-state._

---

## 2026-10-28 (later) — OI-26: backups made pull-not-push (append-only PBS + pull offsite)

**Minda's principle:** "backups should be pulling, not pushing." Checked the live wiring — the nightly
02:00 job runs **on the HQ Proxmox** (production), which mounts `pbs-nas` as a target, initiates the
backup **and runs the prune itself** → the production host holds credentials that can delete the backups,
so ransomware on it could wipe the history. `zfs send/recv` to Beverley is source-push for the same
reason. Minda's right; design-level fix. **Wrote it up (guide-only, nothing changed on live boxes):**
- **Raised OI-26** (`open-issues.md`) — the principle + the three-defence fix + the sequence.
- **RND-3 design** (`R&D/estate-storage/design.md`) — new "Pull, not push" subsection in the backup plan.
- **RND-20 storage note** (`R&D/estate-compute-split/gen10-r710-replacement.md`) — "Backup direction"
  section: Gen10 = **append-only primary PBS**, Beverley = **the puller** (designed in, not retrofitted).
- **Hardening runbook** `Runbooks/Runbook-Backup-PullNotPush-Hardening.md` — Phase A (append-only on the
  current R710 PBS now: `DatastoreBackup`-only token, prune/GC/verify moved onto PBS, ZFS snapshots of the
  datastore, + a negative test that the source is *denied* prune), Phase B (true pull: a PBS sync job on an
  offsite/Beverley PBS pulls from the primary; ZFS replica Beverley-initiated), Phase C (immutable offline).

The threat defeated: a compromised source can **add** a backup but **never delete** one; deletion lives
only on the backup side; the offsite copy is **pulled**, so the source holds no credential to it. Guide-only
(§3) — Minda executes at the console and holds the token/keys; Eugene holds no credential. Sequence: Phase A
now on the R710 PBS, Phase B/C with the Gen10 spine.

---

## 2026-10-28 — RND-21: site-chat bridge → Anna, Telegram-first pilot scoped

**Minda's ask:** site teams post construction updates — **photos + requests** — in **WhatsApp** and
**Telegram** project groups; can we bridge those so **Anna** sees them and the in-house brain can work
them (vision on photos, summarise updates, pull out requests)? "A couple of tests for the AI machine."

**Feasibility (R&D, `R&D/site-chat-bridge/design.md`, spark → exploring):**
- **Telegram = easy, clean.** A bot (added to a group) or a user-client (Telethon / mautrix-telegram)
  reads messages + media. No ToS problem, no ban risk.
- **WhatsApp = genuinely caveated.** There is **no official way to read existing WhatsApp group chats**
  (the Business Cloud API only covers your own business number). Reading the real site groups means an
  **unofficial bridge** (mautrix-whatsapp / Baileys / whatsapp-web.js as a linked device) — against ToS,
  real **ban risk**, breaks E2EE, fragile — or moving the chat to a Business number / to Telegram. Steer:
  if unofficial, **a dedicated/secondary WhatsApp number, never the main business line.**
- **Architecture (elegant):** self-hosted Matrix + mautrix-telegram + mautrix-whatsapp → one inbox →
  Anna + a script read it, media mirrored to storage (RND-3), photos through the vision sentinel
  (RND-16), into the per-project record (RND-7).

**Minda chose: scope the Telegram-first pilot.** Produced
`Runbooks/Plan-Telegram-Site-Chat-Pilot-Anna-RND21.md` — one project's Telegram group → read-only reader
(user-client recommended for full history; bot as fallback) in a capped LXC → mirror messages + photos
to storage → Anna's feed → run the first brain tests (photo vision, day-summary, request extraction).
Phasing P0 (scope) → P1 (ingest) → P2 (AI test) → P3 (expand; WhatsApp decided separately).

**Boundaries held (§3):** read-only (never posts); **Minda holds the Telegram login/token** (Eugene
references it, never holds it); **privacy/consent = Minda + Victoria** (staff + subcontractor chats =
personal data + photos of people → lawful basis + a notice to the people in the group before go-live);
**Anna's domain** — scoped with her.

**Hand-offs (per §1, Raw/-only):**
- **Anna** — `Raw-outbound/Eugene-to-Anna-Telegram-site-chat-pilot-inputs-2026-10-28.md`: 5 inputs
  (which group, what to capture, output shape + location, how she consumes it, retention). Hub **AWT-1035**.
- **Victoria** — `Raw-outbound/Eugene-to-Victoria-Telegram-site-chat-privacy-flag-2026-10-28.md`: the
  privacy/consent governance question (lawful basis, DPIA?, notice, retention, who sees output) — hers +
  Minda's to settle, not Eugene's. Hub **AWT-1036**. Same posture as RND-16.
- ⚠️ **Drive delivery of both Raw notes is PENDING** — the Composio CLI sign-in was dropped by a
  container re-provision (see below), so the notes are committed to git and named in the Hub rows (which
  carry the full content), but not yet byte-verified into Anna's / Victoria's Drive `Raw/` folders. To
  finish next session when the CLI re-auths.

RND-21 logged in `R&D/ideas-log.md`.

---

## 2026-10-27 — HMRC VAT read-only integration: scoped with Rachel, build green-lit

**Chain:** Minda asked whether there's an API to HMRC for tax info. Found: **VAT (MTD)** and **CIS** have
read APIs (OAuth 2.0 user-restricted, scope `read:vat`, mandatory Gov-Client-* fraud-prevention headers,
sandbox → production); **Corporation Tax has no clean read API**. No Composio HMRC connector — a custom
build. Minda's instinct ("we've got QuickBooks already, nothing new to create") was right to test, so —
at her instruction — **asked Rachel directly** what she actually needs from HMRC
(`Raw-outbound/Eugene-to-Rachel-HMRC-data-needs-question-2026-10-27.md`, Hub AWT-1030).

**Rachel confirmed a real, QB-can't-answer need (AWT-1031):** the **QB VAT control balances don't tie to
HMRC** (as of 22/10), plus she wants the tax calendar (obligations/due dates) and a 13-week forecast —
all things only HMRC's own figures can settle. So the value-add is **reconciliation**, not duplicating QB.

**Minda green-lit the build.** Produced:
- `Runbooks/Plan-HMRC-VAT-ReadOnly-Integration-AWT1030.md` — the build plan with Rachel's inputs folded
  in: **3 VRNs** (Construction 190175216, Waste 408853087, Commercial Properties 438278661);
  reconciliation rules (QB VAT Control ties to HMRC within £1; VAT Suspense = open-check; payments
  matched by amount within 5 days; penalties/interest tracked separately); **output = a weekly Monday CSV
  + a short `.md` status to Rachel's Raw before 08:00, Minda + Rachel only**; phasing P0–P5.
- `Runbooks/Runbook-HMRC-DeveloperHub-App-Registration-AWT1030.md` — **Minda's step 1** (guide-only):
  register a sandbox app on the HMRC Developer Hub, subscribe to VAT (MTD), create a test user, redirect
  URI `http://localhost:8631/callback`, creds into the secret store.

**Boundaries (§3):** **read-only** (never files, never pays); **Minda holds all credentials + does the
OAuth**; the egress to gov.uk is blocked for routines (OI-6) so the first build runs interactively/against
sandbox. Build row **AWT-1032** raised. Blocked on Minda's step-1 app registration (unblocks P1 sandbox).
Rachel hand-off `Raw-outbound/Eugene-to-Rachel-HMRC-build-scoping-inputs-2026-10-27.md` (delivered to
Rachel's Drive `Raw/`, byte-verified, while the CLI was still up).

---

## 2026-10-25 (cont.)–26 — RND-19 RAM bought; RND-20 estate re-architecture + Gen10 = storage spine

**RND-19 (software foundry RAM, `R&D/software-foundry/ram-upgrade-spec.md`):** researched the DL380 Gen9
RAM path for the 480B-foundry dream — 24 DIMM slots, DDR4-2400 max, RDIMM≠LRDIMM (don't mix), fill in
multiples of 8 for bandwidth. **Corrected an earlier price underestimate** (it is ~£80–120/module used,
not £12–25 — that was old/smaller-DIMM pricing; 512GB ≈ £1,000–1,450). **Minda bought a kit:** 4× HPE
**840758-091** (32GB 2Rx4 PC4-2666V, down-clocks to 2400) → the box goes to **256GB**. Logged ACQUIRED.

**RND-20 (estate compute split, `R&D/estate-compute-split/design.md` + `gen10-r710-replacement.md`):**
Minda's idea — **move the PBX off the DL380 onto the R710 and leave the DL380 purely as the brain**;
move the 10G NIC to the R710 to free DL380 GPU slots. Then: **replace the R710 as the storage spine with
a modern Gen10.** Scoped the full Gen10 BOM from Techbuyer (24×SFF chassis, 2× 6226, E208i-a HBA in
IT/HBA mode not RAID, 2× **865408-B21** 500W Flex-Slot PSUs — **buy the Gen10 PSUs, don't gamble the old
Gen9 ones**, 2666 RAM). Compared **Gen10-as-brain vs Gen9**: Cascade Lake gives ~1.8× CPU inference
(6 memory channels, DDR4-2933, AVX-512) but the **GPU side is a wash** (both PCIe Gen3). **DECISION
(Minda): Gen10 = storage spine, Gen9 = brain** (Gen10-as-brain parked). RND-19/20 logged in the
ideas-log.

---

## Housekeeping / state at sign-off (2026-10-28)

- **Composio CLI sign-in is DOWN** (dropped by an OS-v180 container re-provision; `composio whoami`
  returns empty). The Composio **MCP** route (the `ck_` consumer key) still works. **Drive sync is
  therefore blocked** — git is the source of truth; the control-file + R&D/Runbook mirror to Drive, and
  the two pending Anna/Victoria Raw notes, catch up next session when the CLI re-auths.
- **Git:** all 26–28 Oct work is on `claude/lucid-mayer-nsoili`, pushed (branch == origin). A PR to
  `main` is raised at wrap-up (Eugene never merges — Minda merges).
- **No Hub task of Eugene's left mid-flight**; AWT-1032 (HMRC build) blocked on Minda's app registration;
  AWT-1035/1036 awaiting Anna's inputs + Victoria's privacy ruling.
- **Open non-R&D standing task:** OI-20 (Beverley UniFi Cloud Key login still not held).
