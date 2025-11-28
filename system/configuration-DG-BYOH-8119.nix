{ config, pkgs, ... }:

{
  homebrew.casks = [
    "banana-cake-pop"
    "microsoft-teams"
    "pritunl"
    "rancher"
  ];

  networking.hostName = "DG-BYOH-8119";
}
