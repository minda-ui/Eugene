#!/bin/bash
# drive-sync-verified — archive-then-recreate one local file into a Google Drive
# folder via the Composio CLI, with byte verification. Eugene's standard write
# discipline (CLAUDE.md §1 / §4), made repeatable.
#
# Usage:
#   sync.sh <local-file> <drive-folder-id> [options]
# Options:
#   --reason "<text>"     why the old copy is superseded (goes in its archived title)
#   --baseline <git-ref>  refuse unless the live Drive copy equals <git-ref>:<local-file>
#                         (e.g. origin/main) — guards against overwriting someone else's write
#   --archive <folder-id> Archive folder (default: Eugene's Archive/)
#   --account <alias>     Composio Drive connection (default: eugene-googledrive)
#   --dry-run             check everything, change nothing
#
# Exit codes: 0 ok / nothing to do, 1 usage, 2 precondition failed (nothing
# changed), 3 verification failed AFTER a change (investigate — see SKILL.md).
# Never prints file contents or credentials.
set -uo pipefail

ARCHIVE="1yw-FuDwvPc6Soi0xXArMCavb-N4eiP9z"
ACCOUNT="eugene-googledrive"
REASON="updated"
BASELINE=""
DRY=0
FILE="${1:-}"; FOLDER="${2:-}"
[ -n "$FILE" ] && [ -n "$FOLDER" ] || { echo "usage: sync.sh <local-file> <drive-folder-id> [--reason ..] [--baseline ref] [--archive id] [--account alias] [--dry-run]" >&2; exit 1; }
shift 2
while [ $# -gt 0 ]; do
  case "$1" in
    --reason) REASON="$2"; shift 2;;
    --baseline) BASELINE="$2"; shift 2;;
    --archive) ARCHIVE="$2"; shift 2;;
    --account) ACCOUNT="$2"; shift 2;;
    --dry-run) DRY=1; shift;;
    *) echo "unknown option: $1" >&2; exit 1;;
  esac
done
[ -f "$FILE" ] || { echo "FAIL: local file not found: $FILE" >&2; exit 1; }

export PATH="$HOME/.local/bin:$PATH"
command -v composio >/dev/null || { echo "FAIL: composio CLI not installed" >&2; exit 2; }
composio whoami 2>/dev/null | grep -q '"email"' || { echo "FAIL: composio CLI not signed in (needs 'composio login'; routine runs with only a ck_ key can't use this script)" >&2; exit 2; }

NAME="$(basename "$FILE")"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
say(){ echo "$*"; }
cx(){ composio execute "$@" --account "$ACCOUNT" 2>&1; }
find_ids(){ cx GOOGLEDRIVE_FIND_FILE -d "{q:\"'$FOLDER' in parents and trashed=false and name = '$NAME'\", fields:\"files(id)\"}" | jq -r '[.data.files[]?.id]|join(" ")'; }
download(){ local j; j=$(cx GOOGLEDRIVE_DOWNLOAD_FILE -d "{fileId:\"$1\"}"); local u; u=$(echo "$j" | jq -r '.data.downloaded_file_content.s3url // empty'); [ -n "$u" ] || return 1; curl -sS -o "$2" "$u"; }
fffd(){ grep -c $'\xef\xbf\xbd' "$1" 2>/dev/null || true; }

LOCAL_SIZE=$(wc -c <"$FILE"); LOCAL_MD5=$(md5sum "$FILE" | cut -d' ' -f1)
[ "$(fffd "$FILE")" = "0" ] || { echo "FAIL: local file contains U+FFFD replacement characters — fix before uploading" >&2; exit 2; }

IDS=$(find_ids); N=$(echo "$IDS" | wc -w)
say "file: $NAME  local: ${LOCAL_SIZE} B md5 ${LOCAL_MD5}"
say "live copies in folder: $N"
[ "$N" -le 1 ] || { echo "FAIL: $N live copies named '$NAME' — resolve the duplicate first (see SKILL.md)" >&2; exit 2; }

