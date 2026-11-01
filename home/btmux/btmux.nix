{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.btmux.homeManagerModules.default ];

  programs.btmux = {
    enable = true;
    desktop.enable = true;
    service = {
      enable = true;
      host = "127.0.0.1";
      port = 8004;
      shell = "${pkgs.fish}/bin/fish";
    };
    settings = {
      prefix = "C-a";
      shell = "${pkgs.fish}/bin/fish";

      # Use desktop VS Code's settings, keybindings and extensions (from programs.vscode).
      vscode.desktop = true;

      # wallpaper-shader = "ink-flow";
      # wallpaper-saturate = 1.0;
      # wallpaper-speed = 1.0;
      # wallpaper-fps = 60;
      # wallpaper-shader-follows-keyboard-input = true;
      #
      # wallpaper-shader-params = {
      #   "chroma-flow" = {
      #     intensity = 1;
      #     momentum = 25;
      #     radius = 2;
      #   };
      #   "ink-flow" = {
      #     curl = 0;
      #     decay = 2;
      #     momentum = 0.5;
      #     radius = 0.25;
      #   };
      # };

      terminal = {
        font-family = "GeistMono Nerd Font";
        font-size = 16;
        font-weight = 300;
      };
    };
  };
}
