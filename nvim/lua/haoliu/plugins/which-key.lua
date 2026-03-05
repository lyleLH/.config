return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = true,
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},
		win = {
			border = "single",
			padding = { 1, 2 },
		},
		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Group labels only — actual keybindings live in their respective plugin files
		wk.add({
			{ "<leader>f", group = "Find/Files" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>s", group = "Split" },
			{ "<leader>t", group = "Tabs/Theme" },
			{ "<leader>h", group = "Git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>w", group = "Workspace" },
			{ "<leader>m", group = "Misc" },
			{ "<leader>T", group = "Terminal" },
			{ "<leader>F", group = "Flutter" },
			{ "<leader>c", group = "Code" },
			{ "<leader>r", group = "Refactor" },
			{ "<leader>n", group = "Nvim-Tree" },
			{ "[", group = "Previous" },
			{ "]", group = "Next" },
			{ "g", group = "Go to" },

			-- Keybindings only defined here (no plugin file owns them)
			{
				"<leader>C",
				function() require("monokai-pro").select_filter() end,
				desc = "Select Monokai pro filter",
			},
			{ "<leader>lv", "<cmd>DiagnosticToggleVirtualText<cr>", desc = "Toggle virtual text/lines" },
			{ "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Info" },
		})
	end,
}
