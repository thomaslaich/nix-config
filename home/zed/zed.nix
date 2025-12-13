_: {
  programs.zed-editor = {
    enable = true;

    mutableUserSettings = false;
    userSettings = {
      "vim_mode" = true;
      "Python" = {
        "tab_size" = 4;
        "format_on_save" = "off";
      };
    };

    mutableUserKeymaps = false;
    userKeymaps = [
      {
        "bindings" = {
          # window navigation
          "ctrl-h" = [
            "workspace::ActivatePaneInDirection"
            "Left"
          ];
          "ctrl-l" = [
            "workspace::ActivatePaneInDirection"
            "Right"
          ];
          "ctrl-k" = [
            "workspace::ActivatePaneInDirection"
            "Up"
          ];
          "ctrl-j" = [
            "workspace::ActivatePaneInDirection"
            "Down"
          ];
        };
      }
      {
        "context" = "Editor && vim_mode == insert && !menu";
        "bindings" = {
          "j j" = [
            "vim::SwitchMode"
            "Normal"
          ];
        };
      }
      {
        "context" = "((VimControl && !menu) || (!Editor && !Terminal))";
        "bindings" = {
          "space w v" = "pane::SplitVertical";
          "space w s" = "pane::SplitHorizontal";
          "space w o" = "pane::JoinAll";
          "space w c" = "pane::CloseActiveItem";
          "space f f" = "file_finder::Toggle";
          "space t v" = "workspace::NewTerminal";
        };
      }
      {
        "context" = "Workspace";
        "bindings" = {
          "space g g" = [
            "task::Spawn"
            { "gitu" = "Open gitu"; }
          ];
        };
      }
    ];
    # {
    #   "key" = "space t v";
    #   "command" = "terminal:toggle";
    # }
    #
    # # search in files (fg)
    # {
    #   "key" = "space f g";
    #   "command" = "search:project";
    # }
    #
    # # open explorer
    # {
    #   "key" = "space n";
    #   "command" = "project_panel:toggle";
    # }
    #
    # # format
    # {
    #   "key" = ", f";
    #   "command" = "editor:format";
    # }
    #
    # # rename symbol
    # {
    #   "key" = ", m";
    #   "command" = "editor:rename";
    # }

    mutableUserTasks = false;
    userTasks = [
      {
        "label" = "Open gitu";
        "command" = "gitu";
        "use_new_terminal" = true;
        "allow_concurrent_runs" = false;
        "reveal" = "always";
      }
    ];

    extensions = [
      "nix"
      "csharp"
      "org"
    ];
  };
}
