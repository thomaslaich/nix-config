if not vim.g.vscode then
  vim.o.timeout = true
  vim.o.timeoutlen = 1000
  require("which-key").setup {}
end
