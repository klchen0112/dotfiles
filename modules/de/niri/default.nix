{ inputs, ... }:
{
  flake-file.inputs = {
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs-stable.follows = "nixpkgs-stable";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      programs.xwayland.enable = true;
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        # for hyprland with nvidia gpu" = " ref https://wiki.hyprland.org/Nvidia/
        "LIBVA_DRIVER_NAME" = "nvidia";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        # VA-API hardware video acceleration
        "NVD_BACKEND" = "direct";

        "GBM_BACKEND" = "nvidia-drm";

      };
      imports = [
        inputs.niri.nixosModules.niri
      ];
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri;
      nixpkgs.overlays = [
        inputs.niri.overlays.niri
      ];
      services.displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        sessionPackages = with pkgs; [
          niri
        ];
      };
      xdg = {
        autostart.enable = true;
        portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-wlr
            pkgs.xdg-desktop-portal
          ];
          config.common.default = [ "gnome" ];
        };
      };
      #services.greetd = {
      #  enable = true;
      #  settings =
      #    let
      #      session = {
      #        command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${config.programs.niri.package}/bin/niri-session --remember";
      #        user = "klchen";
      #      };
      #    in
      #    {
      #      terminal.vt = 1;
      #      default_session = session;
      #    };
      #};
      # unlock GPG keyring on login
      security.polkit.enable = true; # polkit
      services.gnome.gnome-keyring.enable = true; # secret service
      security.pam.services.swaylock = { };
    };
  flake.modules.homeManager.niri =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        # screenshot
        # utils
        loupe
        wl-clipboard
        wlr-randr
        nautilus

      ];

      programs.niri.settings.binds = with config.lib.niri.actions; {
        "Alt+Tab".action = spawn "niriswitcherctl" "show" "--window";
        "Alt+Shift+Tab".action = spawn "niriswitcherctl" "show" "--window";
        "Alt+Grave".action = spawn "niriswitcherctl" "show" "--workspace";
        "Alt+Shift+Grave".action = spawn "niriswitcherctl" "show" "--workspace";
      };
      # 夜光护眼软件
      # services.wlsunset = {
      #   enable = true;
      #   latitude = "30:00";
      #   longitude = "120:00";
      # };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
        # for hyprland with nvidia gpu" = " ref https://wiki.hyprland.org/Nvidia/
        "LIBVA_DRIVER_NAME" = "nvidia";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        # VA-API hardware video acceleration
        "NVD_BACKEND" = "direct";

        "GBM_BACKEND" = "nvidia-drm";

      };
    };
}
