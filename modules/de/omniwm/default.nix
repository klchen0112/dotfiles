{
  flake.modules.darwin.omniwm = {
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
