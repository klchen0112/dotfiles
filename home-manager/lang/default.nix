{ pkgs, ... }: {
  imports = [
    ./bash
    ./cpp
    ./go
    ./java
    ./json
    ./julia
    ./lua
    ./latex
    ./markdown
    ./nix
    ./nodejs
    ./python
    ./rust
  ];

  home.packages = with pkgs;
    [
      tree-sitter

    ];
}
