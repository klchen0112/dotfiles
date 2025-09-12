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
      package = mkOption {
        type = types.package;
        default = pkgs.aria2;
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
      # extraArguments = mkOption {
      #   type = types.separatedString " ";
      #   example = "--rpc-listen-all --remote-time=true";
      #   default = "";
      #   description = lib.mdDoc ''
      #     Additional arguments to be passed to Aria2.
      #   '';
      # };
      errorLogFile = lib.mkOption {
        type = with lib.types; nullOr (either path str);
        defaultText = lib.literalExpression "\${config.home.homeDirectory}/Library/Logs/aria2/err.log";
        example = "/Users/khaneliman/Library/Logs/skhd.log";
        description = "Absolute path to log all stderr output.";
      };

      outLogFile = lib.mkOption {
        type = with lib.types; nullOr (either path str);
        defaultText = lib.literalExpression "\${config.home.homeDirectory}/Library/Logs/aria2/out.log";
        example = "/Users/khaneliman/Library/Logs/skhd.log";
        description = "Absolute path to log all stdout output.";
      };
    };
  };
  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [ pkgs.aria2 ];
        xdg.configFile."aria2/aria2.conf".text = lib.concatStringsSep "\n" (
          [ ]
          ++ lib.mapAttrsToList formatLine cfg.settings
          ++ lib.optional (cfg.extraConfig != "") cfg.extraConfig
        );
      }
      (mkIf pkgs.stdenv.isLinux {
        systemd.user.services.cachix-agent = {
          Unit.Description = "Cachix Deploy Agent";

          Service = {
            # We don't want to kill children processes as those are deployments.
            KillMode = "process";
            Restart = "on-failure";
            ExecStart = lib.escapeShellArgs (
              [ "${cfg.package}/bin/aria2c" ]
              ++ [
                "--enable-rpc"
              ]
            );
          };

          Install.WantedBy = [ "default.target" ];
        };
      })
      (mkIf pkgs.stdenv.isDarwin {
        services.aria2 = {
          errorLogFile = lib.mkOptionDefault "${config.home.homeDirectory}/Library/Logs/aria2/skhd.err.log";
          outLogFile = lib.mkOptionDefault "${config.home.homeDirectory}/Library/Logs/aria2/skhd.out.log";
        };
        launchd.agents.aria2 = {
          enable = true;
          config = {
            ProgramArguments = [
              "${cfg.package}/bin/aria2c"
              "--enable-rpc"
              # "--conf-path=${cfg.xdg.configFile."aria2/aria2.conf"}"
            ];
            RunAtLoad = true;
            StandardErrorPath = cfg.errorLogFile;
            StandardOutPath = cfg.outLogFile;
            KeepAlive = {
              Crashed = true;
              SuccessfulExit = false;

            };
          };
        };
      })
    ]
  );
}
