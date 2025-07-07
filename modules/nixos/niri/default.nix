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
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";

      };
    };
  };
  nix.settings = {
    # add binary caches
    trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
    substituters = [
      "https://walker.cachix.org"
    ];
  };
}
