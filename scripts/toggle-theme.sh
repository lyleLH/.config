#!/usr/bin/env bash
# Toggle dark/light theme across tmux + neovim
# Usage: toggle-theme.sh [dark|light]

if [[ -z "$1" ]]; then
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    MODE="dark"
  else
    MODE="light"
  fi
else
  MODE="$1"
fi

if [[ "$MODE" == "dark" ]]; then
  CATPPUCCIN_TMUX="macchiato"
  NVIM_BG="dark"
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null
else
  CATPPUCCIN_TMUX="latte"
  NVIM_BG="light"
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false' 2>/dev/null
fi

# ── tmux ──────────────────────────────────────────────
if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
  # Unset all @thm_ variables so -o flag in theme files can set new values
  for var in $(tmux show -g | grep "^@thm_" | cut -d' ' -f1); do
    tmux set -gu "$var"
  done
  for var in $(tmux show -g | grep "^@catppuccin_" | cut -d' ' -f1); do
    tmux set -gu "$var"
  done

  # Set flavor and reload catppuccin
  tmux set -g @catppuccin_flavor "$CATPPUCCIN_TMUX"

  PLUGIN_DIR=""
  for base in "$HOME/.tmux/plugins" "$HOME/.config/tmux/plugins"; do
    for dir in tmux catppuccin-tmux catppuccin; do
      if [[ -x "$base/$dir/catppuccin.tmux" ]]; then
        PLUGIN_DIR="$base/$dir"
        break 2
      fi
    done
  done

  if [[ -n "$PLUGIN_DIR" ]]; then
    tmux source "$PLUGIN_DIR/catppuccin_options_tmux.conf"
    tmux source "$PLUGIN_DIR/catppuccin_tmux.conf"
  fi
fi

# ── neovim ────────────────────────────────────────────
for sock in /tmp/nvim-*.sock /tmp/nvim.*/0; do
  if [[ -S "$sock" ]]; then
    nvim --server "$sock" --remote-send "<Cmd>set background=$NVIM_BG<CR>" 2>/dev/null
  fi
done

echo "Switched to $MODE mode (tmux: $CATPPUCCIN_TMUX, nvim: $NVIM_BG)"
