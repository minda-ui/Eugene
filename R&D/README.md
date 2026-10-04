# R&D — Eugene's creative pool

> **Created 2026-10-04 (Minda's idea).** A space to do creative, speculative, half-formed things —
> and let the good ones become real. Scope: **Eugene's, to start** (can widen to an estate-wide R&D
> world later, via Victoria/Alex). Git is the primary home for R&D (experimental notes/code); a Drive
> `R&D/` mirror holds the same for the KB record.

## How it works

- **Trigger it:** say **"Creative mode"** (or "R&D mode"). A `UserPromptSubmit` hook
  (`.claude/hooks/creative-mode.sh`) injects the R&D posture so it fires reliably, every session.
- **End it:** say **"Normal mode"** (or "exit creative" / "back to normal") to return to the standard
  working posture.
- In Creative mode Eugene explores boldly, prototypes quickly, and keeps the churn here in `R&D/`
  rather than in the main control files — until an idea **graduates**.

## The one hard line — safety is UNCHANGED in Creative mode

Creative mode loosens **scope and formality**, never **safety**. Charter §3 applies in full:
- **No live-system changes** — guide-and-verify only; a human executes anything real.
- **Never hold, type or request secrets.**
- **Archive-never-trash.**
- **Cross-KB only via `Raw/`** (the one named scaffolding exception aside).
- Anything irreversible or production-affecting is **flagged for a human, never done unilaterally.**

Creative ≠ reckless. The freedom is to *think and prototype*, not to bypass the boundary.

## The flow

```
spark  →  exploring  →  prototyped  →  graduated  (becomes a real project/runbook/Hub task)
                                    ↘  parked      (good, not now)
                                    ↘  dropped     (tried, didn't fly — kept as a record, not deleted)
```

- Every spark gets a one-line row in **`ideas-log.md`** (id `RND-<n>`, date, idea, status).
- Anything substantial gets its own folder **`R&D/<slug>/`** for notes, sketches, prototype code.
- When an idea is ready to become real, Eugene **proposes graduation to Minda**; on her approval it's
  recorded in **`graduation-register.md`** and turned into the real thing (a `Runbooks/` runbook, a
  `Hardware-Projects/` project, a Hub task, or handed to another employee via their `Raw/`).

## Folder map
```
R&D/
├── README.md               <- this file (how the pool works + the safety line)
├── ideas-log.md            <- one RND-<n> row per spark, with status
├── graduation-register.md  <- ideas that became real, and what they became
└── <slug>/                 <- a working folder per substantial experiment
```
