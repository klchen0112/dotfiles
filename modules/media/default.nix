#
# ../../media
#
{pkgs, ...}: {
  programs.mpv = {
    enable = true;
  };
  programs.sioyek = {
    enable = true;
    #  package = pkgs.sioyek;
  };
  home.packages = with pkgs; [
    anki
    # calibre
    raycast
  ];
}
