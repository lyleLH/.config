
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



source $HOME/.config/zsh/alias.zsh 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/go/bin:/Users/hao92/.cargo/bin:/Applications/iTerm.app/Contents/Resources/utilities
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$PATH:$HOME/.asdf/installs/python/3.9.0/bin
export PATH=$PATH:$HOME/.asdf/shims

export PATH=$HOME/development/flutter/bin:$PATH
export GOKU_EDN_CONFIG_FILE="$HOME/.config/goku_config/karabiner.edn"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/hao92/.lmstudio/bin"

export RUBY_YJIT_ENABLE=1
export RUBY_CONFIGURE_OPTS="--with-zlib-dir=$(brew --prefix zlib) --with-openssl-dir=$(brew --prefix openssl@1.1) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml) --with-gdbm-dir=$(brew --prefix gdbm)"
export CFLAGS="-Wno-error=implicit-function-declaration"
export LDFLAGS="-L$(brew --prefix libyaml)/lib"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

export PATH=$PATH:$HOME/go/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias v='nvim' # default Neovim config
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
