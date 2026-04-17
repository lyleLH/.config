#!/usr/bin/env bash
# Render a tmux window tab with dir-based background color.
# Usage: tmux-win-fmt.sh <cwd> <is_active 0|1> <window_index> <pane_count>

cwd="$1"
active="$2"
idx="$3"
pcount="${4:-1}"

case "$pcount" in
  1) icon="" ;;
  2) icon="" ;;
  3) icon="" ;;
  *) icon="" ;;
esac

color=""
label=""
case "$cwd" in
  */Documents/GitHub*) color="#334b9e"; label=$(basename "$cwd") ;;
  */Desktop*)          color="#b23838"; label="Desktop" ;;
  */Downloads*)        color="#a6701f"; label="Downloads" ;;
  */.config*)          color="#7f4ac7"; label=".config" ;;
  */development*)      color="#2c9683"; label="development" ;;
  */notes*)            color="#a77c27"; label="notes" ;;
  */Documents*)        color="#2c944e"; label="Documents" ;;
  *)                   label=$(basename "$cwd") ;;
esac

[[ -z "$label" ]] && label="/"

if [[ "$active" == "1" ]]; then
  if [[ -n "$color" ]]; then
    printf '#[bg=%s,fg=#ffffff,bold] %s %s  %s #[default]' "$color" "$idx" "$icon" "$label"
  else
    printf '#[reverse,bold] %s %s  %s #[default]' "$idx" "$icon" "$label"
  fi
else
  if [[ -n "$color" ]]; then
    printf '#[fg=%s] %s %s  %s #[default]' "$color" "$idx" "$icon" "$label"
  else
    printf ' %s %s  %s ' "$idx" "$icon" "$label"
  fi
fi
