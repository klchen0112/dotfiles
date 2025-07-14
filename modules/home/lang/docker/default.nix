{ pkgs, ... }:
{
  home.packages = with pkgs; [ dockfmt ];
}
