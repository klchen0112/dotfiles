{ pkgs, ... }:
{
  programs.java = {
    enable = true;
    package = pkgs.jdk8;
  };
  programs.gradle.enable = true;
}
