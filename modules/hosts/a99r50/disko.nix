{
  flake.modules.nixos.a99r50 =
    { lib, ... }:
    let
      disk_by_id = "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_4TB_ZTA54T0AB251540AHC_1-part3";
      root_volume = "@root";
      mount_p = "/btrfs_tmp";
      old_roots = "old_root";
    in
    {
      boot.initrd.systemd.services.rollback = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        wantedBy = [ "initrd.target" ];
        after = [ "systemd-cryptsetup@crypted.service" ];
        before = [ "sysroot.mount" ];

        script = ''
          mkdir -p ${mount_p}
          mount -t btrfs ${disk_by_id} ${mount_p}

          # 1. 确保 old_roots 是一个子卷，而不是普通目录
          if [[ ! -e ${mount_p}/${old_roots} ]]; then
              btrfs subvolume create ${mount_p}/${old_roots}
          fi

          if [[ -e ${mount_p}/${root_volume} ]]; then
              timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
              
              # 2. 备份当前 root：创建只读快照到 old_roots 子卷下
              # 注意：snapshot 只能在同一个 Btrfs 文件系统内跨子卷存放，这没问题
              btrfs subvolume snapshot -r ${mount_p}/${root_volume} ${mount_p}/${old_roots}/$timestamp
              
              btrfs subvolume delete ${mount_p}/${root_volume}
          fi
          for i in $(find ${mount_p}/old_roots/ -maxdepth 1 -mtime +30); do
              btrfs subvolume delete ${mount_p}/$i
          done

          btrfs subvolume create ${mount_p}/${root_volume}


          umount ${mount_p}
        '';
      };
      disko.devices = {
        disk.main = {
          device = "/dev/nvme1n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02";
              };
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                    };

                    "etc" = {
                      mountpoint = "/etc";
                      mountOptions = [
                        "compress=zstd"
                      ];
                    };
                    "log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd"
                      ];
                    };
                    "nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "root" = {
                      mountpoint = "/root";
                      mountOptions = [
                        "compress=zstd"
                      ];
                    };
                    "home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "48G";
                    };
                  };
                  mountpoint = "/partition-root";
                  swap = {
                    swapfile = {
                      size = "48G";
                    };
                  };
                };
              };
            };
          };

        };
      };
    };
}
