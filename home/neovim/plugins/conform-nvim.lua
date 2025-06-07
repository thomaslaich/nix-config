require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    cs = { "csharpier" },
    css = { { "prettierd", "prettier" }, "stylelint" },
    fs = { "fantomas" },
    hcl = { "hcl" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    json = { "jq" },
    just = { "just" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    python = { "ruff_format", "ruff_fix" },
    terraform = { "terraform" },
    tfvars = { "hcl" },
    typescript = { "prettierd" },
    yaml = { "yamlfmt" },
  },
  formatters = {
    csharpier = {
      command = "dotnet",
      args = { "csharpier", "format", "$FILENAME" },
      stdin = false,
      require_cwd = false,
    },
  },
})
