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
  programs.niri.package = pkgs.niri-unstable;
  nixpkgs.overlays = [
    flake.inputs.niri.overlays.niri
  ];
  services.greetd = {
    enable = true;
    settings =
      let
        session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${config.programs.niri.package}/bin/niri-session --remember";
          user = "klchen";
        };
      in
      {
        terminal.vt = 1;
        default_session = session;
      };
  };
  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;

}
