-- enable languages here
vim.lsp.enable("bashls") -- bash
vim.lsp.enable("html") -- HTML
vim.lsp.enable("lua_ls") -- Lua
vim.lsp.enable("nil_ls") -- Nix
vim.lsp.enable("roslyn_ls") -- C# (LSP from DevKit)
vim.lsp.enable("taplo") -- TOML
vim.lsp.enable("ts_ls") -- Typescript/Javascript
vim.lsp.enable("ty") -- Python
vim.lsp.enable("hls") -- Haskell

-- extra config below
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      format = true,
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- do not ask for third party on every startup
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})
vim.lsp.config("ts_ls", {
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
})
