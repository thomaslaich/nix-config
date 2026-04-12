{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
        "https://cache.iog.io"
        "https://zed.cachix.org"
      ];
    };
  };
}
