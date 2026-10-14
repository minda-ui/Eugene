# Runbook — Shared Skills Library rollout (AWT-0635)

> **Guide-only / §3.** Eugene writes these steps and verifies each env afterwards; **Minda performs every
> environment edit** (setup-script / secret config is platform config Eugene cannot do, §3). No secret is
> ever held by Eugene. For Minda, with Alex (curator, AWT-0636) and Victoria (estate fit, AWT-0626).
>
> **Status (2026-10-14):** distribution **PROVEN** on Eugene's env — a fresh **private** session loads the
> shared skills via the env's GitHub integration, **no token** (= option A). This runbook rolls the same
> mechanism to every other AI-employee environment, **one at a time, verifying each**. The rollout is
> gated on **Minda's go** (pilot condition #4: no other env/hook/charter changed until she says go).

---

## 0. What this does (and the one decision that unblocks it)

The shared skills library lives in the **private** repo `minda-ui/Fishbone-Skills`. A session only loads
skills that are present in `$HOME/.claude/skills/` **before the agent starts**. So each employee's
**session environment setup script** clones the shared repo and stages its skills at start. Proven on
Eugene's env with the repo private and **no credential** — the env's own GitHub integration served the
clone (option A).

**Decision owed by Minda:** say **go** on the rollout (the pilot report is in; AWT-0635). Everything below
waits on that. Nothing here changes any employee's KB, charter, or their own `.claude/skills/` — it only
adds a clone+stage line to each env's setup script, and the shared skills land in a staging dir, not the
repo.

---

## 1. Phase 1 — before any env is touched (on Minda's go)

Do these **once**, before rolling any environment:

1. **Alex genericizes the two seeds** (AWT-0636): strip Eugene-specific folder ids, `§`-refs and author
   name from `raw-handoff-to-employee` and `drive-sync-verified` so they read as estate-general. Until
   this is done the seeds carry Eugene's KB ids — don't roll them to other employees first.
2. **Alex builds `INDEX.md`** at the repo root (his curation surface, his AWT-0636 ask): one row per skill
   — *skill · purpose · which employees use it · last-reviewed date*. This is the list Minda/Victoria/Alex
   review monthly, not the raw repo tree.
3. **Estate-fit gate (Victoria → Alex order, Alex's AWT-0636 ask):** a new shared skill is checked for
   estate-generality by **Victoria before it reaches Alex**; Alex judges tidiness, not whether it belongs.
   (Approval of the *starter set* is Minda's; this gate is for additions after go-live.)

Eugene does the repo mechanics (commits Alex's genericized text + index via the normal reviewed-merge
flow); Alex owns the content/curation decisions.

---

## 2. The snippet (canonical — paste into each env's setup script)

Append exactly this to the **end** of the employee's environment **setup script** (session title-bar →
environment → **Edit** → Setup script). It is idempotent and **fails safe** — if the clone can't reach the
repo it prints a line and the session still starts normally (no hard error, charter §3 "fail safe"):

```bash
# --- Fishbone shared skills library (AWT-0635) ---
if git clone --depth 1 https://github.com/minda-ui/fishbone-skills /tmp/fsk 2>/dev/null; then
  mkdir -p "$HOME/.claude/skills"
  cp -r /tmp/fsk/.claude/skills/* "$HOME/.claude/skills/" 2>/dev/null || true
  rm -rf /tmp/fsk
  echo "shared skills staged"
else
  echo "shared skills NOT staged (repo unreachable from this env) — see Runbook-Shared-Skills-Rollout.md"
fi
# --- end shared skills ---
```

Notes:
- Staged into `$HOME/.claude/skills/` alongside the employee's **own** skills — their local skills are
  untouched (different source; copy only adds).
- A shared skill that names a connector an employee lacks simply won't work for them — it grants nothing
  (a skill is **instructions, not permissions**, §3). That's why only estate-general, fail-safe skills go
  in the library (README rules).

---

## 3. Per-environment procedure (one employee at a time)

For each employee in the order in §4:

1. **Edit** that employee's env setup script; append the §2 snippet; save.
2. **Start a fresh session** for that employee.
3. **Verify the clone ran:** the setup log shows `shared skills staged` (not the "NOT staged" line).
4. **Verify the skills loaded:** in that session, confirm the shared skills appear in the available-skills
   list (e.g. `raw-handoff-to-employee`, `drive-sync-verified`). Eugene can verify from the employee's
   session output; Minda confirms the setup-log line.
5. **If step 3 shows "NOT staged"** (the env's GitHub integration can't reach the private repo) → use the
   **token fallback in §5** for that env only; re-run steps 2–4.
6. Record the env as done (ledger + the AWT-0635 row); move to the next employee. **Never roll two at once**
   — a bad snippet should surface on one env, not ten.

---

## 4. Rollout order

Eugene's env is already wired + verified. Roll the rest one at a time. Suggested order (library owners
first so they can see/curate what everyone gets, then daily-driver seats, then newest seat last):

