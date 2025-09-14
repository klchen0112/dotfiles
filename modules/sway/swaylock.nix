{
  flake.moduels.nixos.sway =
    { ... }:
    {
      stylix.targets.swaylock.enable = true;
      programs.swaylock = {
        enable = true;
      };
    };
}
