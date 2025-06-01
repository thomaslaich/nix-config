-- local cmd = vim.cmd
-- local api = vim.api
local g = vim.g
local o = vim.o
local map = vim.keymap.set
local opt = vim.opt
local global_opt = vim.opt_global

g.mapleader = " "
g.maplocalleader = ","

local oil = require("oil")
local fzf = require("fzf-lua")
local conform = require("conform")
local tscontext = require("treesitter-context")

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
  virtual_text = false,
  virtual_lines = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
})

-- KEYBINDINGS
map("n", "<leader>-", oil.open, { desc = "Browse parent directory" })
-- inspired by doom emacs
map("n", "<leader>.", oil.open, { desc = "Browse parent directory" })

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>", { desc = "open init.lua" })

map("n", "<leader>ctx", tscontext.toggle, { desc = "toggle treesitter context" })

-- leaving this for reference, but adjusting this to conform to lsp-zero standards
-- map("n", "<localleader>a", vim.lsp.buf.code_action, { desc = "lsp code action" })
-- map("n", "<localleader>d", vim.lsp.buf.definition, { desc = "lsp definition" })
-- map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format, { desc = "lsp format" })
-- map({ "n", "v" }, "<localleader>g", function() require("conform").format({ async = true, lsp_fallback = true }) end,
--   { desc = "lsp format" })
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
    nmap("gr", fzf.lsp_references, "Goto References")
    nmap("gI", fzf.lsp_implementations, "Goto Implementation")
    -- nmap("<leader>D", fzf.lsp_type_definitions, "Type Definition")
    -- nmap("<leader>ds", fzf.lsp_document_symbols, "Document Symbols")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
    nmap("<localleader>a", vim.lsp.buf.code_action, "Code Action")
    nmap("<localleader>m", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<localleader>f", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { desc = "format" })
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
map("n", "<leader>bb", fzf.buffers, { desc = "Switch buffer" })

-- [f] FIND KEYBINDINGS

local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

map("n", "<leader>?", fzf.man_pages, { desc = "[?] Find in help" })
map("n", "<leader><space>", fzf.buffers, { desc = "[ ] Find existing buffers" })
-- map("n", "<leader>/", function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   fzf.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
--     winblend = 10,
--     previewer = false,
--   }))
-- end, { desc = "[/] Fuzzily search in current buffer" })

map("n", "<leader>ff", fzf.files, { desc = "Search Files" })

map("n", "<leader>fa", function()
  fzf.find_files({ no_ignore = true, hidden = true })
end, { desc = "Find all Files" })
map("n", "<leader>fh", fzf.help_tags, { desc = "Search Help" })
-- map("n", "<leader>fw", telescope_builtin.grep_string, { desc = "Search current Word" })
map("n", "<leader>fg", function()
  fzf.live_grep({})
end, { desc = "Search by Grep" })
map("n", "<leader>fG", ":LiveGrepGitRoot<cr>", { desc = "Search by Grep on Git Root" })
map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Search Diagnostics" })
map("n", "<leader>fr", fzf.resume, { desc = "Search Resume" })
map("n", "<leader>fc", fzf.commands, { desc = "Search Commands" })
-- map("n", "<leader>fy", telescope_builtin.symbols, { desc = "Search emoji/symbols" })
map("n", "<leader>fo", fzf.oldfiles, { desc = "Find recently opened files" })

map("n", "<leader>ft", fzf.treesitter, { desc = "Search Treesitter" })

-- [g] GIT KEYBINDINGS

map("n", "<leader>gf", fzf.git_files, { desc = "Search Git Files" })
map("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
map("n", "<leader>gb", fzf.git_branches, { desc = "Git Branches" })
map("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })

-- [t] Toggle
map("n", "<leader>tb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git [b]lame" })

-- enable spell checking for text files
local spell_augroup = vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text", "neorg" },
  callback = function()
    vim.opt.spell = true
  end,
  group = spell_augroup,
})

-- LSP hover
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
