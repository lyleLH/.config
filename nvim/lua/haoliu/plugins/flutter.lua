return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
	},
	config = function()
		if vim.g.vscode then
			return
		end

		local flutter_path = vim.fn.trim(vim.fn.system("which flutter"))
		local dart_bin = vim.fn.trim(vim.fn.system("which dart"))
		local dart_sdk = vim.fn.trim(vim.fn.system("dart --print-sdk-path 2>/dev/null"))

		require("flutter-tools").setup({
			ui = {
				border = "rounded",
				notification_style = "native",
			},
			decorations = {
				statusline = {
					app_version = true,
					device = true,
				},
			},
			debugger = {
				enabled = not vim.g.vscode,
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
					dart_bin,
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
				-- Generic LSP bindings (gd, gD, gi, K) are handled by
				-- lspconfig.lua's LspAttach autocmd — no need to duplicate here.
				-- Only Flutter-specific commands below.
				on_attach = function(client, bufnr)
					if vim.g.vscode then
						return
					end

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
