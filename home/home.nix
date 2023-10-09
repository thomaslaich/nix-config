{ pkgs, ... }: {
  imports = [
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
    ./vscode/vscode.nix
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    python-with-packages = (pkgs.python3.withPackages python-packages);
  in with pkgs; [
    amber
    any-nix-shell
    bat
    curl
    eza
    fd
    fzf
    gh
    httpie
    jq
    killall
    kubernetes-helm
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
    stack
    tldr
    vifm
    wget
    yarn
    yazi
  ];

  programs.git = {
    enable = true;
    userEmail = "thomaslaich@gmail.com";
    userName = "Thomas Laich";
    diff-so-fancy.enable = true;
  };

  programs.zsh = { enable = true; };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;
}
