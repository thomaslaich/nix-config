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
        "when" = "neovim.mode != insert && editorTextFocus";
      }
      {
        "key" = "space l g";
        "command" = "workbench.action.findInFiles";
        "when" = "neovim.mode != insert && editorTextFocus";
      }
      {
        "key" = "space g s";
        "command" = "workbench.view.scm";
        "when" = "neovim.mode != insert && editorTextFocus";
      }
      {
        "key" = "space -";
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
      {
        "key" = ", r";
        "command" = "editor.action.goToReferences";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor && !isInEmbeddedEditor";
      }
      {
        "key" = ", h";
        "command" = "editor.action.showHover";
        "when" = "neovim.mode != insert && editorTextFocus && editorTextFocus";
      }
      {
        "key" = ", d";
        "command" = "editor.action.revealDefinition";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasDefinitionProvider && editorTextFocus && !isInEmbeddedEditor";
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
      # editor basics
      "editor.tabSize" = 2;
      "editor.lineNumbers" = "relative";
      "files.autoSave" = "off";
      "workbench.colorTheme" = "Tokyo Night Storm";
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

    extensions = [
      # Theme
      pkgs.vscode-marketplace.enkia.tokyo-night

      # Misc
      pkgs.vscode-marketplace.eamodio.gitlens
      pkgs.vscode-marketplace.asvetliakov.vscode-neovim
      pkgs.vscode-marketplace.github.copilot
      pkgs.vscode-marketplace.github.copilot-chat
      pkgs.vscode-marketplace.postman.postman-for-vscode

      # JS/TS
      pkgs.vscode-marketplace.ms-vscode.vscode-typescript-next
      pkgs.vscode-marketplace.svelte.svelte-vscode
      pkgs.vscode-marketplace.dbaeumer.vscode-eslint

      # Python
      pkgs.vscode-marketplace.ms-python.python
      pkgs.vscode-marketplace.ms-toolsai.jupyter

      # Go
      pkgs.vscode-marketplace.golang.go

      # Rust
      pkgs.vscode-marketplace.rust-lang.rust-analyzer
      # example of using open-vsx instead
      # open-vsx-release.rust-lang.rust-analyzer

      # .NET
      pkgs.vscode-marketplace.ms-dotnettools.vscode-dotnet-pack
      pkgs.vscode-marketplace.ms-dotnettools.csharp
      # for some reason this is not working :(
      # pkgs.vscode-marketplace.ms-dotnettools.csdevkit
      pkgs.vscode-marketplace.ms-dotnettools.dotnet-interactive-vscode
      pkgs.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
      pkgs.vscode-marketplace.ionide.ionide-fsharp

      # Lua
      pkgs.vscode-marketplace.sumneko.lua

      # Nix
      pkgs.vscode-marketplace.bbenoist.nix
      pkgs.vscode-marketplace.brettm12345.nixfmt-vscode

      # Docker
      pkgs.vscode-marketplace.ms-azuretools.vscode-docker
      pkgs.vscode-marketplace.ms-kubernetes-tools.vscode-kubernetes-tools

      # YAML
      pkgs.vscode-marketplace.redhat.vscode-yaml

      # GraphQL
      pkgs.vscode-marketplace.graphql.vscode-graphql-syntax
      pkgs.vscode-marketplace.graphql.vscode-graphql

      # C/C++
      pkgs.vscode-marketplace.ms-vscode.makefile-tools
      pkgs.vscode-marketplace.ms-vscode.cpptools

      # Lisp
      pkgs.vscode-marketplace.mattn.lisp

      # Haskell
      pkgs.vscode-marketplace.haskell.haskell
      pkgs.vscode-marketplace.justusadam.language-haskell
    ];
  };
}
