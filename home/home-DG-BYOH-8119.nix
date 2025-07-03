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
  # TODO remove once GitHub migration is complete
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
      };
      "ssh.dev.azure.com" = {
        user = "git";
        extraOptions = {
          "PubkeyAcceptedAlgorithms" = "+ssh-rsa";
          "HostkeyAlgorithms" = "+ssh-rsa";
        };
      };
    };
  };

  home.sessionPath = [
    # needed for rancher
    "${homeDirectory}/.rd/bin"
  ];

  home.sessionVariables = {
    # needed for rancher
    KRB5_CONFIG = "${homeDirectory}/.config/krb5.conf";
  };

  home.packages = with pkgs; [
    krb5
  ];

}
