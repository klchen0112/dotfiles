{
  flake.modules.homeManager.aerospace =
    { pkgs, config, ... }:
    {
      programs.aerospace = {
        enable = true;
        package = pkgs.hyprspace;
        userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      };
    };
}
