{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
let
  homeDirectory = "${config.home.homeDirectory}";
in
{
  home.sessionPath = [
    # needed for rancher
    "${homeDirectory}/.rd/bin"
    # needed for pixi global
    "${homeDirectory}/.pixi/bin"
  ];

  home.sessionVariables = {
    # needed for rancher
    KRB5_CONFIG = "${homeDirectory}/.config/krb5.conf";
  };

  home.packages = with pkgs; [
    krb5
  ];

}
