{
  description = "My Nix configs";

  inputs = {
    # utils 
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-nixos-stable.url = "github:nixos/nixpkgs/nixos-24.11";

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
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    epkgs-overlay.url = "github:thomaslaich/epkgs-overlay";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay?ref=pull/11/head"; # latest master is currently broken, TODO: undo this change
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions?rev=8e091c59f250bcc1f6e73350fcacc59b36769ade";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vimplugins-overlay.url = "github:thomaslaich/vimplugins-overlay";

    # themes
    # kauz.url = "github:buntec/kauz";
    nix-colorscheme.url = "github:buntec/nix-colorscheme";

    hcat.url = "github:thomaslaich/hcat";

    # dg-cli, etc.
    dg-nix.url = "git+ssh://git@ssh.dev.azure.com/v3/DigitecGalaxus/devinite/Chabis.Nix";
    dg-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
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
                  scripts.rebuild.exec = ''
                    hostname=$(hostname)
                    nix run .#rebuild-$hostname
                  '';
                  scripts.hm-switch.exec = ''
                    hostname=$(hostname)
                    nix run .#hm-switch-$hostname
                  '';
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
        builtins.map (machine: {
          inherit (machine) name;
          value = lib.nixosSystem {
            inherit (machine) system;
            specialArgs = {
              inherit inputs outputs;
            };
            modules = [
              ./system/configuration-nixos.nix
              ./system/configuration-${machine.name}.nix
            ];
          };
        }) nixosMachines
      );

      darwinConfigurations = builtins.listToAttrs (
        builtins.map (machine: {
          inherit (machine) name;
          value = darwin.lib.darwinSystem {
            inherit (machine) system;
            specialArgs = {
              inherit inputs outputs;
            };
            modules = [
              ./system/configuration-darwin.nix
              ./system/configuration-${machine.name}.nix
            ];
          };
        }) darwinMachines
      );

      homeConfigurations = builtins.listToAttrs (
        builtins.map (machine: {
          inherit (machine) name;
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsBySystem.${machine.system};
            extraSpecialArgs = {
              inherit inputs outputs;
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
      );

      apps = builtins.mapAttrs (
        system: machines:
        builtins.listToAttrs (
          lib.flatten (
            builtins.map (
              machine:
              let
                pkgs = pkgsBySystem.${system};
                rebuildScript = pkgs.writeShellScript "rebuild-${machine.name}" (
                  if (isDarwin machine.system) then
                    "${
                      self.darwinConfigurations.${machine.name}.system
                    }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}"
                  else
                    "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}"
                );
                hmSwitchScript = pkgs.writeShellScript "hm-switch-${machine.name}" "${
                  inputs.home-manager.packages.${system}.home-manager
                }/bin/home-manager switch --flake ${self}#${machine.name}";
              in
              [
                {
                  name = "rebuild-${machine.name}";
                  value = {
                    type = "app";
                    program = "${rebuildScript}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}";
                  value = {
                    type = "app";
                    program = "${hmSwitchScript}";
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
