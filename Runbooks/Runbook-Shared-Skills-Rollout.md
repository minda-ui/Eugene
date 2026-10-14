# Runbook — Shared Skills Library distribution (AWT-0635)

> **Guide-only / §3.** Eugene authors/zips the skills and verifies; **Minda performs the claude.ai upload**
> (account/console action). No secret is ever in a skill or held by Eugene. For Minda, with Alex (curator,
> AWT-0687) and Victoria (estate fit, AWT-0626).
>
> **Status (2026-10-14): PROVEN & LIVE.** `drive-sync-verified` and `raw-handoff-to-employee` were uploaded
> to **Settings → Skills** and verified syncing into a fresh **Alex** session's `~/.claude/skills/synced/`.
> Because every AI-employee environment runs under **Minda's one claude.ai account**, a skill uploaded here
> reaches **every** employee automatically — no per-env wiring, no repo clone, no token.

---

## 0. The mechanism (why this is the right channel)

Claude Code downloads the account's enabled skills into `~/.claude/skills/synced/` at **session start**
(it only downloads — edits there aren't saved back). That synced set includes **"skills your organization
provides" and the ones you create in Settings → Skills**, alongside Anthropic's built-ins. Every employee
environment (Anna, Alex, Peter, Rachel, John, Victoria, Nadia, Darius, Helen, Sarah, Eugene) runs under
**minda@'s account**, so **one upload = all employees** at their next session start. Routines are fresh
sessions under the same account, so they get the skills too.

**Retired (anti-pattern).** The earlier plan — a private repo (`minda-ui/Fishbone-Skills`) cloned by each
env's setup-script snippet — does **not** work and is unsupported: setup scripts run as root *before*
Claude Code, with **no git credentials** for a private repo (clone fails `could not read Username … terminal
prompts disabled`), user-level skills written there aren't carried over, and anything in a setup script is
readable by everyone who uses that env. **Do not use it.** Any env that had the snippet/`add_repo` added
during testing (Eugene's, Alex's) should have the snippet **removed** for tidiness (harmless but dead).

**Repo keeps its job.** `minda-ui/Fishbone-Skills` remains the **source of truth**: authoring, git history,
Alex's curation/index. The claude.ai upload is only the **distribution** step. Author/curate in the repo →
upload the approved version to claude.ai → it syncs everywhere.

---

## 1. Add or update a shared skill (the whole flow)

1. **Author/curate** the skill in `minda-ui/Fishbone-Skills` as `<skill-name>/SKILL.md` (+ `scripts/` etc.).
   Estate-general only (useful to ≥2 employees, no role/connector assumptions, fails safe) — README rules.
2. **Zip it** so the archive root is the skill folder: `zip -r <name>.zip <name>` (the zip must unzip to
   `<name>/SKILL.md`, not a bare `SKILL.md`). Eugene produces the zip and hands it to Minda.
3. **Upload (Minda):** claude.ai → **Settings → Customize → Skills → `+ Add` → Upload a skill** → pick the
   zip. A **security scan** runs on each upload. It lands under **"Created by you."**
4. **To update an existing shared skill:** re-upload the **same skill name** — users move to the new version
   at next sync (no per-env change).
5. **Verify (see §3).**

**Hard gotcha — SKILL.md frontmatter.** The YAML `description:` must be plain text: **no XML/angle-bracket
tags**. `<employee>`, `<name>`, `<X>` etc. in the description are rejected ("SKILL.md description cannot
contain XML tags"). Write `an employee` / `[name]` instead. (Caught on `raw-handoff-to-employee`, fixed
2026-10-14.) The `.md` must carry a YAML `name` + `description`; the zip must include `SKILL.md`.

---

## 2. Policy / prerequisites (one-time)

- The account must be **Team/Enterprise with an Owner** (Minda). To push a skill to *all* members where
  employees are separate users, an Owner **provisions it organization-wide** (Org settings → Plugins &
  skills). **In this estate every employee env is the same account (minda@),** so a plain "Created by you"
  upload already reaches them all — org-wide provisioning isn't required here.
- Ensure **Skills** and **Code execution & file creation** are enabled (Org settings → Plugins & skills →
  Policy) — they are (the Anthropic set and `my-writing-style` already sync).

---

## 3. Verify (per skill, after upload)

Start a **fresh** (not resumed) employee session — Alex is the reference — and either:
- ask it *"do you have the `<skill>` skill?"*, or
- run `ls -1 ~/.claude/skills/synced/*/` — the skill folder should appear alongside the Anthropic set.

Sync happens at **session start**, so an already-open session won't show a new skill until restarted.
**Verified 2026-10-14:** both seeds appeared in a fresh Alex session. ✓

---

## 4. Current state & remaining

- **Live now:** `drive-sync-verified`, `raw-handoff-to-employee` — uploaded, syncing to all employees.
- **Alex (AWT-0687):** genericize the two seeds (strip Eugene-specific ids/§-refs/author) + keep the repo
  `INDEX.md`. When done, Eugene zips the genericized versions and Minda **re-uploads** (same names) → the
  cleaner versions replace them everywhere. No env work.
- **Victoria estate-fit gate** before a new skill reaches Alex (AWT-0626) — curation flow unchanged:
  propose → Victoria estate-fit → Minda approves → Eugene adds to repo + zips → Minda uploads → Alex indexes.
- **Cleanup (Minda, optional):** remove the dead setup-script snippet from Alex's (and Eugene's) env.

---

## 5. Rollback (per skill)

In **Settings → Skills**, toggle the skill off or delete it; it stops syncing to sessions at next start.
The repo copy is unaffected (source of truth).

---

_Eugene, 2026-10-14. Guide-only (§3): Minda performs the claude.ai upload; Eugene authors/zips and verifies.
Native org-skills channel proven; private-repo-clone approach retired._
