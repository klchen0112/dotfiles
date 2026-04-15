let
  machine = "wsl-nixos";
in
{
  inputs,
  config,
  lib,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "emacs-twist"
      "stylix-home"
      "python"
      "java"

    ];
    users = {
      klchen.roles = [
        "emacs-twist"
        "stylix-home"
        "python"
        "java"
      ];
    };
    wsl.enable = true;
    klchen = { };
  };

  den.aspects.wsl-nixos = {
    includes = with den.aspects; [
      stylix
    ];
    nixos =
      { pkgs, ... }:
      {
        networking.hostName = "${machine}";
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
        system.build.installBootLoader = lib.mkForce "${pkgs.coreutils}/bin/true";
      };
  };
}