if [ "$N" -eq 1 ]; then
  OLD="$IDS"
  download "$OLD" "$TMP/live" || { echo "FAIL: could not download live copy $OLD" >&2; exit 2; }
  if cmp -s "$TMP/live" "$FILE"; then say "RESULT: Drive already identical to local — nothing to do"; exit 0; fi
  if [ -n "$BASELINE" ]; then
    if git show "$BASELINE:$FILE" >"$TMP/base" 2>/dev/null && cmp -s "$TMP/live" "$TMP/base"; then
      say "baseline: live Drive copy == $BASELINE:$FILE  OK"
    else
      echo "FAIL: live Drive copy ($(wc -c <"$TMP/live") B) differs from $BASELINE:$FILE — someone else may have written it. Rule C: check sibling branches / Drive history before overwriting. Nothing changed." >&2
      exit 2
    fi
  fi
else
  OLD=""
  say "no live copy — will upload as new"
fi

if [ "$DRY" -eq 1 ]; then say "RESULT: dry run — all preconditions pass; would $( [ -n "$OLD" ] && echo "archive $OLD and ")upload $NAME"; exit 0; fi

if [ -n "$OLD" ]; then
  STAMP=$(date -u +'%Y-%m-%d %H%M')
  TITLE="$NAME (archived $STAMP, superseded by $REASON)"
  TITLE_JSON=$(jq -Rn --arg t "$TITLE" '$t')
  R=$(cx GOOGLEDRIVE_UPDATE_FILE_METADATA_PATCH -d "{fileId:\"$OLD\", title:$TITLE_JSON, addParents:\"$ARCHIVE\", removeParents:\"$FOLDER\"}")
  [ "$(echo "$R" | jq -r .successful)" = "true" ] || { echo "FAIL: archive step failed — nothing uploaded; old copy untouched or partially renamed (check Drive): $(echo "$R" | jq -c .error)" >&2; exit 2; }
  say "archived: $OLD -> Archive/ as \"$TITLE\""
fi

NEW=$(composio execute GOOGLEDRIVE_UPLOAD_FILE --account "$ACCOUNT" --file "$FILE" -d "{folder_to_upload_to:\"$FOLDER\"}" 2>&1 | jq -r '.data.id // empty')
[ -n "$NEW" ] || { echo "FAIL: upload failed AFTER archiving — the folder now has NO live '$NAME'. Restore: move $OLD back from Archive/ and rename it to '$NAME'." >&2; exit 3; }
say "uploaded: $NEW"

META=$(cx GOOGLEDRIVE_GET_FILE_METADATA -d "{fileId:\"$NEW\", fields:\"size,md5Checksum\"}")
D_SIZE=$(echo "$META" | jq -r .data.size); D_MD5=$(echo "$META" | jq -r .data.md5Checksum)
download "$NEW" "$TMP/rt" || { echo "FAIL: could not download new copy for round-trip check" >&2; exit 3; }
FAILS=0
[ "$D_SIZE" = "$LOCAL_SIZE" ] && say "check size:       OK ($D_SIZE B)" || { say "check size:       FAIL (Drive $D_SIZE vs local $LOCAL_SIZE)"; FAILS=1; }
[ "$D_MD5" = "$LOCAL_MD5" ] && say "check md5:        OK" || { say "check md5:        FAIL"; FAILS=1; }
cmp -s "$TMP/rt" "$FILE" && say "check round-trip: OK (byte-identical)" || { say "check round-trip: FAIL"; FAILS=1; }
[ "$(fffd "$TMP/rt")" = "0" ] && say "check U+FFFD:      OK (0)" || { say "check U+FFFD:      FAIL"; FAILS=1; }
C=$(find_ids | wc -w); [ "$C" -eq 1 ] && say "check live copies: OK (1)" || { say "check live copies: FAIL ($C)"; FAILS=1; }

if [ "$FAILS" -eq 0 ]; then say "RESULT: OK — $NAME synced ($NEW)"; exit 0; fi
echo "RESULT: VERIFICATION FAILED for $NAME ($NEW) — see SKILL.md 'If verification fails'" >&2
exit 3
