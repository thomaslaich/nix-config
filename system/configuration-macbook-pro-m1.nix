{ config, pkgs, ... }:

{
  homebrew.casks = [
    "nordvpn"
    "docker"
    "telegram"
    "whatsapp"
  ];

  networking.hostName = "macbook-pro-m1";
  
  ids.gids.nixbld = 30000;
}
