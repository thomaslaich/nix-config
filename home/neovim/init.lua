-- byte-compile and cache lua modules for faster require()
vim.loader.enable()

-- local cmd = vim.cmd
-- local api = vim.api
local g = vim.g
local o = vim.o
local map = vim.keymap.set
local opt = vim.opt
local global_opt = vim.opt_global

g.mapleader = " "
g.maplocalleader = ","

-- cmd.language("en_US")

global_opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
global_opt.hidden = true -- Enable modified buffers in background
global_opt.ignorecase = true -- Ignore case
global_opt.joinspaces = false -- No double spaces with join after a dot
global_opt.scrolloff = 4 -- Lines of context
global_opt.shiftround = true -- Round indent
global_opt.sidescrolloff = 8 -- Columns of context
global_opt.smartcase = true -- Don't ignore case with capitals
global_opt.splitbelow = true -- Put new windows below current
global_opt.splitright = true -- Put new windows right of current
global_opt.termguicolors = true -- True color support
global_opt.wildmode = "list:longest" -- Command-line completion mode
global_opt.clipboard = "unnamedplus"
-- global_opt.hlsearch = false                                -- Disable search highlight
global_opt.mouse = "a" -- Enable mouse support

local indent = 2

opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = indent -- Size of an indent
-- opt.smartindent = true    -- Insert indents automatically
opt.tabstop = indent -- Number of spaces tabs count for
vim.bo.softtabstop = 2
opt.breakindent = true -- Break line indent

opt.list = true -- Show some invisible characters (tabs...)
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.wrap = true
opt.showbreak = "↪" -- character to show when line is broken
opt.swapfile = false

-- opt.conceallevel = 2 -- Hide * markup for bold and italic (Neorg)

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
})

-- Keep diagnostics compact, then show the full message after a short pause.
opt.updatetime = 500
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
  end,
})

o.timeout = true
o.timeoutlen = 800 -- 800ms (the same as doom emacs)

-- KEYBINDINGS
-- Plugins are lazy-loaded (see plugins/lazy.lua), so map to their commands
-- rather than `require()`-ing them here.
map("n", "<leader>-", "<cmd>Explore<CR>", { desc = "Browse parent directory" })
-- inspired by doom emacs
map("n", "<leader>.", "<cmd>Explore<CR>", { desc = "Browse parent directory" })

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>", { desc = "open init.lua" })

map("n", "<leader>ctx", "<cmd>TSContext toggle<CR>", { desc = "toggle treesitter context" })

-- leaving this for reference, but adjusting this to conform to lsp-zero standards
-- map("n", "<localleader>a", vim.lsp.buf.code_action, { desc = "lsp code action" })
-- map("n", "<localleader>d", vim.lsp.buf.definition, { desc = "lsp definition" })
-- map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format, { desc = "lsp format" })
-- map("n", "<localleader>i", vim.lsp.buf.implementation, { desc = "lsp implementation" })
-- map("n", "<localleader>h", vim.lsp.buf.hover, { desc = "lsp hover" })
-- map("n", "<localleader>m", vim.lsp.buf.rename, { desc = "lsp rename" })
-- map("n", "<localleader>r", vim.lsp.buf.references, { desc = "lsp references" })
-- map("n", "<localleader>s", vim.lsp.buf.document_symbol, { desc = "lsp document symbol" })

-- LSP SHORTCUTS

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end

      map("n", keys, func, { buffer = ev.buf, desc = desc })
    end

    -- general
    nmap("gd", vim.lsp.buf.definition, "Goto Definition")
    -- nmap('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
    nmap("gr", "<cmd>FzfLua lsp_references<CR>", "Goto References")
    nmap("gI", "<cmd>FzfLua lsp_implementations<CR>", "Goto Implementation")
    -- nmap("<leader>D", fzf.lsp_type_definitions, "Type Definition")
    -- nmap("<leader>ds", fzf.lsp_document_symbols, "Document Symbols")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
    nmap("<localleader>a", vim.lsp.buf.code_action, "Code Action")
    nmap("<localleader>m", vim.lsp.buf.rename, "Rename")
    -- map({ "n", "v" }, "<localleader>f", function()
    --   conform.format({ async = true, lsp_fallback = true })
    -- end, { desc = "format" })
    nmap("<F2>", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<F3>", vim.lsp.buf.format, { desc = "LSP: Format" })
    nmap("<F4>", vim.lsp.buf.code_action, "Code Action")
  end,
})

