{ pkgs, ... }:
{
  # plugin configs, `require("plugins.<name>")`-able from lazy-loading specs
  xdg.configFile."nvim/lua/plugins".source = ./plugins;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins =
      let
        # Plugins loaded at startup. Keep this list short: everything here is
        # sourced (and `setup()`) before the first frame is drawn.
        eager = [
          {
            plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
            type = "lua";
            config = builtins.readFile ./plugins/treesitter.lua;
          }

          {
            plugin = pkgs.vimPlugins.nvim-lspconfig;
            type = "lua";
            config = builtins.readFile ./plugins/lspconfig.lua;
          }

          # https://github.com/Saghen/blink.cmp
          # setup() is deferred to the first InsertEnter in plugins/lazy.lua
          { plugin = pkgs.vimPlugins.blink-cmp; }
          { plugin = pkgs.vimPlugins.lspkind-nvim; }

          # https://github.com/folke/snacks.nvim
          # bigfile/quickfile need to be active before the first buffer is read
          {
            plugin = pkgs.vimPlugins.snacks-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/snacks.lua;
          }

          # linting for some languages (when no lsp available)
          {
            plugin = pkgs.vimPlugins.nvim-lint;
            type = "lua";
            config = builtins.readFile ./plugins/nvim-lint.lua;
          }

          { plugin = pkgs.vimPlugins.plenary-nvim; }
          { plugin = pkgs.vimPlugins.haskell-tools-nvim; }
          { plugin = pkgs.vimPlugins.vim-tmux-navigator; }

          # copilot is starting to annoy me
          # {
          #   plugin = pkgs.vimPlugins.copilot-lua;
          #   type = "lua";
          #   config = builtins.readFile ./plugins/copilot.lua;
          # }

          # nice popup windows
          { plugin = pkgs.vimPlugins.dressing-nvim; }

          # https://github.com/echasnovski/mini.icons
          # also stands in for nvim-web-devicons, which is much slower to load
          {
            plugin = pkgs.vimPlugins.mini-icons;
            type = "lua";
            config = ''
              require("mini.icons").setup({})
              MiniIcons.mock_nvim_web_devicons()
            '';
          }

          {
            plugin = pkgs.vimPlugins.mini-colors;
            type = "lua";
            config = ''
              require("mini.colors").setup({})
            '';
          }

          # status line
          {
            plugin = pkgs.vimPlugins.lualine-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/lualine.lua;
          }

          # https://github.com/nvim-neorocks/lz.n
          {
            plugin = pkgs.vimPlugins.lz-n;
            type = "lua";
            config = builtins.readFile ./plugins/lazy.lua;
          }
        ];

        # Plugins loaded on demand by lz.n; their specs and configs are in
        # plugins/lazy.lua.
        lazy = map (plugin: {
          inherit plugin;
          optional = true;
        }) (
          with pkgs.vimPlugins;
          [
            fzf-lua
            conform-nvim
            diffview-nvim
            neogit
            git-blame-nvim
            grug-far-nvim
            refactoring-nvim
            trouble-nvim
            nvim-treesitter-context
            precognition-nvim
            neorg
            better-escape-nvim
            gitsigns-nvim
            which-key-nvim
            indent-blankline-nvim
            nvim-surround
            comment-nvim
          ]
        );
      in
      eager ++ lazy;

    extraPackages = [ ];

    initLua = builtins.readFile ./init.lua;
  };
}
