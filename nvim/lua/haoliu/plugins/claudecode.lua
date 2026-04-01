return {
  "coder/claudecode.nvim",
  config = true,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeAdd<cr>", desc = "Add file to Claude context" },
  },
}
