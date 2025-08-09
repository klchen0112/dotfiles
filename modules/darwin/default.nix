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
    ./system
    ./stylix
  ];
  programs.zsh.enable = true;
}
