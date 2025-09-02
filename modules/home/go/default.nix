{ pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   # go
  #   gopls
  #   gomodifytags
  #   gotests
  #   gore
  #   gotools
  # ];
  programs.go = {
    enable = true;
    # packages = {
    # "volcano.sh/apis"= builtins.fetchGit "https://github.com/volcano-sh/apis";
    # "volcano.sh/volcano" = builtins.fetchGit "https://github.com/volcano-sh/volcano";
    # "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
    # "golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
    # };
  };
}
