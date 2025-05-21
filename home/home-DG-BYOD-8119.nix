{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
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
}
