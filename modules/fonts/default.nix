{ config
, pkgs
, username
, system
, inputs
, ...
}: {
  imports = [
    ./fonts.nix
  ];

  fonts = {
    fontconfig = {
      defaultFonts = {
        serif = [ "CMU Typewriter Text" ];
        sansSerif = [ "IBM Plex Serif" ];
        monospace = [ "jetbrains-mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
