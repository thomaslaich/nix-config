if not vim.g.vscode then
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {
      layout_strategy = "vertical",
      mappings = {
        i = {
          ["<C-j"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
        },
      },
    },
  })
end
