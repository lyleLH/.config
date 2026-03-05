

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
═══════════════════════════════════════════════════════
 prefix = Ctrl+a  (先按 Ctrl+a 松开，再按后续键)
═══════════════════════════════════════════════════════

[SESSION 会话]
prefix + d          | Detach 脱离会话
prefix + $          | Rename session 重命名会话
prefix + s          | List sessions 列出会话
prefix + o          | SessionX 会话管理器 (fzf搜索/预览/创建/删除)
prefix + g          | Sessionist: 输入名字跳转 session
prefix + C          | Sessionist: 新建 session
prefix + X          | Sessionist: kill 当前 session 并自动切换
prefix + @          | Sessionist: 把当前 pane 拆到新 session
  例: 当你想快速切换项目时 → prefix+o → fzf搜索 session → 回车切换

[WINDOW 窗口]
prefix + c          | New window 新建窗口 (自动显示 Nerd Font 图标)
prefix + ,          | Rename window 重命名窗口
prefix + w          | List windows 列出窗口
prefix + n          | Next window 下一窗口
prefix + p          | Previous window 上一窗口 (注意和 floax 的 p 不冲突，p 弹浮窗)
prefix + 1-9        | Go to window N 跳转窗口N
prefix + &          | Kill window 关闭窗口

[PANE 面板]
prefix + |          | Split horizontal 水平分割(左右)
prefix + -          | Split vertical 垂直分割(上下)
prefix + x          | Kill pane 关闭面板
prefix + m          | Toggle zoom 切换全屏
prefix + q          | Show pane numbers 显示面板编号
prefix + {          | Move pane left 面板左移
prefix + }          | Move pane right 面板右移
  例: 当你想边写代码边看日志 → prefix+| → 左边 nvim 右边 tail -f

[RESIZE 调整面板大小]
prefix + h/j/k/l   | 向左/下/上/右扩展 (可重复按)
  例: 当面板太小时 → prefix+l 连按3次 → 向右扩展15格

[NAVIGATE 导航]
Ctrl + h/j/k/l      | 跨面板导航 (vim-tmux-navigator, nvim里也能用)
  例: 当你在 nvim 里想跳到右边终端 → Ctrl+l → 直接跳过去

[COPY MODE 复制模式]
prefix + [          | Enter copy mode 进入复制模式
v                   | Begin selection 开始选择
y                   | Copy to clipboard (tmux-yank) 复制到系统剪贴板
o                   | Open file/URL (tmux-open) 打开选中的文件或链接
Ctrl+o              | Open with $EDITOR (tmux-open) 用 nvim 打开
q                   | Exit copy mode 退出复制模式
  例: 当你看到报错路径想打开 → prefix+[ → v选中路径 → o 直接打开

[SCREEN TEXT 屏幕文本提取]
prefix + Space      | Thumbs: 高亮屏幕上所有 URL/路径/hash → 按标签字母复制
prefix + Tab        | Extrakto: fzf 模糊搜索屏幕上所有文本 → 选中复制
prefix + j          | Jump: 输入字符 → 屏幕出现跳转标签 → 按标签跳过去
  例: 当你看到一个 git hash 想复制 → prefix+Space → 按对应字母 → 自动复制
  例: 当你想找屏幕上某个路径 → prefix+Tab → fzf搜索 → 回车复制
  例: 当你想跳到屏幕上某个位置 → prefix+j → 输入目标字符 → 按标签跳转

[POPUP 弹窗]
prefix + p          | Floax: 弹出/收起浮动终端 (不离开当前面板)
prefix + g          | 弹出临时终端 (关闭后消失)
prefix + G          | 弹出 lazygit
prefix + e          | 弹出 yazi 文件管理器
prefix + T          | 弹出本速查表
  例: 当你在写代码想快速 git commit → prefix+G → lazygit 操作 → q退出回来
  例: 当你想浏览文件 → prefix+e → yazi 里浏览 → q退出回来

[FZF 模糊搜索]
prefix + F          | tmux-fzf: 万能菜单 (session/window/pane/command/keybinding)
  例: 当你忘了某个快捷键 → prefix+F → 选 keybinding → fzf搜索

[SAVE & RESTORE 保存恢复]
prefix + Ctrl+s     | Resurrect: 手动保存所有 session
prefix + Ctrl+r     | Resurrect: 手动恢复 session
(自动)              | Continuum: 每15分钟自动保存，重启后自动恢复
  例: 当你要重启电脑 → 不用管，重新打开 tmux 自动恢复所有窗口

[LOGGING 日志]
prefix + P          | 开始/停止记录当前 pane 输出到文件
prefix + Alt+p      | 截取当前屏幕到文件
prefix + Alt+P      | 保存完整历史到文件
  例: 当你在 debug 想保存终端输出 → prefix+P 开始录 → 复现 bug → prefix+P 停止

[PROCESS 进程]
prefix + *          | Cowboy: 强制 kill 当前 pane 卡住的进程
  例: 当 npm install 卡死了 → prefix+* → 进程被 kill，pane 还在

[SSH NESTED 嵌套 tmux]
F12                 | 切换内外层 tmux (本地 ↔ 远程)
  例: 当你 SSH 到服务器且服务器也有 tmux → F12 切到内层 → 操作远程 tmux

[MISC 其他]
prefix + r          | Reload config 重新加载配置
prefix + I          | Install plugins (tpm) 安装插件
prefix + U          | Update plugins 更新插件
prefix + ?          | 显示所有快捷键 (原始格式)
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
