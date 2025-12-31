{
  flake.modules.nixos.gnome =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      services.xserver.enable = true;
      # As of 25.11
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # To disable installing GNOME's suite of applications
      # and only be left with GNOME shell.
      services.gnome.core-apps.enable = true;
      services.gnome.core-developer-tools.enable = true;
      services.gnome.games.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
    };
}
