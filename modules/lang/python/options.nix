{
  pkgs,
  config,
  lib,
  ...
}: {
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
  config = lib.mkIf config.programs.micromamba.enable {
    # Always add the configured `pyenv` package.
    home.packages = [config.programs.micromamba.package];
    programs.bash.initExtra = lib.mkIf config.programs.micromamba.enableBashIntegration ''
      eval $(/nix/store/629s7qzxlskxkfyzs5q26hnjj9jkxnzi-micromamba-1.4.4/bin/micromamba shell hook --shell zsh --prefix  /Users/chenkailong_dxm/micromamba)
    '';

    programs.zsh.initExtra =
      lib.mkIf config.programs.micromamba.enableZshIntegration ''
        eval $(/nix/store/629s7qzxlskxkfyzs5q26hnjj9jkxnzi-micromamba-1.4.4/bin/micromamba shell hook --shell zsh --prefix  /Users/chenkailong_dxm/micromamba)'';

    programs.fish.interactiveShellInit = lib.mkIf config.programs.micromamba.enableFishIntegration ''
      ${config.programs.micromamba.package}/bin/micromamba shell hook --shell fish --prefix  ${config.programs.micromamba.rootDirectory} | source
    '';
  };
}
