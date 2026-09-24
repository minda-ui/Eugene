# Runbook — Narrow Rachel's Microsoft 365 / OneDrive connector grant (v0.2)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda (or a delegated tenant
admin) performs every connector-settings / Entra ID step.** Eugene has no Microsoft 365 connector of his
own (charter §1 Connectors list) and does not call Microsoft 365/Graph tools against Rachel's connector
— everything below is drawn from Rachel's own investigation as relayed on the Hub (AWT-0090), not from
Eugene querying her connector directly. No credential is ever written into this file. Author: Claude for
Eugene. v0.1 2026-09-24; **v0.2 2026-09-24 — tenant identity confirmed by Minda, §0 updated.** Resolves
**Hub AWT-0090** (Assigned to Eugene, Priority High), tracks the Authority Register row **"Rachel —
Microsoft 365 / OneDrive connector grant"** and Rachel's own **RA-22**._

## 0. Status

1. ✅ **Tenant confirmed (Minda, 2026-09-24): `info@fishbonedrylining.onmicrosoft.com` is the estate's
   real M365 login** — not a misconfiguration, not the wrong account. Path B's admin (whoever holds
   Global/Application Administrator on that tenant) is a known, correct target — proceed on that basis.
2. ⬜ **Still open — which of the two narrowing paths below** (or both) Minda wants to take; they do
   different things (§2). Recommendation stands: both, Path A first (§3).

## 1. What's actually granted vs. what RA-22 recorded

RA-22 (opened 2026-09-19) originally logged **4** scopes. Rachel verified the real grant at source on
2026-09-24 by calling `get_granted_scopes` rather than trusting the old issue text — the connector
actually holds **29 delegated Microsoft Graph scopes**:

| Family | Scopes | Verdict |
|---|---|---|
| **Files (OneDrive)** | `Files.Read`, `Files.Read.All`, `Files.ReadWrite.All` | **Keep** — justified by Authority Register grant RA-20(3), which permits Rachel writing to OneDrive to retire a consolidated financial-document source once it's copied into the Financial Archive. |
| **Mail / mailbox (9 scopes)** | `Mail.Send`, `Mail.Read`, `Mail.ReadBasic`, `Mail.ReadWrite`, `Mail.Read.Shared`, `MailboxFolder.Read`, `MailboxItem.Read`, `MailboxSettings.Read`, `MailboxSettings.ReadWrite` | **Drop all nine.** Rachel's charter authority is read/consolidate/bounded-QuickBooks-posting — never email, and never a payment/bank/HMRC channel this could touch. `Mail.Send` in particular is exactly the kind of send-capability Rachel's charter explicitly withholds. |
| **Shared-data (flagged first)** | `Mail.Read.Shared`, `Calendars.Read.Shared` | **Drop — highest priority.** These two read *other people's* mailboxes/calendars, which runs directly against Minda's standing rule (2026-09-19) that Rachel indexes company documents and leaves personal data alone. No grant on the finance desk was ever asked for on this basis. |
| **Teams / chat (6 scopes)** | `Chat.Read`, `Chat.ReadBasic`, `ChatMessage.Read`, `ChatMember.Read`, `Channel.ReadBasic.All`, `ChannelMessage.Read.All` | **Drop all six** — never recorded anywhere in the estate as something Rachel's role needs. |
| **Online meetings (5 scopes)** | `OnlineMeetingRecording.Read.All`, `OnlineMeetingTranscript.Read.All`, `OnlineMeetingAiInsight.Read.All`, `OnlineMeetingArtifact.Read.All`, `OnlineMeetings.Read` | **Drop all five** — same reasoning; recordings/transcripts/AI-insight access has no role justification. |
| **SharePoint** | `Sites.Read.All` (every SharePoint site in the tenant) | **Drop, unless Minda confirms SharePoint filing is now in scope for Rachel** — it currently is not. |

Net: **keep 3 (Files), drop 26** (9 mail/mailbox + 6 Teams/chat + 5 online-meeting + `Sites.Read.All`, and
whatever residual scopes fall outside these named families once the full 29-scope list is reviewed
directly against the RA-22 detail Rachel logged in her own `open-issues.md`).

## 2. The two narrowing paths — pick one or both

These do genuinely different things; neither alone gives the same result as the other.

### Path A — Claude connector per-tool permissions (`claude.ai/customize/connectors`)

Restricts what **Claude itself will call** through the connector, regardless of what Microsoft's
consent grant technically still allows. Quick, no tenant-admin role needed — whoever administers
Rachel's connector on the Claude side (Minda, or Rachel's own account owner) does this directly:

