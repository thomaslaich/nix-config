# This file defines overlays
{ inputs, ... }:

let
  # # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    {

    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  from-inputs = with inputs; [
    # Kauz colorscheme overlay
    kauz.overlays.default
    # Neorg Overlay
    neorg-overlay.overlays.default
    # this adds a few vimplugins unavailable in nixpkgs
    vimplugins-overlay.overlays.default
    # this adds a few emacs packages unavailable in nixpkgs
    epkgs-overlay.overlays.default
    # Emacs overlay
    emacs-overlay.overlays.default
  ];

in [
  # additions
  modifications
  stable-packages
] ++ from-inputs

