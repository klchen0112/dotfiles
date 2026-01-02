{
  flake.modules.darwin.omniwm = {
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
