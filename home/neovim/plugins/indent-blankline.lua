if not vim.g.vscode then
  require("ibl").setup {
    exclude = {
      filetypes = { "help", "dashboard", "startup", "Trouble" },
    }
  }
end
