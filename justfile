host := `hostname`

default:
    @just --list

# rebuild system-manager configuration and switch
[linux]
system-manager-switch:
    nix run .#rebuild-{{ host }}

# rebuild nix darwin configuration and switch
[macos]
nix-darwin-switch:
    sudo nix run .#rebuild-{{ host }}

# rebuild Home Manager config and switch
[unix]
hm-switch:
    nix run .#hm-switch-{{ host }}

# format all sources in the repository
format:
    nix fmt

check:
    nix flake check --impure

update:
    nix flake update
    just check

# clean up nix store by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d
