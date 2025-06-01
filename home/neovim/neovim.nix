{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins =
      let
        treesitter = {
          plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ./plugins/treesitter.lua;
        };

        ts-context = {
          plugin = pkgs.vimPlugins.nvim-treesitter-context;
          type = "lua";
          config = ''
            require'treesitter-context'.setup({
              enable = false
            })
          '';
        };

        lspconfig = {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/lspconfig.lua;
        };

        # https://github.com/Saghen/blink.cmp
        blink-cmp = {
          plugin = pkgs.vimPlugins.blink-cmp;
          type = "lua";
          config = builtins.readFile ./plugins/blink-cmp.lua;
        };

        # https://github.com/folke/snacks.nvim
        snacks = {
          plugin = pkgs.vimPlugins.snacks-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/snacks.lua;
        };

        fzf-lua = {
          plugin = pkgs.vimPlugins.fzf-lua;
          type = "lua";
          config = builtins.readFile ./plugins/fzf-lua.lua;
        };

        # https://github.com/MagicDuck/grug-far.nvim
        grug-far = {
          plugin = pkgs.vimPlugins.grug-far-nvim;
          type = "lua";
          config = ''
            require('grug-far').setup({});
          '';
        };

        # linting for some languages (when no lsp available)
        nvim-lint = {
          plugin = pkgs.vimPlugins.nvim-lint;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lint.lua;
        };

        # formatter for some languages (when no lsp available)
        conform-nvim = {
          plugin = pkgs.vimPlugins.conform-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/conform-nvim.lua;
        };

        # file browser
        oil = {
          plugin = pkgs.vimPlugins.oil-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/oil.lua;
        };

        plenary = {
          plugin = pkgs.vimPlugins.plenary-nvim;
        };

        core-motion-plugins = [
          # manipulate surrouding characters (e.g. brackets)
          {
            plugin = pkgs.vimPlugins.nvim-surround;
            type = "lua";
            config = ''
              require"nvim-surround".setup {}
            '';
          }
          # comment/uncomment with gcc
          {
            plugin = pkgs.vimPlugins.comment-nvim;
            type = "lua";
            config = ''
              require"Comment".setup {}
            '';
          }
          # use 'jk' and 'jj' to escape insert mode
          {
            plugin = pkgs.vimPlugins.better-escape-nvim;
            type = "lua";
            config = ''
              require"better_escape".setup {}
            '';
          }

          # vim motions hints
          {
            plugin = pkgs.vimPlugins.precognition-nvim;
            type = "lua";
            config = ''
              require('precognition').setup({
                startVisible = false
              })
            '';
          }

          { plugin = pkgs.vimPlugins.vim-tmux-navigator; }
        ];

        ui-plugins =
          let
            # https://github.com/romgrk/barbar.nvim/
            barbar = {
              plugin = pkgs.vimPlugins.barbar-nvim;
              type = "lua";
              config = ''
                vim.g.barbar_auto_setup = false
                require('barbar').setup({})
              '';
            };
            # https://github.com/j-hui/fidget.nvim
            fidget = {
              plugin = pkgs.vimPlugins.fidget-nvim;
              type = "lua";
              config = builtins.readFile ./plugins/fidget.lua;
            };

            # nice popup windows
            dressing = {
              plugin = pkgs.vimPlugins.dressing-nvim;
            };

            # https://github.com/echasnovski/mini.icons
            mini-icons = {
              plugin = pkgs.vimPlugins.mini-icons;
              type = "lua";
              config = ''
                require('mini.icons').setup({})
              '';
            };

            mini-colors = {
              plugin = pkgs.vimPlugins.mini-colors;
              type = "lua";
              config = ''
                require('mini.colors').setup()
              '';
            };

            web-devicons = {
              plugin = pkgs.vimPlugins.nvim-web-devicons;
            };

            lsp-kind = {
              plugin = pkgs.vimPlugins.lspkind-nvim;
              type = "lua";
            };

            indent-blank-line = {
              plugin = pkgs.vimPlugins.indent-blankline-nvim;
              type = "lua";
              config = builtins.readFile ./plugins/indent-blankline.lua;
            };

            which-key = {
              plugin = pkgs.vimPlugins.which-key-nvim;
              type = "lua";
              config = builtins.readFile ./plugins/which-key.lua;
            };

            trouble = {
              plugin = pkgs.vimPlugins.trouble-nvim;
              type = "lua";
              config = builtins.readFile ./plugins/trouble.lua;
            };

            # status line
            lualine = {
              plugin = pkgs.vimPlugins.lualine-nvim;
              type = "lua";
              config = builtins.readFile ./plugins/lualine.lua;
            };

            # show lsp progress in status line
            lsp-progress = {
              plugin = pkgs.vimPlugins.lsp-progress-nvim;
              type = "lua";
              config = ''
                require"lsp-progress".setup {}
              '';
            };

          in
          pkgs.lib.lists.flatten [
            barbar
            dressing
            fidget
            indent-blank-line
            lsp-kind
            lsp-progress
            lualine
            mini-colors
            mini-icons
            trouble
            web-devicons
            which-key
          ];

        git-plugins = [
          {
            plugin = pkgs.vimPlugins.gitsigns-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/gitsigns.lua;
          }
          {
            plugin = pkgs.vimPlugins.git-blame-nvim;
            type = "lua";
            config = ''
              require"gitblame".setup {
                enabled = false,
              }
            '';
          }
          { plugin = pkgs.vimPlugins.vim-fugitive; }
          {
            plugin = pkgs.vimPlugins.neogit;
            type = "lua";
            config = builtins.readFile ./plugins/neogit.lua;
          }
          {
            plugin = pkgs.vimPlugins.diffview-nvim;
            type = "lua";
            config = ''
              require("diffview").setup({})
            '';
          }
        ];

        # copilot is starting to annoy me
        # copilot = {
        #   plugin = pkgs.vimPlugins.copilot-lua;
        #   type = "lua";
        #   config = builtins.readFile ./plugins/copilot.lua;
        # };

        neorg = with pkgs; {
          plugin = vimPlugins.neorg;
          type = "lua";
          config = builtins.readFile ./plugins/neorg.lua;
        };

        orgmode = with pkgs; [
          {
            plugin = vimPlugins.orgmode;
            type = "lua";
            config = builtins.readFile ./plugins/orgmode.lua;
          }
          {
            plugin = vimPlugins.org-bullets-nvim;
            type = "lua";
            config = ''
              require('org-bullets').setup()
            '';
          }
        ];

        haskell-tools = {
          plugin = pkgs.vimPlugins.haskell-tools-nvim;
        };
        kubectl = {
          plugin = pkgs.vimPlugins.kubectl-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/kubectl-nvim.lua;
        };
      in
      pkgs.lib.lists.flatten [
        neorg
        blink-cmp
        conform-nvim
        # copilot
        fzf-lua
        git-plugins
        grug-far
        haskell-tools
        kubectl
        lspconfig
        nvim-lint
        oil
        orgmode
        plenary
        snacks
        treesitter
        ts-context

        core-motion-plugins

        ui-plugins
      ];

    extraPackages = [ ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
