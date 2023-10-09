if not vim.g.vscode then
  require("nvim-treesitter.configs").setup {
    highlight = {
      enable = true,
    }
  }
end
