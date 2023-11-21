{ pkgs, config,lib, ... }: {
  options.programs.micromamba = {
    enable = lib.mkEnableOption "micromamba";
     package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.micromamba;
      defaultText = lib.literalExpression "pkgs.micromamba";
      description = "The package to use for micromamba.";
    };
    rootDirectory = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/micromamba";
      defaultText = "\${config.home.homeDirectory}/micromamba";
    };
    # enableBashIntegration = lib.mkOption {
    #   type = lib.types.bool;
    #   default = true;
    #   description = ''
    #     Whether to enable micromamba's Bash integration.
    #   '';
    # };
    # enableZshIntegration = lib.mkOption {
    #   type = lib.types.bool;
    #   default = true;
    #   description = ''
    #     Whether to enable micromamba's Zsh integration.
    #   '';
    # };
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable micromamba's Fish integration.
      '';
    };
  };
  config = lib.mkIf config.programs.micromamba.enable {
    # Always add the configured `pyenv` package.
    home.packages = [ config.programs.micromamba.package ];
    # programs.bash.initExtra = lib.mkIf cfg.enableBashIntegration ''
    #   export MAMBA_ROOT_PREFIX="${cfg.rootDirectory}"
    #   eval "$(${lib.getExe cfg.package} init - bash)"
    # '';

    # programs.zsh.initExtra = lib.mkIf cfg.enableZshIntegration ''
    #   export MAMBA_ROOT_PREFIX="${cfg.rootDirectory}"
    #   eval "$(${lib.getExe cfg.package} init - zsh)"
    # '';

    programs.fish.interactiveShellInit = lib.mkIf config.programs.micromamba.enableFishIntegration ''
      set -Ux MAMBA_ROOT_PREFIX "${config.programs.micromamba.rootDirectory}"
      set -Ux MAMBA_EXE "${config.programs.micromamba.package}/bin/micromamba"
      $MAMBA_EXE shell hook --shell fish --prefix $MAMBA_ROOT_PREFIX | source
    '';
  };
}
