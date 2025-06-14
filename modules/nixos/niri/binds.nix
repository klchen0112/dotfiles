{
  config,
  pkgs,
  ...
}:
{
  programs.niri.settings.binds = with config.lib.niri.actions; { };
}
