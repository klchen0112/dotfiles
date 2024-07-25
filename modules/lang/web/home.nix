{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.eslint
  ];
}
