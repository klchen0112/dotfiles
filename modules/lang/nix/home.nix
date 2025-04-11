{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    # nixfmt
    # nix-du
    nil
    cachix
    devbox
    statix
    deadnix
    nix-fast-build
  ];
}
