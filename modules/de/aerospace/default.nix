{
  flake.modules.darwin.aerospace =
    { lib, ... }:
    {
      system.defaults.NSGlobalDomain._HIHideMenuBar = lib.mkForce true;
    };
  flake.modules.homeManager.aerospace =
    { ... }:
    {
      programs.aerospace = {
        enable = true;
        launchd.enable = true;
        settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      };
    };
}
