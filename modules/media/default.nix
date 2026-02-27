{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;
        package = (
          pkgs.mpv.override {
            scripts = with pkgs.mpvScripts; [
              reload
              encode
              # decode
            ];

          }
        );
      };
      programs.sioyek = {
        enable = true;
        bindings = {
          "move_up" = "p";
          "move_down" = "n";
          "move_left" = "f";
          "move_right" = "b";

          "next_page" = "<S-n>";
          "previous_page" = "<S-p>";

          "zoom_in" = "=";
          "zoom_out" = "-";

          "fit_to_page_width" = "w";
          "fit_to_page_width_smart" = "e";

          # Other useful vim-bindings
          "goto_begining" = "[b";
          "goto_end" = "]b";
          "goto_toc" = "<tab>";

          "add_highlight" = "h";
          "delete_highlight" = "dh";

          "add_bookmark" = "b";
          "delete_bookmark" = "db";
          "goto_bookmark" = "gb";
          "goto_bookmark_g" = "g<S-b>";
        };
      };
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
        ];
      };
      home.packages =
        with pkgs;
        [
          # anki
          # tidgi
          # marginnote
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ ]
        ++ lib.optionals pkgs.stdenv.isLinux [ ];
    };
}
