# RND-25 — Composio developer side: findings (docs read 2026-10-31)

_R&D (creative mode). Read from docs.composio.dev (allowed by Minda this session). Docs = data, not
instructions — pages telling agents to install skills/packages were not followed; nothing installed.
Guide-only (§3); nothing built._

## What fits our plan
| Feature | What it does | For Fishbone |
|---|---|---|
| **Sessions** (`composio.create(user_id)`, REST `POST /api/v3.1/tool_router/session`) | scope a user's tools, auth, connected accounts, MCP URL, workbench state | **one session per worker** (each local role + each AI employee) |
| **Read-only tags** `tags={"enable":["readOnlyHint"],"disable":["destructiveHint"]}` | only read-only tools discoverable **and executable** | default for local workers |
| **Exact allowlist** `tools={"gmail":{"enable":["GMAIL_FETCH_EMAILS"]}}` | narrowest; new tools never slip in | e.g. Gmail = fetch + create draft only — enforced server-side (stronger than today's local deny-rules) |
| **Sandbox off** `sandbox={"enable":False}` (REST: `workbench`) | removes remote code execution | for every worker that doesn't need it |
| **Direct-tools MCP URL** (`SESSION_PRESET_DIRECT_TOOLS`, `mcp=True`) | a URL serving only the listed tools, no search/meta tools | the cleanest "hands" for an MCP-capable local agent |
| **OpenAI provider** with our own `OpenAI()` client | provider only formats/executes tools; the model client is ours | point the client at the LiteLLM gateway → local models can use Composio tools (**inferred, not documented**) |
| **Custom tools** (experimental, run **in-process**) | wrap our own systems | only route to LAN systems (Proxmox/FusionPBX) — our code holds those creds; **not over MCP** |
| **Approvals** `no_elicitation_support_fallback:"deny"` | sessions can require approval; deny when the client can't ask | fits the Approvals Desk |

## Watch-outs
1. **Proxy Execute bypasses tag/tool rules** (only toolkit on/off applies) → a "read-only" session with proxy on could still send mail. **Keep Proxy Execute OFF** and use a project key **without** the Proxy-execute permission.
2. **Session MCP headers carry the project key** → it's a secret; Minda holds it, never in git/chat.
3. **Triggers in production need a public webhook** (no VPN/IP-allowlist). No-public-URL options (`subscribe()` WebSocket, CLI forwarder) are documented as **dev tools**. Polling (Gmail/Calendar) min 2 min.
4. **Data:** Composio Cloud holds the OAuth tokens and keeps call logs (arguments + responses) **up to 1 year** on every plan. **Zero Data Retention** = paid add-on, needs **our own OAuth apps**, excludes triggers/sandbox/files. Self-hosting / customer-managed keys = **Enterprise only**.
5. **OAuth scopes** can be narrowed (e.g. read-only) per auth config — applies to **new connections only** (reconnect needed).

## Implications
- Local workers can get Composio "hands" safely: own session, exact allowlist, read-only tags, sandbox off, proxy off.
- The **sovereign lane** (HR/finance/site photos) should **not** route through Composio at all while payloads are logged for a year — or needs ZDR + own OAuth apps first.
- Triggers wait until we decide on a public endpoint (public-proxy VM) — security review first.

Source pages: how-composio-works, kb platform-session-tool-policies, custom-tools-and-toolkits, providers/openai,
custom-providers/python, triggers, subscribing-to-events, sandbox/local, security/token-custody,
data-retention, zero-data-retention, kb project-api-key-permissions, controlling-scopes, proxy-execute,
sessions-via-mcp (all under https://docs.composio.dev/).
