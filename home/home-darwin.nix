{
  lib,
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./vscode/vscode.nix
    # ./zed/zed.nix
  ];

  home.packages = with pkgs; [
    pinentry_mac # gpg
  ];
}
