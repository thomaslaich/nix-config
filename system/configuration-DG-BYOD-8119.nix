{ config, pkgs, ... }:

{
  homebrew.casks = [
    "banana-cake-pop"
    "microsoft-teams"
    "pritunl"
    "rancher"
  ];

  networking.hostName = "DG-BYOD-8119";

  ids.gids.nixbld = 350;
}
