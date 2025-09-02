{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./gc.nix
    ./caches.nix
  ];

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
