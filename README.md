# .dotfiles

my dotfile for neovim zsh omz and others


## 两个关键的路径

- .zshrc
- .config/

当你迁移到一台新的mac, zsh 是默认的 shell 之一

但是zsh的配置较为复杂(?)，所以基本都会安装 `oh-mh-zsh`

这个仓库中已经含有了zsh的配置入口文件`.zshrc`，后面符号链接到电脑的根目录下。


## 创建符号链接

### 🎯 符号链接的工作原理

当你使用 ln -s 创建一个符号链接时：

- 符号链接（symlink）只是一个指向原始文件或目录的“快捷方式”。

- 修改符号链接指向的目录或文件时，修改的实际上是原始目录或文件的内容。

### 链接 `.zshrc`

`ln -s ~/my-config-repo/.config/zsh/.zshrc ~/.zshrc`

### 链接 `.config/`

`ln -s ~/my-config-repo/.config ~/.config`


## 安装omz

`.zshrc` 会依赖 omz 目录，而 omz 是另外一个 git 项目，所以需要手动安装一下 omz

```

git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

```
这里clone到链接过的路径，也是ok的


### 推荐安装方式

或者 你单独 clone omz 之后，将 omz 链接到 .config/ 目录下

`ln -s ~/Documents/GitHub/oh-my-zsh ~/.config/`

### nvim 和 其他 app 后续的安装也都会安装在.config 目录下


## cmux + tmux 集成

[cmux](https://www.cmux.dev/) 是基于 Ghostty 的终端，侧边栏的每个 workspace 自动对应一个 tmux session，实现持久化。

### 映射关系

| cmux | tmux |
|------|------|
| workspace（侧边栏项） | session |
| tmux 内部管理 | window / pane |

### 工作原理

1. **zshrc 自动绑定**：cmux 终端启动时通过 `precmd` hook 获取当前 workspace 名称，自动 `exec tmux new-session -As <name>` 进入同名 tmux session
2. **同步脚本**：`cmux/cmux-tmux-sync.sh` 将已有 tmux session 批量创建为 cmux workspace

### 使用方式

```sh
# cmux 启动后同步已有 tmux session 到侧边栏
~/.config/cmux/cmux-tmux-sync.sh

# 手动新建 workspace 时，命名后自动创建同名 tmux session
# 关掉 cmux 后 tmux session 不丢，重开后自动 reattach
```

### 注意事项

- workspace 命名避免 `.` `:` `/` `\` 等特殊字符（会被替换为 `-`）
- 每个 workspace 保留 1 个 surface，window/pane 由 tmux 管理
- tmux 持久化依赖 `tmux-resurrect` + `tmux-continuum` 插件