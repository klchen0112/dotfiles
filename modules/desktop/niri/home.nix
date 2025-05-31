{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ];
  # Clipboard Manager not working
  programs.niri.enable = true;

}
