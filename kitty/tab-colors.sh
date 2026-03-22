#!/bin/zsh
# Directory-to-tab-color mapping

typeset -A DIR_COLORS
DIR_COLORS=(
  "Documents/GitHub" "89b4fa"
  "Desktop"          "f38ba8"
  "Downloads"        "fab387"
  "Documents"        "a6e3a1"
  ".config"          "cba6f7"
  "development"      "94e2d5"
  "notes"            "f9e2af"
)

DEFAULT_TAB_COLOR="cdd6f4"
_LAST_TAB_COLOR=""

_update_tab_color() {
  local sock=$(ls /tmp/kitty-socket-* 2>/dev/null | head -1)
  [ -z "$sock" ] && return

  local dir="$PWD"
  local color="$DEFAULT_TAB_COLOR"
  local best_len=0

  for pattern col in "${(@kv)DIR_COLORS}"; do
    if [[ "$dir" == *"$pattern"* ]] && (( ${#pattern} > best_len )); then
      best_len=${#pattern}
      color="$col"
    fi
  done

  # Skip if color hasn't changed (avoid flicker)
  [ "$color" = "$_LAST_TAB_COLOR" ] && return
  _LAST_TAB_COLOR="$color"

  kitty @ --to "unix:${sock}" set-colors \
    active_tab_background="#${color}" active_tab_foreground="#1e1e2e" 2>/dev/null
}
