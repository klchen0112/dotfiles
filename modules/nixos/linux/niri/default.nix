{ pkgs
, flake
, ...
}:
{
  imports = [
    flake.inputs.niri.nixosModules.niri
    ./binds.nix
  ];
  # Clipboard Manager not working
  stylix.targets.niri.enable = true;
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  pro
    }
