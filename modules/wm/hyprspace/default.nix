{
  flake.modules.homeManager.hyprspace =
    { pkgs, ... }:
    {
      programs.aerospace = {
        enable = true;
        package = pkgs.hyprspace;
        userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      };
    };
}
