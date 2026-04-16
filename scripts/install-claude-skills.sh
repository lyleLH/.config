#!/usr/bin/env bash
# install-claude-skills — link ~/.config/.claude/{skills,commands} into ~/.claude
#
# Idempotent. Safe to re-run. On a fresh machine:
#   1. clone ~/.config dotfiles
#   2. ./scripts/install-claude-skills.sh
#
# Why: Claude Code reads ~/.claude/skills and ~/.claude/commands, but we
# keep the source of truth inside the dotfiles repo at ~/.config/.claude/*.
# This script symlinks the two directories so CC picks them up.

set -euo pipefail

SRC_DIR="${HOME}/.config/.claude"
DEST_DIR="${HOME}/.claude"

die()  { printf 'error: %s\n' "$*" >&2; exit 1; }
info() { printf '%s\n' "$*"; }

link_one() {
  local name="$1"
  local src="${SRC_DIR}/${name}"
  local dest="${DEST_DIR}/${name}"

  [ -d "$src" ] || die "missing source: $src (dotfiles not checked out?)"

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      info "  ✓ ${name} already linked"
      return
    fi
    info "  ↻ ${name} link points elsewhere ($current), replacing"
    rm "$dest"
  elif [ -e "$dest" ]; then
    # Real directory/file already exists — back it up rather than overwrite.
    local backup="${dest}.backup.$(date +%Y%m%d-%H%M%S)"
    info "  ⚠ ${name} exists as non-symlink; backing up to ${backup}"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  info "  + ${name} -> ${src}"
}

mkdir -p "$DEST_DIR"
info "linking Claude Code skills/commands from ${SRC_DIR}"
link_one skills
link_one commands
info "done"
