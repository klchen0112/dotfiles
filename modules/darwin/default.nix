{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    ./common
    ./homebrew
    ./access-tokens.nix
    ./system
    ./stylix
  ];
  programs.zsh.enable = true;
}
