# RND-17 — Estate Voice (design sketch v1)

_R&D design (git-primary; creative mode, 2026-10-25). Status: **spark → exploring**. Guide-only (§3):
voice is for **asking and drafting**, never executing. Audio is processed **locally** (never cloud).
Nothing is sent, paid or signed by voice — anything that writes to the world goes through the Approvals
Desk, not a spoken command._

## The one-sentence idea
Talk to the estate brain hands-free from the van — **speak a question, hear an answer** — with the whole
voice pipeline running on our own hardware so your words never leave the building's control.

## The pipeline (all local)
```
  🎙 speak  ──▶  Whisper (speech→text, local)  ──▶  Gateway `estate-brain` (RND-14) + RAG over the KB
                                                               │
  🔊 hear  ◀──  Piper TTS (text→speech, local)  ◀────────────┘  short spoken answer
```
- **STT:** `whisper.cpp` / faster-whisper — small model on CPU, large on a P40 for accuracy.
- **Brain:** the gateway's `estate-brain` alias, grounded on the KB (RAG) so answers cite real facts.
- **TTS:** Piper (local, fast, natural). No cloud speech service — that's the point.
- **Front-end:** the phone. Start with Open WebUI's built-in voice over Tailscale (the RND-2 server);
  grow to a push-to-talk / wake-word PWA.

## What you'd actually say
- "What's FC2611's **deposit status**?" → reads the Amfa/project record.
- "What does the **method statement** say about the Bullring hoarding fire rating?" → RAG cites the RAMS.
- "**Draft a note to Anna** about moving the FC2611 inspection to Thursday." → leaves a draft for sign-off.
- "What's **waiting for my approval**?" → reads the Approvals Desk queue.
All **read** or **draft**. None of them *do* anything irreversible by voice.

## The hard line (why voice needs extra care)
- **Voice never executes.** A misheard word must never send money, an email, or a signature. Queries and
  drafts only; anything that writes to the world (send, pay, sign, change a live system) is **refused by
  voice and routed to the Approvals Desk** (RND-9) for a deliberate tap, not a spoken yes.
- **Audio stays in-building.** STT and TTS are local; the brain is local; a voice query uses the sovereign
  lane (RND-18) by default — a van conversation is ambient/personal and never goes to a cloud API.
- **Driving-safe by design.** Answers are **short and spoken**; it won't read a long document aloud while
  you drive — "I've drafted that, review it when you stop." No screen-reading required.

## Phasing
- **P0 (today, CPU):** text chat on the phone (already in the RND-2 server runbook) — the baseline.
- **P1:** add **local STT** → talk, read the answer on screen.
- **P2:** add **local TTS** → fully spoken answer.
- **P3:** **push-to-talk / wake-word** hands-free in the van.
- **P4:** safe **query intents** wired (Hub, registers, Approvals read via RAG); drafts to the right queue.
- GPU (P40) sharpens STT accuracy + TTS latency, but a basic version runs CPU-only.

## Honest edges
- **Noisy cab = STT errors.** Expect mishears; keep it to short, confirmable queries and always show/return
  what it *heard* for important asks.
- **It's a convenience layer, not a new power.** It can only reach what the brain + its keys already allow
  — voice doesn't widen access, it just changes the input method.

## Graduation
Rides on the gateway (RND-14) + the phone server (RND-2 runbook). First real step: P1 local STT on the
existing phone chat. Nothing that writes goes live by voice — that stays the Approvals Desk's job.

---
_Guide-only; local audio; ask/draft only, never execute; driving-safe; sovereign-lane by default. Pairs
with RND-2 (brain), RND-14 (gateway), RND-18 (sovereign lane), RND-9 (approvals for anything that writes)._
