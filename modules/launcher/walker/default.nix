{ ... }:
{
  flake.modules.homeManager.walker = {
    services.walker = {
      enable = true;
    };
  };
}
