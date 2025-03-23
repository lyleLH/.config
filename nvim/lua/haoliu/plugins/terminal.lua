return {
  {
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

      -- Custom terminals
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      -- Node terminal
      local node = Terminal:new({ 
        cmd = "node",
        hidden = true,
        direction = "float",
      })

      -- Python terminal
      local python = Terminal:new({ 
        cmd = "python3",
        hidden = true,
        direction = "float",
      })

      -- Export terminals to be used in keymaps
      _G.terminals = {
        lazygit = lazygit,
        node = node,
        python = python,
      }

      -- Register which-key mappings
      local wk = require("which-key")
      wk.register({
        ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", "Toggle terminal" },
        ["<leader>T"] = {
          name = "+terminal",
          t = { "<cmd>ToggleTerm direction=float<cr>", "Float terminal" },
          h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal terminal" },
          v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical terminal" },
          n = { function() _G.terminals.node:toggle() end, "Node terminal" },
          p = { function() _G.terminals.python:toggle() end, "Python terminal" },
          ["["] = { "<cmd>ToggleTerm<cr>", "Previous terminal" },
          ["]"] = { "<cmd>ToggleTerm<cr>", "Next terminal" },
        },
      })

      -- Terminal keymaps
      vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
      vim.keymap.set("n", "<leader>Tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
      vim.keymap.set("n", "<leader>Th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
      vim.keymap.set("n", "<leader>Tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
      vim.keymap.set("n", "<leader>Tn", function() _G.terminals.node:toggle() end, { desc = "Node terminal" })
      vim.keymap.set("n", "<leader>Tp", function() _G.terminals.python:toggle() end, { desc = "Python terminal" })

      -- Terminal mode mappings
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0, silent = true, noremap = true }
        -- 使用更简单的 ESC 映射
        vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)
        vim.keymap.set("t", "jk", "<C-\\><C-n>", opts)
        -- 添加 kj 作为备选
        vim.keymap.set("t", "kj", "<C-\\><C-n>", opts)
        -- 窗口导航，不需要先退出终端模式
        vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
        vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
        vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
        vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
      end

      -- Auto-set terminal keymaps
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- 添加提示信息并设置终端选项
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          -- 设置终端特定选项
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
          -- 自动进入插入模式
          vim.cmd("startinsert")
          -- 显示提示信息
          local msg = "Terminal tips: Press ESC or jk/kj to exit terminal mode"
          vim.api.nvim_echo({{msg, "WarningMsg"}}, false, {})
        end,
      })
    end,
  },
  {
    "voldikss/vim-floaterm",
    dependencies = {
      "folke/which-key.nvim",
    },
    keys = {
      { "<leader>Tf", "<cmd>FloatermNew<cr>", desc = "New floaterm" },
      { "<leader>Tk", "<cmd>FloatermKill<cr>", desc = "Kill floaterm" },
      { "<leader>T[", "<cmd>FloatermPrev<cr>", desc = "Previous floaterm" },
      { "<leader>T]", "<cmd>FloatermNext<cr>", desc = "Next floaterm" },
      { "<leader>Th", "<cmd>FloatermHide<cr>", desc = "Hide floaterm" },
      { "<leader>Ts", "<cmd>FloatermShow<cr>", desc = "Show floaterm" },
      { "<leader>Tt", "<cmd>FloatermToggle<cr>", desc = "Toggle floaterm" },
    },
    cmd = {
      "FloatermNew",
      "FloatermToggle",
      "FloatermPrev",
      "FloatermNext",
      "FloatermKill",
      "FloatermHide",
      "FloatermShow",
    },
    config = function()
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
      vim.g.floaterm_title = "Terminal $1/$2"
      vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
      vim.g.floaterm_autoclose = 1

      -- Register which-key mappings for floaterm
      local wk = require("which-key")
      wk.register({
        ["<leader>T"] = {
          name = "+terminal",
          f = { "<cmd>FloatermNew<cr>", "New floating terminal" },
          k = { "<cmd>FloatermKill<cr>", "Kill terminal" },
          ["["] = { "<cmd>FloatermPrev<cr>", "Previous terminal" },
          ["]"] = { "<cmd>FloatermNext<cr>", "Next terminal" },
          h = { "<cmd>FloatermHide<cr>", "Hide terminal" },
          s = { "<cmd>FloatermShow<cr>", "Show terminal" },
          t = { "<cmd>FloatermToggle<cr>", "Toggle terminal" },
        },
      })

      -- Set up keymaps (保持现有的普通模式映射)
      vim.keymap.set("n", "<leader>Tf", "<cmd>FloatermNew<cr>", { desc = "New floaterm" })
      vim.keymap.set("n", "<leader>Tk", "<cmd>FloatermKill<cr>", { desc = "Kill floaterm" })
      vim.keymap.set("n", "<leader>T[", "<cmd>FloatermPrev<cr>", { desc = "Previous floaterm" })
      vim.keymap.set("n", "<leader>T]", "<cmd>FloatermNext<cr>", { desc = "Next floaterm" })
      vim.keymap.set("n", "<leader>Th", "<cmd>FloatermHide<cr>", { desc = "Hide floaterm" })
      vim.keymap.set("n", "<leader>Ts", "<cmd>FloatermShow<cr>", { desc = "Show floaterm" })
      vim.keymap.set("n", "<leader>Tt", "<cmd>FloatermToggle<cr>", { desc = "Toggle floaterm" })

      -- 简化 floaterm 的终端模式映射
      vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
      vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
      vim.keymap.set("t", "kj", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
} 