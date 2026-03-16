
# --- PATH ---
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"

# --- Fcitx5 Input Method ---
#export GTK_IM_MODULE=fcitx  # Not needed on Wayland
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

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

# Aliases & functions
source $HOME/.config/zsh/alias.zsh

# Neovim aliases
alias v='nvim'
alias vc='NVIM_APPNAME=nvim-nvchad nvim'

vv() {
  local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
  [[ -z $config ]] && echo "No config selected" && return
  NVIM_APPNAME=$(basename $config) nvim $@
}

# tmux aliases
alias t="tmux"
alias ta="tmux attach-session -t"
alias tnew="tmux new-session -s"
alias tls="tmux list-sessions"
alias tkill="tmux kill-session -t"

# uv
. "$HOME/.local/bin/env" 2>/dev/null
