require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    cs = { "csharpier" },
    just = { "just" },
  },
})
