{
  flake.modules.darwin.omniwm =
    { lib, ... }:
    {
      system.defaults.NSGlobalDomain._HIHideMenuBar = lib.mkForce false;
      homebrew = {
        taps = [
          "BarutSRB/tap"
        ];
        casks = [
          "omniwm"
        ];
      };
    };
}
