{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    keybindings = [
      {
        "args" = "j";
        "command" = "vscode-neovim.compositeEscape1";
        "key" = "j";
        "when" = "neovim.mode == insert && editorTextFocus";
      }
      {
        "key" = ", f f";
        "command" = "workbench.action.quickOpen";
        "when" = "neovim.mode != insert && editorTextFocus";
      }
      {
        "key" = "space a";
        "command" = "editor.action.quickFix";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasCodeActionsProvider && textInputFocus && !editorReadonly";
      }
      {
        "key" = "space a";
        "command" = "acceptSelectedCodeAction";
        "when" =
          "neovim.mode != insert && editorTextFocus && codeActionMenuVisible";
      }
      {
        "key" = "space a";
        "command" = "problems.action.showQuickFixes";
        "when" = "neovim.mode != insert && editorTextFocus && problemFocus";
      }
      {
        "key" = "space f";
        "command" = "editor.action.formatDocument";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
      }
      {
        "key" = "space m";
        "command" = "editor.action.rename";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasRenameProvider && editorTextFocus && !editorReadonly";
      }
      {
        "key" = "space r";
        "command" = "editor.action.goToReferences";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor && !isInEmbeddedEditor";
      }
      {
        "key" = "space h";
        "command" = "editor.action.showHover";
        "when" = "neovim.mode != insert && editorTextFocus && editorTextFocus";
      }
      {
        "key" = "space d";
        "command" = "editor.action.revealDefinition";
        "when" =
          "neovim.mode != insert && editorTextFocus && editorHasDefinitionProvider && editorTextFocus && !isInEmbeddedEditor";
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

      # disable updates & synching
      "extensions.autoCheckUpdates" = false;
      "update.mode" = "none";
      "settingsSync.keybindingsPerPlatform" = false;

      # extension configurations
      "extensions.experimental.affinity" = { "asvetliakov.vscode-neovim" = 1; };
      "svelte.enable-ts-plugin" = true;
    };
    extensions = [
      # Theme
      pkgs.vscode-marketplace.enkia.tokyo-night

      # Misc
      pkgs.vscode-marketplace.visualstudioexptteam.vscodeintellicode
      pkgs.vscode-marketplace.redhat.vscode-yaml
      pkgs.vscode-marketplace.asvetliakov.vscode-neovim

      # JS/TS
      pkgs.vscode-marketplace.ms-vscode.vscode-typescript-next
      pkgs.vscode-marketplace.svelte.svelte-vscode

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
      pkgs.vscode-marketplace.ms-dotnettools.dotnet-interactive-vscode
      pkgs.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime

      # Docker
      pkgs.vscode-marketplace.ms-azuretools.vscode-docker

      # Nix
      pkgs.vscode-marketplace.bbenoist.nix
      pkgs.vscode-marketplace.brettm12345.nixfmt-vscode
    ];
  };
}
