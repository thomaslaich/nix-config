host := `hostname`

default:
    @just --list

rebuild:
    nix run .#rebuild-{{ host }}

# rebuild Home Manager config and switch. mode = 'dark' or 'light'
hm-switch mode='light':
    nix run .#hm-switch-{{ host }}-{{ mode }}
    # reload tmux config
    tmux source-file ~/.config/tmux/tmux.conf
    # reload fish config
    fish -c 'reload_all_fish_instances'

format:
    nix fmt

check:
    nix flake check --impure

update:
    nix flake update && rebuild && hm-switch

# clean up nix store by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d
