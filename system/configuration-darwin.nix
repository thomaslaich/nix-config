{ inputs, outputs, pkgs, ... }: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    # Allow binary caches to be trusted
    # currently used for: emacs-overlay,  devenv, and haskell.nix
    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
    extra-substituters = https://nix-community.cachix.org https://devenv.cachix.org https://cache.iog.io 
  '';

  # imports = [ inputs.agenix.darwinModules.default ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    # Configure your nixpkgs instance
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  services.emacs.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  system = {
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    defaults = {
      dock = {
        autohide = true;
        static-only = true; # show only running apps
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false; # disable "natural" scroll

        # key repeat: lower is faster
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
      };
    };

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
        "Ubuntu"
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
      "azure-data-studio"
      "banana-cake-pop"
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

  # TODO add rancher to path
  # "${home.homeDirectory}/.rd/bin"

  # environment.shells = [ pkgs.fish ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # nix.package = pkgs.nix; # this is the default
  nix.package =
    pkgs.nixVersions.nix_2_20; # manually go for newest version for now

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.thomaslaich = {
    name = "thomaslaich";
    home = "/Users/thomaslaich";
    # shell = pkgs.fish;
  };
}
