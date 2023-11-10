if not vim.g.vscode then
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {
      layout_strategy = "vertical",
      history = {
        mappings = {
          i = {
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
          },
        },
      },
    },
  })
  local builtin = require("telescope.builtin")

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

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })


  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })

  vim.keymap.set("n", "<leader>sa", function() builtin.find_files({ no_ignore = true, hidden = true }) end,
    { desc = "[S]earch [a]ll Files" })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>sc', builtin.resume, { desc = '[S]earch [C]ommands' })
  vim.keymap.set("n", "<leader>sy", builtin.symbols, { desc = "[S]earch emoji/s[y]mbols" })

  vim.keymap.set("n", "<leader>st", builtin.treesitter, { desc = "[S]earch [T]reesitter" })

  -- Git specific
  vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
  vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits" })
  vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[G]it [B]ranches" })
  vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })

  -- LSP specific
  vim.keymap.set("n", "<leader>mc", telescope.extensions.metals.commands, { desc = "metals commands" })
end
