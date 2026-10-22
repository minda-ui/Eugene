# Project A — Identity Gap Note + Wall Map (AWT-0961)

> **Eugene, 2026-10-22, draft v1 (guide-only).** Two of my three Project-A deliverables for the Operating
> System Framework **v0.2** (the exchange-sheet template is separate, pending Victoria/Peter on columns —
> AWT-0974). **Guide-only (§3): Eugene maps and verifies; Minda provisions accounts/sharing/2FA; nothing
> built on a live system here. ISO freeze respected — no live change to ISO roles or records before 8 Nov.**
> These feed Victoria's Friday **access-fence** checks and the **Monday go/no-go** checklist for connecting
> Andrejus (Project B). Target model is v0.2: master core crosses all; **secondary cores on own logins**;
> **a folder per business, shared only with its people**; **per-business ops@ opened only by Minda's login**.

---

# Part 1 — Identity Gap Note: one shared identity → per-person logins

## 1a. Where we are today (the single-identity model)
Everything in the AI workforce runs **as `minda@fishboneconstruction.co.uk`**:
| Layer | Today |
|---|---|
| Google Workspace | Assistants read/write Drive & Gmail as minda@ (or seat connectors OAuth'd to minda@, e.g. `eugene-gmail`). |
| Composio | One `ck_` consumer key per environment; connected accounts (Drive ×~14, Gmail, GitHub, Smartsheet) are **all Minda's**. Unattended routines use the Composio **MCP** route. |
| GitHub | One org `minda-ui`; Composio GitHub uses **Minda's OAuth**, reaching every repo incl. private. |
| Smartsheet | Account-wide connector; the one **AI Workforce Hub** + registers. |
| Secrets | In **1Password** (Minda holds). |

**Strength:** simple, and the master core's cross-estate reach (seat-settings rollouts, Raw hand-offs,
Drive-sync, the single Hub) depends on it. **Weakness:** it is **SPOF-1** in the Build Register — loss or
compromise of Minda's accounts is estate-wide, and there is no per-person accountability or wall.

## 1b. Where v0.2 wants to go
- **Master core** (Minda + key team incl. **Eugene**) keeps cross-business reach — unchanged identity.
- **Secondary cores** (Andrejus w/ Helen·Nadia; Irina w/ John; future people) run on **that person's own
  logins**, with their assistant **on the same logins**, seeing **only what the work needs**.
- Each **business = a folder** shared only with its people; each business its **own ops@** (Minda login only).

## 1c. The gap — what changes, and what each step needs (guide-only; Minda executes)
| # | Gap | What it requires | Risk / watch |
|---|---|---|---|
| G1 | Secondary people need **their own Google logins + 2-step sign-in** | Provision per-person Workspace accounts; enforce 2FA (checklist B6) | Licence/seat cost (Rachel/Minda); don't reuse a shared mailbox login (OI-5) |
| G2 | A secondary **assistant runs on that person's login**, not minda@ | A **new, scoped** connector set for that assistant (its own Composio connected accounts), **not** Minda's | **Composio 10-account/app cap** (AWT-0778) — plan the account budget; a new `ck_`/connection set per core |
| G3 | Secondary core **sees only its business folder** | Drive/Smartsheet **sharing scoped** to the business folder + that person's exchange sheet; **no** group root/Raw/Outputs/Wiki/Hub access | This is the **wall** — Part 2; verified read-only (Monday checklist A) |
| G4 | Master core keeps cross-reach | **Keep the current minda@ identity + connectors for the master core** (Eugene incl.), untouched | So the AI-workforce automation does **not** break — the migration is *additive*, not a rip-and-replace |
| G5 | Settings/permissions per core | Each core's `.claude/settings.json` scoped; applied by Minda | The cloud **weaken-guard** keeps settings-widening a **Minda-by-hand** step (Eugene cannot push it) |
| G6 | Recovery | **Break-glass accounts + credentials model** (1Password), so a business can't be locked out | New in v0.2's delivery list; this is SPOF-1's mitigation — must exist before go-live |

## 1d. How to move without losing the automation (recommended shape)
**Additive, phased — the master core's identity never moves:**
1. **Keep minda@ + its connectors for the master core** (Minda + key team incl. Eugene) exactly as today —
   the AI workforce keeps running.
