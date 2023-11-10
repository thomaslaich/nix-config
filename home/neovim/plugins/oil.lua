if not vim.g.vscode then
  local oil = require("oil")
  oil.setup({
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    }
  })

  vim.keymap.set("n", "<leader>-", oil.open, { desc = "Browse parent directory" })
  -- inspired by doom emacs
  vim.keymap.set("n", "<leader>.", oil.open, { desc = "Browse parent directory" })
end
