{ pkgs, ... }: {
  imports = [
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
}
