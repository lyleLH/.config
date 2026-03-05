return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<c-\\>", desc = "Toggle terminal" },
		{ "<leader>Tt", desc = "Float terminal" },
		{ "<leader>Th", desc = "Horizontal terminal" },
		{ "<leader>Tv", desc = "Vertical terminal" },
		{ "<leader>Tn", desc = "Node terminal" },
		{ "<leader>Tp", desc = "Python terminal" },
	},
	cmd = {
		"ToggleTerm",
		"TermExec",
		"ToggleTermToggleAll",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualLines",
		"ToggleTermSendVisualSelection",
	},
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		on_create = function()
			vim.opt.foldcolumn = "0"
			vim.opt.signcolumn = "no"
		end,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = 0.3,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			width = function()
				return math.floor(vim.o.columns * 0.8)
			end,
			height = function()
				return math.floor(vim.o.lines * 0.8)
			end,
			winblend = 3,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		local Terminal = require("toggleterm.terminal").Terminal

		local node = Terminal:new({
			cmd = "node",
			hidden = true,
			direction = "float",
		})

		local python = Terminal:new({
			cmd = "python3",
			hidden = true,
			direction = "float",
		})

		_G.terminals = {
			node = node,
			python = python,
		}

		-- Terminal keymaps
		vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
		vim.keymap.set("n", "<leader>Tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
		vim.keymap.set("n", "<leader>Th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
		vim.keymap.set("n", "<leader>Tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
		vim.keymap.set("n", "<leader>Tn", function() _G.terminals.node:toggle() end, { desc = "Node terminal" })
		vim.keymap.set("n", "<leader>Tp", function() _G.terminals.python:toggle() end, { desc = "Python terminal" })

		-- Terminal mode mappings
		function _G.set_terminal_keymaps()
			local topts = { buffer = 0, silent = true, noremap = true }
			vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", topts)
			vim.keymap.set("t", "jk", "<C-\\><C-n>", topts)
			vim.keymap.set("t", "kj", "<C-\\><C-n>", topts)
			vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", topts)
			vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", topts)
			vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", topts)
			vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", topts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.signcolumn = "no"
				vim.cmd("startinsert")
			end,
		})
	end,
}
