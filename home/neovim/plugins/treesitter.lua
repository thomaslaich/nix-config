-- start treesitter highlighting for every filetype that has a parser
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
