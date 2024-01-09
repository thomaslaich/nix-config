{ pkgs, ... }: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    # Allow binary caches to be trusted
    # currently used for: emacs-overlay,  devenv, and haskell.nix
    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
    extra-substituters = https://nix-community.cachix.org https://devenv.cachix.org https://cache.iog.io 
  '';

  services.emacs.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  system = {

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [ ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    ubuntu_font_family
    etBook
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "DroidSansMono"
        "NerdFontsSymbolsOnly"
        # "Ubuntu"
      ];
    })
  ];

  # some GUI apps need to be installed with homebrew (but not all!)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "1password"
      "amethyst"
      "discord"
      "dropbox"
      "firefox"
      "google-chrome"
      "kitty"
      "microsoft-teams"
      "mos" # mos allows that mouse scrolling and trackpad scrolling is inverted
      "nordvpn"
      "pritunl"
      "rancher"
      "skype"
      "spotify"
      "studio-3t"
      "telegram"
      "visual-studio-code"
      "whatsapp"
    ];
  };

  # environment.shells = [ pkgs.fish ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix; # this is the default

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.thomaslaich = {
    name = "thomaslaich";
    home = "/Users/thomaslaich";
    # shell = pkgs.fish;
  };
}
