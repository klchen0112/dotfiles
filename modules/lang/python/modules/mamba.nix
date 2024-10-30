{
  pkgs,
  config,
  lib,
  ...
}: {
  options.programs.mamba-cpp = {
    enable = lib.mkEnableOption "mamba";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mamba-cpp;
      defaultText = lib.literalExpression "pkgs.mamba-cpp";
      description = "The package to use for mamba-cpp.";
    };
    rootDirectory = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/mamba";
      defaultText = "\${config.home.homeDirectory}/mamba";
    };
    enableBashIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.bash.enable;
      description = ''
        Whether to enable micromamba's Bash integration.
      '';
    };
    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.zsh.enable;
      description = ''
        Whether to enable micromamba's Zsh integration.
      '';
    };
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.fish.enable;
      description = ''
        Whether to enable micromamba's Fish integration.
      '';
    };
  };
  config = lib.mkIf config.programs.mamba-cpp.enable {
    # Always add the configured `pyenv` package.
    home.packages = [config.programs.mamba-cpp.package];
    programs.bash.initExtra = lib.mkIf config.programs.micromamba.enableBashIntegration ''
      export MAMBA_ROOT_PREFIX=${config.programs.mamba-cpp.rootDirectory}
      eval $(${config.programs.mamba-cpp.package}/bin/mamba shell hook --shell bash --root-prefix $MAMBA_ROOT_PREFIX)'';

    programs.zsh.initExtra = lib.mkIf config.programs.mamba-cpp.enableZshIntegration ''
      export MAMBA_ROOT_PREFIX=${config.programs.mamba-cpp.rootDirectory}
      eval $(${config.programs.mamba-cpp.package}/bin/mamba shell hook --shell zsh --root-prefix $MAMBA_ROOT_PREFIX)'';

    programs.fish.interactiveShellInit = lib.mkIf config.programs.mamba-cpp.enableFishIntegration ''
      set -gx MAMBA_ROOT_PREFIX ${config.programs.mamba-cpp.rootDirectory}
      set -gx MAMBA_EXE ${config.programs.mamba-cpp.package}/bin/mamba
      $MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
    '';
  };
}
