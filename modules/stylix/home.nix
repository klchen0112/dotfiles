{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork,
  ...
}:
{
  imports = [

    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };
}
