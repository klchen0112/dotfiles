{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.mamba-cpp;
  cfgRootDirectory = cfg.rootDirectory;
in
{
  options.programs.mamba-cpp = {
    enable = lib.mkEnableOption "mamba-cpp" // {
      default = false;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mamba-cpp;
      defaultText = lib.literalExpression "pkgs.mamba-cpp";
      description = "The package to use for mamba-cpp.";
    };
    rootDirectory = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.local/share/mamba";
      defaultText = "\${config.home.homeDirectory}/.local/share/mamba";
    };
    enableBashIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.bash.enable;
      description = ''
        Whether to enable mamba's Bash integration.
      '';
    };
    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.zsh.enable;
      description = ''
        Whether to enable mamba's Zsh integration.
      '';
    };
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.fish.enable;
      description = ''
        Whether to enable mamba's Fish integration.
      '';
    };
  };
  config = lib.mkIf config.programs.mamba-cpp.enable {
    # Always add the configured `pyenv` package.
    home.packages = [ config.programs.mamba-cpp.package ];
    programs.bash.initExtra = lib.mkIf config.programs.mamba-cpp.enableBashIntegration ''
      export MAMBA_EXE=${lib.getExe cfg.package}
      export MAMBA_ROOT_PREFIX=${cfgRootDirectory}
      #"$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX"
    '';

    programs.zsh.initContent = lib.mkIf config.programs.mamba-cpp.enableZshIntegration ''
      export MAMBA_EXE=${lib.getExe cfg.package}
      export MAMBA_ROOT_PREFIX=${cfgRootDirectory}
      #"$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX"
    '';

    programs.fish.interactiveShellInit = lib.mkIf config.programs.mamba-cpp.enableFishIntegration ''
      set -gx MAMBA_EXE ${lib.getExe cfg.package}
      set -gx MAMBA_ROOT_PREFIX ${cfgRootDirectory}
    '';
  };
}
