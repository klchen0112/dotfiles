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
    bindings = [

      "move_up" = "p";
      "move_down" = "n";
      "move_left" = "b";
      "move_right" = "f";
      "screen_down" = [ "d" "<C-d>" ];
      "screen_up" = [ "u" "<C-u>" ];
    ];

  };
  home.packages = with pkgs; [
    # calibre
    raycast
  ];
}
