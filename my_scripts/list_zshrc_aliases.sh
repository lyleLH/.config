#!/bin/bash

# 脚本功能：列出 ~/.zshrc 中定义的所有 alias

ZSHRC_FILE="$HOME/.zshrc"

# 检查 ~/.zshrc 文件是否存在
if [ ! -f "$ZSHRC_FILE" ]; then
    echo "错误：未找到 $ZSHRC_FILE 文件。"
    echo "请确保你使用的是 zsh，并且 alias 定义在 ~/.zshrc 中。"
    exit 1
fi

echo "=== $ZSHRC_FILE 中定义的所有 alias ==="
# 使用 grep 提取 alias 定义，忽略注释行和空行
grep -v "^\s*#" "$ZSHRC_FILE" | grep -E "^\s*alias\s" | while read -r line; do
    # 去除前导空格
    line=$(echo "$line" | sed "s/^\s*//")
    # 提取 alias 名称和命令
    if [[ $line =~ ^alias\ ([^=]+)=(.+)$ ]]; then
        alias_name="${BASH_REMATCH[1]}"
        alias_cmd="${BASH_REMATCH[2]}"
        # 去除命令两端的引号（单引号或双引号）
        alias_cmd=$(echo "$alias_cmd" | sed "s/^['\"]//; s/['\"]$//")
        echo "Alias: $alias_name -> $alias_cmd"
    fi
done

# 如果没有找到 alias，提示用户
if [ -z "$(grep -E "^\s*alias\s" "$ZSHRC_FILE")" ]; then
    echo "未在 $ZSHRC_FILE 中找到任何 alias 定义。"
fi

echo -e "\n提示：请确保已通过 'source ~/.zshrc' 加载 alias，或者重启终端以生效。"
