{
  description = "My Nix configs";

  inputs = {
    # utils
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-nixos-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # secret management with agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # overlays
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    vimplugins-overlay.url = "github:thomaslaich/vimplugins-overlay";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # theming
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    kauz = {
      url = "github:buntec/kauz";
      flake = false;
    };
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      nixpkgs-nixos,
      home-manager,
      devenv,
      flake-utils,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      inherit (lib) genAttrs;

      machines = [
        {
          name = "macbook-pro-m1";
          user = "thomaslaich";
          system = flake-utils.lib.system.aarch64-darwin;
        }
        {
          name = "lenovo-desktop";
          user = "thomaslaich";
          system = flake-utils.lib.system.x86_64-linux;
        }
        # My Galaxus device
        {
          name = "DG-BYOH-8119";
          user = "thomaslaich";
          system = flake-utils.lib.system.aarch64-darwin;
        }
      ];
      isDarwin = system: (builtins.match ".*darwin" system) != null;
      darwinMachines = builtins.filter (machine: isDarwin machine.system) machines;
      nixosMachines = builtins.filter (machine: !isDarwin machine.system) machines;
      machinesBySystem = builtins.groupBy (machine: machine.system) machines;
      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = import ./overlays { inherit inputs; };

      # we select the branch according to recommendation in https://nix.dev/concepts/faq.html#rolling
      pkgsBySystem = builtins.listToAttrs (
        builtins.map (system: {
          name = system;
          value = import (if (isDarwin system) then nixpkgs else nixpkgs-nixos) {
            inherit system;
            # inherit overlays;
            config = {
              allowUnfree = true;
            };
          };
        }) systems
      );

      treefmtEval = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        treefmt-nix.lib.evalModule pkgs ./treefmt.nix
      );

    in
    rec {
      inherit overlays;

      devShells = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              (
                { pkgs, config, ... }:
                {
                  languages.lua.enable = true;
                  languages.nix.enable = true;
                  packages = with pkgs; [ just ];
                }
              )
            ];
          };
        }
      );

      formatter = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        treefmtEval.${pkgs.system}.config.build.wrapper
      );

      nixosConfigurations = builtins.listToAttrs (
        builtins.concatMap
          (
            mode:
            builtins.map (machine: {
              name = "${machine.name}-${mode}";
              value = lib.nixosSystem {
                inherit (machine) system;
                specialArgs = {
                  inherit inputs outputs mode;
                };
                modules = [
                  ./system/configuration-nixos.nix
                  ./system/configuration-${machine.name}.nix
                ];
              };
            }) nixosMachines
          )
          [
            "light"
            "dark"
          ]
      );

      darwinConfigurations = builtins.listToAttrs (
        builtins.concatMap
          (
            mode:
            builtins.map (machine: {
              name = "${machine.name}-${mode}";
              value = darwin.lib.darwinSystem {
                inherit (machine) system;
                specialArgs = {
                  inherit inputs outputs mode;
                };
                modules = [
                  ./system/configuration-darwin.nix
                  ./system/configuration-${machine.name}.nix
                  inputs.nix-homebrew.darwinModules.nix-homebrew
                  {
                    nix-homebrew = {
                      inherit (machine) user;
                      enable = true;
                      enableRosetta = true;
                      taps = {
                        "homebrew/homebrew-core" = inputs.homebrew-core;
                        "homebrew/homebrew-cask" = inputs.homebrew-cask;
                      };
                      autoMigrate = true; # Automatically migrate existing Homebrew installations
                    };
                  }
                ];
              };
            }) darwinMachines
          )
          [
            "light"
            "dark"
          ]
      );

      homeConfigurations = builtins.listToAttrs (
        builtins.concatMap
          (
            mode:
            builtins.map (machine: {
              name = "${machine.name}-${mode}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = pkgsBySystem.${machine.system};
                extraSpecialArgs = {
                  inherit inputs outputs mode;
                };
                modules = [
                  {
                    home.username = machine.user;
                    home.homeDirectory =
                      if (isDarwin machine.system) then "/Users/${machine.user}" else "/home/${machine.user}";
                  }
                  ./home/home.nix
                  ./home/home-${if (isDarwin machine.system) then "darwin" else "nixos"}.nix
                  ./home/home-${machine.name}.nix
                ];
              };
            }) machines
          )
          [
            "light"
            "dark"
          ]
      );

      apps = builtins.mapAttrs (
        system: machines:
        builtins.listToAttrs (
          lib.flatten (
            builtins.map (
              machine:
              let
                pkgs = pkgsBySystem.${system};
                rebuildScriptLight = pkgs.writeShellScript "rebuild-${machine.name}-light" (
                  if (isDarwin machine.system) then
                    "${
                      self.darwinConfigurations.${"${machine.name}-dark"}.system
                    }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}-light"
                  else
                    "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}-light"
                );
                rebuildScriptDark = pkgs.writeShellScript "rebuild-${machine.name}-dark" (
                  if (isDarwin machine.system) then
                    "${
                      self.darwinConfigurations.${"${machine.name}-dark"}.system
                    }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}-dark"
                  else
                    "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}-dark"
                );
                hmSwitchScriptLight = pkgs.writeShellScript "hm-switch-${machine.name}-light" "${
                  inputs.home-manager.packages.${system}.home-manager
                }/bin/home-manager switch --flake ${self}#${machine.name}-light";
                hmSwitchScriptDark = pkgs.writeShellScript "hm-switch-${machine.name}-dark" "${
                  inputs.home-manager.packages.${system}.home-manager
                }/bin/home-manager switch --flake ${self}#${machine.name}-dark";
              in
              [
                {
                  name = "rebuild-${machine.name}-light";
                  value = {
                    type = "app";
                    program = "${rebuildScriptLight}";
                  };
                }
                {
                  name = "rebuild-${machine.name}-dark";
                  value = {
                    type = "app";
                    program = "${rebuildScriptDark}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}-dark";
                  value = {
                    type = "app";
                    program = "${hmSwitchScriptDark}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}-light";
                  value = {
                    type = "app";
                    program = "${hmSwitchScriptLight}";
                  };
                }
              ]
            ) machines
          )
        )
      ) machinesBySystem;

      # add all nixos and darwin configs to checks
      checks =
        (builtins.mapAttrs (
          system: machines:
          builtins.listToAttrs (
            builtins.map (
              machine:
              let
                toplevel =
                  if (isDarwin machine.system) then
                    darwinConfigurations.${machine.name}.config.system.build.toplevel
                  else
                    nixosConfigurations.${machine.name}.config.system.build.toplevel;
              in
              {
                name = "toplevel-${machine.name}";
                value = toplevel;
              }
            ) machines
          )
        ) machinesBySystem)
        // eachSystem (system: {
          formatting = treefmtEval.${system}.config.build.check self;
        });
    };
}
