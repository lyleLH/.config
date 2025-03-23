return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1001,
		config = function()
			local transparent = false -- set to true if you would like to enable transparency

			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
				transparent = transparent,
				styles = {
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
					comments = { italic = true },
					keywords = { italic = false },
					functions = { bold = true },
					variables = { italic = false },
					types = { italic = false },
					strings = { italic = false },
				},
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = transparent and colors.none or bg_dark
					colors.bg_float = transparent and colors.none or bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = transparent and colors.none or bg_dark
					colors.bg_statusline = transparent and colors.none or bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
				integrations = {
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = false,
					},
				},
			})
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = {
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false,
				show_end_of_buffer = false,
				term_colors = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = { "italic" },
					keywords = { "italic" },
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = false,
					},
					telescope = true,
					notify = true,
					mini = true,
					aerial = true,
					mason = true,
					semantic_tokens = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
				},
			})
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				colors = {
					palette = {},
					theme = {
						wave = {},
						lotus = {},
						dragon = {},
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptNormal = { bg = theme.ui.bg_p1 },
						TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
						TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
						TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
						TelescopePreviewNormal = { bg = theme.ui.bg_dim },
						TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
					}
				end,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
				integrations = {
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = false,
					},
				},
			})
		end,
	},

	{
		"loctvl842/monokai-pro.nvim",
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				transparent_background = false,
				terminal_colors = true,
				devicons = true,
				filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
				day_night = {
					enable = true,
					day_filter = "pro",
					night_filter = "spectrum",
				},
				inc_search = "background", -- underline | background
				background_clear = {
					"nvim-tree",
					"bufferline",
					"telescope",
					"toggleterm",
				},
				plugins = {
					bufferline = {
						underline_selected = true,
						underline_visible = false,
						underline_fill = true,
						bold = false,
					},
					indent_blankline = {
						context_highlight = "pro",
						context_start_underline = true,
					},
					telescope = {
						enabled = true,
						style = "default", -- default | flat
					},
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = false,
					},
				},
			})
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					compile_path = vim.fn.stdpath("cache") .. "/nightfox",
					compile_file_suffix = "_compiled",
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic,bold",
					},
					transparent = false,
					terminal_colors = true,
					modules = {
						diagnostic = {
							enable = true,
							background = true,
						},
						native_lsp = {
							enable = true,
							background = true,
						},
						treesitter = true,
						telescope = true,
						cmp = true,
						gitsigns = true,
						whichkey = true,
						indent_blankline = true,
						dashboard = true,
						nvimtree = {
							enabled = true,
							show_root = true,
							transparent_panel = false,
						},
					},
				},
				palettes = {},
				specs = {},
				groups = {},
			})

			vim.cmd("colorscheme nightfox")
		end,
	},

	{
		"AlexvZyl/nordic.nvim",
		priority = 1000,
		config = function()
			require('nordic').setup({
				italic_comments = true,
				bold_keywords = true,
				transparent = {
					bg = false,
					float = false,
				},
				bright_border = false,
				reduced_blue = true,
				cursorline = {
					bold = false,
					bold_number = true,
					theme = 'dark',
					blend = 0.85,
				},
				telescope = {
					style = 'flat',
				},
				noice = {
					style = 'flat',
				},
				ts_context = {
					dark_background = true,
				},
				integrations = {
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = false,
					},
				},
				on_palette = function(palette) 
				end,
				on_highlight = function(highlights, palette)
				end,
			})
		end,
	},
}
