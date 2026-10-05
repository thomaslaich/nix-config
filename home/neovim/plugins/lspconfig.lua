local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Server executables are installed through Home Manager.
vim.lsp.enable("bashls")
vim.lsp.enable("buf-lsp")
vim.lsp.enable("clangd")
vim.lsp.enable("cssls")
vim.lsp.enable("eslint")
vim.lsp.enable("gopls")
vim.lsp.enable("hls")
vim.lsp.enable("html")
vim.lsp.enable("lua_ls")
vim.lsp.enable("neocmake")
vim.lsp.enable("nil_ls")
vim.lsp.enable("protols")
vim.lsp.enable("pyrefly")
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("taplo")
vim.lsp.enable("texlab")
vim.lsp.enable("ts_ls")
vim.lsp.enable("zls")
vim.lsp.enable("jdtls")
vim.lsp.enable("roslyn_ls") -- Microsoft Roslyn, not the community csharp-ls server
vim.lsp.enable("tinymist")

vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  cmd = { os.getenv("CLANGD_BIN") or "clangd" },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      format = {
        enable = false, -- we prefer stylua via conform
      },
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
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config("texlab", {
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        -- Use a project-provided TeX toolchain when available.
        onSave = vim.fn.executable("latexmk") == 1,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = vim.fn.executable("chktex") == 1,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {},
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = true,
      },
    },
  },
})

vim.lsp.config("neocmake", {
  -- neocmakelsp can spend a long time scanning a project before handling shutdown.
  exit_timeout = 1000,
})

vim.lsp.config("buf-lsp", {
  cmd = { "buf", "lsp", "serve" },
  filetypes = { "proto" },
  root_markers = { "buf.yaml", ".git" },
})

vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  settings = {
    formatterMode = "typstyle", -- or "typstfmt"
    -- formatterProseWrap = true, -- wrap lines in content mode
    -- formatterPrintWidth = 80, -- limit line length to 80 if possible
    -- formatterIndentSize = 4, -- indentation width
  },
})

-- Keep Nix formatting through nil when Conform falls back to the LSP.
vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = { command = { "nixfmt" } },
    },
  },
})

-- Pyrefly provides Python hover/type information; Ruff handles linting and fixes.
vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})
