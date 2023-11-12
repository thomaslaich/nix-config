{ pkgs, lib, ... }: {

  programs.emacs = {
    enable = true;
    package =

      (pkgs.emacsWithPackagesFromUsePackage {
        # Your Emacs config file. Org mode babel files are also

        # supported.
        # NB: Config files cannot contain unicode characters, since
        #     they're being parsed in nix, which lacks unicode
        #     support.
        config = ./config.el;
        # for some reason this does not work for me :(
        # config = ./emacs.org;

        # Whether to include your config as a default init file.
        # If being bool, the value of config is used.
        # Its value can also be a derivation like this if you want to do some
        # substitution:
        #   defaultInitFile = pkgs.substituteAll {
        #     name = "default.el";
        #     src = ./emacs.el;
        #     inherit (config.xdg) configHome dataHome;
        #   };
        defaultInitFile = true;

        # Package is optional, defaults to pkgs.emacs
        package = pkgs.emacs-pgtk.overrideAttrs (old: {
          # the following is need for darwin (i.e., replicate homebrew emacs-plus patches)
          patches = (old.patches or [ ]) ++ [
            # Fix OS window role (needed for window managers like yabai)
            (pkgs.fetchpatch {
              url =
                "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
              sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
            })
            # Use poll instead of select to get file descriptors
            (pkgs.fetchpatch {
              url =
                "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
              sha256 = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
            })
            # Enable rounded window with no decoration
            (pkgs.fetchpatch {
              url =
                "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
              sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
            })
            # Make Emacs aware of OS-level light/dark mode
            (pkgs.fetchpatch {
              url =
                "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
              sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
            })
          ];
        });

        # By default emacsWithPackagesFromUsePackage will only pull in
        # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
        # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
        # and pulls in all use-package references not explicitly disabled via
        # `:ensure nil` or `:disabled`.
        # Note that this is NOT recommended unless you've actually set
        # `use-package-always-ensure` to `t` in your config.
        alwaysEnsure = true;

        # For Org mode babel files, by default only code blocks with
        # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
        # will include all code blocks missing the `:tangle` argument,
        # defaulting it to `yes`.
        # Note that this is NOT recommended unless you have something like
        # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
        # which defaults `:tangle` to `yes`.
        alwaysTangle = true;

        # Optionally provide extra packages not in the configuration file.

        # (lsp-dependency 'typescript-language-server `(:system "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"))
        # (lsp-dependency 'typescript `(:system "${pkgs.nodePackages.typescript}/bin/tsserver"))))
        extraEmacsPackages = epkgs:
          with epkgs; [
            cask
            treesit-grammars.with-all-grammars
            nerd-icons
            copilot
            lsp-install-servers
          ];

        # Optionally override derivations.
        override = epkgs:
          epkgs // {
            weechat = epkgs.melpaPackages.weechat.overrideAttrs
              (old: { patches = [ ./weechat-el.patch ]; });
            # Install copilot.el
            copilot = epkgs.trivialBuild {
              pname = "copilot";
              version = "2023-04-27";

              packageRequires = with epkgs; [ dash editorconfig s ];

              preInstall = ''
                mkdir -p $out/share/emacs/site-lisp
                cp -vr $src/dist $out/share/emacs/site-lisp
              '';

              src = pkgs.fetchFromGitHub {
                owner = "zerolfx";
                repo = "copilot.el";
                rev = "7cb7beda89145ccb86a4324860584545ec016552";
                sha256 = "sha256-57ACMikRzHSwRkFdEn9tx87NlJsWDYEfmg2n2JH8Ig0=";
              };
            };

            lsp-install-servers = epkgs.trivialBuild {
              pname = "lsp-install-servers";
              version = "1.0";
              src = pkgs.writeText "lsp-install-servers.el" ''
                (eval-after-load 'lsp-mode
                 '(progn
                   (lsp-dependency 'omnisharp `(:system "${pkgs.omnisharp-roslyn}/bin/omnisharp"))
                   (lsp-dependency 'lua-language-server `(:system "${pkgs.lua-language-server}/bin/lua-language-server"))))
              '';
              packageRequires = [ epkgs.lsp-mode ];
            };

          };
      });
  };
}
