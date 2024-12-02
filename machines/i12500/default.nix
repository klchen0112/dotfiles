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
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/locale
    ../../modules/desktop/wayland
    ../../modules/fonts/fonts.nix
    ../../modules/nixpkgs
    ../../modules/shells
    ../../modules/network
    ../../modules/secrets
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = ["wheel" "networkmanager" "seat"];
    shell = pkgs.fish; # Default shell
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  system.stateVersion = "25.05";

  environment = {
    shells = with pkgs; [fish bash]; # Default shell
    systemPackages = with pkgs; [
      cachix
      fontconfig
      gnugrep # replacee macos's grep
      gnutar # replacee macos's tar
      p7zip
    ];
  };
}
