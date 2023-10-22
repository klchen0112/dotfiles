{ inputs, pkgs, lib, config, ... }:
{

  imports = [
    ./waybar.nix
    ./swayidle.nix
    ./swaylock.nix

  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # plugins=[];
    xwayland.enable = true;
    systemdIntegration = true;
    # settings = {

    # };
  };


  fonts.fontconfig.enable = true;


}
