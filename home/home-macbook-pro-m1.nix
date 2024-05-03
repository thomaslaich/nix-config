{
  inputs,
  outputs,
  pkgs,
  ...
}:
{

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      outputs.overlays.stable-packages
    ];
  };

  home.packages = with pkgs; [

    pinentry_mac # gpg
  ];
}
