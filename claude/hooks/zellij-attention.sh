#!/usr/bin/env bash
# Ring the terminal bell so zellij shows its native [!] attention marker.
# Zellij automatically clears it when the user switches to the tab.
set -eu

[ -z "${ZELLIJ:-}" ] && exit 0

printf '\a' > /dev/tty
