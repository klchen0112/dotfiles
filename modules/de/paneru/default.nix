{ inputs, ... }:
{
  flake-file.inputs = {
    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.darwin.paneru =
    { lib, ... }:
    {

    };
  flake.modules.homeManager.paneru =
    { ... }:
    {
      imports = [
        inputs.paneru.homeModules.paneru
      ];

      services.paneru = {
        enable = true;
        # Equivalent to what you would put into `~/.paneru` (See Configuration options below).
        settings = {
          options = {
            preset_column_widths = [
              0.25
              0.33
              0.5
              0.66
              0.75
            ];
            swipe_gesture_fingers = 4;
            animation_speed = 50;
          };
          bindings = {
            window_focus_west = "alt - leftarrow";
            window_focus_east = "alt - rightarrow";
            window_focus_north = "alt - uparrow";
            window_focus_south = "alt - downarrow";
            window_center = "ctrl + cmd - c";
            window_resize = "ctrl + cmd - r";
            window_fullwidth = "ctrl + cmd - f";

            window_swap_west = "alt + shift - leftarrow";
            window_swap_east = "alt + shift - rightarrow";
            window_swap_first = "alt + shift - a";
            window_swap_last = "alt + shift - e";

            window_nextdisplay = "alt + shift - n";

            window_manage = "alt + shift - t";
            window_stack = "alt + shift - ]";
            window_unstack = "alt + shift - ]";
            quit = "ctrl + alt - q";
          };
        };
      };
    };
}
