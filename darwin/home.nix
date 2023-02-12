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
  imports =
    (import ../modules/editors) ++
    (import ../modules/shell);
  home = {
    # Specific packages for macbook
    # packages = with pkgs; [
    #   # Terminal
    #   pfetch
    # ];
    stateVersion = "22.11";
  };
}
