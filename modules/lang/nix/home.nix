{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    # nixfmt
    # nix-du
    nil
    cachix
    devenv
    devbox
    statix
    deadnix
    nix-fast-build
  ];
}
