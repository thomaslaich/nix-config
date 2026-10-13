-- Lazy-loaded plugins (installed as `optional = true` in neovim.nix).
-- Each spec's `name` must match the plugin's directory under pack/hm/opt.
-- https://github.com/nvim-neorocks/lz.n

-- Plugin config files live in ./plugins and are linked to ~/.config/nvim/lua/plugins.
local function cfg(name)
  return function()
    require("plugins." .. name)
  end
end

require("lz.n").load({
  -- [[ loaded on command / keymap ]]
  {
    "fzf-lua",
    cmd = "FzfLua",
    after = cfg("fzf-lua"),
  },
  {
    "conform.nvim",
    cmd = "ConformInfo",
    keys = {
      {
        "<localleader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "format",
      },
    },
    after = cfg("conform-nvim"),
  },
  {
    "diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewLog" },
    after = function()
      require("diffview").setup({})
    end,
  },
  {
    "neogit",
    cmd = "Neogit",
    before = function()
      -- neogit auto-detects diffview for its diff viewer
      require("lz.n").trigger_load("diffview.nvim")
    end,
    after = cfg("neogit"),
  },
  {
    "git-blame.nvim",
    cmd = { "GitBlameToggle", "GitBlameEnable", "GitBlameOpenCommitURL", "GitBlameCopySHA" },
    after = function()
      require("gitblame").setup({ enabled = false })
    end,
  },
  {
    "grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    after = function()
      require("grug-far").setup({})
    end,
  },
  {
    "refactoring.nvim",
    cmd = "Refactor",
    after = function()
      require("refactoring").setup({})
    end,
  },
  {
    "trouble.nvim",
    cmd = "Trouble",
    after = function()
      require("trouble").setup({})
    end,
  },
  {
    "nvim-treesitter-context",
    cmd = "TSContext",
    after = function()
      require("treesitter-context").setup({ enable = false })
    end,
  },
  {
    "precognition.nvim",
    cmd = "Precognition",
    after = function()
      require("precognition").setup({ startVisible = false })
    end,
  },

  -- [[ loaded on filetype ]]
  {
    "neorg",
    ft = "norg",
    cmd = "Neorg",
    after = cfg("neorg"),
  },

  -- [[ loaded on insert ]]
  {
    "better-escape.nvim",
    event = "InsertEnter",
    after = function()
      require("better_escape").setup({})
    end,
  },

  -- [[ loaded right after the UI is drawn ]]
  {
    "gitsigns.nvim",
    event = "DeferredUIEnter",
    after = cfg("gitsigns"),
  },
  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = cfg("which-key"),
  },
  {
    "indent-blankline.nvim",
    event = "DeferredUIEnter",
    after = cfg("indent-blankline"),
  },
  {
    "nvim-surround",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "comment.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("Comment").setup({})
    end,
  },
})

-- blink.cmp stays a start plugin so its plugin/ file can register LSP
-- capabilities early; the (expensive) setup only runs on first insert.
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("LazyBlink", { clear = true }),
  once = true,
  callback = cfg("blink-cmp"),
})

-- refactoring keymaps (typing the command loads the plugin)
vim.keymap.set("x", "<leader>re", ":Refactor extract ")
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
