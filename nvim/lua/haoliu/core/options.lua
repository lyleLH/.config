vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- 命令行补全（:w 时按 Tab 补全路径）
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- 保存撤销历史，即使关闭 Neovim 也能恢复
opt.undofile = true
opt.undodir = vim.fn.expand("~/.nvim/undo") -- 确保目录存在

-- 设置剪贴板选项
opt.clipboard = "unnamedplus"
opt.scrolloff = 15
-- 显示行号
opt.relativenumber = true
opt.number = true

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    opt.scroll = math.floor(vim.o.lines / 2)
  end,
})
opt.scroll = math.floor(vim.o.lines / 2)
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })


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
-- Auto-detect macOS appearance for dark/light mode
local function set_bg_from_macos()
  local result = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if result:match("Dark") then
    opt.background = "dark"
  else
    opt.background = "light"
  end
end
set_bg_from_macos()

-- Re-check on focus (e.g. after toggling macOS appearance)
vim.api.nvim_create_autocmd("FocusGained", {
  callback = set_bg_from_macos,
})
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- Set font for GUI clients (Neovide, etc.)
opt.guifont = { "CaskaydiaCove Nerd Font", ":h14" }

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

opt.guicursor = "n-v-c:block-blinkwait700-blinkon400-blinkoff250,i:ver25-blinkwait500-blinkon300-blinkoff300"
