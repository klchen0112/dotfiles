#
# OpenVPN
#
{ config
, lib
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # openvpn
  ];
}
