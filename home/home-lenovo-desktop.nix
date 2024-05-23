{ pkgs, ... }:
{
  # programs.kitty = {
  #   font.size = 10;
  # };
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
