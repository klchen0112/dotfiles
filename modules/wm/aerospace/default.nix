{
  flake.modules.homeManager.aerospace =
    { pkgs, config, ... }:
    {
      programs.aerospace = {
        enable = true;
        userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      };
    };
}
