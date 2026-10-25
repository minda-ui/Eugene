# RND-19 — The Estate Software Foundry (design sketch v1)

_R&D design (git-primary; creative mode, 2026-10-25). Status: **spark → exploring**. A Ring-3 dream —
Rings 1–2 (CPU models, P40s) earn their keep first. Guide-only (§3): the foundry drafts; a human reviews
and deploys; nothing ships itself. That human gate isn't a caveat bolted on — it **is** the design._

## The one-sentence dream
Fishbone stops renting software and starts **growing its own**, overnight, on hardware it already owns —
a private frontier-class coder that writes the estate's tools from the estate's own knowledge, and a
review gate that keeps a human in charge of everything that ships.

## The estate as an organism (where the foundry fits)
The sparks aren't separate projects — they're organs of one private intelligence, all hosted in-building:

| Organ | What | Spark |
|---|---|---|
| **Nervous system** | one private endpoint routing to models + HQ/Beverley nodes, with failover | RND-14 gateway |
| **Memory** | the markdown KB + project record + storage, as RAG | KB · RND-7 · RND-3 |
| **Eyes** | vision over every site photo | RND-16 sentinel |
| **Voice/ears** | talk to it hands-free | RND-17 voice |
| **Hands that build** | the 480B coder that writes the tools | **RND-19 foundry (this)** |
| **Conscience / gate** | every irreversible action + every deploy reviewed | RND-9 Approvals Desk |
| **Immune system** | screams when a signal goes quiet; keeps creds clean | RND-6 · RND-13 |
| **Sovereign lane / failover** | private tier for restricted data; local fallback if cloud dies | RND-18 |

The foundry is the **hands**. The Approvals Desk is the **conscience**. Together they're a
**propose → review → deploy** loop for in-house software.

## The loop (the heart of it)
```
 1. NEED surfaces      a Hub row · a manual task Eugene keeps repeating · a gap the sentinel/alarm finds
                       · or Minda just says "I wish we had X"
        │
 2. SPEC              the estate brain drafts a plain-English spec from the KB + the request
                       (it knows how Fishbone actually works — that's the edge a SaaS vendor never has)
        │
 3. BUILD  ───────▶   the 480B foundry writes the tool + its tests, OVERNIGHT, on the RAM-grown box
        │              (batch; slow is fine — it has all night and nothing else wants the CPU)
        │
 4. PREVIEW          it deploys itself to a THROWAWAY staging LXC (RND-11's "prove on a clone" instinct)
        │              so Minda sees the REAL working thing, not a promise
        │
 5. REVIEW GATE      Approvals Desk (RND-9): a working preview link + a diff + one honest paragraph
        │              ("what it does / what it touches / what could go wrong"). Minda taps Approve.
        │
 6. DEPLOY           a human (or Eugene, guided) promotes staging → live. Never the model, never alone.
        │
 7. OBSERVE          the immune system (RND-6) + usage watch how it behaves in the wild
        │
 8. LEARN  ──────▶   failures + feedback become tomorrow night's backlog item ──┐
        └──────────────────────────────────────────────────────────────────────┘  the flywheel
```
The magic is step 8 closing back to step 1: the foundry doesn't just build tools, it **keeps them current**
— patches the Amfa interface when Nadia's process changes, fixes what the alarm flags, refreshes a register
when a rule moves. The estate's software stays alive without a dev team or a subscription.

## What it could build first (real Fishbone backlog, not toys)
Everything we've already sketched is a candidate the foundry could draft overnight, each as a reviewed PR:
- **Approvals Desk** (RND-9) — fittingly, the first thing it builds is its own conscience.
- **Amfa ops interface** (RND-10) — the NocoDB/Budibase app, from the process map.
- **Project brain** (RND-7) — the per-job search/record over the KB + evidence.
- **Induction/competence register** (AWT-0542) — the gap Victoria found.
- **New AI-employee scaffolding** — charter + control files + hooks, from the house pattern (§2b).
Each one today is "a project Eugene writes by hand over a session"; the foundry makes it "a draft by
morning, reviewed by lunch."

## Why it's *Fishbone's* edge (not just cheaper SaaS)
- **It knows the business.** It reads the KB — the procedures, the job numbers, how Rachel does money, how
  Peter triages. A bought tool never does. In-house software fits the process instead of bending it.
- **It's private.** Code + data never leave the building (ties RND-18). Tenant/finance tools can be built
  and run on the sovereign lane.
- **It's recycled-kit economics.** Same instinct as the NetApp shelf and the R710: the capability is one
  cheap part (a tray of used ECC) away from hardware already owned. A construction firm quietly running a
  private frontier coder on a server in a cupboard — nobody expects that.

## The honest edges (because this one has teeth)
- **A model that writes your tools MUST have a hard human gate.** Code drafted ≠ code shipped. Review +
  deploy are human, every time — that's exactly what the Approvals Desk is for, so the foundry and the
  desk are two halves of one thing, not two projects.
- **Staging is sacred.** The foundry builds and previews on a throwaway LXC; it never has hands on live
  systems or prod data. Promotion to live is a separate, human, reversible step.
- **Scope creep is the risk.** Start it on *internal* tools with low blast radius (a register, a dashboard)
  — not anything touching money, the PBX, or customer-facing systems — and widen only on a proven track
  record.
- **Ring 3, not now.** The RAM upgrade + a 480B are a later step; the loop itself can be *rehearsed today*
  with a 30B coder on the P40s building something small, to prove the propose→review→deploy flow before the
  big brain arrives.

## Graduation path
Candidate far down the line. Sensible first real step once the P40s are in: **rehearse the loop small** —
have the 30B coder draft one genuinely useful internal tool (say the induction register) into a staging
LXC, run it through a manual Approvals review, deploy by hand. If that flow feels good and safe, *then* the
RAM upgrade + 480B make the overnight-foundry version worth it. Everything cross-KB (Amfa/Nadia,
finance/Rachel) still routes through Raw/ + Minda's approval. Nothing live until it's earned.

---
_Guide-only; the human review+deploy gate is the design, not a disclaimer. Pairs with RND-9 (conscience),
RND-14 (nervous system), RND-11 (prove-on-a-clone), RND-2/15 (brain/night-shift), RND-18 (sovereign lane)._
