{pkgs, ...}: {
  home.packages = with pkgs; [
    # (python310.withPackages (ps: with ps; [isort pyflakes black matplotlib numpy pandas tensorflow torch torchvision virtualenv opencv4 tqdm conda]))
    # python3Full
    nodejs
    nodePackages.pyright
    micromamba
  ];
}
