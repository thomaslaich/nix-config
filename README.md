# Personal Nix configuration

This flake contains the Nix configuration for my personal machines: macOS systems managed with
[nix-darwin](https://github.com/LnL7/nix-darwin), and Linux systems managed with
[System Manager](https://github.com/numtide/system-manager).

The configuration started as a clone of [buntec/nix-config](https://github.com/buntec/nix-config), which remains the main inspiration.

For more flake layout ideas, I also recommend [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs).

## Fresh macOS install

1. Re-install macOS from scratch. Open the terminal and enter `git`. This will prompt you to install Xcode developer tools.
   Proceed with the installation.

2. Change your `hostname` either in the config or on your machine. To change the `hostname` on your machine, type

```bash
sudo scutil --set HostName <new_hostname>
```

3. Install Nix. I recommend the [nix installer](https://github.com/DeterminateSystems/nix-installer) from Determinate Systems
   instead of the official shell script. On macOS, use the GUI installer.

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

7. After successful installation, again `cd` into the git repo and type `direnv allow`. This will start the devshell automatically
   whenever you enter the config folder.

## Fresh Linux install

These instructions are for a regular Linux installation with Nix installed on top of the host OS. Linux machines in this flake are managed with [System Manager](https://github.com/numtide/system-manager), not NixOS.

1. Install Nix. As on macOS, I recommend the [nix installer](https://github.com/DeterminateSystems/nix-installer) from Determinate Systems instead of the official shell script.

2. Change your `hostname` either in the config or on your machine. The `just` recipes use `hostname` to select the matching flake output. To change the `hostname` on your machine, type

```bash
sudo hostnamectl set-hostname <new_hostname>
```

3. Clone this repo and `cd` into it. Use `nix-shell -p git` to access git if needed.

4. Enter the devshell:

```bash
nix develop --impure
```

5. Build and activate the System Manager configuration:

```bash
just system-manager-switch

# alternatively, without the devshell:
nix run .#rebuild-desktop-ubuntu-wsl-light
```

6. Activate Home Manager:

```bash
just hm-switch

# alternatively, without the devshell:
nix run .#hm-switch-desktop-ubuntu-wsl-light
```

7. After successful installation, again `cd` into the repo and type `direnv allow`. This will start the devshell automatically
   whenever you enter the config folder. From then on, rebuild with:

```bash
just system-manager-switch
just hm-switch
```

See all available recipes with:

```bash
just --list
```

## Theming with stylix

For theming I use [stylix](https://github.com/nix-community/stylix). This allows me to use a single base24-color-scheme
and let stylix magically apply this color theme to everything:
- Gnome
- Ghostty/tmux
- neovim
- VSCode
- etc.

All my installation scripts also allow for applying a "light" or "dark" variant. Simply run:
```bash
just system-manager-switch "dark" # or "light" (default)
just nix-darwin-switch "dark" # or "light" (default)
just hm-switch "dark" # or "light" (default)
```

This is what it ends up looking on my MacBook with the dark theme (here Ghostty and VSCode):

![Screenshot](https://raw.githubusercontent.com/thomaslaich/nix-config/main/.github/images/screenshot.png)

I currently use [buntec/kauz](https://github.com/buntec/kauz) as my color scheme.

## Secrets with agenix

Secrets are managed with `agenix`.

The rules for which SSH keys can decrypt which secret live in `secrets/secrets.nix`.

To edit an existing secret:

```bash
nix run github:ryantm/agenix -- -e secrets/claptrap.age
```

Home Manager decrypts configured secrets during activation. For example, `claptrap.age` is written to `~/.claptrap` by `home/home.nix`.
