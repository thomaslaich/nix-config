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

  nix.package = pkgs.nix; # needed because I don't use determinate nix yet on my work volume
  nix.enable = true;
}
