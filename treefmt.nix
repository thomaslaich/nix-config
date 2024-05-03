{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt-rfc-style.enable = true;
  settings.formatter.nixfmt-rfc-style.excludes = [ "hardware-configuration.nix" ];
  programs.stylua.enable = true;
}
