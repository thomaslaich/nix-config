{ ... }:
{
  services.sketchybar = {
    enable = true;
    config = ''
      sketchybar --bar height=24
      sketchybar --update
      echo "sketchybar configuration loaded.."
    '';
  };
}
