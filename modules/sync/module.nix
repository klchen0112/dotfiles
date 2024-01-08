{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.syncthing;
in {
  options = {
    services.syncthing = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether or not to enable the headless syncthing daemon service.
        '';
      };
      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["--gui-apikey=apiKey"];
        description = ''
          Extra command-line arguments to pass to {command}`syncthing`.
        '';
      };
      logFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/tmp/syncthing.log";
        description = lib.mdDoc ''
          The logfile to use for the ipfs service. Alternatively
          {command}`sudo launchctl debug system/org.nixos.ipfs --stderr`
          can be used to stream the logs to a shell after restarting the service with
          {command}`sudo launchctl kickstart -k system/org.nixos.ipfs`.
        '';
      };
    };
    config = mkIf cfg.enable {
      environment.systemPackages = [pkgs.syncthing];
      launchd.user.agents.syncthing = {
        command = "${pkgs.syncthing}/bin/syncthing -no-browser -no-restart -logflags=0";
        serviceConfig = {
          KeepAlive = true;
          StandardOutPath = cfg.logFile;
          StandardErrorPath = cfg.logFile;
        };
      };
    };
  };
}
