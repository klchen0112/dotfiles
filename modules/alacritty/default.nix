{
  flake.modules.homeManager.alacritty =
    {
      pkgs,
      ...
    }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          window = {
            opacity = 0.8;
            startup_mode = "Windowed";
            dynamic_title = true;
            dynamic_padding = true;
            option_as_alt = "Both";
            decorations = if pkgs.stdenv.isDarwin then "buttonless" else "Full";
            blur = true;
          };
          scrolling = {
            history = 10000;
            multiplier = 3;
          };
          font =
            let
              fontname = if pkgs.stdenv.isLinux then "Iosevka Nerd Font" else "SF Mono";
            in
            {
              normal = {
                family = fontname;
                style = "Bold";
              };
              bold = {
                family = fontname;
                style = "Bold";
              };
              italic = {
                family = fontname;
                style = "Italic";
              };
              size = 14;
            };
          cursor.style = "Block";
          terminal.shell = {
            program = "${pkgs.fish}/bin/fish";
            args = [ "-l" ];
          };
          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            TERM = "xterm-256color";
          };
          selection = {
            save_to_clipboard = true;
          };
        };
      };
    };
}
