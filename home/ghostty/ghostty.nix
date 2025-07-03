{ pkgs, ... }:
{

  programs.ghostty = {
    enable = true;
    settings = {
      macos-option-as-alt = false;
      font-size = 14;
    };
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty; # currently marked broken on Darwin
  };

}
