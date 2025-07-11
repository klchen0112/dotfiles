{
  pkgs,
  flake,
  config,
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
  services.greetd =
    let
      session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      };
    in
    {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        # initial_session = session;
      };
    };
}
