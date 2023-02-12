#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  home = {
    # Specific packages for macbook
    # packages = with pkgs; [
    #   # Terminal
    #   pfetch
    # ];
    stateVersion = "22.11";
  };
}
