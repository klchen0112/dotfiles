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
    ../../modules/desktop/cosmic
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/locale
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs
    ../../modules/shells
    ../../modules/secrets
  ];


    # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.


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

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # nvidia settings
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
}
