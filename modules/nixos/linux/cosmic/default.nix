{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.nixos-cosmic.nixosModules.default
  ];
  # Clipboard Manager not working
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  # COSMIC Utilities - Observatory not working
  systemd.packages = [ pkgs.observatory ];
  systemd.services.monitord.wantedBy = [ "multi-user.target" ];
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.flatpak.enable = true;
  services.geoclue2.enable = true;

  environment.systemPackages = with pkgs; [
    chronos
    cosmic-applets
    cosmic-edit
    cosmic-ext-calculator
    cosmic-ext-forecast
    cosmic-ext-tasks
    cosmic-ext-tweaks
    cosmic-reader
    cosmic-screenshot
    quick-webapps
  ];

  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

}
