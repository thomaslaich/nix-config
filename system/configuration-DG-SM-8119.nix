{ config, pkgs, ... }:

{
  homebrew.casks = [
    "banana-cake-pop"
    "microsoft-teams"
    "pritunl"
    "rancher"
  ];

  networking.hostName = "DG-SM-8119";
}
