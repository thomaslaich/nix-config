# My personal Nix configuration flake

Configuration for my personal machines (both macOS and NixOS).

Credits to [buntec/nix-config](https://github.com/buntec/nix-config); my config started as a clone of that repo.

I also highly recommend to checkout [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) to get inspiration for your flake config.

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
sudo just nixos-switch
just hm-switch
```

See all available recipes with:

```bash
just --list
```

## Fresh macOS install

1. Re-install macOS from scratch. Open the terminal and enter `git`. This will prompt you to install XCode developer tools.
   Proceed with the installation.

2. Change your `hostname` either in the config or on your machine. To change the `hostname` on your machine, type

```bash
sudo scutil --set HostName <new_hostname>
```

3. Install nix. I would highly recommend **not** to use the official nix shell script, but instead use the
   (nix installer)[https://github.com/DeterminateSystems/nix-installer] from determinate systems.
   For macOS there is a GUI installer available which is the recommended way to install nix.

4. Open the terminal application, clone this git repo, and `cd` into it.

5. Enter the devshell:

```bash
nix develop --impure
```

6. Once in the devshell, install system configuration and home manager applications:

```bash
just nix-darwin-switch
just hm-switch
```

6. After successful installation, again `cd` into the git repo and type `direnv allow`. This will start the devshell automatically
   when entering the folder.

## Theming with stylix

TODO

## Secrets with agenix

TODO
