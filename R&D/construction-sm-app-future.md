# Future option — a site-manager app (Android + iOS)

> **Eugene, 2026-10-28 (guide-only, §3). FUTURE — not now (Minda).** Captured as the richer version of the
> RND-22 "SM view". The honest message: **you don't need a native app to start** (the site chat does the
> job), and when you do want a real app there's a **ladder** — each rung more capable + more effort. Eugene
> writes + tests the code (§2c); a human (Minda) holds the store accounts + does the publish (a live/outward
> step). Pairs with RND-22 (the SM view + per-SM routing).

## The ladder (least → most effort)
| Rung | What it is | Effort | Stores? | Best for |
|---|---|---|---|---|
| **1. Site chat** (now) | WhatsApp/Telegram — capture + brief/digest/alerts + reply-to-approve | **£0, zero install** | no | proving the pipeline; where SMs already are |
| **2. PWA** (installable web app) | one web codebase → installs to the home screen on **both** iOS + Android; camera, photos, offline, "today/approve/job" screens | **modest** (Eugene builds; deploy to a URL) | **no stores** | the big UX jump for low cost — the natural next step |
| **3. Native app** (cross-platform) | **Expo / React Native** (one codebase → both platforms) — best camera/offline/background, proper push, store presence | **real product** (builds, store review, maintenance) | yes | when the PWA's limits bite + it's worth the overhead |

**Recommended trajectory: 1 now → 2 (PWA) next → 3 (native) later if justified.** That matches "not now,
future" — and each rung reuses the same estate backend, so nothing is thrown away.

## What the SM app would do (the richer SM view)
- **Capture** — photo / voice / note tagged to the job, with time + GPS; **offline-queue** (site signal is
  patchy) → syncs when back online.
- **Today** — their jobs, "needs you today", urgent alerts.
- **Approve / decline** a request with **one tap** (the authority gate; above-limit escalates to Minda).
- **The job** — record, progress, materials, look-ahead, photos.
- **Push notifications** — urgent H&S, a decision needed.
- **Their jobs only** (access follows ownership).

## How it fits the sovereign estate (the key design point)
The app is a **thin client**; the **brain + the record stay on-estate**. It talks to the estate over a secure
endpoint — the **inference gateway + an API** (RND-14), reachable over the internet or **Tailscale**. Photos/
data land on the **NAS**, processed by the local brain. So the app doesn't change the sovereignty story: it's
a window onto the estate, not a new cloud. Offline-first so a bad-signal site still works.

## The honest costs / realities of rung 3 (native)
- **Cross-platform, not two apps** — Expo/React Native = one codebase for iOS + Android (don't build two).
- **Store overhead** — Apple Developer (~£79/yr) + Google Play (~£20 one-off); **app review**; device testing.
- **It's a product with a lifecycle** — OS updates, store-policy changes, app updates — ongoing maintenance,
  not a one-off build. Budget for upkeep, not just the build.
- **Publish = a human step** — Eugene builds/tests; **Minda holds the developer accounts + publishes** (§3,
  outward/live).
- **A PWA (rung 2) sidesteps most of this** (no stores, instant updates) — which is why it's the recommended
  next rung before committing to native.

## Privacy / security
Per-SM login (who's who) · their-jobs-only access · secure transport · data on-estate. Site photos = personal
data → the same consent posture as RND-22 (Minda + Victoria). A lost phone must not expose the estate →
device auth + remote sign-out.

## When to revisit
When the **site-chat pilot (RND-22 P2) is proven** and the SMs want a cleaner, offline, one-tap experience —
start at the **PWA**, and only go **native** if its limits (iOS push, deep offline/background, store presence)
actually bite. Flagged now so it's on the roadmap, costed and sequenced, not a surprise later.

---
_Guide-only (§3): Eugene writes + tests the app code; Minda holds the store/developer accounts + publishes.
Future — not now. The app is a thin client onto the sovereign estate (brain + data stay on-estate). Ladder:
site chat → PWA → native (Expo/React Native). Pairs with RND-22 (SM view) + RND-14 (gateway/API)._
