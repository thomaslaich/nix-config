{
  lib,
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    mos # smooth scrolling

    pinentry_mac # gpg
  ];

  home.activation = {
    rsync-home-manager-applications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rsyncArgs="--archive --checksum --copy-unsafe-links --delete"
      apps_source="$genProfilePath/home-path/Applications"
      moniker="Home Manager Trampolines"
      app_target_base="${config.home.homeDirectory}/Applications"
      app_target="$app_target_base/$moniker"
      mkdir -p "$app_target"
      ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
    '';
  };

  programs.aerospace = {
    enable = true;
  };

  home.file.".aerospace.toml".text = ''
    # Start AeroSpace at login
    start-at-login = true
  '';
}
