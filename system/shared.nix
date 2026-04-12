{
  outputs,
  ...
}:
{
  imports = [
    ./nix-settings.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config.allowUnfree = true;
  };
}
