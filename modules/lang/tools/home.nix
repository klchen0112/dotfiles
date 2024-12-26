{pkgs, ...}: {
  home.packages = with pkgs; [
    bazel
  ];
}
