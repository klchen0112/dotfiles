{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.aria2;
  formatLine =
    n: v:
    let
      formatValue = v: if builtins.isBool v then (if v then "true" else "false") else toString v;
    in
    "${n}=${formatValue v}";
in
{
  options = {
    services.aria2 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether or not to enable the headless Aria2 daemon service.

          Aria2 daemon can be controlled via the RPC interface using
          one of many WebUI (http://localhost:6800/ by default).

          Targets are downloaded to ${downloadDir} by default and are
          accessible to users in the "aria2" group.
        '';
      };
      settings = mkOption {
        type =
          with types;
          attrsOf (oneOf [
            bool
            float
            int
            str
          ]);
        default = { };
        description = ''
          Options to add to {file}`aria2.conf` file.
          See
          {manpage}`aria2c(1)`
          for options.
        '';
        example = literalExpression ''
          {
            listen-port = 60000;
            dht-listen-port = 60000;
            seed-ratio = 1.0;
            max-upload-limit = "50K";
            ftp-pasv = true;
          }
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines added to {file}`aria2.conf` file.
        '';
      };
      extraArguments = mkOption {
        type = types.separatedString " ";
        example = "--rpc-listen-all --remote-time=true";
        default = "";
        description = lib.mdDoc ''
          Additional arguments to be passed to Aria2.
        '';
      };
      logFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/tmp/aria2.log";
        description = lib.mdDoc ''
          The logfile to use for the ipfs service. Alternatively
          {command}`sudo launchctl debug system/org.nixos.ipfs --stderr`
          can be used to stream the logs to a shell after restarting the service with
          {command}`sudo launchctl kickstart -k system/org.nixos.ipfs`.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    lib.mkMerge [
      {
        home.systemPackages = [ pkgs.aria2 ];
        xdg.configFile."aria2/aria2.conf"= lib.concatStringsSep "\n" (
          [ ]
          ++ lib.mapAttrsToList formatLine cfg.settings
          ++ lib.optional (cfg.extraConfig != "") cfg.extraConfig
        );
      }
      (mkIf pkgs.stdenv.isDarwin {
          launchd.user.agents.aria2 = {
            command = "${pkgs.aria2}/bin/aria2c --enable-rpc --conf-path=/etc/aria2.conf ${config.services.aria2.extraArguments}";
            serviceConfig = {
              KeepAlive = true;
              StandardOutPath = cfg.logFile;
              StandardErrorPath = cfg.logFile;
            };
          };
      })
    ];
  };
}
