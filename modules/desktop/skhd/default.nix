{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''

      alt - left  : yabai -m window --focus west || yabai -m display --focus west

      alt - right : yabai -m window --focus east || yabai -m display --focus east

      alt - up    : yabai -m window --focus north || yabai -m display --focus north

      alt - down  : yabai -m window --focus south || yabai -m display --focus south

      shift + alt - left  : yabai -m window --warp west   || (yabai -m window --display west && yabai -m display --focus west)

      shift + alt - right : yabai -m window --warp east   || (yabai -m window --display east && yabai -m display --focus east)

      shift + alt - down  : yabai -m window --warp north  || (yabai -m window --display north && yabai -m display --focus north)

      shift + alt - up    : yabai -m window --warp south  || (yabai -m window --display south  && yabai -m display --focus south)

      ctrl + alt - left  : yabai -m window --insert west

      ctrl + alt - right : yabai -m window --insert east

      ctrl + alt - down  : yabai -m window --insert north

      ctrl + alt - up    : yabai -m window --insert south

      shift + alt - x  : yabai -m space --mirror x-axis

      shift + alt - y  : yabai -m space --mirror y-axis

      shift + alt - r  :  yabai -m space --rotate 90

      shift + alt - 1  :  yabai -m window --space 1 && yabai -m space --focus 1;

      shift + alt - 2  :  yabai -m window --space 2 && yabai -m space --focus 2;

      shift + alt - 3  :  yabai -m window --space 3 && yabai -m space --focus 3;

      shift + alt - 4  :  yabai -m window --space 4 && yabai -m space --focus 4;

      shift + alt - 5  :  yabai -m window --space 5 && yabai -m space --focus 5;

      shift + alt - 6  :  yabai -m window --space 6 && yabai -m space --focus 6;

      shift + alt - 7  :  yabai -m window --space 7 && yabai -m space --focus 7;

      shift + alt - 8  :  yabai -m window --space 8 && yabai -m space --focus 8;

      shift + alt - 9  :  yabai -m window --space 9 && yabai -m space --focus 9;

      shift + alt - 0  :  yabai -m window --space 10 && yabai -m space --focus ;

      # maximize

      alt - m :  yabai -m window --toggle zoom-fullscreen

      shift + alt - m :  yabai -m window --toggle native-fullscreen

      # resize
      ctrl + alt - left : yabai -m window --resize left:-50:0 || yabai -m window --resize right:-50:0

      ctrl + alt - right  : yabai -m window --resize right:50:0 || yabai -m window --resize left:50:0

      ctrl + alt - down  : yabai -m window --resize top:0:-50 || yabai -m window --resize bottom:0:-50

      ctrl + alt - up  : yabai -m window --resize bottom:0:50 || yabai -m window --resize top:0:50

      ctrl + alt - e  : yabai -m space --balance

      shift + alt - space : yabai -m window --toggle float

      ctrl + alt + shift - e : emacsclient -c -n -a \'\'


      ctrl + alt - b : yabai -m space --layout bsp
      ctrl + alt - f : yabai -m space --layout float
    '';
  };
}
