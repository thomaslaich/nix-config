{ config, pkgs, ... }:

{
  homebrew.casks = [
    "discord"
    "docker"
    "nordvpn"
    "telegram"
    "whatsapp"
    "zoom"
  ];

  networking.hostName = "macbook-pro-m1";

  ids.gids.nixbld = 30000;

  nix.enable = false; # we need to disable this when using determinate nix
}
