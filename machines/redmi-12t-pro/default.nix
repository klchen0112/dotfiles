{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # inputs.nix-doom-emacs.hmModule
    ../../modules/nixpkgs
    ../../modules/locale
  ];

  programs.home-manager.enable = true;

  system.stateVersion = "23.11";

  environment = {
    shells = with pkgs; [fish bash]; # Default shell
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
