{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ifstat-legacy
  ];
}
