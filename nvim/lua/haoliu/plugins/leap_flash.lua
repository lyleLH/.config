--
-- 按 f → 使用 Leap.nvim 进行双字符快速跳转
-- 按 s → 使用 Flash.nvim 进行模糊搜索
-- 按 S（大写） → 使用 Flash.nvim 进行 Treesitter 代码跳转

return {
	-- Leap.nvim（双字符快速跳转）
	{
		"ggandor/leap.nvim",
		config = function()
			local leap = require("leap")
			-- 不使用默认映射，仅自定义 'f' 键
			vim.keymap.set("n", "<leader>f", function()
				leap.leap({ target_windows = { vim.fn.win_getid() } })
			end, { desc = "Leap 双字符跳转" })
		end,
	},

	-- Flash.nvim（模糊搜索 & Treesitter 代码跳转）
	{
		"folke/flash.nvim",
		-- 如果频繁使用，移除 event 或改为 BufReadPre
		event = "VeryLazy",
		config = function()
			require("flash").setup({
				modes = {
					char = { enabled = true }, -- 字符搜索
					search = { enabled = true }, -- 模糊搜索
				},
				highlight = {
					label = { rainbow = { enabled = true } },
				},
			})

			-- 自定义快捷键
			vim.keymap.set("n", "<leader>s", function()
				require("flash").jump()
			end, { desc = "Flash 模糊搜索" })
			vim.keymap.set("n", "<leader>S", function()
				require("flash").treesitter()
			end, { desc = "Flash Treesitter 跳转" })
		end,
	},
}
