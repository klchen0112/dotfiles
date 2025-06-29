{
  pkgs,
  flake,
  ...
}:
{
  programs.anyrun = {
    enable = true;
    package = flake.inputs.anyrun.packages.${pkgs.system}.anyrun;
    config = {
      plugins = with flake.inputs.anyrun.packages.${pkgs.system}; [
        applications
        shell
        symbols
        translate
      ];

      width.fraction = 0.25;
      y.fraction = 0.3;
      hidePluginInfo = true;
      closeOnClick = true;
    };

  };
}
