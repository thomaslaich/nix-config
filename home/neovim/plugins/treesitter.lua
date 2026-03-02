vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local ok, _ = pcall(vim.treesitter.start)
    -- optional: fallback or silent fail if no parser installed
  end,
})
