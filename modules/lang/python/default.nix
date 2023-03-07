{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (python310.withPackages (ps: with ps; [isort matplotlib numpy pandas tensorflow torch torchvision virtualenv]))
    # python3Full
    nodejs
    nodePackages.pyright
  ];
}
