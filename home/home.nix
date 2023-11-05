{ pkgs, ... }: {
  imports = [
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
    ./vscode/vscode.nix
    ./emacs/emacs.nix
  ];

  home.stateVersion = "22.11";

  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

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
    _1password
    amber
    any-nix-shell
    bat
    btop
    curl
    dotnet-sdk
    eza
    fd
    fzf
    gh
    httpie
    jq
    killall
    kubernetes-helm
    lazydocker
    lazygit
    lua
    ncdu
    nil
    nixfmt
    nixpkgs-fmt
    nodejs
    postgresql
    python-with-packages
    restic
    ripgrep
    scala-cli
    scc
    shellcheck
    stack
    statix
    tldr
    vagrant
    vale
    vifm
    wget
    yarn
    yazi
    zoxide
  ];
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userEmail = "thomaslaich@gmail.com";
      userName = "Thomas Laich";
      diff-so-fancy.enable = true;
    };

    zsh = { enable = true; };

    htop.enable = true;
    htop.settings.show_program_path = true;
  };
}
