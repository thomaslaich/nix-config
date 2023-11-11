if not vim.g.vscode then
  vim.o.timeout = true
  vim.o.timeoutlen = 800 -- 800ms (the same as doom emacs)
  local whichkey = require "which-key"

  whichkey.setup {}

  -- document existing key chains
  whichkey.register {
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    -- ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]indows', _ = 'which_key_ignore' },
  }
end
