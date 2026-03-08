return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      name_formatter = function(buf)
        -- Show last 4 path components: e.g. "lua/haoliu/plugins/bufferline.lua"
        local parts = {}
        for part in buf.path:gmatch("[^/]+") do
          table.insert(parts, part)
        end
        local n = #parts
        local start = n > 4 and n - 3 or 1
        return table.concat(parts, "/", start, n)
      end,
      max_name_length = 50,
      truncate_names = false,
    },
  },
}
