
# --- PATH (must be before everything) ---
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/go/bin:/Users/hao92/.cargo/bin:/Applications/iTerm.app/Contents/Resources/utilities
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# --- Zinit Plugin Manager ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Oh-My-Zsh libs (completion, history, key-bindings, etc.)
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZL::directories.zsh

# Oh-My-Zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::fzf

# Third-party plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light agkozak/zsh-z

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Starship prompt
eval "$(starship init zsh)"


source $HOME/.config/zsh/alias.zsh 

export PATH=$PATH:$HOME/.asdf/installs/python/3.9.0/bin

export PATH=$HOME/development/flutter/bin:$PATH
export GOKU_EDN_CONFIG_FILE="$HOME/.config/goku_config/karabiner.edn"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/hao92/.lmstudio/bin"

export RUBY_YJIT_ENABLE=1
export RUBY_CONFIGURE_OPTS="--with-zlib-dir=/opt/homebrew/opt/zlib --with-openssl-dir=/opt/homebrew/opt/openssl@1.1 --with-readline-dir=/opt/homebrew/opt/readline --with-libyaml-dir=/opt/homebrew/opt/libyaml --with-gdbm-dir=/opt/homebrew/opt/gdbm"
export CFLAGS="-Wno-error=implicit-function-declaration"
export LDFLAGS="-L/opt/homebrew/opt/libyaml/lib"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"  # asdf shims (primary)

export PATH=$PATH:$HOME/go/bin
export UNSPLASH_ACCESS_KEY="sgPiQr5uhTgbukBgxQzG1uCjC73BwT-BdY7-4ROjzFU"


alias v='nvim' # default Neovim config
alias fixaudio='sudo killall coreaudiod' # fix simulator audio crackling
# alias vz='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim
alias vc='NVIM_APPNAME=nvim-nvchad nvim' # NvChad
# alias vk='NVIM_APPNAME=nvim-kickstart nvim' # Kickstart
# alias va='NVIM_APPNAME=nvim-astrovim nvim' # AstroVim
# alias vl='NVIM_APPNAME=nvim-lunarvim nvim' # LunarVim
#



vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
 
  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return
 
  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}


alias t="tmux"
alias ta="tmux attach-session -t"
alias tnew="tmux new-session -s"
alias tls="tmux list-sessions"
alias tls="tmux list-sessions"
alias tkill="tmux kill-session -t"

tm() {
  # 定义 tmux 命令选项
  local commands=(
    "new-session:新建会话"
    "attach-session:附着到现有会话"
    "list-sessions:列出所有会话"
    "rename-session:重命名会话"
    "rename-window:重命名窗口"
    "kill-session:杀死会话"
    "new-window:新建窗口"
    "split-vertical:垂直分割窗格"
    "split-horizontal:水平分割窗格"
  )

  # 使用 fzf 交互式选择命令
  local selected=$(printf "%s\n" "${commands[@]}" | fzf --prompt="tmux Commands > " --height=~50% --layout=reverse --border --exit-0)

  # 如果未选择任何命令，则退出
  [[ -z $selected ]] && echo "No command selected" && return

  # 提取选择的命令（去掉描述部分）
  local cmd=$(echo "$selected" | cut -d':' -f1)

  # 根据选择的命令执行操作
  case $cmd in
    "new-session")
      read -p "Enter session name: " session_name
      [[ -z $session_name ]] && session_name="default"
      tmux new-session -s "$session_name"
      ;;
    "attach-session")
      local session=$(tmux list-sessions 2>/dev/null | fzf --prompt="Select Session > " --height=~50% --layout=reverse --border --exit-0 | cut -d':' -f1)
      [[ -z $session ]] && echo "No session selected" && return
      tmux attach-session -t "$session"
      ;;
    "list-sessions")
      tmux list-sessions 2>/dev/null || echo "No active sessions"
      ;;
    "rename-session")
      local session=$(tmux list-sessions 2>/dev/null | fzf --prompt="Select Session to Rename > " --height=~50% --layout=reverse --border --exit-0 | cut -d':' -f1)
      [[ -z $session ]] && echo "No session selected" && return
      read -p "Enter new session name: " new_name
      [[ -z $new_name ]] && echo "New name cannot be empty" && return
      tmux rename-session -t "$session" "$new_name"
      ;;
    "rename-window")
      local window=$(tmux list-windows -a 2>/dev/null | fzf --prompt="Select Window to Rename > " --height=~50% --layout=reverse --border --exit-0 | cut -d':' -f1-2)
      [[ -z $window ]] && echo "No window selected" && return
      read -p "Enter new window name: " new_name
      [[ -z $new_name ]] && echo "New name cannot be empty" && return
      tmux rename-window -t "$window" "$new_name"
      ;;
    "kill-session")
      local session=$(tmux list-sessions 2>/dev/null | fzf --prompt="Select Session to Kill > " --height=~50% --layout=reverse --border --exit-0 | cut -d':' -f1)
      [[ -z $session ]] && echo "No session selected" && return
      tmux kill-session -t "$session"
      ;;
    "new-window")
      tmux new-window
      ;;
    "split-vertical")
      tmux split-window -h
      ;;
    "split-horizontal")
      tmux split-window -v
      ;;
    *)
      echo "Unknown command"
      ;;
  esac
}


