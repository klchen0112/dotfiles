{
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri.homeModules.niri
  ];
  # Clipboard Manager not working
  programs.niri.enable = true;

}
