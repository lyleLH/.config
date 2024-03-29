require("haoliu.plugins-setup")
require("haoliu.core.options")
require("haoliu.core.keymaps")
require("haoliu.core.colorscheme")
require("haoliu.plugins.comment")
-- require("haoliu.plugins.nvim-tree")
require("haoliu.plugins.lualine")
require("haoliu.plugins.telescope")
require("haoliu.plugins.nvim-cmp")
require("haoliu.plugins.lsp.mason")
require("haoliu.plugins.lsp.lspsaga")
require("haoliu.plugins.lsp.lspconfig")
require("haoliu.plugins.lsp.null-ls")
require("haoliu.plugins.autopairs")
require("haoliu.plugins.treesitter")
require("haoliu.plugins.gitsigns")
require("haoliu.plugins.toggleterm")

require("haoliu.plugins.whichkey")
require("haoliu.plugins.harpoon")

require("haoliu.plugins.hop")
require("haoliu.plugins.wilder")
-- require("haoliu.plugins.flutter-tools")

-- require("haoliu.plugins.light-bulb")
-- require("haoliu.plugins.ufo")

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here

	-- vim.o.guifont = ""
	vim.opt.guifont = { "BlexMono Nerd Font Mono", ":h16" }
	-- vim.opt.guifont = { "CaskaydiaCove Nerd Font", ":h20" }
	-- vim.opt.guifont = { "Hack Nerd Font", ":h18" }

	-- vim.opt.guifont = { "Fira Code", ":h15" }

	vim.g.neovide_cursor_animation_length = 0.03
	vim.g.neovide_cursor_trail_length = 0.5
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_padding_top = 20
	vim.g.neovide_padding_bottom = 20
	vim.g.neovide_padding_right = 20
	vim.g.neovide_padding_left = 20
	vim.g.neovide_fullscreen = true
	-- Helper function for transparency formatting
	-- local alpha = function()
	-- 	return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
	-- end
	-- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
	-- vim.g.neovide_transparency = 0.0
	-- vim.g.transparency = 1
	-- vim.g.neovide_background_color = "#12121e" .. alpha()
	-- vim.g.neovide_foreground_color = "#e0def4" .. alpha()
	--
	-- vim.g.neovide_background_color = "#282828" .. alpha()
	-- vim.g.neovide_background_color = "#1e1e1e" .. alpha()

	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
end

if vim.g.vscode then
	-- VSCode extension
	-- vim.opt.guifont = { "CaskaydiaCove Nerd Font", ":h18" }
	vim.opt.guifont = { "Fira Code", ":h15" }
end
