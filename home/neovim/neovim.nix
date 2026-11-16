{ pkgs, ... }:
let
  # plugin whose config lives in ./plugins/<file>
  withConfig = plugin: file: {
    inherit plugin;
    type = "lua";
    config = builtins.readFile ./plugins/${file};
  };

  # plugin with an inline lua config
  withLua = plugin: config: {
    inherit plugin config;
    type = "lua";
  };
in
{
  # neorg is loaded on demand from init.lua via `require("plugins.neorg")`
  xdg.configFile."nvim/lua/plugins/neorg.lua".source = ./plugins/neorg.lua;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      (withConfig nvim-treesitter.withAllGrammars "treesitter.lua")
      (withConfig nvim-lspconfig "lspconfig.lua")
      # linting for some languages (when no lsp available)
      (withConfig nvim-lint "nvim-lint.lua")
      (withConfig lualine-nvim "lualine.lua")

      (withConfig fzf-lua "fzf-lua.lua")
      (withConfig conform-nvim "conform-nvim.lua")
      # before neogit, which auto-detects it as its diff viewer
      (withLua diffview-nvim ''require("diffview").setup({})'')
      (withConfig neogit "neogit.lua")
      (withConfig gitsigns-nvim "gitsigns.lua")
      (withLua grug-far-nvim ''require("grug-far").setup({})'')
      (withLua trouble-nvim ''require("trouble").setup({})'')
      (withLua nvim-treesitter-context ''require("treesitter-context").setup({ enable = false })'')
      (withLua precognition-nvim ''require("precognition").setup({ startVisible = false })'')
      (withLua better-escape-nvim ''require("better_escape").setup({})'')
      (withConfig which-key-nvim "which-key.lua")
      (withConfig indent-blankline-nvim "indent-blankline.lua")
      (withLua nvim-surround ''require("nvim-surround").setup({})'')

      {
        plugin = neorg;
        optional = true;
      }
    ];

    initLua = builtins.readFile ./init.lua;
  };
}
