# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  # Enable the terraform formatter
  programs.nixfmt.enable = true;

  programs.shellcheck.enable = true;
  programs.shfmt.enable = true;
  programs.taplo.enable = true;
  programs.jsonfmt.enable = true;
}
