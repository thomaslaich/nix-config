local neogit = require("neogit")

neogit.setup({
  mappings = {
    popup = {
      ["F"] = "PullPopup", -- like in Magit, don't know why Neogit has this on 'p'
    },
  },
})

-- create some mappings
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "[g] Neo[g]it" })
