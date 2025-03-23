vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- 保存撤销历史，即使关闭 Neovim 也能恢复
opt.undofile = true
opt.undodir = vim.fn.expand("~/.nvim/undo") -- 确保目录存在

-- 设置剪贴板选项
opt.clipboard = "unnamedplus"
opt.scrolloff = 15
-- 显示行号
opt.relativenumber = true
opt.number = true

opt.scroll = 20
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

opt.wrap = true
opt.textwidth = 80
opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#72e77a" })

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- Set font for GUI clients (Neovide, etc.)
opt.guifont = { "CaskaydiaCove Nerd Font", ":h14" }

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

opt.guicursor = "n-v-c:block-blinkwait700-blinkon400-blinkoff250,i:ver25-blinkwait500-blinkon300-blinkoff300"
