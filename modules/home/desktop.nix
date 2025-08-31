{ pkgs, ... }:
{
  imports = [
    ./kitty
    ./chrome
    ./vscode
    #    ./zen
    ./lang
    ./inputmethod
    ./aria2
    ./visualisation
    ./ghostty
    ./media
    ./emacs
    ./sync
  ];
  home.packages =
    with pkgs;
    [

    ]
    ++ (lib.optionals pkgs.stdenv.isLinux

      [ rustdesk ]
    );
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "M PLUS Code Latin 50" ];
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
        "Twitter Color Emoji"
        "Noto Color Emoji"
        "Segoe UI Emoji"
      ];
    };
  };
}
