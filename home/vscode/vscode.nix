{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # I try to make the key bindings as similar as possible to my nvim setup
    keybindings = [
      {
        "args" = "j";
        "command" = "vscode-neovim.compositeEscape1";
        "key" = "j";
        "when" = "neovim.mode == insert && editorTextFocus";
      }
      {
        "key" = "space f f";
        "command" = "workbench.action.quickOpen";
        "when" = "neovim.mode != insert";
      }
      {
        "key" = "space space";
        "command" = "workbench.action.quickOpen";
        "when" = "neovim.mode != insert";
      }
      {
        "key" = "space f g";
        "command" = "workbench.action.findInFiles";
        "when" = "neovim.mode != insert";
      }
      {
        "key" = "space /";
        "command" = "actions.find";
        "when" = "neovim.mode != insert && (editorFocus || editorIsOpen)";
      }
      {
        "key" = "space g s";
        "command" = "workbench.view.scm";
        "when" = "neovim.mode != insert";
      }
      {
        "key" = "space n";
        "command" = "workbench.view.explorer";
        "when" =
          "neovim.mode != insert && editorTextFocus && viewContainer.workbench.view.explorer.enabled";
      }
      {
        "key" = ", a";
        "command" = "editor.action.quickFix";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasCodeActionsProvider && textInputFocus && !editorReadonly";
      }
      {
        "key" = ", a";
        "command" = "acceptSelectedCodeAction";
        "when" =
          "neovim.mode != insert && editorTextFocus && codeActionMenuVisible";
      }
      {
        "key" = ", a";
        "command" = "problems.action.showQuickFixes";
        "when" = "neovim.mode != insert && editorTextFocus && problemFocus";
      }
      {
        "key" = ", f";
        "command" = "editor.action.formatDocument";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
      }
      {
        "key" = ", m";
        "command" = "editor.action.rename";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasRenameProvider && editorTextFocus && !editorReadonly";
      }

      # (split) window navigation
      {
        "key" = "ctrl+h";
        "command" = "workbench.action.navigateLeft";
      }
      {
        "key" = "ctrl+l";
        "command" = "workbench.action.navigateRight";
      }
      {
        "key" = "ctrl+k";
        "command" = "workbench.action.navigateUp";
      }
      {
        "key" = "ctrl+j";
        "command" = "workbench.action.navigateDown";
      }
    ];
    userSettings = {
      # theming
      "editor.semanticHighlighting.enabled" = true;
      "terminal.integrated.minimumContrastRatio" = 1;
      "window.titleBarStyle" = "custom";
      # "workbench.colorTheme" = "Catppuccin Macchiato";
      "workbench.colorTheme" = "Tokyo Night Storm";

      # editor basics
      "editor.tabSize" = 2;
      "editor.lineNumbers" = "relative";
      "files.autoSave" = "off";
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontLigatures" = true;
      "window.zoomLevel" = 1;
      "editor.minimap.enabled" = false;

      # disable updates & synching
      "extensions.autoUpdate" = false;
      "extensions.autoCheckUpdates" = false;
      "update.mode" = "none";
      "settingsSync.keybindingsPerPlatform" = false;

      # neovim extension config
      "extensions.experimental.affinity" = { "asvetliakov.vscode-neovim" = 1; };
      "vscode-neovim.neovimInitVimPaths.darwin" = "~/.config/nvim/init.lua";

      # svelte extension config
      "svelte.enable-ts-plugin" = true;

      # JS/TS setup
      "eslint.format.enable" = true;
      "eslint.workingDirectories" = [{ "mode" = "auto"; }];
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      };
      "extensions.ignoreRecommendations" = true;
    };

    extensions = with pkgs.vscode-marketplace; [
      # Theme
      enkia.tokyo-night
      keifererikson.nightfox
      catppuccin.catppuccin-vsc

      # Misc
      eamodio.gitlens
      asvetliakov.vscode-neovim
      github.copilot
      github.copilot-chat
      postman.postman-for-vscode

      # JS/TS
      ms-vscode.vscode-typescript-next
      svelte.svelte-vscode
      dbaeumer.vscode-eslint

      # Python
      ms-python.python
      ms-toolsai.jupyter

      # Go
      golang.go

      # Rust
      rust-lang.rust-analyzer
      # example of using open-vsx instead
      # open-vsx-release.rust-lang.rust-analyzer

      # .NET
      ms-dotnettools.vscode-dotnet-pack
      ms-dotnettools.csharp
      # for some reason this is not working :(
      # ms-dotnettools.csdevkit
      ms-dotnettools.dotnet-interactive-vscode
      ms-dotnettools.vscode-dotnet-runtime
      ionide.ionide-fsharp

      # Lua
      sumneko.lua

      # Nix
      bbenoist.nix
      brettm12345.nixfmt-vscode

      # Docker
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools

      # YAML
      redhat.vscode-yaml

      # GraphQL
      graphql.vscode-graphql-syntax
      graphql.vscode-graphql

      # C/C++
      ms-vscode.makefile-tools
      ms-vscode.cpptools

      # Lisp
      mattn.lisp

      # Haskell
      haskell.haskell
      justusadam.language-haskell
    ];
  };
}
