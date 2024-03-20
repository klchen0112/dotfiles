{pkgs, ...}: {
  imports = [
    ./bash/home.nix
    ./cpp/home.nix
    ./go/home.nix
    ./java/home.nix
    ./json/home.nix
    ./julia/home.nix
    ./lua/home.nix
    ./latex/home.nix
    ./markdown/home.nix
    ./nix/home.nix
    ./nodejs/home.nix
    ./python/home.nix
    ./rust/home.nix
  ];

  home.packages = with pkgs; [
    tree-sitter
    dockfmt
  ];
}
