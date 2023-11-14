-- local cmd = vim.cmd
-- local api = vim.api
local g = vim.g
local map = vim.keymap.set
local opt = vim.opt
local global_opt = vim.opt_global


g.mapleader = " "
g.maplocalleader = ","

-- cmd.language("en_US")

global_opt.shortmess:remove("F")                           -- recommended for nvim-metals
global_opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
global_opt.hidden = true                                   -- Enable modified buffers in background
global_opt.ignorecase = true                               -- Ignore case
global_opt.joinspaces = false                              -- No double spaces with join after a dot
global_opt.scrolloff = 4                                   -- Lines of context
global_opt.shiftround = true                               -- Round indent
global_opt.sidescrolloff = 8                               -- Columns of context
global_opt.smartcase = true                                -- Don't ignore case with capitals
global_opt.splitbelow = true                               -- Put new windows below current
global_opt.splitright = true                               -- Put new windows right of current
global_opt.termguicolors = true                            -- True color support
global_opt.wildmode = "list:longest"                       -- Command-line completion mode
global_opt.clipboard = "unnamedplus"

local indent = 2

opt.expandtab = true      -- Use spaces instead of tabs
opt.shiftwidth = indent   -- Size of an indent
opt.smartindent = true    -- Insert indents automatically
opt.tabstop = indent      -- Number of spaces tabs count for

opt.list = true           -- Show some invisible characters (tabs...)
opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.wrap = false          -- Disable line wrap
opt.swapfile = false

opt.conceallevel = 2 -- Hide * markup for bold and italic (Neorg)

map("n", "<C-j>", "<C-W><C-J>")
map("n", "<C-k>", "<C-W><C-K>")
map("n", "<C-l>", "<C-W><C-L>")
map("n", "<C-h>", "<C-W><C-H>")

-- for reference (use "better-escape.nvim" instead)
-- map("i", "jk", "<Esc>")
-- map("i", "jj", "<Esc>")

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>", { desc = "open init.lua" })

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
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions

    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
    end

    -- general
    nmap("gd", vim.lsp.buf.definition, 'Goto Definition')
    -- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
    nmap('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
    -- TODO: find mapping under something else than "w"
    -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    -- TODO: find mapping under something else than "w"
    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')


    -- code action
    nmap("<localleader>a", vim.lsp.buf.code_action, 'Code Action')

    -- rename
    nmap("<localleader>m", vim.lsp.buf.rename, "Rename")

    -- formatting
    map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format, { desc = "Format" })
    -- alternative formatter with conform (TODO: can we combine the 2 somehow?)
    map({ "n", "v" }, "<localleader>g", function() require("conform").format({ async = true, lsp_fallback = true }) end,
      { desc = "Conform: Format" })

    -- F-keys
    nmap("<F2>", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<F3>", vim.lsp.buf.format, { desc = "LSP: Format" })
    nmap("<F4>", vim.lsp.buf.code_action, 'Code Action')
  end,
})

-- [w] WINDOW MANAGEMENT
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

-- [b] BUFFER SHORTCUTS
map("n", "<leader>bk", ":bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bb", ":Telescope buffers<CR>", { desc = "Switch buffer" })

-- [f] FIND KEYBINDINGS

-- general search
-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
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

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

local telescope_builtin = require("telescope.builtin")

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', telescope_builtin.man_pages, { desc = '[?] Find in help' })
vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Search Files' })

vim.keymap.set("n", "<leader>fa", function() telescope_builtin.find_files({ no_ignore = true, hidden = true }) end,
  { desc = "[S]earch [a]ll Files" })
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Search Help' })
vim.keymap.set('n', '<leader>fw', telescope_builtin.grep_string, { desc = 'Search current Word' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>fG', ':LiveGrepGitRoot<cr>', { desc = 'Search by Grep on Git Root' })
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = 'Search Diagnostics' })
vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, { desc = 'Search Resume' })
vim.keymap.set('n', '<leader>fc', telescope_builtin.commands, { desc = 'Search Commands' })
vim.keymap.set("n", "<leader>fy", telescope_builtin.symbols, { desc = "Search emoji/symbols" })
vim.keymap.set('n', '<leader>fo', telescope_builtin.oldfiles, { desc = 'Find recently opened files' })

vim.keymap.set("n", "<leader>ft", telescope_builtin.treesitter, { desc = "Search Treesitter" })

-- [g] GIT KEYBINDINGS

vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, { desc = 'Search Git Files' })
vim.keymap.set("n", "<leader>gc", telescope_builtin.git_commits, { desc = "Git Commits" })
vim.keymap.set("n", "<leader>gb", telescope_builtin.git_branches, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gs", telescope_builtin.git_status, { desc = "Git Status" })

-- MISC
vim.keymap.set("n", "<leader>mc", require "telescope".extensions.metals.commands, { desc = "metals commands" })
