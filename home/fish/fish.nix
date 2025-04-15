{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        inherit (pkgs.fishPlugins.pure) src;
      }
    ];

    interactiveShellInit = ''
      # fish_vi_key_bindings
      any-nix-shell fish --info-right | source
    '';

    functions = {

      reload_all_fish_instances = {
        body = ''
          # Get the process IDs of all running fish processes except the current one
          set fish_pids (pgrep -x fish | grep -v $fish_pid)

          # Check if there are any fish processes to reload
          if test -n "$fish_pids"
              # Send SIGHUP to each process
              for pid in $fish_pids
                  kill -SIGHUP $pid
              end
              echo "Reloaded configuration for fish processes: $fish_pids"
          else
              echo "No other fish processes found to reload."
          end
        '';
      };

    };

    shellAbbrs = {

      fish-reload-config = "source ~/.config/fish/**/*.fish";
      tmux-reload-config = "tmux source-file ~/.config/tmux/tmux.conf";

    };

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

    };
  };
}
