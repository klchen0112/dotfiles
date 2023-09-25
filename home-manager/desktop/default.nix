{ inputs, pkgs, lib, config, ... }:
{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.packages = with pkgs; [
	    hyprland
	];
}
