{
  pkgs,
  mode,
  inputs,
  ...
}:
let
  schemes = {
    light = "${inputs.kauz}/base24/kauz-light.yml";
    dark = "${inputs.kauz}/base24/kauz-dark.yml";
  };
in
{
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    base16Scheme = schemes.${mode};
    polarity = mode;
    # opacity.terminal = 0.92;
    # opacity.applications = 0.92;
    image = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1524889777220-eae0b973ec80";
      sha256 = "sha256-Njkv8yt4RMZIo0poTtc2Avz8q1WZjREa9zwqLdYwtgE=";
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.dejavu-sans-mono;
        name = "JetBrainsMono Nerd Font";
        # package = pkgs.dejavu_fonts;
        # name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
