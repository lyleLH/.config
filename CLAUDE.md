# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles/config repository for macOS. Configs are meant to be symlinked into place:

- `~/.zshrc` → `zsh/.zshrc`
- `~/.config/` → this repo's root directory (the whole repo is symlinked as `~/.config`)

## Key Configuration Files and Their Purpose

| Path | Tool | Notes |
|------|------|-------|
| `zsh/.zshrc` | Zsh shell | Main shell config, sources `zsh/alias.zsh` |
| `zsh/alias.zsh` | Zsh aliases | All custom aliases and shell functions |
| `nvim/` | Neovim | Lazy.nvim-based config, namespace `haoliu` |
| `goku_config/karabiner.edn` | Karabiner-Elements | Keyboard remapping via Goku DSL |
| `aerospace/aerospace.toml` | AeroSpace | Tiling window manager |
| `tmux/.tmux.conf` | tmux | Prefix is `C-a`, plugins in `tmux/plugins/` |
| `karabiner/karabiner.json` | Karabiner | Auto-generated; edit via `karabiner.edn` instead |
| `zed/settings.json` | Zed editor | Editor settings |

## Neovim Architecture (`nvim/`)

Entry point: `nvim/init.lua` — detects VSCode environment and loads accordingly.

- **VSCode mode**: loads `lua/haoliu/vscode.lua` only
- **Normal mode**: loads `lua/haoliu/core/` and `lua/haoliu/lazy.lua`

Structure:
```
lua/haoliu/
  core/        # options.lua, keymaps.lua, init.lua
  plugins/     # one file per plugin (lazy.nvim managed)
  lazy.lua     # lazy.nvim bootstrap
  vscode.lua   # VSCode-specific bindings
```

Leader key is `<Space>`. `jk` exits insert mode.

## Keyboard Remapping (`goku_config/karabiner.edn`)

Uses [Goku](https://github.com/yqrashawn/GokuRakuJoudo) DSL to generate `karabiner/karabiner.json`.

- **Do not edit `karabiner/karabiner.json` directly** — it is auto-generated
- Edit `karabiner.edn` and run `goku` to regenerate

Key modes defined:
- `:w-mode` (simlayer on `w`): app launcher shortcuts
- `:o-mode` (simlayer on `o`): app launcher shortcuts
- `:hyper-mode` (layer on `right_option`): hyper key combinations

Modifier notation in EDN: `C`=left_cmd, `T`=left_ctrl, `O`=left_opt, `S`=left_shift; `!` = mandatory, `#` = optional.

## Shell Environment Notes

- Oh My Zsh installed at `~/.config/oh-my-zsh` (symlinked)
- `asdf` manages Python/Ruby versions; shims at `~/.asdf/shims`
- Conda is lazy-loaded (defined as a function to avoid startup delay)
- `GOKU_EDN_CONFIG_FILE` points to `~/.config/goku_config/karabiner.edn`
- Multiple Neovim configs supported via `NVIM_APPNAME` env var; `vv` function uses fzf to select

## Common Workflows

**Apply keyboard remapping changes:**
```sh
goku
```

**Reload tmux config:**
```
<C-a> r
```

**Switch Neovim configs interactively:**
```sh
vv   # fzf picker for ~/.config/nvim-* directories
```

**Edit key configs via aliases:**
```sh
keyboard    # opens goku_config/karabiner.edn in vim
vimkeys     # opens nvim keymaps.lua in vim
showalias   # opens zsh/alias.zsh in nvim
tmuxconf    # opens tmux/.tmux.conf in nvim
```
