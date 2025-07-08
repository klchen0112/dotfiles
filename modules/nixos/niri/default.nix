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
  services.greetd = let
    session = {
      command = "${config.programs.niri.package}/bin/niri-session";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
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
