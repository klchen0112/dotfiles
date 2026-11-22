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
        system.build.installBootLoader = lib.mkForce "${pkgs.coreutils}/bin/true";

        # 原 `den.default.wsl`：#694 之后 `den.default` 会在 user 作用域留下一条
        # 无法归属的 nixos 内容（den 的 lostAt 记账问题），因此直接写到 host 上。
        wsl.enable = true;
        wsl.wslConf.automount.root = "/mnt";
        wsl.wslConf.interop.appendWindowsPath = false;
        wsl.wslConf.network.generateHosts = false;
        wsl.startMenuLaunchers = true;
      };
  };
}
