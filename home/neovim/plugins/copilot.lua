vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    require "copilot".setup {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          next = "<M-]>",
          prev = "<M-[>",
        }
      }
    }
  end
})
