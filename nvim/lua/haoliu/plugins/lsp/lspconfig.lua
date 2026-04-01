return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", ft = "lua", opts = {} },
	},
	config = function()
		if vim.g.vscode then
			return
		end

		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Capabilities for autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic signs (Neovim 0.11+)
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		-- Configure each server using vim.lsp.config (Neovim 0.11+)
		-- mason-lspconfig v2 auto-enables installed servers via vim.lsp.enable()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					pythonPath = vim.fn.trim(vim.fn.system("asdf which python")),
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		vim.lsp.config("svelte", {
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		})

		vim.lsp.config("graphql", {
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		vim.lsp.config("ts_ls", {
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		})

		vim.lsp.config("eslint", {
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		vim.lsp.config("emmet_ls", {
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
			},
		})

		vim.lsp.config("sourcekit", {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift", "objc", "objcpp" },
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				general = { positionEncodings = { "utf-16" } },
				offsetEncoding = { "utf-16" },
			}),
			root_markers = {
				"buildServer.json",
				"*.xcodeproj",
				"*.xcworkspace",
				"Package.swift",
				".git",
			},
		})
		vim.lsp.enable("sourcekit")

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
	end,
}
