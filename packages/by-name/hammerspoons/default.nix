{ lib, callPackage, ... }:
{
  PaperWM = callPackage ./paperwm { };
  Swipe = callPackage ./Swipe { };
  ActiveSpace = callPackage ./ActiveSpace { };
  WarpMouse = callPackage ./WarpMouse { };
}
