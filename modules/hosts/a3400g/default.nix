{
  inputs,
  ...
}:
{
  flake.modules.nixos.a3400g = {
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";

  };
}
