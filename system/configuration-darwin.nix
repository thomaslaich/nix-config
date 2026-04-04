{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./shared.nix
    inputs.agenix.darwinModules.default
    inputs.stylix.darwinModules.stylix
    ../stylix.nix
    ./aerospace/aerospace.nix
  ];

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
    et-book
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
      "tailscale-app"
      "whatsapp"
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

  ids.gids.nixbld = 30000;

  nix.enable = false; # not needed when using determinate nix

  nix.settings.extra-trusted-public-keys = [
    "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
  ];
  nix.settings.extra-substituters = [ "https://zed.cachix.org" ];
}
