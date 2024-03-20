{pkgs, ...}: {
  home.packages = with pkgs; [
    python310Packages.grip
  ];
}
