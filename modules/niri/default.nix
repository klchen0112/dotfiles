{
  flake-file.inputs = {
    niri.url = "github:sodiboo/niri-flake";
    # niri-caelestia-shell.url = "github:jutraim/niri-caelestia-shell";
    DankMaterialShell.url = "github:AvengeMedia/DankMaterialShell";
  };
  flake.modules.nixos.niri =
    { pkgs, inputs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri;
      # nixpkgs.overlays = [
      #   flake.inputs.niri.overlays.niri
      # ];
      services.displayManager = {
        gdm.enable = true;
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
      security.pam.services.greetd.enableGnomeKeyring = true;
    };
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # screenshot
        grim
        slurp
        # utils
        wl-clipboard
        wlr-randr
        gnome-themes-extra

      ];

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
