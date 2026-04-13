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
			{ "<leader>g", group = "Git (Telescope)" },
			{ "<leader>h", group = "Git (Hunks)" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>w", group = "Workspace" },
			{ "<leader>m", group = "Misc" },
			{ "<leader>T", group = "Terminal" },
			{ "<leader>F", group = "Flutter" },
			{ "<leader>c", group = "Code" },
			{ "<leader>r", group = "Refactor" },
			{ "<leader>n", group = "Nvim-Tree" },
			{ "<leader>a", group = "AI/Claude" },
			{ "<leader>x", group = "Xcodebuild" },
			{ "[", group = "Previous" },
			{ "]", group = "Next" },
			{ "g", group = "Go to" },

			-- Cheatsheet (display only, no action)
			{ "<leader>?", group = "Cheatsheet" },
			{ "<leader>?f", function() end, desc = ":w <path>  Save new file with path" },
			{ "<leader>?F", function() end, desc = ":saveas <path>  Save as new name" },
			{ "<leader>?r", function() end, desc = ":e <path>  Open/reload file" },
			{ "<leader>?d", function() end, desc = ":!mkdir -p <dir>  Create directory" },
			{ "<leader>?R", function() end, desc = ":file <name>  Rename current buffer" },
			{ "<leader>?x", function() end, desc = ":!rm <path>  Delete file" },
			{ "<leader>?c", function() end, desc = ":cd <dir>  Change working directory" },
			{ "<leader>?p", function() end, desc = ":pwd  Show current directory" },
			{ "<leader>?b", function() end, desc = ":bd  Close current buffer" },
			{ "<leader>?s", function() end, desc = ":source %  Source current file" },
			{ "<leader>?m", function() end, desc = ":%s/old/new/g  Replace all in file" },
			{ "<leader>?e", function() end, desc = ":enew  New empty buffer" },

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
