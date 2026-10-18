---
name: shared-skill-package-for-upload
description: Package a curated skill from the minda-ui/Fishbone-Skills repo for distribution via the native claude.ai Skills upload channel. Use whenever a shared skill is ready to roll out or update across the AI workforce, after Alex genericises a skill in the library, or when Minda says "package the <skill> for upload", "zip the skill", "get <skill> ready to upload", or "update the shared skill". Validates the SKILL.md (the YAML description must be plain text with NO angle-bracket/XML tags — the upload rejects them), zips it with the correct <name>/ top-level folder, byte-checks the zip, and hands Minda the exact upload path. Guide-only (charter §3): Eugene builds + validates the zip; Minda uploads under her one claude.ai account (which syncs it to every seat). Built 2026-10-18 from the shared-skills curation loop (hit the XML-tags-in-description rejection on raw-handoff).
---

# Package a shared skill for upload

Shared skills distribute through the **native claude.ai Skills channel**: a skill uploaded under Minda's
one account syncs to **every** AI-employee session (via `~/.claude/skills/synced/`) at session start — no
per-env wiring, no clone, no token. The repo-clone/setup-script route was tried and **failed** (a fresh
session has no git creds at setup time) — do not revive it. This skill prepares a library skill for that
upload the safe way. **Source of truth = `minda-ui/Fishbone-Skills`; curation loop = Propose → Victoria
estate-fit → Alex genericise/index → Eugene package → Minda upload.**

**Guide-only (§3):** Eugene validates + builds the zip in the repo; **Minda does the upload** (holds the
account). Eugene never uploads, never holds a credential.

## Before you start
- The skill must be **genericised + estate-fit-checked** already (Alex + Victoria). This skill packages;
  it does not re-write the skill's content.
- Have the library repo checked out (`add_repo` + clone `minda-ui/Fishbone-Skills` if not present).
- Know the skill's folder: `.claude/skills/<name>/` (contains `SKILL.md`, maybe `scripts/`).

## Step 1 — validate the SKILL.md (the upload is picky)
1. **Frontmatter present:** a `---` YAML block with `name:` and `description:`.
2. **`name` matches the folder** exactly (`<name>` == the directory name).
3. ⚠️ **`description` is PLAIN TEXT — no angle-bracket/XML tags.** `<employee>`, `<site>`, `<X>` etc. are
   **rejected on upload** (hit 2026-10-14 on `raw-handoff`'s `<employee>`). Replace with plain words
   ("an employee", "a site"). Grep to be sure:
   ```
   grep -nE '<[^>]+>' .claude/skills/<name>/SKILL.md   # any hit in the description line = fix it
   ```
4. **No secret** anywhere in the skill (reference where a secret lives, never its value — §3).
5. **Scripts** (if any) are referenced by a path relative to the skill folder and are present under
   `scripts/`.

## Step 2 — build the zip with the correct top-level folder
The zip must contain the skill **as a folder** (`<name>/SKILL.md`), not loose files at the root:
```
cd .claude/skills            # so the folder is the top level inside the zip
zip -r /tmp/<name>.zip <name> -x '*.DS_Store' '*/.git/*'
unzip -l /tmp/<name>.zip     # CONFIRM entries read "<name>/SKILL.md", "<name>/scripts/..." — not bare files
```

## Step 3 — byte-check the zip
```
ls -l /tmp/<name>.zip                 # non-zero size
unzip -t /tmp/<name>.zip              # "No errors detected in compressed data"
unzip -p /tmp/<name>.zip <name>/SKILL.md | head -5   # frontmatter intact, name correct
```
If anything is off, fix and re-zip — don't hand over a broken package.

## Step 4 — hand it to Minda (she uploads)
Give her the exact path:
> **claude.ai → Settings → Customize → Skills → `+ Add` → Upload a skill** → choose `/tmp/<name>.zip`.
> If a skill with the same name already exists, **the upload replaces it** (that's how a v2 rolls out) —
> same name = in-place update everywhere at the next session sync.

Tell her: the zip name doesn't matter, the **top-level folder name inside it** is the skill name; and the
new version reaches each seat on that seat's **next session start**.

## Step 5 — record + verify
- Note the upload in the library `INDEX.md` row ("Last reviewed" date) if this is a new/updated entry —
  that's **Alex's** curation file, so cross-KB: hand the INDEX change via Alex's `Raw/` if it's his to make,
  or just report the package is ready on the Hub row.
- Verify (optional): in a fresh session of any seat, the skill appears in the synced set.
- Close the Hub row (`hub-close-on-finish`) naming the zip + the upload path given to Minda.

## Gotchas
- **XML/angle-bracket tags in `description`** → rejected. The single most common failure.
- **Zipping from inside the skill folder** (so entries are bare `SKILL.md`) → the skill won't register;
  always zip from `.claude/skills` so the top level is `<name>/`.
- Same family as `drive-sync-verified`: validate, then hand over — don't skip the checks because it "looks
  fine".

## §3 / safety
Guide-only: Eugene validates + zips; **Minda uploads** (holds the account). No secret in the skill or the
zip. The library repo stays the source of truth; content changes go through the curation loop, not here.
