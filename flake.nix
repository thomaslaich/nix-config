{
  description = "My Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # overlays
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    vimplugins-overlay.url = "github:thomaslaich/vimplugins-overlay";
    vimplugins-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # themes
    colorscheme.url = "github:buntec/nix-colorscheme";
  };

  outputs = { self, darwin, nixpkgs, home-manager, flake-utils, treefmt-nix
    , agenix, nix-vscode-extensions, neorg-overlay, vimplugins-overlay
    , emacs-overlay, colorscheme, ... }@attrs:
    let
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

      overlays = [
        # Nix VSCode Extensions Overlay
        nix-vscode-extensions.overlays.default
        # Neorg Overlay
        neorg-overlay.overlays.default
        # this adds a few vimplugins unavailable in nixpkgs
        vimplugins-overlay.overlays.default
        # Emacs Overlay
        emacs-overlay.overlays.default
      ];

      treefmtEval = eachSystem (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

    in rec {
      formatter = eachSystem (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in treefmtEval.${pkgs.system}.config.build.wrapper);

      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = nixpkgs.lib.nixosSystem {
          inherit (machine) system;
          specialArgs = attrs;
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
              # there is a bug in gnupg 2.4.1, so we need to downgrade to gnupag 2.2.x
              # in turn gnupg 2.2.x has an insecure dep
              # TODO remove when gnupg gets upgraded to >= 2.4.3
              nixpkgs.config.permittedInsecurePackages = [ "libgcrypt-1.8.10" ];
            }
            ./system/configuration-nixos.nix
            ./system/configuration-${machine.name}.nix
            agenix.homeManagerModules.default # user secrets
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${machine.user} = {
                  imports = [
                    ./home/home.nix
                    ./home/home-nixos.nix
                    ./home/home-${machine.name}.nix
                  ];
                };
              };
            }
          ];
        };
      }) nixosMachines);

      darwinConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = darwin.lib.darwinSystem {
          inherit (machine) system;
          specialArgs = attrs;
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
              # there is a bug in gnupg 2.4.1, so we need to downgrade to gnupag 2.2.x
              # in turn gnupg 2.2.x has an insecure dep
              # TODO remove when gnupg gets upgraded to >= 2.4.3
              nixpkgs.config.permittedInsecurePackages = [ "libgcrypt-1.8.10" ];
            }
            ./system/configuration-darwin.nix
            ./system/configuration-${machine.name}.nix
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${machine.user} = {
                  imports = [
                    agenix.homeManagerModules.default
                    {
                      imports = [ colorscheme.homeModules.colorscheme ];
                      colorscheme = {
                        enable = true;
                        name = "tokyonight-storm";
                      };
                    }
                    ./home/home.nix
                    ./home/home-darwin.nix
                    ./home/home-${machine.name}.nix
                  ];
                };
              };
            }
          ];
        };
      }) darwinMachines);

      apps = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (builtins.map (machine:
          let
            pkgs = import nixpkgs { inherit system; };
            script = pkgs.writeShellScript "rebuild-${machine.name}"
              (if (isDarwin machine) then
                "${
                  darwinConfigurations.${machine.name}.system
                }/sw/bin/darwin-rebuild switch --flake .#${machine.name}"
              else
                "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .#${machine.name}");
          in {
            name = "rebuild-${machine.name}";
            value = {
              type = "app";
              program = "${script}";
            };
          }) machines)) machinesBySystem;

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
