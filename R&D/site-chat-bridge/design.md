# RND-21 — Site-chat bridge: WhatsApp + Telegram → Anna (feasibility)

_R&D feasibility (git-primary; 2026-10-28, Minda's idea). Status: **spark → exploring**. Guide-only (§3):
Minda links the accounts + holds creds; Eugene builds/verifies; privacy/consent is Minda+Victoria's call,
not Eugene's. It's Anna's domain (construction) — scope the build with Anna via her Raw._

## The ask
Site teams post construction updates — **photos + requests** — in **WhatsApp** and **Telegram** groups.
Bridge those so **Anna** (AI construction assistant) can see them, and the in-house brain can work them
(vision on photos, summarise updates, pull out requests). A new ingest layer + "couple of tests" for the
AI machine.

## The two platforms are night and day

### Telegram — easy, clean ✅
A **bot** (added to each project group) or a **user-client** (Telethon / mautrix-telegram) reads messages
+ downloads media. **No ToS problem, no ban risk.** This is the ingest the project-record (RND-7) and
vision-sentinel (RND-16) ideas already assume.

### WhatsApp — possible, but genuinely caveated ⚠️
**There is no official way to read existing WhatsApp group chats.** The official **WhatsApp Business
(Cloud) API** only covers conversations on *your own business number* — it cannot see the personal/staff
site groups where the photos land. So reading those groups means one of:
1. **Unofficial bridge** — `mautrix-whatsapp` / Baileys / whatsapp-web.js pair a server as a **linked
   device** to a Fishbone WhatsApp number and *can* read existing groups. **But:** against WhatsApp's ToS;
   **real ban risk** on that number (unpredictable — days to months; server IPs flagged harder); **breaks
   E2EE** at the bridge; fragile (breaks on WhatsApp changes). mautrix-whatsapp is the most mature, same
   fundamental risk.
2. **Official WhatsApp Business (Cloud API) number** — compliant + ban-proof, but a **behaviour change**
   (teams message a business flow, not their existing groups).
3. **Move site chat to Telegram** — sidesteps WhatsApp entirely; behaviour change toward the easy platform.

**Steer:** if we go unofficial, use a **dedicated/secondary WhatsApp number — never the main business
line** — so a ban costs a throwaway number, not the lifeline.

## Architecture (the elegant version)
A self-hosted **Matrix homeserver + mautrix-telegram + mautrix-whatsapp** on the estate → both platforms
flow into one place → **Anna + a script read it**, **media mirrored to storage (RND-3)**, photos run
through the **vision sentinel (RND-16)** (tags / H&S flags / delivery-note reads) → **per-project record
(RND-7)**. One unified site-chat inbox for the brain.
- Simpler non-Matrix option: a **Telegram bot now** + a WhatsApp bridge later, each writing to a store Anna
  reads. Matrix is the clean "one framework, both platforms."
- Composio has Telegram/WhatsApp toolkits, but they're oriented to **sending / Business API**, not reading
  existing group chats — so the bridge is a **custom self-hosted** build.

## The AI tests it unlocks (Minda's "couple of tests")
- **Vision on site photos** (RND-16) — progress tags, H&S hazards, delivery-note/sign-in reads.
- **Update summarisation** — "what happened on FC2611 today" from the chat stream.
- **Request extraction** — turn "need 20 more boards Thursday" into a structured action/request.
All feed the project record (RND-7) and are great workloads for the in-house brain (RND-2/14).

## Flags (before anything is built)
- **Privacy/consent** — staff + subcontractor chats = personal data (messages + photos). Bridging to an AI
  is workplace monitoring → lawful basis + notice to the people in the chats. **Minda + Victoria decide**;
  not Eugene's call. (Same posture as RND-16.)
- **Anna's domain** — scope the build with Anna via her Raw (which groups, what she needs to see, output
  shape), the way HMRC was scoped with Rachel.
- **Guide-only** — Minda links the WhatsApp device + the Telegram account, holds creds; Eugene builds/verifies.

## Recommendation + phasing
**Telegram first — it's the easy, clean win and proves the whole pipeline; decide WhatsApp separately.**
- **P0 — scope with Anna** (which groups, what she needs, output shape) + Minda/Victoria on the privacy
  notice.
- **P1 — Telegram bridge**: bot/user-client → mirror messages + media to storage → Anna reads. Prove it.
- **P2 — AI test**: run the photos through the vision sentinel + summarise updates (the in-house-machine
  tests).
- **P3 — WhatsApp decision**: if still wanted, pick a route — unofficial bridge on a **dedicated number**
  (accept ban risk), or move updates to a Business number / Telegram. Build to the chosen route.
- **P4 — unify** (optional): Matrix + both mautrix bridges → one inbox + the project record (RND-7).

---
_Guide-only; Minda links accounts/holds creds; privacy = Minda+Victoria; Anna's domain (via her Raw).
Telegram clean; WhatsApp ToS/ban-risk → dedicated number. Pairs with RND-7 (project record), RND-16 (vision),
RND-2/14 (brain). Sources: WhatsApp unofficial-lib ban-risk guides; mautrix bridge docs._
