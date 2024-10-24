{pkgs, ...}: {
  imports = [
    ./options.nix
  ];
  home.packages = with pkgs; [
    # (python310.withPackages (ps: with ps; [isort pyflakes black matplotlib numpy pandas tensorflow torch torchvision virtualenv opencv4 tqdm conda]))
    # python3Full
    pyright # python language server
    # python311Packages.black # python formatter
    # micromamba
  ];
  programs.micromamba = {
    enable = false;
    package = pkgs.micromamba;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
