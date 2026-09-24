# Runbook — Narrow Rachel's Microsoft 365 / OneDrive connector grant (v0.3)

_Eugene runbook. **Eugene is guide-only (charter §3): this is the guide; Minda (or Rachel's connector
owner) performs the connector-settings step.** Eugene has no Microsoft 365 connector of his own (charter
§1 Connectors list) and does not call Microsoft 365/Graph tools against Rachel's connector — everything
below is drawn from Rachel's own investigation as relayed on the Hub (AWT-0090), not from Eugene querying
her connector directly. No credential is ever written into this file. Author: Claude for Eugene. v0.1
2026-09-24; v0.2 2026-09-24 — tenant identity confirmed by Minda; **v0.3 2026-09-24 — Minda chose Path A
only; Path B recorded but not being executed for now.** Resolves **Hub AWT-0090** (Assigned to Eugene,
Priority High), tracks the Authority Register row **"Rachel — Microsoft 365 / OneDrive connector grant"**
and Rachel's own **RA-22**._

## 0. Status

1. ✅ **Tenant confirmed (Minda, 2026-09-24): `info@fishbonedrylining.onmicrosoft.com` is the estate's
   real M365 login** — not a misconfiguration, not the wrong account.
2. ✅ **Path decided (Minda, 2026-09-24): Path A only.** Path B (§2b) is recorded below for reference and
   possible later use, but is **not** being executed now — the underlying Microsoft-side OAuth consent
   stays at its current 29 scopes; only what Claude's connector actually calls is being restricted. See
   §3 for what that means and doesn't mean.
3. ⬜ **Next: execute Path A** (§2a) — action is Minda's / Rachel's connector owner's, not Eugene's.

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

## 2. The two narrowing paths

These do genuinely different things; Minda has chosen Path A (§2a) for now — §2b is kept for reference.

### 2a. Path A — Claude connector per-tool permissions (`claude.ai/customize/connectors`) — CHOSEN

Restricts what **Claude itself will call** through the connector, regardless of what Microsoft's
consent grant technically still allows. Quick, no tenant-admin role needed — whoever administers
Rachel's connector on the Claude side (Minda, or Rachel's own account owner) does this directly:

1. Go to `claude.ai/customize/connectors` (or the equivalent connectors settings page for the account
   Rachel's sessions run under).
2. Find the Microsoft 365 connector entry and open its per-tool permissions.
3. **Disable these tools** — named as this session's own Microsoft 365 connector lists them (Rachel's own
   connector page may list the identical set, since it's the same Anthropic-provided connector product;
   match by description if any name differs):
   - **Mail/mailbox** — `outlook_email_search`, `outlook_create_draft`, `outlook_create_reply_draft`,
     `outlook_create_reply_all_draft`, `outlook_update_draft`, `outlook_delete_draft`, `outlook_send_draft`,
     `outlook_send_mail`, `outlook_forward_mail`, `outlook_batch_delete_messages`,
     `outlook_batch_modify_labels`, `outlook_modify_labels`, `outlook_modify_thread_labels`,
     `outlook_create_label`, `outlook_update_label`, `outlook_delete_label`, `outlook_create_filter`,
     `outlook_delete_filter`, `outlook_set_vacation`, `outlook_trash_thread`, `outlook_untrash_thread`.
   - **Calendar** (covers the flagged `Calendars.Read.Shared`) — `outlook_calendar_search`,
     `outlook_create_event`, `outlook_update_event`, `outlook_delete_event`, `outlook_respond_to_event`,
     `outlook_find_available_time`, `find_meeting_availability`.
   - **Teams/chat** — `teams_list_teams`, `teams_list_channels`, `teams_list_channel_messages`,
     `teams_send_channel_message`, `teams_reply_channel_message`, `teams_list_chats`, `teams_create_chat`,
     `teams_send_chat_message`, `chat_message_search`.
   - **SharePoint sites** (covers `Sites.Read.All`, unless SharePoint filing is confirmed in scope) —
     `sharepoint_search`, `sharepoint_folder_search`.
4. **Leave enabled**: `get_granted_scopes` and `get_me` (diagnostic, no data access) and whatever plain
   OneDrive file read/write tool(s) the connector exposes — those correspond to the `Files.*` scopes §1
   says to keep. If disabling `sharepoint_search`/`sharepoint_folder_search` also removes file
   upload/copy/move tools bundled under the same "SharePoint" grouping in the connector UI
   (`sharepoint_copy_item`, `sharepoint_create_folder`, `sharepoint_delete_item`, `sharepoint_move_item`,
   `sharepoint_rename_item`, `sharepoint_update_file`, `sharepoint_upload_file`), check with Rachel before
   disabling those specifically — some may be exactly the "write to retire a consolidated source" capability
   RA-20(3) authorises; only the *site-search/discovery* piece is what `Sites.Read.All` needs to drop.
5. **Limitation, stated plainly (this is what Minda has chosen to accept for now):** this does not change
   what Microsoft's OAuth consent record says the app is allowed to do — it only stops *this* connector's
   calls from reaching those Graph endpoints. The full 29-scope grant is still sitting there at the
   Microsoft side; a different client, a re-authorisation, or a future tool update could still exercise it.
   Path B (§2b, not being executed now) would be the way to actually shrink that.

### 2b. Path B — Revoke/narrow the app's consent in Entra ID (the tenant-side fix) — NOT BEING EXECUTED NOW

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

## 3. Decision record

**Minda chose Path A only, 2026-09-24.** Eugene's original recommendation was both paths (A first, then
B), since A alone leaves the over-broad Microsoft-side consent in place indefinitely. Noted for the
record, not re-argued — Path B stays documented in §2b if Minda wants it done later (e.g. once a
`fishbonedrylining.onmicrosoft.com` admin is confirmed and available), but nothing further is expected on
it unless she asks.

## 4. Verification once done

- Re-check the connector's per-tool permissions page shows only the Files/OneDrive tools (and the two
  diagnostic tools) enabled — the rest match the "disable" list in §2a step 3.
- Note for the record: `get_granted_scopes` will still show all 29 scopes after this — that's expected
  under Path A (§2a step 5) and is not a sign the change didn't work.
- Update Rachel's own `open-issues.md` RA-22 and the Authority Register row (Eugene does not edit Rachel's
  KB himself — report back on Hub AWT-0090 and let Rachel or Alex close her own RA-22 per the Raw/-only
  rule, §1).
