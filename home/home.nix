{ inputs, outputs, pkgs, config, ... }:
let
  dotnet-packages = with pkgs.dotnetCorePackages;
    combinePackages [ sdk_8_0 sdk_7_0 sdk_6_0 ];
  inherit (config.home) homeDirectory;

in {
  imports = [
    inputs.kauz.homeModules.default
    inputs.agenix.homeManagerModules.default
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
    ./emacs/emacs.nix
    ./email/email.nix
  ];

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

  programs.zsh = { enable = true; };

  # Kauz colorscheme
  kauz = {
    fish.enable = true;
    kitty.enable = true;
    neovim.enable = true;
    tmux.enable = true;
  };

  # private dropbox
  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # from inputs

      # Kauz colorscheme overlay
      inputs.kauz.overlays.default
      # Neorg Overlay
      inputs.neorg-overlay.overlays.default
      # this adds a few vimplugins unavailable in nixpkgs
      inputs.vimplugins-overlay.overlays.default
      # this adds a few emacs packages unavailable in nixpkgs
      inputs.epkgs-overlay.overlays.default
      # Emacs overlay
      inputs.emacs-overlay.overlays.default
      # dg-cli overlay
      inputs.dg-nix.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      # there is a bug in gnupg 2.4.1, so we need to downgrade to gnupag 2.2.x
      # in turn gnupg 2.2.x has an insecure dep
      # TODO remove when gnupg gets upgraded to >= 2.4.3
      permittedInsecurePackages = [ "libgcrypt-1.8.10" ];
    };
  };

  # I use this for pipx installations now
  # Of course I should not use pipx and instead install all CLI tools from source
  home.sessionPath =
    [ "${homeDirectory}/.local/bin" "${homeDirectory}/.rd/bin" ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-packages}";
    KRB5_CONFIG = "${homeDirectory}/.config/krb5.conf";
  };

  home.packages = let
    python-packages = ps:
      with ps; [
        jupyter
        numpy
        pandas
        # pipx
        python-lsp-ruff
        python-lsp-server
        requests
        scipy
      ];
    python-with-packages = pkgs.python3.withPackages python-packages;
    dg-cli-with-plugins = pkgs.dg-cli.withPlugins (plugins:
      with plugins; [
        dg-cli-plugin-azure-devops
        # dg-cli-plugin-digidog
        dg-cli-plugin-graphql
        dg-cli-plugin-kafka
        # dg-cli-plugin-kube
        dg-cli-plugin-mongodb
        # dg-cli-plugin-ravendb
        dg-cli-plugin-sql
        dg-cli-plugin-templates
        # dg-cli-plugin-topiccompare
        # dg-cli-plugin-statictranslations
        # dg-cli-plugin-github
        # dg-cli-plugin-devcontainer
        # dg-cli-plugin-keyringdevcontainer
      ]);
  in with pkgs;
  [
    _1password # pw manager
    age
    amber
    any-nix-shell
    azure-cli
    bat # better cat
    curl # http requests from command line
    eza # better ls (bound to `l` and `la` in fish)
    fd
    fzf
    gh # github CLI
    ghc
    httpie
    jq # json parser
    killall
    krb5
    kubelogin
    kubernetes-helm
    lazydocker
    lua
    mu # maildir indexer
    ncdu
    nixfmt
    nixpkgs-fmt
    nodejs
    openssl
    poetry
    postgresql
    python-with-packages
    restic
    ripgrep # better grep
    scala-cli
    scc # analyse codebases
    tldr # simpler manpages
    vifm
    wget
    yarn
    yazi
    zoxide # better cd (bound to `z` in fish)

    # lsps and formatters
    clang-tools
    csharpier # needed for emacs (format-all-the-code and neoformat)
    gopls
    haskell-language-server
    haskellPackages.fourmolu # haskell formatter
    lua-language-server
    nil
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.typescript-language-server
    omnisharp-roslyn
    prettierd
    ruff
    ruff-lsp
    statix
    stylua
    vale
    vscode-langservers-extracted
    yamlfmt

    # Galaxus
    dg-cli-with-plugins
    watchman # relay GQL incremental compilation
  ] ++

  # stable packages
  (with pkgs.stable;
    [
      pinentry_mac # gpg
    ]) ++ [ dotnet-packages ];

  # secrets for from agenix 
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
  };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.gpg = {
    enable = true;
    package = pkgs.gnupg22;
    settings = {
      # allow pw fill in applications like emacs without popups
      pinentry-mode = "loopback";
      # allow-loopback-entry = true;
    };
  };
}
