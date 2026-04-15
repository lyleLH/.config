#!/bin/bash
# cmux-tmux-sync.sh — 同步已有 tmux session 到 cmux workspace
# 用法：cmux 启动后跑一次，或加到 Login Items / LaunchAgent
#
# 逻辑：
#   1. 有已存在的 tmux session → 为每个创建 cmux workspace 并 attach
#   2. 没有 tmux session → 不做任何事（新建由 zshrc 自动处理）
#
# Edge case 处理：
#   - cmux 未启动：等待最多 15 秒后退出
#   - tmux 未运行：静默退出
#   - 同名 workspace 已存在：跳过
#   - cmux 默认 workspace（空 shell）：不影响，只额外创建

# 等 cmux socket 就绪
for i in $(seq 1 30); do
  cmux ping &>/dev/null && break
  sleep 0.5
done

if ! cmux ping &>/dev/null; then
  echo "cmux 未启动，退出"
  exit 1
fi

# 获取已有 tmux session 列表
sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

if [[ -z "$sessions" ]]; then
  echo "没有已存在的 tmux session，跳过"
  exit 0
fi

# 获取已有 cmux workspace 名称
existing_workspaces=$(cmux list-workspaces 2>/dev/null)

while IFS= read -r session_name; do
  # 跳过空名
  [[ -z "$session_name" ]] && continue

  # 跳过已存在同名 workspace
  if echo "$existing_workspaces" | grep -qF "$session_name"; then
    echo "workspace '$session_name' 已存在，跳过"
    continue
  fi

  echo "创建 workspace '$session_name' → tmux session '$session_name'"
  # 用 --command 直接 attach，这样打开 workspace 就进入 tmux
  cmux new-workspace --name "$session_name" \
    --command "tmux new-session -As \"$session_name\""
done <<< "$sessions"

echo "同步完成"
