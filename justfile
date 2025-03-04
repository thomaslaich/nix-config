host := `hostname`

default:
    @just --list

# rebuild NixOS configuration and switch. mode = 'dark' or 'light'
[linux]
nixos-switch mode='light':
    sudo nix run .#rebuild-{{ host }}-{{ mode }}

# rebuild nix darwin configuration and switch. mode = 'dark' or 'light'
[macos]
nix-darwin-switch mode='light':
    nix run .#rebuild-{{ host }}-{{ mode }}

# rebuild Home Manager config and switch. mode = 'dark' or 'light'
[unix]
hm-switch mode='light':
    nix run .#hm-switch-{{ host }}-{{ mode }}
    # reload tmux config
    tmux source-file ~/.config/tmux/tmux.conf
    # reload fish config
    fish -c 'reload_all_fish_instances'

# format all sources in the repository
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
