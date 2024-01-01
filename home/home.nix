{ pkgs, config, ... }: {
  imports = [
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
    ./vscode/vscode.nix
    ./emacs/emacs.nix
    ./email/email.nix
  ];

  # private dropbox
  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  home.stateVersion = "22.11";

  home.packages = let
    python-packages = ps:
      with ps; [
        jupyter
        numpy
        pandas
        python-lsp-ruff
        python-lsp-server
        requests
        scipy
      ];
    python-with-packages = pkgs.python3.withPackages python-packages;
  in with pkgs; [
    _1password # pw manager
    amber
    any-nix-shell
    bat # better cat
    curl # http requests from command line
    dotnet-sdk
    eza # better ls (bound to `l` and `la` in fish)
    fd
    fzf
    gh # github CLI
    ghc
    httpie
    jq # json parser
    killall
    kubernetes-helm
    lazydocker
    lua
    mu # maildir indexer
    ncdu
    nixfmt
    nixpkgs-fmt
    nodejs
    pinentry_mac # gpg
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
    gopls
    haskell-language-server
    haskellPackages.fourmolu # haskell formatter
    lua-language-server
    nil
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    omnisharp-roslyn
    statix
    stylua
    vale
    vscode-langservers-extracted
  ];

  # secrets for emacs 
  age.secrets = {
    gcal-clientid = {
      file = ../secrets/gcal-clientid.age;
      path = "${config.home.homeDirectory}/.emacs.d/gcal-clientid";
    };
    gcal-clientsecret = {
      file = ../secrets/gcal-clientsecret.age;
      path = "${config.home.homeDirectory}/.emacs.d/gcal-clientsecret";
    };
    authinfo = {
      file = ../secrets/authinfo.age;
      path = "${config.home.homeDirectory}/.authinfo";
    };
  };

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

  programs.starship = {
    enable = true;
    # promptInit = ''
    #   eval "$(starship init zsh)"
    # '';
  };

  programs.zsh = { enable = true; };

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
