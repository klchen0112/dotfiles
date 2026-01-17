{
  flake.moduels.nixos.sway-lock =
    { ... }:
    {
      stylix.targets.swaylock.enable = true;
      programs.swaylock = {
        enable = true;
      };
    };
}
