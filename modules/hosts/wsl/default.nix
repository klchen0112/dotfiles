let
  machine = "wsl-nixos";
in
{
  inputs,
  config,
  lib,
  ...
}:
{
  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "emacs-twist"
    ];
    users = {
      klchen.roles = [
        "emacs-twist"

      ];
    };
    klchen = { };
  };

  den.aspects.wsl-nixos = {
    nixos =
      { pkgs, ... }:
      {
        fileSystems."/".device = "/dev/noroot";
        boot.loader.grub.enable = false;
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";

      };
  };
}
