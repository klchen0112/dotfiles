{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    ./base.nix
    flake.inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.machine.base16Scheme}.yaml";
    homeManagerIntegration.autoImport = false;
    homeManagerIntegration.followSystem = false;
  };
}
