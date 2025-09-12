{
  flake.modules.homeManager.fontconfig = {
    fonts = {
      fontconfig = {
        defaultFonts = {
          serif = [
            "CMU Typewriter Text"
            "Noto Serif CJK SC"
            "Source Han Serif SC"
            "DejaVu Serif"
          ];
          sansSerif = [
            "IBM Plex Serif"
            "Noto Sans CJK SC"
            "Source Han Sans SC"
            "DejaVu Sans"
          ];
          monospace = [
            "Iosevka Nerd Font"
            "Noto Sans Mono CJK SC"
            "Sarasa Mono SC"
            "DejaVu Sans Mono"
          ];
          emoji = [
            "Noto Color Emoji"
            "Seagoe UI Emoji"
            "Twitter Color Emoji"
          ];
        };
      };
    };
  };
}
