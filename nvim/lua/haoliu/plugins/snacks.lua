return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    -- 配置 vim.ui.select 接口
    select = {
      backend = {
        -- 优先使用 telescope 作为选择器后端
        telescope = {
          -- 可以自定义 telescope 的外观
          theme = "dropdown",
        },
        -- 如果没有 telescope，使用内置的选择器
        builtin = true,
      },
    },
    -- 配置 vim.ui.input 接口
    input = {
      -- 默认提示字符串
      default_prompt = "Input:",
      -- 提示字符串位置
      prompt_align = "left",
      -- 输入框大小
      size = {
        width = 30,
        height = 1,
      },
      -- 边框样式
      border = "rounded",
      -- 输入框相对位置
      relative = "cursor",
    },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim", -- 可选，但推荐用于更好的选择器界面
  },
} 