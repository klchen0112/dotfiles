{
  pkgs,
  ...
}:
{
  stylix.targets.nushell.enable = true;
  programs.nushell = {
    enable = true;
  };
}
