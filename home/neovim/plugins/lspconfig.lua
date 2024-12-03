local lsp_config = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

lsp_config.util.default_config =
  vim.tbl_extend("force", lsp_config.util.default_config, { capabilities = capabilities })

lsp_config.smithy_ls.setup({
  cmd = { "cs", "launch", "com.disneystreaming.smithy:smithy-language-server:latest.stable", "--", "0" },
})

-- don't need this -> haskell-tools.nvim instead
-- lsp_config.hls.setup {}

lsp_config.bashls.setup({})
lsp_config.pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = false,
        },
        flake8 = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
      },
    },
  },
})
lsp_config.gopls.setup({})
lsp_config.html.setup({})
lsp_config.ts_ls.setup({
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
})

-- waiting for https://github.com/jmederosalvarado/roslyn.nvim to move the lsp server installation
-- outside the module. Until then, let's use omnisharp-roslyn for .NET
lsp_config.omnisharp.setup({
  handlers = {
    ["textDocument/definition"] = require("omnisharp_extended").definition_handler,
    ["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
    ["textDocument/references"] = require("omnisharp_extended").references_handler,
    ["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
  },
  cmd = { omnisharpBin },
})

lsp_config.fsautocomplete.setup({})

lsp_config.eslint.setup({
  on_attach = function(client, bufnr)
    -- Uncomment this to run eslint --fix on save
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   buffer = bufnr,
    --   command = "EslintFixAll",
    -- })
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    format = true,
    workingDirectory = {
      mode = "auto",
    },
  },
})

lsp_config.svelte.setup({})

lsp_config.nil_ls.setup({
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

lsp_config.lua_ls.setup({
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
