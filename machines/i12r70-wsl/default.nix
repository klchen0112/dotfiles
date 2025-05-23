#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{
  config,
  pkgs,
  username,
  system,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/account
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/locale
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs
    ../../modules/shells
    ../../modules/secrets
  ];

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.05";

  environment = {
    shells = with pkgs; [
      fish
      bash
    ]; # Default shell
    systemPackages = with pkgs; [
      cachix
      fontconfig
      gnugrep # replacee macos's grep
      gnutar # replacee macos's tar
      p7zip
      wget
    ];
  };
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld; # only for NixOS 24.05
  };
  programs.dconf.enable = true;
}
