if not vim.g.vscode then
  require("lualine").setup({
    options = {
      theme = "tokyonight",
    },
    sections = {
      lualine_a = { { "mode", upper = true } },
      lualine_b = { { "branch", icon = "" } },
      lualine_c = {
        { "filename", file_status = true },
        require('lsp-progress').progress,
        "g:metals_status" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "fzf" },
  })
end
