

alias nv="nvim"

alias myip="curl http://ipecho.net/plain; echo"

alias sexcode14="sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
alias sexcode13="sudo xcode-select -s /Applications/Xcode13.1/Xcode.app/Contents/Developer"
alias showxcodepath="xcode-select -p"

alias xvim="vi ~/.xvimrc"

alias keyboard="vi ~/.config/goku_config/karabiner.edn"
alias vimkeys="vi ~/.config/nvim/lua/haoliu/core/keymaps.lua"
 
alias skhdkey="nv ~/.config/skhd/skhdrc"

alias showalias="nv ~/.config/zsh/alias.zsh"
alias tmuxconf="nv ~/.config/tmux/.tmux.conf"

# ── tmux ──────────────────────────────────────────────
alias t="tmux"
alias tkill="tmux kill-session -t"

# tx — unified tmux tool with fzf
tx() {
  local cmd="${1:-}"

  case "$cmd" in
    h) _tx_help ;;
    c) _tx_cmd ;;
    w) _tx_win ;;
    *) _tx_session ;;
  esac
}

# tmux environment label for fzf border
_tx_env() {
  if [[ -n "$TMUX" ]]; then
    local s=$(tmux display-message -p '#S')
    echo " tmux [$s] "
  else
    echo " terminal "
  fi
}

# ── tx: create session with emoji ─────────────────────
_tx_new_session() {
  local emojis=(
    "🚀 rocket"    "💻 dev"       "🔧 config"    "📝 notes"
    "🌐 web"       "🗂️ files"     "🧪 test"      "📦 build"
    "🎯 focus"     "🐛 debug"     "📊 data"      "🎨 design"
    "☁️ cloud"      "🔒 secure"    "📡 server"    "🏠 home"
  )

  local picked
  picked=$(printf '%s\n' "${emojis[@]}" | fzf \
    --height=~50% \
    --header "Pick an emoji for the session" \
    --border --border-label=" emoji " \
    --preview-window=hidden)

  [[ -z "$picked" ]] && return

  local emoji="${picked%% *}"

  read -r "name?Session name: "
  [[ -z "$name" ]] && return

  local full="${emoji} ${name}"
  tmux new-session -d -s "$full" && echo "Created '$full'"
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$full"
  else
    tmux attach-session -t "$full"
  fi
}

# ── tx: session manager ──────────────────────────────
_tx_session() {
  if ! command -v fzf &>/dev/null; then
    echo "fzf is required. Install with: brew install fzf"
    return 1
  fi

  local sessions
  sessions=""
  local _line
  while IFS=$'\t' read -r _sname _wins _att _path _created; do
    local git_branch="-"
    if [[ -d "$_path/.git" ]]; then
      local _branch=$(git -C "$_path" branch --show-current 2>/dev/null)
      local _dirty=$(git -C "$_path" status --porcelain 2>/dev/null | head -1)
      git_branch="${_branch:-detached}"
      [[ -n "$_dirty" ]] && git_branch+="*"
    fi
    local time_str=$(date -r "$_created" '+%m/%d %H:%M' 2>/dev/null)
    local short_path=$(echo "$_path" | awk -F/ '{if(NF>=2) print $(NF-1)"/"$NF; else print $0}')
    _line="${_sname}│${_wins}w│${_att} attached│${short_path}│${git_branch}│${time_str}"
    sessions+="${_line}"$'\n'
  done < <(tmux list-sessions -F "#{session_name}	#{session_windows}	#{session_attached}	#{pane_current_path}	#{session_created}" 2>/dev/null)
  sessions="${sessions%$'\n'}"
  sessions=$(echo "$sessions" | column -t -s '│')

  if [[ -z "$sessions" ]]; then
    echo "No tmux sessions. Creating new session..."
    _tx_new_session
    return
  fi

  local selected
  selected=$(echo "$sessions" | fzf \
    --height=~70% \
    --header "ENTER=attach | Ctrl-X=kill | Ctrl-N=new | Ctrl-R=rename" \
    --preview 'tmux capture-pane -ep -t "$(echo {} | awk "{print \$1}")" 2>/dev/null || echo "No preview"' \
    --preview-window=up:75% \
    --expect=ctrl-x,ctrl-n,ctrl-r \
    --border --border-label="$(_tx_env) sessions ")

  [[ -z "$selected" ]] && return

  local key action_line
  key=$(echo "$selected" | head -1)
  action_line=$(echo "$selected" | tail -1)
  # Match first column against actual tmux session names
  local session_name=""
  while IFS= read -r _s; do
    if [[ "$action_line" == "$_s"* || "$action_line" == "$_s "* ]]; then
      session_name="$_s"
      break
    fi
  done < <(tmux list-sessions -F '#{session_name}' 2>/dev/null | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2-)

  case "$key" in
    ctrl-x)
      echo "Kill session '$session_name'? [y/N] "
      read -r confirm
      [[ "$confirm" =~ ^[yY]$ ]] && tmux kill-session -t "$session_name" && echo "Killed '$session_name'"
      ;;
    ctrl-n)
      _tx_new_session
      ;;
    ctrl-r)
      read -r "newname?Rename '$session_name' to: "
      [[ -n "$newname" ]] && tmux rename-session -t "$session_name" "$newname" && echo "Renamed to '$newname'"
      ;;
    *)
      if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
      else
        tmux attach-session -t "$session_name"
      fi
      ;;
  esac
}

