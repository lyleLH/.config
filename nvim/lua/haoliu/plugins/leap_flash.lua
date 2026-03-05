-- s → Flash 模糊搜索跳转
-- S → Flash Treesitter 代码跳转

return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("flash").setup({
				modes = {
					char = { enabled = true },
					search = { enabled = false },
				},
				label = { rainbow = { enabled = true } },
			})

			vim.keymap.set("n", "<leader>s", function()
				require("flash").jump()
			end, { desc = "Flash 模糊搜索" })
			vim.keymap.set("n", "<leader>S", function()
				require("flash").treesitter()
			end, { desc = "Flash Treesitter 跳转" })
		end,
	},
}
