{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  services.mako = {
    enable = true;
    width = 256;
    height = 500;
    margin = "10";
    padding = "5";
    borderSize = 3;
    borderRadius = 3;
    backgroundColor = "#eff1f5";
    borderColor = "#c0caf5";
    progressColor = "over #ccd0da";
    textColor = "#414868";
    defaultTimeout = 5000;
    extraConfig = ''
      text-alignment=center
      [urgency=high]
      border-color=#fe640b
    '';
  };
}