2. **Add** each secondary core as a **separate, new identity** with a **scoped, read-mostly** footprint
   (own login + 2FA; access only to its business folder + its own exchange sheet; no Hub, no group Drive,
   no GitHub, no connector into the master core).
3. Connect the secondary **assistant last**, on that person's login, with its **own narrow connector set**
   — only after the fence is verified (Monday checklist A, D).
4. **Break-glass first:** recovery accounts + 1Password entries before any secondary core goes live.
- **Eugene's part = guide-only:** the per-core setup runbook, the fence-verification method (Part 2), and
  verifying each step. **Minda's part:** provision accounts, set 2FA, make the Composio connections, apply
  settings, hold all secrets.

---

# Part 2 — Wall Map: the folder-per-business fence, per layer

v0.2: **"a folder per business inside the master place, shared only with that business's people"** (folder
ownership parked) + **per-business ops@ opened only by Minda's login**. Only Minda's master core crosses
all. Below: for each layer, **what the wall is** and **how it's verified read-only / absent** (the
verification maps to the Monday go/no-go **access-fence** items A1–A5).

| Layer | The wall (secondary core sees…) | Verify (how Eugene/Victoria check) | Monday checklist |
|---|---|---|---|
| **Google Drive** | **Only its business folder**; **no** access to the group Drive root, `Raw/`, `Outputs/`, `Wiki/`, `Archive/`, KB folders, or any assistant's home | Check each of those folders' **sharing list** does not include the secondary person; check the business folder **is** shared to them (and at the right level) | **A1** |
| **Smartsheet** | **Not** the Hub or its workspace; **only** its own **exchange sheet** (shared with that person + Minda only) | List shares on the Hub workspace + sheets — secondary person absent; exchange sheet shared to person+Minda only. **"1. General" (edit-and-share) workspace needs a decision** (flag) | **A2** |
| **GitHub** | **Not a collaborator** on any `minda-ui` repo | `list_repository_collaborators` per repo — secondary person absent | **A3** |
| **Composio / connectors** | **No** connector or **mail delegation** from the secondary person's account **into** the master core | Confirm no connected account / delegation bridges the secondary identity to minda@'s Drive/Gmail/Hub | **A4** |
| **Email / ops@** | Each business's **own ops@**, **opened only by Minda's login**, **no delegation**; a **charter rule** governs what assistants may copy out; **staff told in writing** | Confirm ops@ has no delegate; confirm the copy-in routing is admin-level and the staff notice exists | **A5** |
| **Claude skills** | Only the skills its assistant needs (loaded per that core); **no** master-core-only skills/tools | Confirm the secondary assistant's skill set is the scoped list, not the master set | _(part of B9 — assistant connected last)_ |

**The one crossing:** only **Minda's master core** (incl. Eugene for IT/enablement) crosses the walls.
Everyone else reaches **only** the business spaces they work in.

### Fence verification = read-only, and it's the go/no-go gate
Every check above is **read-only** (list shares / collaborators / delegates — change nothing). A
**master-core exposure** on any A-item is a **No-Go** for connecting that secondary core (Monday checklist
D). Eugene supplies the checks; **Minda/Victoria run them on the live accounts** (guide-only).

### Open decisions to flag (not Eugene's to decide)
- **"1. General" workspace** (edit-and-share) — in or out of a secondary core's reach? (checklist A2).
- **Folder ownership** — parked in v0.2; affects break-glass (who can't be locked out of a business folder).
- **Composio account budget** vs the **10-per-app cap** (AWT-0778) as secondary cores add connections.

---

## Status / what's next (AWT-0961)
- **Delivered here (draft v1, by Sat noon target, early):** the Identity Gap Note (Part 1) + the Wall Map
  (Part 2), both feeding Victoria's Friday access-fence checks and the Monday go/no-go.
- **Still mine:** the **exchange-sheet template** (Fri 14:00) — pending Victoria's steer on whether to
  strawman now vs wait for Peter's columns (AWT-0974).
- **Guide-only throughout; ISO freeze respected.** Project-A questions go to Victoria (curator).
