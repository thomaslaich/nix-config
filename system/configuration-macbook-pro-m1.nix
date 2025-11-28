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
}
