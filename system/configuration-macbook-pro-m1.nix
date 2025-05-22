{ config, pkgs, ... }:

{
  homebrew.casks = [
    "nordvpn"
    "docker"
    "telegram"
    "whatsapp"
    "zoom"
  ];

  networking.hostName = "macbook-pro-m1";

  ids.gids.nixbld = 30000;
}
