{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    # Allow binary caches to be trusted
    # currently used for: emacs-overlay,  devenv, and haskell.nix
    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
    extra-substituters = https://nix-community.cachix.org https://devenv.cachix.org https://cache.iog.io 
  '';

  imports = [
    inputs.agenix.darwinModules.default
    inputs.stylix.darwinModules.stylix
    ../stylix.nix
    ./yabai/yabai.nix
    ./skhd/skhd.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
  };

  # services.emacs.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    primaryUser = "thomaslaich";
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
        "com.apple.swipescrolldirection" = true; # use natural scroll (we use MOS to invert it again for mouse)

        # key repeat: lower is faster
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        ApplePressAndHoldEnabled = false;
      };
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
  };

  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [ ];

  environment.variables = {
    FISH_SHELL = "${pkgs.fish}/bin/fish";
  };

  # Fonts
  # NOTE: managed by stylix
  fonts.packages = with pkgs; [
    ubuntu-classic
    etBook
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu
  ];

  # some GUI apps need to be installed with homebrew (but not all!)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "1password"
      "azure-data-studio"
      "dropbox"
      "firefox"
      "ghostty"
      "github"
      "google-chrome"
      "obsidian"
      "spotify"
      "studio-3t"
    ];
  };

  # environment.shells = [ pkgs.fish ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.thomaslaich = {
    name = "thomaslaich";
    home = "/Users/thomaslaich";
    # shell = pkgs.fish;
  };
}
