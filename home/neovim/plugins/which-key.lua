local whichkey = require("which-key")

whichkey.setup({})

-- document existing key chains
whichkey.add({
  { "<leader>b", group = "[B]uffers" },
  { "<leader>c", group = "[C]ode" },
  { "<leader>f", group = "[F]ind" },
  { "<leader>g", group = "[G]it" },
  { "<leader>h", group = "Git [h]unks" },
  { "<leader>t", group = "[T]oggle" },
  { "<leader>w", group = "[W]indows" },
})
