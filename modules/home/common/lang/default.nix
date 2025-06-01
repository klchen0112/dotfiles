{
  pkgs,
  ...
}:
{
  imports = [
    ./bash
    ./cpp
    ./csharp
    ./go
    ./java
    ./json
    ./julia
    ./lua
    ./latex
    ./markdown
    ./nix
    ./web
    ./python
    ./rust
    ./web
    ./yaml
    ./k8s

  ];

  home.packages = with pkgs; [ dockfmt ];
}
