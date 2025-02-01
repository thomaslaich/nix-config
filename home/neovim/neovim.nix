{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
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

        lspconfig = {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          type = "lua";
          config = ''
            local pid = vim.fn.getpid()
            local omnisharpBin = "${pkgs.omnisharp-roslyn}/bin/omnisharp"

            ${builtins.readFile ./plugins/lspconfig.lua}
          '';
        };

        cmp = with pkgs.vimPlugins; [
          {
            plugin = nvim-cmp;
            type = "lua";
            config = builtins.readFile ./plugins/cmp.lua;
          }
          { plugin = cmp-buffer; }
          { plugin = cmp-path; }
          { plugin = cmp-vsnip; }
          { plugin = cmp-nvim-lsp; }
          { plugin = cmp-nvim-lsp-signature-help; }
          { plugin = vim-vsnip; }
        ];

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

        # fuzzy finder and live grep
        telescope = [
          {
            plugin = pkgs.vimPlugins.telescope-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/telescope.lua;
          }
          { plugin = pkgs.vimPlugins.telescope-symbols-nvim; }
        ];

        aerial = {
          plugin = pkgs.vimPlugins.aerial-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/aerial.lua;
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
          # move around fast in the current buffer
          {
            plugin = pkgs.vimPlugins.lightspeed-nvim;
            type = "lua";
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
          # heuristically set options for buffer (e.g. indentation)
          { plugin = pkgs.vimPlugins.vim-sleuth; }

          { plugin = pkgs.vimPlugins.vim-tmux-navigator; }
        ];

        ui-plugins =
          let
            # a dashboard for neovim (TODO make this nicer)
            dashboard = {
              plugin = pkgs.vimPlugins.dashboard-nvim;
              type = "lua";
              config = builtins.readFile ./plugins/dashboard.lua;
            };

            # nice popup windows
            dressing = {
              plugin = pkgs.vimPlugins.dressing-nvim;
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
            dashboard
            dressing
            indent-blank-line
            lsp-kind
            lsp-progress
            lualine
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
        ];

        copilot = {
          plugin = pkgs.vimPlugins.copilot-lua;
          type = "lua";
          config = builtins.readFile ./plugins/copilot.lua;
        };

        neorg = with pkgs; [
          {
            plugin = vimPlugins.neorg;
            type = "lua";
            config = builtins.readFile ./plugins/neorg.lua;
          }
          {
            plugin = vimPlugins.neorg-telescope;
            type = "lua";
            config = builtins.readFile ./plugins/neorg-telescope.lua;
          }
        ];

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

        lush = {
          plugin = pkgs.vimPlugins.lush-nvim;
          type = "lua";
        };

        # TODO remove once I move to https://github.com/jmederosalvarado/roslyn.nvim
        omnisharp-extended-lsp = {
          plugin = pkgs.vimPlugins.omnisharp-extended-lsp-nvim;
          type = "lua";
          config = "";
        };
        metals = {
          plugin = pkgs.vimPlugins.nvim-metals;
          type = "lua";
          config = builtins.readFile ./plugins/metals.lua;
        };
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
        aerial
        cmp
        conform-nvim
        copilot
        core-motion-plugins
        git-plugins
        haskell-tools
        kubectl
        lspconfig
        lush
        metals
        # neorg
        nvim-lint
        oil
        omnisharp-extended-lsp
        orgmode
        plenary
        telescope
        treesitter
        ui-plugins
      ];

    extraPackages = with pkgs; [
      gopls
      haskell-language-server
      lua-language-server
      nil
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      omnisharp-roslyn
      statix
      vale
      vscode-langservers-extracted
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
