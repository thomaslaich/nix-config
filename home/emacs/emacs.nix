{ pkgs, ... }: {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./.doom.d;

    extraPackages = with pkgs; [
      gopls
      haskell-language-server
      lua-language-server
      nil
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      vscode-langservers-extracted
    ];
  };
}
