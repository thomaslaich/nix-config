{
  description = "My Nix configs";

  inputs = {
    # utils 
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # nixpkgs (note i currently don't have a linux machine, so I'm only using unstable and darwin channels)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";

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
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    vimplugins-overlay.url = "github:thomaslaich/vimplugins-overlay";
    epkgs-overlay.url = "github:thomaslaich/epkgs-overlay";

    # themes
    kauz.url = "github:buntec/kauz";

    # dg-cli, etc.
    dg-nix.url =
      "git+ssh://git@ssh.dev.azure.com/v3/DigitecGalaxus/Playground/Dg.Nix";
    dg-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, darwin, nixpkgs, home-manager, devenv, flake-utils
    , treefmt-nix, agenix, neorg-overlay, vimplugins-overlay, epkgs-overlay
    , emacs-overlay, kauz, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      inherit (lib) genAttrs;

      machines = [{
        name = "macbook-pro-m1";
        user = "thomaslaich";
        system = flake-utils.lib.system.aarch64-darwin;
      }
      # commented for now
      # {
      #   name = "lenovo-desktop";
      #   user = "thomaslaich";
      #   system = flake-utils.lib.system.x86_64-linux;
      # }
        ];
      isDarwin = machine: (builtins.match ".*darwin" machine.system) != null;
      darwinMachines = builtins.filter isDarwin machines;
      nixosMachines = builtins.filter (machine: !isDarwin machine) machines;
      machinesBySystem = builtins.groupBy (machine: machine.system) machines;
      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = import ./overlays { inherit inputs; };

      treefmtEval = eachSystem (system:
        let pkgs = import nixpkgs { inherit system; };
        in treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

    in rec {
      inherit overlays;

      devShells = eachSystem (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              ({ pkgs, config, ... }: {
                languages.lua.enable = true;
                languages.nix.enable = true;
              })
            ];
          };
        });

      formatter = eachSystem (system:
        let pkgs = import nixpkgs { inherit system; };
        in treefmtEval.${pkgs.system}.config.build.wrapper);

      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = nixpkgs.lib.nixosSystem {
          inherit (machine) system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./system/configuration-nixos.nix
            ./system/configuration-${machine.name}.nix
          ];
        };
      }) nixosMachines);

      darwinConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = darwin.lib.darwinSystem {
          inherit (machine) system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./system/configuration-darwin.nix
            ./system/configuration-${machine.name}.nix
            agenix.darwinModules.default
          ];
        };
      }) darwinMachines);

      homeConfigurations = builtins.listToAttrs (builtins.map (machine:
        let pkgs = import nixpkgs { inherit (machine) system; };
        in {
          inherit (machine) name;
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [
              {
                home.username = machine.user;
                home.homeDirectory = if (isDarwin machine) then
                  "/Users/${machine.user}"
                else
                  "/home/${machine.user}";
              }
              ./home/home.nix
              ./home/home-${
                if (isDarwin machine) then "darwin" else "nixos"
              }.nix
              ./home/home-${machine.name}.nix
            ];
          };
        }) machines);

      apps = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (lib.flatten (builtins.map (machine:
          let
            pkgs = import nixpkgs { inherit system; };
            rebuildScript = pkgs.writeShellScript "rebuild-${machine.name}"
              (if (isDarwin machine) then
                "${
                  self.darwinConfigurations.${machine.name}.system
                }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}"
              else
                "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}");
            hmSwitchScript = pkgs.writeShellScript "hm-switch-${machine.name}"
              "${
                inputs.home-manager.packages.${system}.home-manager
              }/bin/home-manager switch --flake ${self}#${machine.name}";
          in [
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
          ]) machines))) machinesBySystem;

      # add all nixos and darwin configs to checks
      checks = (builtins.mapAttrs (system: machines:
        builtins.listToAttrs (builtins.map (machine:
          let
            toplevel = if (isDarwin machine) then
              darwinConfigurations.${machine.name}.config.system.build.toplevel
            else
              nixosConfigurations.${machine.name}.config.system.build.toplevel;
          in {
            name = "toplevel-${machine.name}";
            value = toplevel;
          }) machines)) machinesBySystem) // eachSystem (system: {
            formatting = treefmtEval.${system}.config.build.check self;
          });
    };
}
