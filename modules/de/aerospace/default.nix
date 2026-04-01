{
  den.aspects.darwin.aerospace =
    { lib, ... }:
    {
      system.defaults.NSGlobalDomain._HIHideMenuBar = lib.mkForce true;
    };
  den.aspects.aerospace =
    { ... }:
    {
      programs.aerospace = {
        enable = true;
        launchd.enable = true;
        settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
      };
    };
}
