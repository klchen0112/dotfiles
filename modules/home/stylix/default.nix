{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.stylix.homeModules.stylix
    ./base.nix
  ];
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.me.base16Scheme}.yaml";
}
