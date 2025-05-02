{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];
  # Clipboard Manager not working
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  # COSMIC Utilities - Observatory not working
  systemd.packages = [ pkgs.observatory ];
  systemd.services.monitord.wantedBy = [ "multi-user.target" ];
}
