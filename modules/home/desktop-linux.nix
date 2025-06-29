{
  imports = [
    ./niri
  ];
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Nerd Font" ];
        sansSerif = [
          "IBM Plex Serif"
          "Free Serif"
          "Noto Serif"
          "Noto Serif CJK SC"
        ];

        serif = [
          "IBM Plex Serif"
          "Free Serif"
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        emoji = [
          "Apple Color Emoji"
          "Noto Color Emoji"
          "Segoe UI Emoji"
        ];
      };
    };
  };
}
