require("conform").setup({
  formatters_by_ft = {
    cs = { "csharpier" },
    css = { { "prettierd", "prettier" }, "stylelint" },
    html = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    json = { "jq" },
    just = { "just" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
    yaml = { "yamlfmt" },
    c = { "clang-format" },
  },
})
