{
  pkgs,
  flake,
  config,
  lib,
  ...
}:
{
  imports = [
    flake.inputs.niri.nixosModules.niri
  ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  # nixpkgs.overlays = [
  #   flake.inputs.niri.overlays.niri
  # ];
  services.displayManager = {
    gdm.enable = true;
    sessionPackages = with pkgs; [
      niri
    ];
  };
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal
      ];
      config.common.default = [ "gnome" ];
    };
  };
  #services.greetd = {
  #  enable = true;
  #  settings =
  #    let
  #      session = {
  #        command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${config.programs.niri.package}/bin/niri-session --remember";
  #        user = "klchen";
  #      };
  #    in
  #    {
  #      terminal.vt = 1;
  #      default_session = session;
  #    };
  #};
  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;

}
