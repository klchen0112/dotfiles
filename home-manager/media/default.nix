#
# ../../media
#
{ pkgs, ... }: {
  programs.mpv = {
    enable = true;
  };
  programs.sioyek = {
    enable = true;
    #  package = pkgs.sioyek;
    bindings =
      {
        "move_up" = "k";
        "move_down" = "j";
        "move_left" = "h";
        "move_right" = "l";
        "screen_down" = [ "d" "<C-d>" ];
        "screen_up" = [ "u" "<C-u>" ];
      };
  };
  home.packages = with pkgs; [
    # calibre
    # plexamp

  ];
}
