{ pkgs, ... }: {
  home.packages = with pkgs; [
    # alejandra
    nixfmt

  ];
}
