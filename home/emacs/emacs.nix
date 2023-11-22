{ pkgs, lib, ... }: {
  programs.emacs = {
    enable = true;
    package = (pkgs.emacsWithPackagesFromUsePackage {
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
      package = pkgs.emacs29-pgtk.override { withNativeCompilation = true; };

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
      extraEmacsPackages = epkgs:
        with epkgs; [
          # packages from melpa (pre-requisites)
          # TODO can I just move them into config.el?
          treesit-grammars.with-all-grammars
          nerd-icons

          # custom built packages
          lsp-install-servers # TODO <- this does not seem to work
        ];

      # Optionally override derivations.
      override = epkgs:
        epkgs // {
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
          
          # unfortunately, I have to add the packages from the epkgs-overlay
          # here manually. Apparently, emacs-overlay does not take them
          # into account on its own.
          copilot = pkgs.emacsPackages.copilot;
        };
    });
  };
}