# ── tx h: cheatsheet ─────────────────────────────────
_tx_help() {
  local cheatsheet
  cheatsheet=$(cat <<'CHEAT'
[SESSION 会话]
prefix + d          | Detach 脱离会话
prefix + $          | Rename session 重命名会话
prefix + s          | List sessions 列出会话
prefix + (          | Previous session 上一会话
prefix + )          | Next session 下一会话
prefix + f          | fzf session switcher (custom) fzf会话切换

[WINDOW 窗口]
prefix + c          | New window 新建窗口
prefix + ,          | Rename window 重命名窗口
prefix + w          | List windows 列出窗口
prefix + n          | Next window 下一窗口
prefix + p          | Previous window 上一窗口
prefix + 1-9        | Go to window N 跳转窗口N
prefix + &          | Kill window 关闭窗口

[PANE 面板]
prefix + |          | Split horizontal (custom) 水平分割
prefix + -          | Split vertical (custom) 垂直分割
prefix + x          | Kill pane 关闭面板
prefix + z / m      | Toggle zoom 切换全屏
prefix + q          | Show pane numbers 显示面板编号
prefix + {          | Move pane left 面板左移
prefix + }          | Move pane right 面板右移

[RESIZE 调整大小]
prefix + h          | Resize left 向左扩展
prefix + l          | Resize right 向右扩展
prefix + j          | Resize down 向下扩展
prefix + k          | Resize up 向上扩展

[NAVIGATE 导航]
Ctrl + h/j/k/l      | Navigate panes (vim-tmux-navigator) 跨面板导航

[COPY MODE 复制模式]
prefix + [          | Enter copy mode 进入复制模式
v                   | Begin selection 开始选择
y                   | Copy selection 复制选中
q                   | Exit copy mode 退出复制模式

[MISC 其他]
prefix + r          | Reload config (custom) 重新加载配置
prefix + I          | Install plugins (tpm) 安装插件
prefix + T          | fzf cheatsheet popup (custom) fzf速查弹窗

[PLUGIN 插件]
tmux-resurrect      | prefix+Ctrl-s=save prefix+Ctrl-r=restore 保存/恢复会话
tmux-continuum      | Auto-save every 15min 每15分钟自动保存
vim-tmux-navigator  | Seamless vim/tmux navigation 无缝vim/tmux导航
CHEAT
)

  if command -v fzf &>/dev/null; then
    echo "$cheatsheet" | fzf \
      --height=~80% \
      --header "tmux cheatsheet / 速查表 — ESC to close" \
      --no-sort \
      --border --border-label="$(_tx_env) cheatsheet " \
      --preview-window=hidden \
      --ansi
  else
    echo "$cheatsheet"
  fi
}

# ── tx c: command palette ─────────────────────────────
_tx_cmd() {
  if ! command -v fzf &>/dev/null; then
    echo "fzf is required."
    return 1
  fi

  local commands
  # Commands available outside tmux (no current client needed)
  commands=$(cat <<'CMD'
[Session] new-session          | Create new session 新建会话
[Session] attach-session       | Attach to session 连接会话
CMD
)

  # Commands that require being inside tmux
  if [[ -n "$TMUX" ]]; then
    commands+=$'\n'$(cat <<'CMD'
[Session] kill-session         | Kill current session 删除当前会话
[Session] rename-session       | Rename session 重命名会话
[Session] detach-client        | Detach from session 脱离会话
[Session] switch-client        | Switch to another session 切换会话
[Window]  new-window           | Create new window 新建窗口
[Window]  kill-window          | Kill current window 关闭窗口
[Window]  rename-window        | Rename window 重命名窗口
[Window]  next-window          | Go to next window 下一窗口
[Window]  previous-window      | Go to previous window 上一窗口
[Window]  select-window        | Select window by index 按编号选择窗口
[Pane]    split-window -h      | Split horizontal 水平分割
[Pane]    split-window -v      | Split vertical 垂直分割
[Pane]    kill-pane            | Kill current pane 关闭面板
[Pane]    resize-pane -Z       | Toggle zoom 切换全屏
[Pane]    swap-pane -U         | Move pane up 面板上移
[Pane]    swap-pane -D         | Move pane down 面板下移
[Layout]  select-layout even-horizontal  | Even horizontal layout 均匀水平布局
[Layout]  select-layout even-vertical    | Even vertical layout 均匀垂直布局
[Layout]  select-layout tiled            | Tiled layout 平铺布局
[Misc]    display-message      | Display message 显示消息
[Misc]    clock-mode           | Show clock 显示时钟
[Misc]    clear-history        | Clear pane history 清除面板历史
CMD
)
  fi

  local selected
  selected=$(echo "$commands" | fzf \
    --height=~70% \
    --header "Select command to execute / 选择要执行的命令" \
    --border --border-label="$(_tx_env) commands " \
    --preview-window=hidden)

  [[ -z "$selected" ]] && return

  # Extract the tmux command (between ] and |)
  local tmux_cmd
  tmux_cmd=$(echo "$selected" | sed 's/.*] *//;s/ *|.*//')

  # Route special commands to custom handlers
  case "$tmux_cmd" in
    new-session) _tx_new_session; return ;;
    attach-session) _tx_session; return ;;
  esac

  echo "Running: tmux $tmux_cmd"
  eval "tmux $tmux_cmd"
}

# ── tx w: window switcher ────────────────────────────
_tx_win() {
  if ! command -v fzf &>/dev/null; then
    echo "fzf is required."
    return 1
  fi

  local windows
  windows=$(tmux list-windows -a -F "#{session_name}:#{window_index} | #{window_name} | #{pane_current_path}" 2>/dev/null)

  if [[ -z "$windows" ]]; then
    echo "No tmux windows found."
    return 1
  fi

  local selected
  selected=$(echo "$windows" | fzf \
    --height=~70% \
    --header "Select window / 选择窗口" \
    --preview 'tmux capture-pane -ep -t "$(echo {} | cut -d"|" -f1 | tr -d " ")" 2>/dev/null || echo "No preview"' \
    --preview-window=up:75% \
    --border --border-label="$(_tx_env) windows ")

  [[ -z "$selected" ]] && return

  local target
  target=$(echo "$selected" | cut -d'|' -f1 | tr -d ' ')

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$target"
  else
    tmux attach-session -t "$target"
  fi
}
