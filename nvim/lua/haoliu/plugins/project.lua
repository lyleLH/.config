return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "Package.swift", "package.json", "Makefile", "pyproject.toml", "Cargo.toml" },
    })
    require("telescope").load_extension("projects")
  end,
}
