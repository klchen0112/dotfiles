{pkgs, ...}: {
  home.packages = with pkgs; [
    # go
    gopls
    # gomodifytags
    # gotests
    # gore
    # gotools
  ];
  # programs.go.enable = true;
}
