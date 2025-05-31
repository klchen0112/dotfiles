{ flake
, pkgs
, ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./hardware-configuration.nix
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
  programs.bash.enable = true;
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
  programs.dconf.enable = true;
}
