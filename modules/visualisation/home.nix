#
# fish configuration
#
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    colima
    lima
  ];
  # utm
}
