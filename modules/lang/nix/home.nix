{ pkgs, ... }: {
  home.packages = with pkgs; [
    # alejandra
    nixfmt
    # nix-du
    nil
  ];
}
