# Full `.claude/settings.json` replacements — Composio MCP enabled (2026-10-18)

**For Minda to apply tomorrow.** Each section below is the **complete** `.claude/settings.json` for that
seat, built from the repo's current `main` **plus** the six Composio MCP meta-tools that let an unattended
run write files via the Composio MCP route. Eugene can't push these (the cloud guard blocks
permission-widening writes), so apply by hand.

**How to apply, per repo:** GitHub web → open the repo → `.claude/settings.json` → ✏️ edit → select all →
paste the block below → **Commit directly to `main`**. ~1 min each. Then the seat's next run can update
files via Composio without stalling.

**What was added to each `allow`** (nothing else changed; existing allow/deny/hooks preserved):
`mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL`, `COMPOSIO_SEARCH_TOOLS`, `COMPOSIO_GET_TOOL_SCHEMAS`,
`COMPOSIO_MANAGE_CONNECTIONS`, `COMPOSIO_WAIT_FOR_CONNECTIONS`, `COMPOSIO_REMOTE_WORKBENCH`.
`COMPOSIO_REMOTE_BASH_TOOL` deliberately **left out**.

**Tradeoff you accepted (18 Oct):** the MCP route runs any action through one generic tool, so the
CLI-pattern Gmail/Drive send+delete denies do **not** apply on that path — each seat's no-send/draft-only
(and Sarah's read-only) limit now rests on its charter + prompt here. Peter is already done via
`minda-ui/Peter#3` (merge it); his full file is included below for completeness/idempotency.

## Peter  (already has the 6 lines — no change)

Replace `.claude/settings.json` on `main` with:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Rachel

Replace `.claude/settings.json` on `main` with:

```json
{
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/gmail-recipient-guard.sh\""
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "jq -r \".prompt // empty\" | grep -qiE \"good ?-?night\" && jq -nc \"{hookSpecificOutput:{hookEventName:\\\"UserPromptSubmit\\\",additionalContext:\\\"Minda said good night. Before replying, run the end-of-day check in end-of-day.md (repo root): is today documented - current-state.md session row, amendments, open-issues, register and Hub status, drafts listed - updated in place on Drive, committed and pushed? Fix what is missing, then give the short good-night reply with what is waiting for Minda.\\\"}}\" || true",
            "timeout": 10
          }
        ]
      }
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Alex

Replace `.claude/settings.json` on `main` with:

```json
{
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "Bash(cd /home/user/* && *)",
      "Bash(git reset --hard *)",
      "Bash(git commit-tree *)",
      "Bash(git update-ref *)",
      "Bash(git merge *)",
      "Agent",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ],
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  }
}
```

## Anna

Replace `.claude/settings.json` on `main` with:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Fishbone-Properties-Ltd

Replace `.claude/settings.json` on `main` with:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*john-gmail-fbcl*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*john-gmail-fbcl*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*john-gmail-fbcl*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Helen

Replace `.claude/settings.json` on `main` with:

```json
{
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ],
    "ask": [
      "Bash(composio execute GOOGLEADS_MUTATE_AD_GROUP_CRITERIA*)"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ],
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  }
}
```

## Darius

Replace `.claude/settings.json` on `main` with:

```json
{
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ]
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Sarah

Replace `.claude/settings.json` on `main` with:

```json
{
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GMAIL_CREATE_EMAIL_DRAFT*)",
      "Bash(composio execute GMAIL_UPDATE_DRAFT*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Nadia

Replace `.claude/settings.json` on `main` with:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/good-night-doc-check.sh\""
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
      "Bash(composio execute GMAIL_SEND_DRAFT*)",
      "Bash(composio execute GMAIL_SEND_EMAIL*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Google_Drive__trash_file"
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ]
}
```

## Eugene

Replace `.claude/settings.json` on `main` with:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh\""
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/end-of-day.sh\""
          }
        ]
      },
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/creative-mode.sh\""
          }
        ]
      }
    ]
  },
  "enabledMcpjsonServers": [
    "composio"
  ],
  "permissions": {
    "allow": [
      "Bash(composio execute *)",
      "Bash(composio connections remove *)",
      "Bash(composio link *)",
      "mcp__Google_Drive__create_file",
      "mcp__Google_Drive__update_file",
      "mcp__Google_Drive__copy_file",
      "mcp__Google_Drive__search_files",
      "mcp__Google_Drive__read_file_content",
      "mcp__Google_Drive__download_file_content",
      "mcp__Google_Drive__get_file_metadata",
      "mcp__Google_Drive__get_file_permissions",
      "mcp__Google_Drive__list_recent_files",
      "mcp__Smartsheet__update_rows",
      "mcp__Smartsheet__add_rows",
      "mcp__Smartsheet__get_sheet_summary",
      "mcp__Smartsheet__get_columns",
      "mcp__Smartsheet__find_in_sheet",
      "mcp__composio__COMPOSIO_MULTI_EXECUTE_TOOL",
      "mcp__composio__COMPOSIO_SEARCH_TOOLS",
      "mcp__composio__COMPOSIO_GET_TOOL_SCHEMAS",
      "mcp__composio__COMPOSIO_MANAGE_CONNECTIONS",
      "mcp__composio__COMPOSIO_WAIT_FOR_CONNECTIONS",
      "mcp__composio__COMPOSIO_REMOTE_WORKBENCH"
    ],
    "deny": [
      "Bash(composio execute GMAIL_SEND*)",
      "Bash(composio execute GMAIL_REPLY*)",
      "Bash(composio execute GMAIL_FORWARD*)",
      "Bash(composio execute GMAIL_DELETE_*)",
      "Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
      "Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
      "Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
      "Bash(composio execute GOOGLEDRIVE_DELETE_*)",
      "Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
      "mcp__Gmail__send_message",
      "mcp__Gmail__reply",
      "mcp__Gmail__forward",
      "mcp__Google_Drive__trash_file"
    ]
  }
}
```
