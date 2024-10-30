{pkgs, ...}: {
  imports = [
    ./modules/micromamba.nix
    ./modules/mamba.nix
  ];
  home.packages = with pkgs; [
    # (python310.withPackages (ps: with ps; [isort pyflakes black matplotlib numpy pandas tensorflow torch torchvision virtualenv opencv4 tqdm conda]))
    # python3Full
    pyright # python language server
    # python311Packages.black # python formatter
    # micromamba
  ];
  programs.mamba-cpp = {
    enable = false;
    package = pkgs.unstable.mamba-cpp;
  };
  programs.micromamba = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
