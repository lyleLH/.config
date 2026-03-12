#!/usr/bin/env bash
# Watch for macOS appearance changes and trigger theme switch
# Runs as a background process

LAST_MODE=""

while true; do
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    CURRENT_MODE="dark"
  else
    CURRENT_MODE="light"
  fi

  if [[ "$CURRENT_MODE" != "$LAST_MODE" ]]; then
    LAST_MODE="$CURRENT_MODE"
    "$HOME/.config/scripts/toggle-theme.sh" "$CURRENT_MODE"
  fi

  sleep 5
done
