{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;
    profiles = {
      default = {
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
            "when" =
              "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
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
          {
            "key" = "tab";
            "command" = "-extension.vim_tab";
          }
          {
            "key" = "x";
            "command" = "magit.discard-at-point";
            "when" =
              "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          {
            "key" = "k";
            "command" = "-magit.discard-at-point";
            "when" =
              "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
        ];
        userSettings = {

          # theming
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
          "window.titleBarStyle" = "custom";
          # font and theme is set by stylix

          # editor basics
          "editor.tabSize" = 2;
          "editor.lineNumbers" = "relative";
          "files.autoSave" = "off";
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
              "commands" = [ "magit.status" ];
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
          "[csharp]" = {
            "editor.defaultFormatter" = "csharpier.csharpier-vscode";
          };
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
          "claptrap.configEndpoint" = "${config.age.secrets.claptrap.path}";
          "claptrap.modules.isomorph.projectPath" = "/Users/thomaslaich/repos/galaxus/isomorph";
          "python.analysis.typeCheckingMode" = "standard";
          "editor.fontSize" = pkgs.lib.mkForce 12.0;
          "chat.editor.fontSize" = pkgs.lib.mkForce 12.0;
          "debug.console.fontSize" = pkgs.lib.mkForce 12.0;
          "markdown.preview.fontSize" = pkgs.lib.mkForce 12.0;
          "terminal.integrated.fontSize" = pkgs.lib.mkForce 12.0;
          "workbench.sideBar.location" = "right";

          "github.copilot.enable" = {
            "*" = false; # disable suggestions
            "inlineSuggestions" = false; # disable inline-suggestions
          };
          "chat.agent.enabled" = true;
        };

        extensions =
          # From vscode overlay
          with pkgs.vscode-marketplace;
          [
            # General repo setups
            mkhl.direnv
            editorconfig.editorconfig # needed?
            skellock.just
            # github.vscode-pull-request-github

            # Networking
            postman.postman-for-vscode
            humao.rest-client

            # Make VSCode more like vim and emacs
            vscodevim.vim
            kahole.magit
            rrudi.vscode-dired

            # JS/TS
            ms-vscode.vscode-typescript-next
            svelte.svelte-vscode
            dbaeumer.vscode-eslint
            unifiedjs.vscode-mdx
            esbenp.prettier-vscode

            # Python
            ms-python.python
            ms-python.debugpy
            # ms-python.vscode-python-envs
            # meta.pyrefly # typechecker/LSP by Meta
            # astral-sh.ty # typechecker/LSP by Astral
            charliermarsh.ruff # linter by Astral

            # Go
            golang.go

            # Rust
            rust-lang.rust-analyzer

            # .NET
            ms-dotnettools.dotnet-interactive-vscode # polyglot notebooks
            # ms-dotnettools.vscode-dotnet-runtime # .NET install tool
            ionide.ionide-fsharp
            csharpier.csharpier-vscode # formatter
            tintoy.msbuild-project-tools

            # Lua
            sumneko.lua

            # Nix
            jnoortheen.nix-ide

            # Docker / DevOps / Cloud
            ms-azuretools.vscode-docker
            ms-kubernetes-tools.vscode-kubernetes-tools
            hashicorp.hcl
            github.vscode-github-actions
            ashishalex.dataform-lsp-vscode
            ms-azuretools.vscode-azureresourcegroups
            ms-azuretools.vscode-azurefunctions
            hashicorp.terraform

            # XML, YAML, TOML
            redhat.vscode-yaml
            tamasfe.even-better-toml
            redhat.vscode-xml
            bluebrown.yamlfmt

            # GraphQL
            graphql.vscode-graphql-syntax
            graphql.vscode-graphql
            meta.relay

            # Haskell
            haskell.haskell
            justusadam.language-haskell

            # Avro
            streetsidesoftware.avro

            # Powershell
            ms-vscode.powershell

            # Shell
            timonwong.shellcheck

            # Galaxus
            # dg-infinity.claptrap

            # DuckDB, parquet
            lucien-martijn.parquet-visualizer
          ]
          ++ (with pkgs.vscode-extensions; [
            github.vscode-pull-request-github

            ms-dotnettools.csharp
            ms-dotnettools.csdevkit

            # ms-dotnettools.dotnet-interactive-vscode # polyglot notebooks
            ms-dotnettools.vscode-dotnet-runtime # .NET install tool

            github.copilot
            github.copilot-chat

            ms-python.vscode-pylance
            ms-toolsai.jupyter

            eamodio.gitlens
          ]);
      };
    };
  };
}
