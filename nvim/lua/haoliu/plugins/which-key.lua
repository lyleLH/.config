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
		operators = {},
		key_labels = {},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		popup_mappings = {
			scroll_down = "<c-d>", -- binding to scroll down inside the popup
			scroll_up = "<c-u>", -- binding to scroll up inside the popup
		},
		window = {
			border = "single",
			position = "bottom",
			margin = { 1, 0, 1, 0 },
			padding = { 1, 2, 1, 2 },
			winblend = 0,
		},
		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
			align = "left",
		},
		ignore_missing = false,
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
		show_help = true,
		show_keys = true,
		triggers = "auto",
		triggers_nowait = {
			-- marks
			"`",
			"'",
			"g`",
			"g'",
			-- registers
			'"',
			"<c-r>",
			-- spelling
			"z=",
		},
		triggers_blacklist = {
			-- list of mode / prefixes that should never be hooked by WhichKey
			i = { "j", "k" },
			v = { "j", "k" },
			n = { "f", "s", "S" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Insert mode mappings
		wk.register({
			["<Tab>"] = {
				function()
					if vim.fn.pumvisible() == 1 then
						return "<C-n>"
					else
						return "<Tab>"
					end
				end,
				desc = "Next completion or tab",
				expr = true,
				replace_keycodes = false,
			},
			["<S-Tab>"] = { "<C-p>", desc = "Previous completion", expr = true, replace_keycodes = false },
			["jk"] = { "<ESC>", desc = "Exit insert mode", expr = true, replace_keycodes = false },
		}, { mode = "i" })

		-- Completion menu mappings
		wk.register({
			["<C-Space>"] = {
				function()
					require("cmp").complete()
				end,
				desc = "Show completion suggestions",
			},
			["<C-b>"] = {
				function()
					require("cmp").scroll_docs(-4)
				end,
				desc = "Scroll docs up",
			},
			["<C-e>"] = {
				function()
					require("cmp").abort()
				end,
				desc = "Close completion window",
			},
			["<C-f>"] = {
				function()
					require("cmp").scroll_docs(4)
				end,
				desc = "Scroll docs down",
			},
			["<C-j>"] = {
				function()
					require("cmp").select_next_item()
				end,
				desc = "Next suggestion",
			},
			["<C-k>"] = {
				function()
					require("cmp").select_prev_item()
				end,
				desc = "Previous suggestion",
			},
			["<CR>"] = {
				function()
					require("cmp").confirm({ select = false })
				end,
				desc = "Confirm completion",
			},
		}, { mode = "i" })

		-- Normal mode mappings
		wk.register({
			["<C-w>"] = {
				name = "+Window",
				["h"] = { "<C-w>h", desc = "Go to left window" },
				["j"] = { "<C-w>j", desc = "Go to window below" },
				["k"] = { "<C-w>k", desc = "Go to window above" },
				["l"] = { "<C-w>l", desc = "Go to right window" },
				["w"] = { "<C-w>w", desc = "Go to next window" },
				["v"] = { "<C-w>v", desc = "Split window vertically" },
				["s"] = { "<C-w>s", desc = "Split window horizontally" },
				["c"] = { "<C-w>c", desc = "Close current window" },
				["o"] = { "<C-w>o", desc = "Close other windows" },
				["="] = { "<C-w>=", desc = "Make windows equal size" },
				[">"] = { "<C-w>>", desc = "Increase window width" },
				["<"] = { "<C-w><", desc = "Decrease window width" },
				["+"] = { "<C-w>+", desc = "Increase window height" },
				["-"] = { "<C-w>-", desc = "Decrease window height" },
				["H"] = { "<C-w>H", desc = "Move window to far left" },
				["J"] = { "<C-w>J", desc = "Move window to bottom" },
				["K"] = { "<C-w>K", desc = "Move window to top" },
				["L"] = { "<C-w>L", desc = "Move window to far right" },
			},
			["<leader>"] = {
				n = {
					name = "+Nvim-Tree",
					["?"] = {
						name = "+Help",
						["?"] = {
							function()
								local help = {
									["Basic Operations"] = {
										["o/l/<CR>"] = "Open file/directory",
										["h"] = "Close directory",
										["v"] = "Open: Vertical split",
										["s"] = "Open: Horizontal split",
									},
									["File Operations"] = {
										["a"] = "Create file/directory",
										["r"] = "Rename",
										["d"] = "Delete",
										["x"] = "Cut",
										["c"] = "Copy",
										["p"] = "Paste",
										["y"] = "Copy name",
										["Y"] = "Copy relative path",
										["gy"] = "Copy absolute path",
									},
									["Navigation"] = {
										["f"] = "Find file",
										["F"] = "Live filter: All",
										["g"] = "Live filter: No hidden",
										["<C-k>"] = "Toggle file info",
										["[c"] = "Prev git item",
										["]c"] = "Next git item",
										["<BS>"] = "Navigate up",
									},
									["Folder Operations"] = {
										["H"] = "Toggle dotfiles",
										["I"] = "Toggle gitignore",
										["R"] = "Refresh",
										["q"] = "Close",
									},
								}

								-- 创建帮助信息
								local lines = { "Nvim-Tree Keybindings:", "" }
								for section, mappings in pairs(help) do
									table.insert(lines, section .. ":")
									for key, desc in pairs(mappings) do
										table.insert(lines, string.format("  %-12s: %s", key, desc))
									end
									table.insert(lines, "")
								end

								-- 显示帮助信息
								vim.api.nvim_echo({ { table.concat(lines, "\n"), "Normal" } }, true, {})
							end,
							"Show Nvim-Tree help",
						},
					},
				},

				f = {
					name = "+Find/Files",
					f = { "<cmd>Telescope find_files<cr>", desc = "Find files" },
					r = { "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
					s = { "<cmd>Telescope live_grep<cr>", desc = "Find string" },
					c = { "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },
					t = { "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
				},

				e = {
					name = "+Explorer",
					e = { "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
					f = { "<cmd>NvimTreeFindFileToggle<cr>", desc = "Focus file explorer" },
					c = { "<cmd>NvimTreeCollapse<cr>", desc = "Collapse file explorer" },
					r = { "<cmd>NvimTreeRefresh<cr>", desc = "Refresh file explorer" },
				},

				w = {
					name = "+Workspace",
					s = { "<cmd>SessionSave<cr>", desc = "Save session" },
					r = { "<cmd>SessionRestore<cr>", desc = "Restore session" },
				},

				t = {
					name = "+Tabs/Theme",
					o = { "<cmd>tabnew<cr>", desc = "Open new tab" },
					x = { "<cmd>tabclose<cr>", desc = "Close tab" },
					n = { "<cmd>tabn<cr>", desc = "Next tab" },
					p = { "<cmd>tabp<cr>", desc = "Previous tab" },
					f = { "<cmd>tabnew %<cr>", desc = "Move buffer to new tab" },
					t = { "<cmd>Telescope colorscheme<cr>", desc = "Switch colorscheme" },
				},

				s = {
					name = "+Split Windows",
					v = { "<C-w>v", desc = "Split vertical" },
					h = { "<C-w>s", desc = "Split horizontal" },
					e = { "<C-w>=", desc = "Make splits equal" },
					x = { "<cmd>close<cr>", desc = "Close split" },
					m = { "<cmd>MaximizerToggle<cr>", desc = "Toggle maximize" },
				},

				l = {
					name = "+LSP",
					d = { vim.diagnostic.open_float, desc = "Show line diagnostics" },
					D = { "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Show buffer diagnostics" },
					r = { vim.lsp.buf.rename, desc = "Rename" },
					s = { "<cmd>LspRestart<cr>", desc = "Restart LSP" },
					l = {
						function()
							require("lsp_lines").toggle()
						end,
						desc = "Toggle diagnostic lines",
					},
					v = { "<cmd>DiagnosticToggleVirtualText<cr>", desc = "Toggle virtual text/lines" },
					i = { "<cmd>LspInfo<cr>", desc = "LSP Info" },
				},

				x = {
					name = "+Trouble/Diagnostics",
					w = { "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
					d = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document diagnostics" },
					q = { "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix list" },
					l = { "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
					t = { "<cmd>Trouble todo toggle<cr>", desc = "TODOs" },
				},

				h = {
					name = "+Git",
					s = { "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
					r = { "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
					S = { "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
					R = { "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
					u = { "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
					p = { "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
					b = { "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
					B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle line blame" },
					d = { "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
				},

				F = {
					name = "+Flutter",
					c = { "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy profiler URL" },
					r = { "<cmd>FlutterRun<cr>", desc = "Run" },
					q = { "<cmd>FlutterQuit<cr>", desc = "Quit" },
					R = { "<cmd>FlutterReload<cr>", desc = "Reload" },
					S = { "<cmd>FlutterRestart<cr>", desc = "Restart" },
					d = { "<cmd>FlutterDevices<cr>", desc = "Devices" },
					D = { "<cmd>FlutterDetach<cr>", desc = "Detach" },
				},

				m = {
					name = "+Misc",
					p = {
						function()
							require("conform").format({
								lsp_fallback = true,
								async = false,
								timeout_ms = 1000,
							})
						end,
						desc = "Format file/selection",
					},
					a = { "<cmd>AerialToggle!<cr>", desc = "Toggle aerial" },
					l = {
						function()
							require("lint").try_lint()
						end,
						desc = "Trigger linting",
					},
				},

				-- Terminal commands
				T = {
					name = "+Terminal",
					t = { "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
					h = { "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
					v = { "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical terminal" },
					n = {
						function()
							_G.terminals.node:toggle()
						end,
						desc = "Node terminal",
					},
					p = {
						function()
							_G.terminals.python:toggle()
						end,
						desc = "Python terminal",
					},
					f = { "<cmd>FloatermNew<cr>", desc = "New floaterm" },
					k = { "<cmd>FloatermKill<cr>", desc = "Kill floaterm" },
					-- Previous/Next floaterm
					["["] = { "<cmd>FloatermPrev<cr>", desc = "Previous floaterm" },
					["]"] = { "<cmd>FloatermNext<cr>", desc = "Next floaterm" },
				},

				-- Other individual mappings
				C = {
					function()
						require("monokai-pro").select_filter()
					end,
					desc = "Select Monokai pro filter",
				},
				lg = { "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
				["+"] = { "<C-a>", desc = "Increment number" },
				["-"] = { "<C-x>", desc = "Decrement number" },
				nh = { "<cmd>nohl<cr>", desc = "Clear search highlights" },
			},

			["["] = {
				name = "+Previous",
				d = { vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
				h = { "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
				t = {
					function()
						require("todo-comments").jump_prev()
					end,
					desc = "Previous todo",
				},
			},

			["]"] = {
				name = "+Next",
				d = { vim.diagnostic.goto_next, desc = "Next diagnostic" },
				h = { "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
				t = {
					function()
						require("todo-comments").jump_next()
					end,
					desc = "Next todo",
				},
			},

			g = {
				name = "+Go to",
				R = { "<cmd>Telescope lsp_references<cr>", desc = "References" },
				D = { vim.lsp.buf.declaration, desc = "Declaration" },
				d = { "<cmd>Telescope lsp_definitions<cr>", desc = "Definition" },
				i = { "<cmd>Telescope lsp_implementations<cr>", desc = "Implementation" },
				t = { "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definition" },
			},
		})
	end,
}
