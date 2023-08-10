#
# fish configuration
#
{ lib, pkgs, ... }: {
  home.packages = with pkgs; [ sing-box ];
}
