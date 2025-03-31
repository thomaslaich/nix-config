{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      # We use the README.org directly. The file will be tangled automatically,
      # that is, the source code blocks are going to be extracted.
      # config = ./README.org;

      # workaround for making stylix work with emacs-overlay
      config = pkgs.writeTextFile {
        text = ''
          ${builtins.readFile ./README.org}
          #+begin_src emacs-lisp
          ${config.programs.emacs.extraConfig}
          #+end_src'';
        name = "config.org";
      };

      # Include the config as a default init file
      defaultInitFile = true;

      # Package is optional, defaults to pkgs.emacs
      package = pkgs.emacs-unstable-pgtk;

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
      extraEmacsPackages =
        epkgs:
        with epkgs;
        [
          # packages from melpa (pre-requisites)
          # TODO can I just move them into config.el?
          treesit-grammars.with-all-grammars
          nerd-icons
          # emacsql-sqlite

          # custom built packages
          lsp-install-servers # TODO <- this does not seem to work
        ]
        # workaround for making stylix work with emacs-overlay
        ++ (config.programs.emacs.extraPackages epkgs);

      # Optionally override derivations.
      override =
        epkgs:
        epkgs
        // {
          lsp-install-servers = epkgs.trivialBuild {
            pname = "lsp-install-servers";
            version = "1.0";
            src = pkgs.writeText "lsp-install-servers.el" ''
              (eval-after-load 'lsp-mode
               '(progn
                 (lsp-dependency 'omnisharp '(:system "${pkgs.omnisharp-roslyn}/bin/omnisharp"))
                 (lsp-dependency 'lua-language-server '(:system "${pkgs.lua-language-server}/bin/lua-language-server"))))

              (provide 'lsp-install-servers)
            '';
            packageRequires = [ epkgs.lsp-mode ];
          };

          # unfortunately, I have to add the packages from the epkgs-overlay
          # here manually. Apparently, emacs-overlay does not take them
          # into account on its own.
          inherit (pkgs.emacsPackages) copilot;
        };
    };
  };
}
