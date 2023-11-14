vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    require "dashboard".setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          -- { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            -- icon = ' ',
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Find File',
            group = '@property',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'File Browser',
            group = 'Label',
            action = 'Oil',
            key = '-',
          },
          -- TODO Neorg access
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'About',
            group = 'DiagnosticHint',
            action = 'intro',
            key = 'a',
          },
          {
            desc = '󰋗 Help',
            group = 'Number',
            action = 'help',
            key = '?',
          },
          {
            icon = '󱠢 ',
            icon_hl = '@variable',
            desc = 'Quit',
            group = 'Number',
            action = 'q',
            key = 'q',
          },
          -- {
          --   desc = ' dotfiles',
          --   group = 'Number',
          --   action = 'Telescope dotfiles',
          --   key = 'd',
          -- },
        },
        packages = { enable = false },
        footer = {},
      },
    }
  end
})
