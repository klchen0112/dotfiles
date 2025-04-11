{ pkgs, ... }:
{
  imports = [
    # ./modules/micromamba.nix
    ./modules/mamba.nix
  ];
  home.packages = with pkgs; [
    # (python310.withPackages (ps: with ps; [isort pyflakes black matplotlib numpy pandas tensorflow torch torchvision virtualenv opencv4 tqdm conda]))
    # python3Full
    pyright # python language server
    # python311Packages.black # python formatter
  ];
  programs.mamba-cpp = {
    enable = true;
    package = pkgs.mamba-cpp;
  };
  # programs.micromamba = {
  #   enable = false;
  # };
}