-- [w] WINDOW MANAGEMENT
map("n", "<leader>wh", "<C-W>h", { desc = "Go Left" })
map("n", "<leader>wj", "<C-W>j", { desc = "Go Down" })
map("n", "<leader>wk", "<C-W>k", { desc = "Go Up" })
map("n", "<leader>wl", "<C-W>l", { desc = "Go Right" })
map("n", "<C-h>", "<C-W>h", { desc = "Go Left" })
map("n", "<C-j>", "<C-W>j", { desc = "Go Down" })
map("n", "<C-k>", "<C-W>k", { desc = "Go Up" })
map("n", "<C-l>", "<C-W>l", { desc = "Go Right" })
map("n", "<leader>wH", "<C-W>H", { desc = "Move Left" })
map("n", "<leader>wJ", "<C-W>J", { desc = "Move Down" })
map("n", "<leader>wK", "<C-W>K", { desc = "Move Up" })
map("n", "<leader>wL", "<C-W>L", { desc = "Move Right" })
map("n", "<leader>w=", "<C-W>=", { desc = "Equalize" })
map("n", "<leader>w|", "<C-W>|", { desc = "Maximize Horizontally" })
map("n", "<leader>w_", "<C-W>_", { desc = "Maximize Vertically" })
map("n", "<leader>w+", "<C-W>+", { desc = "Increase Height" })
map("n", "<leader>w-", "<C-W>-", { desc = "Decrease Height" })
map("n", "<leader>w>", "<C-W>>", { desc = "Increase Width" })
map("n", "<leader>w<", "<C-W><", { desc = "Decrease Width" })
map("n", "<leader>ws", "<C-W>s", { desc = "Split Horizontally" })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Vertically" })
map("n", "<leader>wo", "<C-W>o", { desc = "Close all other windows" })
map("n", "<leader>ww", "<C-W>w", { desc = "Switch window" })
map("n", "<leader>wc", "<C-W>q", { desc = "Close Window" })

-- [b] BUFFER SHORTCUTS
map("n", "<leader>bk", ":bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bb", "<cmd>FzfLua buffers<CR>", { desc = "Switch buffer" })

-- [f] FIND KEYBINDINGS
map("n", "<leader>?", "<cmd>FzfLua manpages<CR>", { desc = "[?] Find in help" })
map("n", "<leader><space>", "<cmd>FzfLua buffers<CR>", { desc = "[ ] Find existing buffers" })
-- map("n", "<leader>/", function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   fzf.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
--     winblend = 10,
--     previewer = false,
--   }))
-- end, { desc = "[/] Fuzzily search in current buffer" })

map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Search Files" })

map("n", "<leader>fa", "<cmd>FzfLua files no_ignore=true hidden=true<CR>", { desc = "Find all Files" })
map("n", "<leader>fh", "<cmd>FzfLua helptags<CR>", { desc = "Search Help" })
-- map("n", "<leader>fw", telescope_builtin.grep_string, { desc = "Search current Word" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Search by Grep" })
map("n", "<leader>fG", ":LiveGrepGitRoot<cr>", { desc = "Search by Grep on Git Root" })
map("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", { desc = "Search Diagnostics" })
map("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { desc = "Search Resume" })
map("n", "<leader>fc", "<cmd>FzfLua commands<CR>", { desc = "Search Commands" })
-- map("n", "<leader>fy", telescope_builtin.symbols, { desc = "Search emoji/symbols" })
map("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { desc = "Find recently opened files" })

map("n", "<leader>ft", "<cmd>FzfLua treesitter<CR>", { desc = "Search Treesitter" })

-- [g] GIT KEYBINDINGS

map("n", "<leader>gf", "<cmd>FzfLua git_files<CR>", { desc = "Search Git Files" })
map("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Git Commits" })
map("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>", { desc = "Git Branches" })
map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Git Status" })

map("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "[g] Neo[g]it" })

-- [t] Toggle
map("n", "<leader>tb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git [b]lame" })
map("n", "<leader>tp", "<cmd>Precognition toggle<cr>", { desc = "Toggle [p]recognition" })

-- TROUBLE
map("n", "<localleader>tt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "toggle trouble" })
map("n", "<localleader>tw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "toggle workspace diagnostics" })
map("n", "<localleader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "toggle document diagnostics" })
map("n", "<localleader>tl", "<cmd>Trouble loclist toggle<CR>", { desc = "toggle trouble (loclist)" })
map("n", "<localleader>tq", "<cmd>Trouble qflist toggle<CR>", { desc = "toggle trouble (quickfix)" })

-- enable spell checking for text files
local spell_augroup = vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text", "neorg" },
  callback = function()
    vim.opt.spell = true
  end,
  group = spell_augroup,
})

-- Floating windows, including LSP hover and signature help.
vim.o.winborder = "rounded"
vim.diagnostic.config({
  float = {
    border = "rounded",
    source = "if_many",
    max_width = 80,
    wrap = true,
  },
})
