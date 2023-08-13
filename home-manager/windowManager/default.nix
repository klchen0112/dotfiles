#
# Download client
#
{ pkgs, ... }: {
  home.file.".config/sketchybar".source = ./sketchybar;
  home.file.".config/yabai".source = ./yabai;
}

