-- 检测是否在VSCode中运行
if vim.g.vscode then
  -- 在VSCode中只加载基础配置
  require("haoliu.vscode")
else
  -- 在普通Neovim中加载所有配置
  require("haoliu.core")
  require("haoliu.lazy")
end
