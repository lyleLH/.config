# .dotfiles

my dotfile for neovim zsh omz and others

### nvim

** m1 chip Mac **

```shell
arch -arm64 brew install neovim

```

** m1 chip Mac **

- 使用系统自带的终端 进入 nvim 目录，等待 Packer 下载和编译好插件

- 等待 Treesitter 下载好 parser 并且编译好

then clone this repo to ‘~/.config/’

### zsh

in `~/.zshrc` file :

```shell
# enable powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

source $ZSH/oh-my-zsh.sh

if [ -r ~/.config/zsh/.zshrc ]; then
    source ~/.config/zsh/.zshrc
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

```

manuly install `oh-my-zsh` and 'powerlevel10k'

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### tmux

brew install tmux

ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf

### kitty
