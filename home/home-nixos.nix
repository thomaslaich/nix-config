{ pkgs, ... }:
{
  programs.git = {
    extraConfig = {
      credential.helper = "store";
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.packages = with pkgs; [
    docker
    whatsapp-for-linux
  ];
}
