# My personal Nix configuration flake

Configuration for my personal machines (both macOS and NixOS). 

Credits to [buntec/nix-config](https://github.com/buntec/nix-config); my config started as a clone of that repo.

## Fresh NixOS install
After installing NixOS from a USB drive, follow these steps:

1. Clone this repo and `cd` into it. Use `nix-shell -p git` to access git.

2. Copy `/etc/nixos/hardware-configuration.nix` into `./system` (OK to overwrite existing dummy file).

3. Build and activate NixOS config:
```bash
sudo nixos-rebuild switch --flake .#lenovo-desktop # the fragment can be dropped if it matches your current host name

# alternatively, using the `apps` provided by the flake:
sudo nix run .#rebuild-lenovo-desktop
```

4. Activate home-manager:
```bash
sudo nix run .#hm-switch-lenovo-desktop
```

5. After the initial installation, again `cd` into the repo, and activate direnv by typing `direnv allow`. Now you can use the simpler commands
to for rebuild and hm switch:
```bash
# rebuild switch
sudo just rebuild

# hm switch
just hm-switch
```

## Fresh macOS install
(Heavily inspired by this [gist](https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050))

To bootstrap a fresh macOS install, follow these steps:

1. Install Homebrew (only needed for managing GUI apps via casks)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install Nix:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

3. Clone this repo, `cd` into it, then build and activate with one command:
```bash
nix run .#rebuild-macbook-pro-m1 # nix-darwin
nix run .#hm-switch-macbook-pro-m1 # home-manager
```

4. After the initial installation, again `cd` into the repo, and activate direnv by typing `direnv allow`. Now you can use the simpler commands
to for rebuild and hm switch:
```bash
# rebuild switch
just rebuild

# hm switch
just hm-switch

# rebuild & hm-switch
just
```

## Migrating an existing macOS install to Nix
1. Uninstall Homebrew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

2. Delete everything under `~/.config` and any other "dot files" in your home directory.

3. Delete all applications that are listed as Homebrew casks in `./system/configuration-darwin.nix`

4. Follow the steps for a fresh macOS install.