# 添加到 ~/.zshrc 或 ~/.bashrc
wmode() {
  # 配置文件路径（根据你的实际情况调整）
  local config_file="$HOME/.config/goku_config/karabiner.edn"

  # 检查文件是否存在
  [[ ! -f "$config_file" ]] && echo "Error: $config_file not found" && return

  # 提取 w-mode 的 rules 部分
  # 使用 awk 更精确地提取 :w-mode 到下一个规则之间的内容
  local wmode_rules=$(awk '
    /:w-mode/ {print_next=1; next}
    print_next && /^\s*]/ {print_next=0; next}
    print_next && !/:w-mode/ {print $0}
  ' "$config_file" | grep -v "^\s*;" | grep -v "^\s*$" | sed 's/^\s*//')

  # 如果没有找到 w-mode rules，退出
  [[ -z "$wmode_rules" ]] && echo "No w-mode rules found in $config_file" && return

  # 构建选项列表
  local options=()
  while IFS= read -r line; do
    # 匹配格式 [:key [:open-path "path"]]
    if [[ $line =~ \[:([a-z]+)\ \[:open-path\ \"([^\"]+)\"\]\] ]]; then
      key="${BASH_REMATCH[1]}"
      path="${BASH_REMATCH[2]}"
      app_name=$(basename "$path" | sed 's/\.app$//')  # 提取应用名
      options+=("$key: Launch $app_name ($path)")
    fi
  done <<< "$wmode_rules"

  # 如果没有提取到任何选项，提示错误
  [[ ${#options[@]} -eq 0 ]] && echo "Failed to parse w-mode rules" && return

  # 使用 fzf 显示交互式菜单
  local selected=$(printf "%s\n" "${options[@]}" | fzf --prompt="w-mode Launcher > " --height=~50% --layout=reverse --border --exit-0)

  # 如果未选择，退出
  [[ -z "$selected" ]] && echo "No option selected" && return

  # 提取选择的键和路径
  local key=$(echo "$selected" | cut -d':' -f1)
  local path=$(echo "$selected" | grep -o '/[^)]\+')

  # 执行对应的 open-path 命令
  if [[ -n "$path" ]]; then
    osascript -e "tell application \"System Events\" to tell process \"Finder\" to open POSIX file \"$path\""
    echo "Launched: $path"
  else
    echo "Error: Could not parse path for key $key"
  fi
}

. "$HOME/.local/bin/env"

# Added by Antigravity
export PATH="/Users/hao92/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin/:$PATH"
export PATH=$PATH:$HOME/.maestro/bin


# Force kitty tab bar redraw on directory change
if ls /tmp/kitty-socket-* &>/dev/null; then
  _kitty_tab_redraw() {
    local sock=$(ls /tmp/kitty-socket-* 2>/dev/null | head -1)
    [ -n "$sock" ] && kitty @ --to "unix:${sock}" set-tab-title "$(basename $PWD)" 2>/dev/null
  }
  chpwd_functions+=(_kitty_tab_redraw)
fi

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
