{ pkgs, inputs, ... }:
{
  programs.git = {
    extraConfig = {
      credential.helper = "store";
    };
  };

  dconf.enable = true;
  # dconf.settings = {
  #   "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # };

  home.packages = with pkgs; [
    _1password-gui
    dropbox
    firefox
    kubernetes
    pritunl-client
    rancher
    whatsapp-for-linux
    ghostty
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1; # for vscode
  };
}
