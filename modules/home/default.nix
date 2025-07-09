{
  imports = [
    ./bash
    ./fish
    ./me
    ./access-tokens.nix
    ./stylix
    ./utils
    ./nix
    ./git
    ./ssh
    ./zsh
    ./nix-index
    ./helix
  ];
  fonts.fontconfig.enable = true;
  xdg.enable  = true;
}
