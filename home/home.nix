{
  lib,
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
let
  dotnet-packages =
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_9_0-bin
      sdk_8_0-bin
    ];
  inherit (config.home) homeDirectory;
in
{
  imports = [
    # inputs.kauz.homeModules.default
    # inputs.nix-colorscheme.homeModules.colorscheme
    inputs.agenix.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ../stylix.nix
    {
      stylix.targets = {
        neovim = {
          transparentBackground = {
            main = true;
            numberLine = true;
            signColumn = true;
          };
        };
        vscode = {
          enable = true;
          profileNames = [ "default" ];
        };
      };
    }
    ./fish/fish.nix
    ./ghostty/ghostty.nix
    ./neovim/neovim.nix
    ./tmux/tmux.nix
    ./vscode/vscode.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      inputs.neorg-overlay.overlays.default
      inputs.vimplugins-overlay.overlays.default
      inputs.nix-vscode-extensions.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "thomaslaich@gmail.com";
    userName = "Thomas Laich";
    diff-so-fancy.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  # # private dropbox
  # services.syncthing = {
  #   enable = true;
  #   extraOptions = [ ];
  # };

  # for some reason fish enables this by default. This siginificantly slows down hm-switch when enabled.
  programs.man.generateCaches = false;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.gpg = {
    enable = true;
    # package = pkgs.gnupg22;
    settings = {
      # allow pw fill in applications like emacs without popups
      pinentry-mode = "loopback";
      # allow-loopback-entry = true;
    };
  };

  programs.zoxide.enable = true;

  home.packages =
    let
      dotnet-language-support = with pkgs; [
        dotnet-packages
        csharpier
        roslyn-ls # LSP for use in Neovim and Emacs
      ];

      python-with-packages = pkgs.python312.withPackages (
        ps: with ps; [
          jupyter
          matplotlib
          numpy
          pandas
          pyarrow
          requests
          scipy
        ]
      );
      python-language-support = with pkgs; [
        pixi # dep management with Conda
        pyright # LSP (TODO replace with ty once stable)
        python-with-packages
        ruff # formatter
        uv # dep management with PyPI
      ];
      nix-tools = with pkgs; [
        any-nix-shell
        nil # LSP
        nixfmt-rfc-style # formatter
        statix # linter
      ];
      haskell-language-support = with pkgs; [
        haskell-language-server # LSP
        haskellPackages.fourmolu # formatter
      ];
      lua-language-support = with pkgs; [
        lua # interpreter
        lua-language-server # LSP
        stylua # formatter
      ];
      go-language-support = with pkgs; [
        go # compiler, formatter, dep management
        gopls # LSP
      ];
      cpp-c-language-support = with pkgs; [
        # clang # commented -> you should use clang from XCode in macOS, or gcc on NixOS
        clang-tools # LSP, formatter, linter
        libcxx # needed for bazel?
      ];
      web-dev-support = with pkgs; [
        nodePackages.prettier # formatter
        nodePackages.typescript-language-server # LSP for JS/TS
        nodejs # JS/TS
        prettierd # formatter
        stylelint # CSS linter
        watchman # relay GQL incremental compilation
        yarn # dep management
      ];
      bash-language-support = with pkgs; [
        bash-language-server
        shfmt # formatter
      ];
      rust-language-support = with pkgs; [
        rust-analyzer # LSP
        rustfmt # formatter
        cargo # compiler / dep management
      ];
      java-language-support = with pkgs; [
        jdk # compiler / JVM
      ];
      misc-langauge-tools = with pkgs; [
        taplo # TOML tools
        vale # markdown linter
        vscode-langservers-extracted # LSPs for various config formats
        yamlfmt # YAML formatter
      ];
      gui-apps = with pkgs; [
        # ghostty # currently broken in nixpkgs
      ];
      git-tools = with pkgs; [
        gh # github CLI
        gitu # Magit clone for the command line
      ];
      json-tools = with pkgs; [
        fx
        jless
        jq # JSON parser
      ];
      network-tools = with pkgs; [
        curl
        hey
        wget
        xh
      ];
      cloud-tools = with pkgs; [
        azure-cli
        (google-cloud-sdk.withExtraComponents (
          with google-cloud-sdk.components;
          [
            kubectl
            gke-gcloud-auth-plugin
            bq
          ]
        ))
        k9s
        kubelogin
        kubernetes-helm
        lazydocker
        terraform
      ];
      database-tools = with pkgs; [
        duckdb
        postgresql
      ];
      build-tools = with pkgs; [
        bazelisk # bazel wrapper (similar to NVM)
      ];
      misc = with pkgs; [
        # _1password-cli # pw manager
        age # file encryption tool, used togehter with agenix - https://github.com/FiloSottile/age
        agenix-cli
        amber # search & replace - https://github.com/dalance/amber
        bat # better cat - https://github.com/sharkdp/bat
        eza # better ls (bound to `l` and `la` in fish)
        fd
        fzf
        httpie
        killall
        libnotify
        ncdu
        openssl
        restic
        ripgrep # better grep
        scc # analyse codebases
        tldr # simpler manpages
        vifm
        yazi # file manager
      ];
    in
    pkgs.lib.lists.flatten [
      # language support
      dotnet-language-support
      python-language-support
      nix-tools
      haskell-language-support
      lua-language-support
      go-language-support
      cpp-c-language-support
      web-dev-support
      bash-language-support
      rust-language-support
      java-language-support
      misc-langauge-tools

      # GUI apps
      gui-apps

      # Other
      git-tools
      json-tools
      network-tools
      cloud-tools
      database-tools
      build-tools
      misc

      # inputs.hcat.packages.${system}.default
    ];

  # secrets from agenix
  age.secrets = {
    gcal-clientid = {
      file = ../secrets/gcal-clientid.age;
      path = "${homeDirectory}/.emacs.d/gcal-clientid";
    };
    gcal-clientsecret = {
      file = ../secrets/gcal-clientsecret.age;
      path = "${homeDirectory}/.emacs.d/gcal-clientsecret";
    };
    authinfo = {
      file = ../secrets/authinfo.age;
      path = "${homeDirectory}/.authinfo";
    };
    netrc = {
      file = ../secrets/netrc.age;
      path = "${homeDirectory}/.netrc";
    };
    claptrap = {
      file = ../secrets/claptrap.age;
    };
  };

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-packages}/share/dotnet";
  };
}
