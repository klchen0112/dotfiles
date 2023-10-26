{ pkgs, ... }: {
  home.packages = with pkgs; [
    rust-analyzer
    cargo # rust package manager
    rustfmt
  ];
}
