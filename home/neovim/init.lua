-- byte-compile and cache lua modules for faster require()
vim.loader.enable()

local map = vim.keymap.set
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- OPTIONS
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 800 -- same as doom emacs
opt.swapfile = false

local indent = 2
opt.expandtab = true
opt.shiftwidth = indent
opt.tabstop = indent
opt.softtabstop = indent
opt.shiftround = true

opt.number = true
opt.relativenumber = true
opt.list = true
opt.breakindent = true
opt.showbreak = "↪"

-- Floating windows, including LSP hover and signature help.
opt.winborder = "rounded"

if vim.g.btmux then
  -- btmux's built-in Neovim animates each scroll; single-line steps keep it smooth
  opt.mousescroll = "ver:1,hor:6"
  opt.winblend = 20 -- floats: hover, diagnostics, plugin windows
  opt.pumblend = 20 -- completion menu and its docs
end

-- COMPLETION
-- Native completion; btmux's built-in Neovim draws the menus itself.
opt.autocomplete = true
opt.complete = { "o", ".^5", "w^5", "b^5", "u^5" }
-- "popup" makes LSP completion resolve docs (a float, or beside btmux's menu)
opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
opt.wildmode = "noselect:lastused,full"
opt.wildoptions = "pum"

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("CmdlineCompletion", { clear = true }),
  pattern = { ":", "/", "?" },
  callback = function()
    vim.fn.wildtrigger()
  end,
})

-- Keep history navigation on <Up>/<Down> while the wildmenu is open
map("c", "<Up>", function()
  return vim.fn.wildmenumode() == 1 and "<C-e><Up>" or "<Up>"
end, { expr = true })
map("c", "<Down>", function()
  return vim.fn.wildmenumode() == 1 and "<C-e><Down>" or "<Down>"
end, { expr = true })

-- <CR> accepts a selected item
map("i", "<CR>", function()
  local selected = vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected or -1
  return selected ~= -1 and "<C-y>" or "<CR>"
end, { expr = true })

-- DIAGNOSTICS
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    source = "if_many",
    max_width = 80,
  },
})

-- Keep diagnostics compact, then show the full message after a short pause.
opt.updatetime = 500
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
  end,
})

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- LSP items, snippets and docs; trigger characters (e.g. ".") open the menu too
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    local function nmap(keys, func, desc)
      map("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end

    nmap("gd", vim.lsp.buf.definition, "Goto Definition")
    nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
    nmap("gr", "<cmd>FzfLua lsp_references<CR>", "Goto References")
    nmap("gI", "<cmd>FzfLua lsp_implementations<CR>", "Goto Implementation")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<localleader>a", vim.lsp.buf.code_action, "Code Action")
    nmap("<localleader>m", vim.lsp.buf.rename, "Rename")
    nmap("<F2>", vim.lsp.buf.rename, "Rename")
    nmap("<F4>", vim.lsp.buf.code_action, "Code Action")
    map({ "n", "v" }, "<F3>", vim.lsp.buf.format, { buffer = ev.buf, desc = "LSP: Format" })
  end,
})

-- KEYBINDINGS
map("n", "<leader>-", "<cmd>Explore<CR>", { desc = "Browse parent directory" })
map("n", "<leader>.", "<cmd>Explore<CR>", { desc = "Browse parent directory" })

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>", { desc = "open init.lua" })
map("n", "<leader>ctx", "<cmd>TSContext toggle<CR>", { desc = "toggle treesitter context" })
map({ "n", "v" }, "<localleader>f", function()
  require("conform").format({ async = true })
end, { desc = "format" })

-- [w] windows
map("n", "<C-h>", "<C-W>h", { desc = "Go Left" })
map("n", "<C-j>", "<C-W>j", { desc = "Go Down" })
map("n", "<C-k>", "<C-W>k", { desc = "Go Up" })
map("n", "<C-l>", "<C-W>l", { desc = "Go Right" })
map("n", "<leader>wh", "<C-W>h", { desc = "Go Left" })
map("n", "<leader>wj", "<C-W>j", { desc = "Go Down" })
map("n", "<leader>wk", "<C-W>k", { desc = "Go Up" })
map("n", "<leader>wl", "<C-W>l", { desc = "Go Right" })
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

-- [b] buffers
map("n", "<leader>bk", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bb", "<cmd>FzfLua buffers<CR>", { desc = "Switch buffer" })

-- [f] find
map("n", "<leader><space>", "<cmd>FzfLua buffers<CR>", { desc = "Find existing buffers" })
map("n", "<leader>?", "<cmd>FzfLua manpages<CR>", { desc = "Find man pages" })
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Search Files" })
map("n", "<leader>fa", "<cmd>FzfLua files no_ignore=true hidden=true<CR>", { desc = "Find all Files" })
map("n", "<leader>fh", "<cmd>FzfLua helptags<CR>", { desc = "Search Help" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Search by Grep" })
map("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", { desc = "Search Diagnostics" })
map("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { desc = "Search Resume" })
map("n", "<leader>fc", "<cmd>FzfLua commands<CR>", { desc = "Search Commands" })
map("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { desc = "Find recently opened files" })
map("n", "<leader>ft", "<cmd>FzfLua treesitter<CR>", { desc = "Search Treesitter" })

-- [g] git
map("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit" })
map("n", "<leader>gf", "<cmd>FzfLua git_files<CR>", { desc = "Search Git Files" })
map("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Git Commits" })
map("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>", { desc = "Git Branches" })
map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Git Status" })

-- [t] toggle
map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })
map("n", "<leader>tp", "<cmd>Precognition toggle<CR>", { desc = "Toggle precognition" })

-- trouble
map("n", "<localleader>tt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "toggle workspace diagnostics" })
map("n", "<localleader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "toggle document diagnostics" })
map("n", "<localleader>tl", "<cmd>Trouble loclist toggle<CR>", { desc = "toggle trouble (loclist)" })
map("n", "<localleader>tq", "<cmd>Trouble qflist toggle<CR>", { desc = "toggle trouble (quickfix)" })

-- spell checking for text files
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("spell", { clear = true }),
  pattern = { "markdown", "gitcommit", "text", "norg" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- NEORG
-- The only lazy-loaded plugin (`optional = true` in neovim.nix): load it on the
-- first norg buffer or the first `:Neorg` call.
local function load_neorg()
  pcall(vim.api.nvim_del_user_command, "Neorg")
  pcall(vim.api.nvim_del_augroup_by_name, "LazyNeorg")
  vim.cmd.packadd("neorg")
  require("plugins.neorg")
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("LazyNeorg", { clear = true }),
  pattern = "norg",
  callback = function(ev)
    load_neorg()
    -- let neorg attach to the buffer that triggered loading
    vim.api.nvim_exec_autocmds("FileType", { buffer = ev.buf, modeline = false })
  end,
})

vim.api.nvim_create_user_command("Neorg", function(cmd)
  load_neorg()
  vim.cmd("Neorg " .. cmd.args)
end, { nargs = "*" })
