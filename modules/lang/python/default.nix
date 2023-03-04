{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [isort matplotlib numpy pandas tensorflow torch torchvision]))
    # python3Full
    nodejs
    nodePackages.pyright
  ];
}
