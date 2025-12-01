{ config, pkgs, ... }:

{
  homebrew.casks = [
    "discord"
    "docker"
    "nordvpn"
    "telegram"
    "zoom"
  ];

  networking.hostName = "macbook-pro-m1";
}
