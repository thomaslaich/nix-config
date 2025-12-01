local neogit = require("neogit")

neogit.setup({
  mappings = {
    popup = {
      ["F"] = "PullPopup", -- like in Magit, don't know why Neogit has this on 'p'
    },
  },
  highlight = {
    bg0 = "NONE",
    bg1 = "NONE",
    bg2 = "NONE",
    bg3 = "NONE",
  },
})

-- create some mappings
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "[g] Neo[g]it" })
