{
  lib,
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./vscode/vscode.nix
    # ./zed/zed.nix
  ];

  home.packages = with pkgs; [
    mos # smooth scrolling

    pinentry_mac # gpg
  ];

  home.activation = {
    rsync-home-manager-applications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rsyncArgs="--archive --no-perms --checksum --copy-unsafe-links --delete --chmod=Du+w,Fu+w"
      apps_source="$genProfilePath/home-path/Applications"
      moniker="Home Manager Trampolines"
      app_target_base="${config.home.homeDirectory}/Applications"
      app_target="$app_target_base/$moniker"
      mkdir -p "$app_target_base"
      app_target_tmp="$(${pkgs.coreutils}/bin/mktemp -d "$app_target_base/.$moniker.tmp.XXXXXX")"
      app_target_old="$app_target_base/.$moniker.old.$$"
      ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target_tmp/"
      if [ -e "$app_target" ]; then
        mv "$app_target" "$app_target_old"
      fi
      mv "$app_target_tmp" "$app_target"
      if [ -e "$app_target_old" ]; then
        chmod -R u+w "$app_target_old" 2>/dev/null || true
        rm -rf "$app_target_old" 2>/dev/null || true
      fi
    '';
  };
}
