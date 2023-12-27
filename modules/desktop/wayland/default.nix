{
  pkgs,
  inputs,
  ...
}: {
  # these code from https://github.com/ryan4yin/nix-config
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
      xwayland = {
        enable = true;
        # hidpi = true;
      };
      # enableNvidiaPatches = false;
    };
    # monitor backlight control
    light.enable = true;

    # thunar file manager(part of xfce) related options
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk # for gtk
      # xdg-desktop-portal-kde  # for kde
    ];
  };

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "hyprland";
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];
  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = {};
}
