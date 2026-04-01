return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("xcodebuild").setup({
      code_coverage = {
        enabled = true,
      },
    })

    vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Xcodebuild Actions" })
    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run" })
    vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Test Class" })
    vim.keymap.set("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Project Manager" })
    vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>", { desc = "Select Scheme" })
    vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Coverage" })
    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Logs" })
    vim.keymap.set("n", "<leader>xi", "<cmd>XcodebuildSetup<cr>", { desc = "Setup Project (init)" })
  end,
}
