#
# OpenVPN
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    # pkgs.sing-box
    ifstat-legacy
  ];
}
