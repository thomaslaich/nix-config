if not vim.g.vscode then
  require("ibl").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
  }
end
