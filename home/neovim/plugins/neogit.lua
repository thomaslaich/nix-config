local neogit = require("neogit")

neogit.setup({})

-- create some mappings
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "[g] Neo[g]it" })
