{ ... }:
{
  services.yabai = {
    enable = true;
    config = {
      # external_bar = "all:39:0";
      layout = "stack";
      auto_balance = "on";

      mouse_modifier = "alt";
      # set modifier + right-click drag to resize window (default: resize)
      mouse_action2 = "resize";
      # set modifier + left-click drag to resize window (default: move)
      mouse_action1 = "move";

      # gaps
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };
    extraConfig = ''
      # opacity
      yabai -m config window_opacity on
      yabai -m config active_window_opacity 0.9
      yabai -m config normal_window_opacity 0.8

      # tiling
      yabai -m config layout bsp
      yabai -m config split_ratio 0.50


      # bar configuration
      # yabai -m signal --add event=window_focused   action="sketchybar --trigger window_focus"
      # yabai -m signal --add event=window_created   action="sketchybar --trigger windows_on_spaces"
      # yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"


      # rules
      yabai -m rule --add app="^System Settings$"    manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add title="Preferences$"       manage=off
      yabai -m rule --add title="Settings$"          manage=off

      # workspace management
      yabai -m space 1  --label todo
      yabai -m space 2  --label productive
      yabai -m space 3  --label chat
      yabai -m space 4  --label utils
      yabai -m space 5  --label code

      # assign apps to spaces
      yabai -m rule --add app="Emacs" space=todo
      yabai -m rule --add app="Reminder" space=todo
      yabai -m rule --add app="Mail" space=todo
      yabai -m rule --add app="Calendar" space=todo

      yabai -m rule --add app="Microsoft Teams" space=chat
      yabai -m rule --add app="Slack" space=chat

      yabai -m rule --add app="Spotify" space=utils

      yabai -m rule --add app="Visual Studio Code" space=code
      yabai -m rule --add app="Ghostty" space=code

      yabai -m rule --add app="Visual Studio Code" opacity=0.7
    '';
  };
}
