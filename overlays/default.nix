# This file defines overlays
{ inputs, ... }:

let
  isDarwin = system: (builtins.match ".*darwin" system) != null;
in
{
  # # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {

  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable =
      import
        (if (isDarwin final.system) then inputs.nixpkgs-darwin-stable else inputs.nixpkgs-nixos-stable)
        {
          system = final.system;
          config.allowUnfree = true;
        };
  };
}
