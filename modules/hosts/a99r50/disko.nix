{
  flake.modules.nixos.a99r50 =
    { lib, pkgs, ... }:
    let
      dev = "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_4TB_ZTA54T0AB251540AHC_1-part3";
      root_subvol = "@root";
      mount_p = "/mnt";
      old_roots = "old_roots";
    in
    {
      boot.initrd.supportedFilesystems = [ "btrfs" ];
      boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir -p ${mount_p}
        # 挂载 Btrfs 根分区（不指定子卷，默认挂载整个分区 ID 5）
        mount -t btrfs ${dev} ${mount_p}
        if [[ ! -e ${mount_p}/${old_roots} ]]; then
           btrfs subvolume create ${mount_p}/${old_roots}
        fi
        if [ -e "${mount_p}/${root_subvol}" ]; then
            # 生成时间戳
            timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
            
            echo ">>> [Rollback] Backing up current / to ${old_roots}/$timestamp"
            # 快照当前 root 为只读并移动到备份目录
            btrfs subvolume snapshot -r ${mount_p}/${root_subvol} ${mount_p}/${old_roots}/$timestamp
            
            # 递归删除旧的 root（因为里面可能有嵌套子卷）
            btrfs subvolume delete ${mount_p}/${root_subvol}
        fi

        echo ">>> [Rollback] Creating fresh / subvolume"
        btrfs subvolume create ${mount_p}/${root_subvol}

        # 可选：清理超过 30 天的备份 (busybox 的 find 语法略有不同)
        # 这里建议手动清理，防止 initrd 时间戳错误误删所有备份

        umount ${mount_p}
      '';
      disko.devices = {
        disk.main = {
          device = "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_4TB_ZTA54T0AB251540AHC_1";
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
