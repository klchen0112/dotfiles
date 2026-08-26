let
  machine = "init";
in
{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "stylix-home"
      "emacs-twist"
    ];
    users.klchen = {
      roles = [
        "stylix-home"
        "emacs-twist"
      ];
    };
    users.root = { };
  };

  # init-base：init 的系统配置（基础系统），init 与 initIso 共用
  # （disko 布局 / 滚动 / impermanence 在 disko.nix 中合并进同一 aspect）
  den.aspects.init-base = {
    nixos =
      {
        lib,
        pkgs,
        ...
      }:
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        # Bootloader.
        boot.loader.systemd-boot.enable = lib.mkDefault true;

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
  };

  den.aspects.init = {
    includes =
      with den.aspects;
      [
        init-base
        font
        # keyboard
        niri
        nix
        btrfs-scrub
        sops
      ]

      ++ [

        (den.provides.tty-autologin "klchen")

      ];

  };

  # initIso：init 的精简 live ISO 变体
  # （去掉 niri / emacs-twist / stylix-home，与 disko-install 生成的 init 系统配置一致）
  # 构建：nix build .#nixosConfigurations.initIso.config.system.build.isoImage
  den.hosts.x86_64-linux.initIso = {
    users.root = { };
  };

  den.aspects.initIso = {
    nixos =
      { lib, modulesPath, ... }:
      {
        imports = [
          (modulesPath + "/installer/cd-dvd/iso-image.nix")
        ];
        # ISO 是 live 镜像：无实际磁盘布局、无持久化、无 root 滚动
        disko.enableConfig = lib.mkForce false;
        environment.persistence = lib.mkForce { };
        # 保留一个不挂载的占位条目，避免 init-base 的 neededForBoot 定义残留
        fileSystems."/persist" = lib.mkForce {
          device = "/dev/disk/by-partlabel/disk-main-root";
          fsType = "btrfs";
          options = [ "subvol=persist" "noauto" ];
        };
        boot.initrd.systemd.services.my-btrfs-backup.enable = lib.mkForce false;
        boot.loader.systemd-boot.enable = lib.mkForce false;
        users.mutableUsers = lib.mkForce true;
        networking.hostName = lib.mkForce "init-iso";
        # live 环境 tty 直接以 root 登录
        services.getty.autologinUser = "root";
        # SSH：保留 sshd，klchen 密钥可远程连接（live 调试用）
        users.users.klchen = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPI6HctaCnuhyOdbrYs2un7/QA/hqFPfDVRlL0klfhGc klchen@i12r20"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNgI2fAHSDQCB+DgZPsjGF+arPudVmWS4hTXbJCvwwX klchen@a99r50"
          ];
        };
      };
    includes = with den.aspects; [
      init-base
      font
      nix
      btrfs-scrub
      sops
    ];
  };
}
