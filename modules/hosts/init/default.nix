let
  machine = "init";
in
{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "stylix-home"
    ];
    users.klchen = {
      roles = [
        "stylix-home"
      ];
    };
    users.root = { };
  };

  den.aspects.init = {
    nixos =
      {
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.disko.nixosModules.disko
        ];

        nixpkgs.hostPlatform = "x86_64-linux";
        # Bootloader.
        boot.loader.systemd-boot.enable = true;

        environment.systemPackages = with pkgs; [
          just
          git
          pciutils
          neovim
        ];
        # Don't allow mutation of users outside of the config.
        users.mutableUsers = false;
        zramSwap.enable = true;
      };
    includes =
      with den.aspects;
      [
        font
        # keyboard
        niri
        persist
        nix
        btrfs-scrub
        sops
      ]

      ++ [

        (den.provides.tty-autologin "klchen")

      ];

  };
}
