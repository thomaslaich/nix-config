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
      # Preference keys verified against Vorssaint 3.4.0. Open the app once after
      # activation and grant Accessibility; it registers its own login item.
      CustomUserPreferences."com.vorssaint.utils" = {
        # First-run presets otherwise overwrite the configured feature selection.
        hasOnboarded = true;
        launchAtLoginWanted = true;
        "featureAvailable.scrollInverter" = true;
        scrollInverterEnabled = true;
        scrollInverterHorizontalEnabled = false;
        smoothScrollEnabled = false;

        # Clipboard and Finder conveniences.
        "featureAvailable.clipboardHistory" = true;
        clipboardHistoryEnabled = true;
        clipboardHistoryShortcutEnabled = true;
        clipboardHistorySkipSensitive = true;
        "featureAvailable.pastePlain" = true;
        pastePlainEnabled = true;
        "featureAvailable.finderCutPaste" = true;
        finderCutPasteEnabled = true;
        finderPasteImageAsFile = true;
        "featureAvailable.finderRename" = true;
        finderRenameEnabled = true;

        # Capture tools use Control-Option-Command shortcuts.
        "featureAvailable.screenshot" = true;
        screenshotShortcutEnabled = true;
        "featureAvailable.screenOCR" = true;
        screenOCRShortcutEnabled = true;
        "featureAvailable.colorPicker" = true;
        colorPickerShortcutEnabled = true;

        # Audio tools and on-demand menu bar utilities.
        "featureAvailable.mixer" = true;
        "featureAvailable.soundOutputSwitcher" = true;
        soundOutputSwitcherEnabled = true;
        "featureAvailable.musicBlock" = true;
        musicBlockEnabled = true;
        "featureAvailable.keepAwake" = true;
        "featureAvailable.micMute" = true;
        "featureAvailable.mediaTools" = true;
        "featureAvailable.monitorCPU" = true;
        "featureAvailable.monitorGPU" = true;
        "featureAvailable.monitorMemory" = true;
        "featureAvailable.monitorNetwork" = true;
        "featureAvailable.monitorDisk" = true;
        "featureAvailable.monitorPower" = true;

        # Leave window management and focus to AeroSpace.
        "featureAvailable.switcher" = false;
        "featureAvailable.dockPreview" = false;
        "featureAvailable.dockClick" = false;
        "featureAvailable.windowMaximizer" = false;
        "featureAvailable.windowLayout" = false;
        "featureAvailable.focusFollowsMouse" = false;
        "featureAvailable.autoQuit" = false;
        "featureAvailable.quitWindowProtection" = false;
        switcherEnabled = false;
        focusFollowsMouseEnabled = false;
        windowMaximizeEnabled = false;
        dockClickMinimize = false;
        dockClickHide = false;
        dockClickCycleWindows = false;
      };

      dock = {
        autohide = true;
        static-only = true; # show only running apps
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true; # natural trackpad scrolling; Vorssaint reverses the mouse wheel

        # key repeat: lower is faster
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
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

  environment.systemPackages = [ ];

  environment.variables = {
    FISH_SHELL = "${pkgs.fish}/bin/fish";
  };

  # Fonts
  # NOTE: managed by stylix
  fonts.packages = with pkgs; [
    ubuntu-classic
    et-book
    nerd-fonts.droid-sans-mono
    nerd-fonts.geist-mono
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
      "dbeaver-community"
      "dropbox"
      "elgato-stream-deck"
      "firefox"
      "github"
      "google-chrome"
      "obsidian"
      "spotify"
      "studio-3t"
      "tailscale-app"
      "vorssaint"
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
}
