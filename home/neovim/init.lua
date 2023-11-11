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
    nmap("gd", vim.lsp.buf.definition, '[G]oto [D]efinition')
    -- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    -- TODO: find mapping under something else than "w"
    -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- TODO: find mapping under something else than "w"
    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')


    -- code action
    nmap("<F4>", vim.lsp.buf.code_action, 'Code Action')

    -- rename
    nmap("<F2>", vim.lsp.buf.rename, "Rename")

    -- formatting
    map({ "n", "v" }, "<F3>", vim.lsp.buf.format, { desc = "LSP: Format" })
    map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format, { desc = "LSP: [F]ormat" })
    -- alternative formatter with conform (TODO: can we combine the 2 somehow?)
    map({ "n", "v" }, "<localleader>g", function() require("conform").format({ async = true, lsp_fallback = true }) end,
      { desc = "Conform: Format" })
  end,
})

-- WINDOW SHORTCUTS (AS IN DOOM EMACS)
map("n", "<leader>wh", "<C-W>h", { desc = "[W]indow: Go [h] Left" })
map("n", "<leader>wj", "<C-W>j", { desc = "[W]indow: Go [j] Down" })
map("n", "<leader>wk", "<C-W>k", { desc = "[W]indow: Go [k] Up" })
map("n", "<leader>wl", "<C-W>l", { desc = "[W]indow: Go [l] Right" })
map("n", "<leader>wH", "<C-W>H", { desc = "[W]indow: Move [H] Left" })
map("n", "<leader>wJ", "<C-W>J", { desc = "[W]indow: Move [J] Down" })
map("n", "<leader>wK", "<C-W>K", { desc = "[W]indow: Move [K] Up" })
map("n", "<leader>wL", "<C-W>L", { desc = "[W]indow: Move [L] Right" })
map("n", "<leader>w=", "<C-W>=", { desc = "[W]indow: Equalize" })
map("n", "<leader>w|", "<C-W>|", { desc = "[W]indow: Maximize Horizontally" })
map("n", "<leader>w_", "<C-W>_", { desc = "[W]indow: Maximize Vertically" })
map("n", "<leader>w+", "<C-W>+", { desc = "[W]indow: Increase Height" })
map("n", "<leader>w-", "<C-W>-", { desc = "[W]indow: Decrease Height" })
map("n", "<leader>w>", "<C-W>>", { desc = "[W]indow: Increase Width" })
map("n", "<leader>w<", "<C-W><", { desc = "[W]indow: Decrease Width" })
map("n", "<leader>ws", "<C-W>s", { desc = "[W]indow: [S]plit Horizontally" })
map("n", "<leader>wv", "<C-W>v", { desc = "[W]indow: Split [V]ertically" })
map("n", "<leader>wo", "<C-W>o", { desc = "[W]indow: Close all [other] windows" })
map("n", "<leader>ww", "<C-W>w", { desc = "[W]indow: S[w]itch window" })
map("n", "<leader>wc", "<C-W>q", { desc = "[W]indow: [C]lose Window" })

-- BUFFER SHORTCUTS
-- TODO

-- SEARCH KEYBINDINGS

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
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })


vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })

vim.keymap.set("n", "<leader>sa", function() telescope_builtin.find_files({ no_ignore = true, hidden = true }) end,
  { desc = "[S]earch [a]ll Files" })
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sc', telescope_builtin.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set("n", "<leader>sy", telescope_builtin.symbols, { desc = "[S]earch emoji/s[y]mbols" })

vim.keymap.set("n", "<leader>st", telescope_builtin.treesitter, { desc = "[S]earch [T]reesitter" })

-- Git specific
vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set("n", "<leader>gc", telescope_builtin.git_commits, { desc = "[G]it [C]ommits" })
vim.keymap.set("n", "<leader>gb", telescope_builtin.git_branches, { desc = "[G]it [B]ranches" })
vim.keymap.set("n", "<leader>gs", telescope_builtin.git_status, { desc = "[G]it [S]tatus" })

-- LSP specific
vim.keymap.set("n", "<leader>mc", require"telescope".extensions.metals.commands, { desc = "metals commands" })
