if not vim.g.vscode then
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  require("which-key").setup {}
end
