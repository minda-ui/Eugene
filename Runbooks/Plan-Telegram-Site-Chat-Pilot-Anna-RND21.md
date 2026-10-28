# Plan — Telegram site-chat pilot: project groups → Anna (RND-21, Telegram-first)

> **Eugene, 2026-10-28 (guide-only, §3).** The easy, clean half of the site-chat bridge (RND-21): bring
> **Telegram project-group updates (photos + requests)** to **Anna**, and use it to run the first AI-machine
> tests. WhatsApp is decided separately later (ToS/ban caveats — see `R&D/site-chat-bridge/design.md`).
> **Minda holds the Telegram login/token; Eugene builds + verifies; privacy/consent is Minda + Victoria's
> call; it's Anna's domain — scoped with her.** Read-only (we *read* the groups, never post).

## Goal (pilot)
One project's Telegram group → an automatic feed Anna can see (messages + photos + flagged requests) +
the photos mirrored to storage. Prove the pipeline on **one** project before expanding, and run the
in-house-brain tests on it (vision + summarisation).

## How it works
- **Ingest options:**
  - **User-client (Telethon)** logged in as a **dedicated Fishbone Telegram account** that's already in the
    project groups → reads full history + all messages + media. Most complete; the login is Minda's.
  - **Bot** added to each group (as admin, privacy-mode off) → sees messages + media **from when it's
    added** onward (bots can't read old history or join by themselves). Simpler creds (a bot token), less
    history.
  - **Pilot recommendation:** a **dedicated user-client account** (full visibility incl. existing photos);
    fall back to a bot if a user account isn't wanted. Either way **Minda provides/holds the login/token**;
    Eugene references it from the secret store, never holds it.
- **The job:** a scheduled script in a **capped LXC** reads the pilot group → for each new message:
  download media, record `{project, time, sender, text, media files, is-request?}` → **mirror photos to
  storage (RND-3 / Drive)** per project → write Anna's feed in the shape she wants.
- **Anna consumes** the feed; the **brain** then runs the tests below.

## The AI-machine tests this unlocks (Minda's "couple of tests")
1. **Photo vision** (RND-16) — tag progress, flag H&S (no hard hat, blocked exit…), read delivery notes.
2. **Update summarisation** — "what happened on FC2611 today" from the message stream.
3. **Request extraction** — turn "need 20 more boards Thursday" into a structured action for Anna.
All drafts for a human; feeds the per-project record (RND-7).

## Boundaries (§3)
- **Read-only** — the bridge reads the groups; it never posts, replies or deletes.
- **Creds = Minda's** — the Telegram user login or bot token lives in the secret store; Eugene references
  it, never holds the value.
- **Privacy/consent = Minda + Victoria** — these are staff + subcontractor chats (personal data +
  photos). A lawful basis + a notice to the people in the chats is needed **before go-live**. Not Eugene's
  call (flagged to Victoria).
- **Anna's domain** — scoped with Anna via her Raw; she says what she needs, Eugene builds to it.

## Phasing
- **P0 — scope (now):** Anna's inputs (below) + Minda/Victoria settle the privacy notice. Pick ONE pilot
  project group.
- **P1 — ingest:** stand up the reader (user-client/bot) on the one group → mirror messages + photos to
  storage → Anna's feed. Prove it.
- **P2 — AI test:** run the pilot's photos through vision + summarise the day's updates + extract requests.
- **P3 — expand:** more project groups, into the project record (RND-7). WhatsApp decided separately (RND-21).

## Open questions for Anna (drive the pilot)
1. **Which Telegram group** for the pilot — one project (e.g. FC2611)? Name it.
2. **What to capture** per message — text + photos + sender + time? Flag "requests" vs chit-chat? Ignore
   anything?
3. **Output format + location** — a Smartsheet, a folder of photos + an `.md` digest, JSON? Where in your
   space should it land?
4. **How you'll consume it** — a daily digest, on-demand, or near-live?
5. **Retention + filtering** — keep everything, or just photos + requests? How long?

## Open items for Minda (the credentialed/outward steps)
- Provide the Telegram access: a **dedicated Fishbone Telegram account login** (or a **bot token** + add it
  to the pilot group as admin) → into the secret store.
- With **Victoria**: agree the **privacy notice / lawful basis** for AI-reading the site chats, and tell
  the people in the group — **before** P1 goes live.

---
_Guide-only; read-only; Minda holds the Telegram creds; privacy = Minda + Victoria; Anna's domain.
Telegram-first (clean); WhatsApp separate (RND-21 ToS/ban caveats). Pairs with RND-16 (vision), RND-7
(project record), RND-2/14 (brain), RND-3 (storage)._
