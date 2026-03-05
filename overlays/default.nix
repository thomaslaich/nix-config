# This file defines overlays
{
  inputs,
  ...
}:

let
  isDarwin = system: (builtins.match ".*darwin" system) != null;
in
{
  modifications = final: prev: {
    codex-cli-nix = inputs.codex-cli-nix.packages.${final.stdenv.hostPlatform.system}.default;
  };

  stable-packages = final: _prev: {
    stable =
      import
        (
          if (isDarwin final.stdenv.hostPlatform.system) then
            inputs.nixpkgs-darwin-stable
          else
            inputs.nixpkgs-nixos-stable
        )
        {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
  };
}
