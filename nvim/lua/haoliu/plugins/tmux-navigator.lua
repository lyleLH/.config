return {
	"christoomey/vim-tmux-navigator",
	event = "VeryLazy",
	config = function()
		-- 设置 tmux 导航器的键位映射
		vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { desc = "Navigate Left" })
		vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { desc = "Navigate Down" })
		vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { desc = "Navigate Up" })
		vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { desc = "Navigate Right" })
		vim.keymap.set("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", { desc = "Navigate Previous" })
	end,
} 