local kubectl = require("kubectl")
kubectl.setup()

vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })
