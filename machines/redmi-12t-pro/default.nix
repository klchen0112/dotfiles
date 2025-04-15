{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/nixpkgs
    ../../modules/locale
  ];

  programs.home-manager.enable = true;

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
      vim
    ];
    etcBackupExtension = ".bak";
  };
}
