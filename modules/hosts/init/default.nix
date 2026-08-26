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
        # keyboard
        nix
        btrfs-scrub
        sops
      ]
      ++ [
        (den.provides.tty-autologin "klchen")
      ];

  };

  # initIso：init 的 ISO 构建变体，直接继承 init 的全部配置
  # （与 disko-install --flake '.#init' 生成的系统一致，只是叠加 iso-image 模块）
  # 构建：nix build .#nixosConfigurations.initIso.config.system.build.isoImage
  den.hosts.x86_64-linux.initIso = {
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
        # 保留一个不挂载的占位条目，避免 init 的 neededForBoot 定义残留
        fileSystems."/persist" = lib.mkForce {
          device = "/dev/disk/by-partlabel/disk-main-root";
          fsType = "btrfs";
          options = [ "subvol=persist" "noauto" ];
        };
        boot.initrd.systemd.services.my-btrfs-backup.enable = lib.mkForce false;
        boot.loader.systemd-boot.enable = lib.mkForce false;
        users.mutableUsers = lib.mkForce true;
        networking.hostName = lib.mkForce "init-iso";
      };
    includes = with den.aspects; [
      init
    ];
  };
}
