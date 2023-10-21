{
  description = "My Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  outputs = { darwin, nixpkgs, home-manager, flake-utils, nix-vscode-extensions
    , neorg-overlay, ... }@attrs:
    let
      machines = [
        {
          name = "macbook-pro-m1";
          user = "thomaslaich";
          system = flake-utils.lib.system.aarch64-darwin;
        }
        {
          name = "lenovo-desktop-intel";
          user = "thomaslaich";
          system = flake-utils.lib.system.x86_64-linux;
        }
      ];
      isDarwin = machine: (builtins.match ".*darwin" machine.system) != null;
      darwinMachines = builtins.filter (machine: isDarwin machine) machines;
      nixosMachines = builtins.filter (machine: !isDarwin machine) machines;
      machinesBySystem = builtins.groupBy (machine: machine.system) machines;

      overlays = [
        # Nix VSCode Extensions Overlay
        nix-vscode-extensions.overlays.default
        # Neorg Overlay
        neorg-overlay.overlays.default
      ];
    in rec {
      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine.name;
        value = nixpkgs.lib.nixosSystem {
          system = machine.system;
          specialArgs = attrs;
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }
            ./system/configuration-nixos.nix
            ./system/configuration-${machine.name}.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${machine.user} = {
                imports = [
                  ./home/home.nix
                  ./home/home-nixos.nix
                  ./home/home-${machine.name}.nix
                ];
              };
            }
          ];
        };
      }) nixosMachines);

      darwinConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine.name;
        value = darwin.lib.darwinSystem {
          system = machine.system;
          specialArgs = attrs;
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }
            ./system/configuration-darwin.nix
            ./system/configuration-${machine.name}.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${machine.user} = {
                imports = [
                  ./home/home.nix
                  ./home/home-darwin.nix
                  ./home/home-${machine.name}.nix
                ];
              };
            }
          ];
        };
      }) darwinMachines);

      apps = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (builtins.map (machine:
          let
            pkgs = import nixpkgs { inherit system; };
            script = (pkgs.writeShellScript "rebuild-${machine.name}"
              (if (isDarwin machine) then
                "${
                  darwinConfigurations.${machine.name}.system
                }/sw/bin/darwin-rebuild switch --flake .#${machine.name}"
              else
                "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .#${machine.name}"));
          in {
            name = "rebuild-${machine.name}";
            value = {
              type = "app";
              program = "${script}";
            };
          }) machines)) machinesBySystem;
    };
}
