{ pkgs, config, ... }: {
  imports = [
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
    # ./vscode/vscode.nix
    ./emacs/emacs.nix
    ./email/email.nix
  ];

  # private dropbox
  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  # I use this for pipx installations now
  # Of course I should not use pipx and instead install all CLI tools from source
  home.sessionPath =
    [ "/Users/thomaslaich/.local/bin" "/Users/thomaslaich/.rd/bin" ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
    KRB5_CONFIG = "/Users/thomaslaich/.config/krb5.conf";
  };

  home.stateVersion = "22.11";

  home.packages = let
    python-packages = ps:
      with ps; [
        jupyter
        numpy
        pandas
        pipx
        python-lsp-ruff
        python-lsp-server
        requests
        scipy
      ];
    python-with-packages = pkgs.python3.withPackages python-packages;
  in with pkgs; [
    _1password # pw manager
    age
    amber
    any-nix-shell
    azure-cli
    bat # better cat
    curl # http requests from command line
    dotnet-sdk_7
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
    netrc = {
      file = ../secrets/netrc.age;
      path = "${config.home.homeDirectory}/.netrc";
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
