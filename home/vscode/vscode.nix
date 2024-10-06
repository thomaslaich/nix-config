{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.stable.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # I try to make the key bindings as similar as possible to my nvim setup
    keybindings = [
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
      {
        "key" = "enter";
        "command" = "-renameFile";
        "when" = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
      }
      {
        "key" = "enter";
        "command" = "filesExplorer.openFilePreserveFocus";
        "when" = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsFolder && !inputFocus";
      }
      {
        "key" = "a";
        "command" = "explorer.newFile";
        "when" = "filesExplorerFocus && foldersViewVisible && explorerResourceIsFolder && !inputFocus";
      }
    ];
    userSettings = {

      # theming
      "editor.semanticHighlighting.enabled" = true;
      "terminal.integrated.minimumContrastRatio" = 1;
      "window.titleBarStyle" = "custom";
      # theming should be done by nix-colorscheme hm module
      # "workbench.colorTheme" = "Tokyo Night Storm";
      # "workbench.colorTheme" = "Catppuccin Macchiato";
      "workbench.colorTheme" = "Catppuccin Frappé";
      "workbench.preferredHighContrastColorTheme" = "Catppuccin Frappé";
      "workbench.iconTheme" = "catppuccin-frappe";

      # editor basics
      "editor.tabSize" = 2;
      "editor.lineNumbers" = "relative";
      "files.autoSave" = "off";
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "workbench.editor.showTabs" = "none"; # no tabs (like my emacs and vim)
      "window.zoomLevel" = 1;

      # disable updates & synching
      "extensions.autoUpdate" = false;
      "extensions.autoCheckUpdates" = false;
      "update.mode" = "none";
      "settingsSync.keybindingsPerPlatform" = false;
      "extensions.ignoreRecommendations" = true;

      # svelte extension config
      "svelte.enable-ts-plugin" = true;

      # JS/TS setup
      "eslint.workingDirectories" = [ { "mode" = "auto"; } ];
      # "eslint.format.enable" = true;
      # "[typescriptreact]" = {
      #   "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      # };
      # "[typescript]" = {
      #   "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      # };

      # vim plugin setup
      "vim.easymotion" = true;
      "vim.incsearch" = true;
      "vim.useSystemClipboard" = true;
      "vim.useCtrlKeys" = true;
      "vim.hlsearch" = true;
      "vim.insertModeKeyBindings" = [
        {
          "before" = [
            "j"
            "j"
          ];
          "after" = [ "<Esc>" ];
        }
      ];
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          "before" = [
            "<leader>"
            "t"
            "v"
          ];
          "commands" = [ "workbench.action.terminal.toggleTerminal" ];
        }
        {
          "before" = [
            "<leader>"
            "f"
            "f"
          ];
          "commands" = [ "workbench.action.quickOpen" ];
        }
        {
          "before" = [
            "<leader>"
            "f"
            "g"
          ];
          "commands" = [ "workbench.action.findInFiles" ];
        }
        {
          "before" = [
            "<leader>"
            "/"
          ];
          "commands" = [ "actions.find" ];
        }
        {
          "before" = [
            "<leader>"
            "g"
            "g"
          ];
          "commands" = [ "workbench.view.scm" ];
        }
        {
          "before" = [
            "<leader>"
            "n"
          ];
          "commands" = [ "workbench.view.explorer" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "h"
          ];
          "commands" = [ "workbench.action.navigateLeft" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "j"
          ];
          "commands" = [ "workbench.action.navigateDown" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "k"
          ];
          "commands" = [ "workbench.action.navigateUp" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "l"
          ];
          "commands" = [ "workbench.action.navigateRight" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "c"
          ];
          "commands" = [ "workbench.action.closeEditorsAndGroup" ];
        }
        {
          "before" = [
            "<leader>"
            "b"
            "k"
          ];
          "commands" = [ "workbench.action.closeActiveEditor" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "o"
          ];
          "commands" = [ "workbench.action.closeOtherEditors" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "s"
          ];
          "commands" = [ "workbench.action.splitEditorOrthogonal" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "v"
          ];
          "commands" = [ "workbench.action.splitEditor" ];
        }
        {
          "before" = [
            "<leader>"
            "w"
            "o"
          ];
          "commands" = [ "workbench.action.closeEditorsInOtherGroups" ];
        }
        {
          "before" = [
            "<leader>"
            "b"
            "b"
          ];
          "commands" = [ "workbench.files.action.focusOpenEditorsView" ];
        }
        {
          "before" = [
            "<leader>"
            "."
          ];
          "commands" = [ "extension.dired.open" ];
        }
        {
          "before" = [
            ","
            "a"
          ];
          "commands" = [
            "editor.action.quickFix"
            "acceptSelectedCodeAction"
            "problems.action.showQuickFixes"
          ];
        }
        {
          "before" = [
            ","
            "f"
          ];
          "commands" = [ "editor.action.formatDocument" ];
        }
        {
          "before" = [
            ","
            "m"
          ];
          "commands" = [ "editor.action.rename" ];
        }
        {
          "before" = [
            "g"
            "I"
          ];
          "commands" = [ "editor.action.goToImplementation" ];
        }
        {
          "before" = [
            "g"
            "r"
          ];
          "commands" = [ "editor.action.goToReferences" ];
        }
        {
          "before" = [ "<C-n>" ];
          "commands" = [ "=nohl" ];
        }
        {
          "before" = [ "K" ];
          "commands" = [ "editor.action.showHover" ];
        }
      ];
      "vim.leader" = "<space>";
      "vim.handleKeys" = {
        "<C-a>" = false;
        "<C-f>" = false;
      };
      # "[csharp]" = {
      #   "editor.defaultFormatter" = "ms-dotnettools.csharp";
      # };
      "[jsonc]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[html]" = {
        "editor.defaultFormatter" = "vscode.html-language-features";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "ilspy.defaultOutputLanguage" = "C# 11.0 / VS 2022.4";
      "files.eol" = "\n";
      "editor.formatOnSave" = false;
      "github.copilot.editor.enableAutoCompletions" = true;
      "claptrap.configEndpoint" = "${config.age.secrets.claptrap.path}";
      "claptrap.modules.isomorph.projectPath" = "/Users/thomaslaich/repos/galaxus/isomorph";
    };

    extensions = with pkgs.vscode-marketplace; [
      # Theme
      enkia.tokyo-night
      keifererikson.nightfox
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      # Misc
      eamodio.gitlens
      github.copilot
      github.copilot-chat
      postman.postman-for-vscode
      rrudi.vscode-dired
      mkhl.direnv
      editorconfig.editorconfig # needed?
      github.vscode-github-actions
      kokakiwi.vscode-just
      humao.rest-client
      vscodevim.vim

      # JS/TS
      ms-vscode.vscode-typescript-next
      svelte.svelte-vscode
      dbaeumer.vscode-eslint
      unifiedjs.vscode-mdx
      esbenp.prettier-vscode

      # Python
      ms-python.python
      ms-toolsai.jupyter
      ms-python.vscode-pylance
      ms-python.debugpy

      # Go
      golang.go

      # Rust
      rust-lang.rust-analyzer
      # example of using open-vsx instead
      # open-vsx-release.rust-lang.rust-analyzer

      # .NET
      ms-dotnettools.vscode-dotnet-pack
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      ms-dotnettools.dotnet-interactive-vscode
      ms-dotnettools.vscode-dotnet-runtime
      # ionide.ionide-fsharp
      csharpier.csharpier-vscode # formatter
      # icsharpcode.ilspy-vscode
      tintoy.msbuild-project-tools

      # Lua
      sumneko.lua

      # Nix
      bbenoist.nix
      brettm12345.nixfmt-vscode

      # Dockerols.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools

      # XML, YAML, TOML
      redhat.vscode-yaml
      be5invis.toml
      redhat.vscode-xml
      bluebrown.yamlfmt

      # GraphQL
      graphql.vscode-graphql-syntax
      graphql.vscode-graphql
      meta.relay

      # C/C++
      # ms-vscode.makefile-tools
      # ms-vscode.cpptools

      # Lisp
      mattn.lisp

      # Haskell
      haskell.haskell
      justusadam.language-haskell

      # Azure
      ms-azuretools.vscode-azureresourcegroups
      ms-vscode.azure-account
      ms-azuretools.vscode-azurefunctions

      # Galaxus
      dg-infinity.claptrap
      # Avro
      streetsidesoftware.avro

      # Powershell
      # ms-vscode.powershell

      # Shell
      timonwong.shellcheck
    ];
  };
}
