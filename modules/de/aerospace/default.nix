{
  flake.modules.homeManager.aerospace =
    { ... }:
    {
      programs.aerospace = {
        enable = true;
        userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      };
    };
}
