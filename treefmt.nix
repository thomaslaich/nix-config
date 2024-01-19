{ pkgs, ... }: {
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  settings.formatter.nixfmt.excludes = [ "hardware-configuration.nix" ];
  programs.stylua.enable = true;
}
