#!/usr/bin/env bash
# Mark the zellij tab containing this Claude Code pane when it needs attention.
# Usage: zellij-attention.sh attention|clear
#
#   attention  ✴ prefix  — Claude needs user input
#   clear               — restore the tab's original name
set -eu

[ -z "${ZELLIJ:-}" ] && exit 0
command -v zellij >/dev/null 2>&1 || exit 0
command -v jq     >/dev/null 2>&1 || exit 0

action="${1:-}"
marker="✴ "
state_file="/tmp/claude-zellij-tab-${ZELLIJ_SESSION_NAME:-x}-${ZELLIJ_PANE_ID:-x}"

panes_json=$(zellij action list-panes -j -t 2>/dev/null || true)
[ -z "$panes_json" ] && exit 0

# Find the tab containing $ZELLIJ_PANE_ID. Field names vary across zellij
# versions, so match defensively on any object whose id/pane_id matches.
lookup=$(printf '%s' "$panes_json" | jq -r --arg pid "${ZELLIJ_PANE_ID:-}" '
  [ .. | objects
    | select(((.id // .pane_id // empty) | tostring) == $pid)
  ] | .[0] // empty
  | "\(.tab_id // .tab_position // "")\t\(.tab_name // "")"
' 2>/dev/null || true)

tab_id=$(printf '%s' "$lookup" | cut -f1)
tab_name=$(printf '%s' "$lookup" | cut -f2)
[ -z "$tab_id" ] && exit 0

rename() {
  zellij action rename-tab-by-id "$tab_id" "$1" >/dev/null 2>&1 || true
}

case "$action" in
  attention)
    case "$tab_name" in "$marker"*) exit 0 ;; esac
    printf '%s' "$tab_name" > "$state_file"
    rename "${marker}${tab_name}"
    ;;
  clear)
    if [ -f "$state_file" ]; then
      orig=$(cat "$state_file")
      rm -f "$state_file"
      rename "$orig"
    else
      case "$tab_name" in
        "$marker"*) rename "${tab_name#$marker}" ;;
      esac
    fi
    ;;
esac
