{
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri-caelestia-shell.homeManagerModules.default

  ];
  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };
  programs.fuzzel = {
    enable = true;
  };

}
