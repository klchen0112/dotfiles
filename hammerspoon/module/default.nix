{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.hammerspoon;
  inherit (lib) mkIf;

in
{
  options =
    let
      inherit (lib) mkEnableOption mkOption types;
    in
    {
      programs.hammerspoon = {
        enable = mkEnableOption "Hammerspoon, a tool for automating macOS tasks";

        package = mkOption {
          type = types.nullOr types.package;
          default = null;
          description = ''
            The Hammerspoon package to use.
          '';
        };

        configPath = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Path to a Hammerspoon configuration.
            If a file (typically init.lua), it will be copied to the hammerspoon config directory.
            If a directory, its contents will be copied to the hammerspoon config directory.
          '';
        };

        spoons = mkOption {
          type = types.listOf types.package;
          default = [ ];
          description = ''
            List of Hammerspoon Spoons to install.
            Keys are spoon names, values are paths to the spoon directories.
            Each spoon will be installed to the Spoons/ subdirectory.
          '';
        };
      };
    };

  config = mkIf cfg.enable {
    targets.darwin.defaults = {
      "org.hammerspoon.Hammerspoon".MJConfigFile = "${config.xdg.configHome}/hammerspoon/init.lua";
    };
    home.packages = mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."hammerspoon/Spoons" = mkIf (cfg.configPath != null || cfg.spoons != { }) {
      source =
        let
          extensionsEnvPkg = pkgs.buildEnv {
            name = "hm-hammersppon-extensions";
            paths = cfg.spoons;
          };
        in
        "${extensionsEnvPkg}";
      recursive = true;
      force = true;
    };
    xdg.configFile."hammerspoon" = mkIf (cfg.configPath != null) {
      source = cfg.configPath;
      recursive = true;
      force = true;
    };
  };
}
