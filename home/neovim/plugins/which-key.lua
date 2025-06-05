vim.o.timeout = true
vim.o.timeoutlen = 800 -- 800ms (the same as doom emacs)
local whichkey = require("which-key")

whichkey.setup({})

-- document existing key chains
whichkey.add({
  { "<leader>c", group = "[C]ode" },
  { "<leader>d", group = "[D]ocument" },
  { "<leader>g", group = "[G]it" },
  { "<leader>h", group = "More git" },
  { "<leader>r", group = "[R]efactor" },
  { "<leader>f", group = "[F]ind" },
  { "<leader>p", group = "[P]rojects" },
  { "<leader>w", group = "[W]indows" },
  { "<leader>b", group = "[B]uffers" },
  { "<leader>t", group = "[T]oggle" },
})