1. Go to `claude.ai/customize/connectors` (or the equivalent connectors settings page for the account
   Rachel's sessions run under).
2. Find the Microsoft 365 / Outlook connector entry.
3. Open its per-tool permissions and **disable every tool in the mail, mailbox, Teams/chat, and
   online-meeting families** — in this session's own tool listing those correspond to the
   `mcp__Microsoft_365__outlook_*`, `mcp__Microsoft_365__teams_*`, and any online-meeting/calendar tools;
   the exact tool names may differ slightly in Rachel's own connector configuration, so match by
   description rather than by name alone.
4. Leave the OneDrive/SharePoint file tools (`sharepoint_*`, file read/write) enabled, unless §1 says to
   drop `Sites.Read.All` too, in which case disable the SharePoint-site-search tools specifically while
   keeping plain file read/write.
5. **Limitation, stated plainly:** this does not change what Microsoft's OAuth consent record says the
   app is allowed to do — it only stops *this* connector's calls from reaching those Graph endpoints. If
   the underlying app registration is ever re-authorised or queried a different way, the full 29-scope
   grant is still sitting there at the Microsoft side. Treat this as a fast mitigation, not the real fix.

### Path B — Revoke/narrow the app's consent in Entra ID (the tenant-side fix)

The actual OAuth grant lives in the `info@fishbonedrylining.onmicrosoft.com` tenant's Entra ID (Azure
AD). This needs a Global Administrator or Application Administrator for **that tenant** — confirm who
holds that role before starting; it's not necessarily the same person who administers
`fishboneconstruction.co.uk`.

1. Sign in to `entra.microsoft.com` (or `portal.azure.com` → Microsoft Entra ID) as an admin for the
   `fishbonedrylining.onmicrosoft.com` tenant.
2. **Identity → Applications → Enterprise applications** — find the app registration the connector
   authenticated through (whatever Anthropic's Microsoft 365 connector is registered as; if it isn't
   obvious by name, cross-check the client/application ID against what Rachel's connector setup used).
3. Open its **Permissions** (or **Security → Permissions**) tab to see the granted delegated permissions
   and who consented.
4. Microsoft Graph delegated grants are typically consented as one block per app-per-user — there is
   usually no native "drop just these 9 of 29 scopes" control in the Entra ID UI. The realistic options
   are:
   - **Full revoke**, then have the connector re-authenticate and consent fresh with only the scopes the
     (ideally narrowed) app registration actually requests — cleanest, but means Rachel's connector needs
     re-connecting afterward (a live re-auth step, not a silent config change).
   - Remove the specific `OAuth2PermissionGrant` for this user/app via **Enterprise applications → \[app\]
     → Permissions → Review permissions**, if the UI exposes per-scope removal for this grant type.
   - If the app registration itself is one Fishbone controls (not a fixed third-party manifest), narrow
     the **requested** scopes in the app registration's API permissions list, which then forces a
     re-consent to the smaller set next sign-in.
5. **Confirm the exact menu path and available controls in the live console before acting** — Entra ID's
   UI labels move between Microsoft's release waves; this section describes the standard mechanism, not a
   verified click-path in the current console. Eugene cannot verify this himself (no Entra ID access,
   guide-only per charter §3) — whoever executes should sanity-check each step against what they actually
   see before proceeding.
6. After the change, verification is a re-run of Rachel's own `get_granted_scopes` (or equivalent) from a
   Rachel session — if the scope count has dropped from 29 to the expected ~3-4, the tenant-side fix
   worked; if the connector needed re-auth, watch for it failing until reconnected.

## 3. Recommendation

Do **both**, in this order: Path A first (immediate, no admin role needed, stops the risky calls today —
especially `Mail.Read.Shared`/`Calendars.Read.Shared`, the two flagged as reaching other people's data),
then Path B when a `fishbonedrylining.onmicrosoft.com` admin is available, since Path A alone leaves the
over-broad consent sitting at the Microsoft side indefinitely.

## 4. Verification once done

- Path A: re-check the connector's per-tool permissions page shows only the Files/OneDrive tools enabled.
- Path B: Rachel (or whoever can call it) re-runs `get_granted_scopes` and confirms the scope list matches
  §1's "keep" column only.
- Either way: update Rachel's own `open-issues.md` RA-22 and the Authority Register row (Eugene does not
  edit Rachel's KB himself — report back on Hub AWT-0090 and let Rachel or Alex close her own RA-22 per
  the Raw/-only rule, §1).
