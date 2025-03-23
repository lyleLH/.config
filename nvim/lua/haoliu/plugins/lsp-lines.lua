return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  event = "LspAttach",
  keys = {
    {
      "<leader>ll",
      function()
        require("lsp_lines").toggle()
      end,
      desc = "Toggle LSP Lines",
    },
  },
  config = function()
    require("lsp_lines").setup()
    
    -- 默认禁用 virtual_text，因为我们使用 lsp_lines 来显示
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = {
        only_current_line = false,
        highlight_whole_line = false,
      },
    })

    -- 创建一个命令来切换 virtual_text 和 virtual_lines
    vim.api.nvim_create_user_command(
      'DiagnosticToggleVirtualText',
      function()
        local virtual_text = vim.diagnostic.config().virtual_text
        local virtual_lines = vim.diagnostic.config().virtual_lines
        if virtual_text then
          vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = true
          })
        else
          vim.diagnostic.config({
            virtual_text = true,
            virtual_lines = false
          })
        end
      end,
      {}
    )

    -- 设置更好的诊断图标
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
} 