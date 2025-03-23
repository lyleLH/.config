return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- 替换 dressing.nvim 为 snacks.nvim
	},
	config = function()
		-- 检查是否在 VSCode 中运行
		if vim.g.vscode then
			return  -- 在 VSCode 中不加载 flutter-tools
		end

		-- 获取 Flutter 和 Dart SDK 路径
		local flutter_path = vim.fn.trim(vim.fn.system("which flutter"))
		local dart_sdk = vim.fn.trim(vim.fn.system("which dart"))

		require("flutter-tools").setup({
			ui = {
				-- the border type to use for all floating windows, the same options/formats
				-- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
				border = "rounded",
				notification_style = "native",
			},
			decorations = {
				statusline = {
					-- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
					app_version = true,
					-- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
					device = true,
				},
			},
			debugger = {
				enabled = not vim.g.vscode, -- 在 VSCode 中禁用调试器
				run_via_dap = not vim.g.vscode,
			},
			flutter_path = flutter_path,
			dart_sdk_path = dart_sdk,
			widget_guides = {
				enabled = true,
			},
			closing_tags = {
				highlight = "ErrorMsg",
				prefix = "//",
				enabled = true,
			},
			lsp = {
				cmd = {
					dart_sdk,
					"language-server",
					"--protocol=lsp",
				},
				color = {
					enabled = true,
					background = true,
					virtual_text = true,
				},
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					enableSnippets = true,
					dart = {
						sdkPath = dart_sdk,
						analysisExcludedFolders = {
							vim.fn.expand("$HOME/.pub-cache"),
							vim.fn.expand("$HOME/.local/share/nvim"),
						},
					},
				},
				-- 在这里配置 LSP 的具体行为
				on_attach = function(client, bufnr)
					if vim.g.vscode then
						return  -- 在 VSCode 中不设置键位映射
					end

					-- 设置基础 LSP 键位映射
					local opts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

					-- Flutter 命令映射 - 与 which-key 保持一致
					local keymap = vim.keymap
					keymap.set("n", "<leader>Fc", "<cmd>FlutterCopyProfilerUrl<cr>", { desc = "Copy profiler URL", buffer = bufnr })
					keymap.set("n", "<leader>Fr", "<cmd>FlutterRun<cr>", { desc = "Run", buffer = bufnr })
					keymap.set("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Quit", buffer = bufnr })
					keymap.set("n", "<leader>FR", "<cmd>FlutterReload<cr>", { desc = "Reload", buffer = bufnr })
					keymap.set("n", "<leader>FS", "<cmd>FlutterRestart<cr>", { desc = "Restart", buffer = bufnr })
					keymap.set("n", "<leader>Fd", "<cmd>FlutterDevices<cr>", { desc = "Devices", buffer = bufnr })
					keymap.set("n", "<leader>FD", "<cmd>FlutterDetach<cr>", { desc = "Detach", buffer = bufnr })
				end,
			},
		})
	end,
}
