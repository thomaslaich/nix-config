{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    plugins = [{
      name = "pure";
      inherit (pkgs.fishPlugins.pure) src;
    }];

    interactiveShellInit = ''
      fish_vi_key_bindings
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      # git
      gs = "git status";
      gd = "git diff";
      gf = "git fetch";
      gl = "git log";

      # vim
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";

      # emacs
      e = "emacsclient -c";

      # tmux
      t = "tmux";
      ta = "t a -t";
      tls = "t ls";
      tn = "t new -t";
      tkill = "t kill-session -t";

      # ls
      la = "eza -la --git --icons";
      l = "eza -l --git --icons";

      # cd
      z = "zoxide";

      # just for testing dg-cli installation using shell alias
      dg-alt =
        "nix run git+ssh://git@ssh.dev.azure.com/v3/DigitecGalaxus/Playground/Dg.Nix?ref=v1.12.7-r1#dg-cli-full";
    };
  };
}
