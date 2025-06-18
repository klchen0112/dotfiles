{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    # nixfmt
    # nix-du
    nil
    cachix
    statix
    deadnix
    nix-fast-build
    devenv
  ];
}
