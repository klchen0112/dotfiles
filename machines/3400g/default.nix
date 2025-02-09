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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/account
    ../../modules/locale
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs
    ../../modules/shells
    ../../modules/secrets
    ../../modules/ssh
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  networking.hostName = "3400g";
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
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

}
