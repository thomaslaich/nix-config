if not vim.g.vscode then
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
              icon = '󱠢 ',
              icon_hl = '@variable',
              desc = 'Quit',
              group = 'Number',
              action = 'q',
              key = 'q',
            },
            -- {
            --   desc = ' Apps',
            --   group = 'DiagnosticHint',
            --   action = 'Telescope app',
            --   key = 'a',
            -- },
            -- {
            --   desc = ' dotfiles',
            --   group = 'Number',
            --   action = 'Telescope dotfiles',
            --   key = 'd',
            -- },
          },
          packages = { enable = false },
          footer = {
            [=[                                    /-----------------------------------\   ]=],
            [=[                                    | I`m not fat, I`m festively plump! |   ]=],
            [=[                                    \-----------------------------------/   ]=],
            [=[                                                        \                   ]=],
            [=[          _          __________                          \   _,             ]=],
            [=[      _.-(_)._     ."          ".      .--""--.          _.-{__}-._         ]=],
            [=[    .'________'.   | .--------. |    .'        '.      .:-'`____`'-:.       ]=],
            [=[   [____________] /` |________| `\  /   .'``'.   \    /_.-"`_  _`"-._\      ]=],
            [=[   /  / .\/. \  \|  / / .\/. \ \  ||  .'/.\/.\'.  |  /`   / .\/. \   `\     ]=],
            [=[   |  \__/\__/  |\_/  \__/\__/  \_/|  : |_/\_| ;  |  |    \__/\__/    |     ]=],
            [=[   \            /  \            /   \ '.\    /.' / .-\                /-.   ]=],
            [=[   /'._  --  _.'\  /'._  --  _.'\   /'. `'--'` .'\/   '._-.__--__.-_.'   \  ]=],
            [=[  /_   `""""`   _\/_   `""""`   _\ /_  `-./\.-'  _\'.    `""""""""`    .'`\ ]=],
            [=[ (__/    '|    \ _)_|           |_)_/            \__)|        '       |   | ]=],
            [=[   |_____'|_____|   \__________/   |              |;`_________'________`;-' ]=],
            [=[    '----------'    '----------'   '--------------'`--------------------`   ]=],
            --
            -- [=[                            \                     ]=],
            -- [=[    _O_        _____         _<>_          ___    ]=],
            -- [=[  /     \     |     |      /      \      /  _  \  ]=],
            -- [=[ |==/=\==|    |[/_\]|     |==\==/==|    |  / \  | ]=],
            -- [=[ |  O O  |    / O O \     |   ><   |    |  |"|  | ]=],
            -- [=[  \  V  /    /\  -  /\  ,-\   ()   /-.   \  X  /  ]=],
            -- [=[  /`---'\     /`---'\   V( `-====-' )V   /`---'\  ]=],
            -- [=[  O'_:_`O     O'M|M`O   (_____:|_____)   O'_|_`O  ]=],
            -- [=[   -- --       -- --      ----  ----      -- --   ]=],
          },
        },
      }
    end
  })
end
