{
  flake.modules.homeManager.mamba-cpp =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      rootDirectory = "${config.home.homeDirectory}/.mambaforge";
    in
    {

      home.packages = [ pkgs.mamba-cpp ];
      programs.bash.initExtra = lib.mkIf config.programs.mamba-cpp.enableBashIntegration ''
        export MAMBA_EXE=${lib.getExe pkgs.mamba-cpp}
        export MAMBA_ROOT_PREFIX=${rootDirectory}
        #"$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX"
      '';

      programs.zsh.initContent = lib.mkIf config.programs.mamba-cpp.enableZshIntegration ''
        export MAMBA_EXE=${lib.getExe pkgs.mamba-cpp}
        export MAMBA_ROOT_PREFIX=${rootDirectory}
        #"$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX"
      '';

      programs.fish.interactiveShellInit = lib.mkIf config.programs.mamba-cpp.enableFishIntegration ''
        set -gx MAMBA_EXE ${lib.getExe pkgs.mamba-cpp}
        set -gx MAMBA_ROOT_PREFIX ${rootDirectory}
      '';
    };

}