| # | Employee | Env reached? | Staged? | Skills load? | Notes |
|---|----------|-------------|---------|--------------|-------|
| ✓ | Eugene   | yes | yes | yes | reference env — done 2026-10-13 |
| 1 | Alex (curator) | | | | roll first — he curates the set |
| 2 | Victoria (coordinator) | | | | estate-fit owner |
| 3 | Peter | | | | daily driver (inbox) |
| 4 | Anna | | | | daily driver |
| 5 | Rachel | | | | finance |
| 6 | John | | | | |
| 7 | Nadia | | | | |
| 8 | Darius | | | | |
| 9 | Helen | | | | |
| 10 | Sarah | | | | newest seat — roll last, after her go-live |

Fill the row's tick-boxes as each is verified. If an env is paused/not live yet, skip and come back.

---

## 5. Fallback — only if an env can't reach the private repo (§3, Minda sets the secret)

If §3 step 3 shows **"NOT staged"**, that env's GitHub integration doesn't serve the private
`minda-ui/Fishbone-Skills` clone. Two options, in order of preference:

- **5a — attach the repo as a source to that env** (if the platform allows a second source/repo on the
  env): preferred, keeps it credential-free. Then re-run §3 steps 2–4.
- **5b — read-only token as an env secret** (last resort): Minda creates a **read-only, repo-scoped**
  deploy token / fine-grained PAT for `minda-ui/Fishbone-Skills`, stores it as an **environment secret**
  (e.g. `FSK_RO_TOKEN`), and the clone line becomes:

  ```bash
  git clone --depth 1 "https://x-access-token:${FSK_RO_TOKEN}@github.com/minda-ui/fishbone-skills" /tmp/fsk 2>/dev/null
  ```

  **Eugene never sees or handles the token** (§3) — Minda sets it in the env secret store; the script
  references it by name only. Scope it read-only and to this one repo. Revoke on offboarding.

---

## 6. Verification & close

- After the last env, **AWT-0635 → Done** with the per-env results; ledger row; dated change-log entry.
- Hand the running library to **Alex** (AWT-0636) for ongoing curation (index, staleness, retirement rule:
  his proposed rule = unused 90 days or owner retired → Raw/ broadcast before removal, per Rule F).
- Future shared-skill additions follow the curation flow: propose (Hub) → **Victoria** estate-fit →
  **Minda** approves → **Eugene** adds to the repo → **Alex** indexes. Rolling a *new* skill needs no env
  change — every env re-clones the latest at next session start.

---

## 7. Rollback (per env)

Remove the §2 snippet block from that env's setup script and start a fresh session — the staged shared
skills simply aren't copied in; the employee's own skills are unaffected. No other state to undo.

---

_Eugene, 2026-10-14. Guide-only (§3): Minda performs every environment edit; Eugene verifies. The library
repo is private; option A (env GitHub integration, no token) is proven on Eugene's env._
