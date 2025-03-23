-- VSCode Neovim 配置
local keymap = vim.keymap

-- 设置leader键
vim.g.mapleader = ","

-- 基础键位映射
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- 文件操作
vim.api.nvim_set_keymap('n', '<leader>ff', ':call VSCodeNotify("workbench.action.quickOpen")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fs', ':call VSCodeNotify("workbench.action.files.save")<CR>', { silent = true, noremap = true })

-- 编辑器操作
vim.api.nvim_set_keymap('n', '<leader>e', ':call VSCodeNotify("workbench.action.toggleSidebarVisibility")<CR>', { silent = true, noremap = true })

-- 搜索
vim.api.nvim_set_keymap('n', '<leader>fw', ':call VSCodeNotify("workbench.action.findInFiles")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fr', ':call VSCodeNotify("workbench.action.replaceInFiles")<CR>', { silent = true, noremap = true })

-- 代码操作
vim.api.nvim_set_keymap('n', 'gd', ':call VSCodeNotify("editor.action.revealDefinition")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'gr', ':call VSCodeNotify("editor.action.goToReferences")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rn', ':call VSCodeNotify("editor.action.rename")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ca', ':call VSCodeNotify("editor.action.quickFix")<CR>', { silent = true, noremap = true })

-- 注释
vim.api.nvim_set_keymap('x', 'gc', ':call VSCodeNotify("editor.action.commentLine")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'gcc', ':call VSCodeNotify("editor.action.commentLine")<CR>', { silent = true, noremap = true })

-- 窗口管理
vim.api.nvim_set_keymap('n', '<leader>sv', ':call VSCodeNotify("workbench.action.splitEditor")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sh', ':call VSCodeNotify("workbench.action.splitEditorOrthogonal")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sx', ':call VSCodeNotify("workbench.action.closeActiveEditor")<CR>', { silent = true, noremap = true })

-- 终端
vim.api.nvim_set_keymap('n', '<leader>t', ':call VSCodeNotify("workbench.action.terminal.toggleTerminal")<CR>', { silent = true, noremap = true }) 