{
  inputs,
  ...
}:
{
  flake.modules.nixos.a3400g = {config,...}:{
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";
    imports = [
      inputs.self.modules.nixos.klchen
    ];
    home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        niri
        ghostty
        aria2
        kitty
        bash
        syncthing
        emacs
      ];
  };
}
