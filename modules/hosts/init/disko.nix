{ inputs, ... }:
{
  flake-file.inputs = {
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  # init 与 initIso 共享的磁盘配置（disko 布局 + 滚动 + impermanence）
  den.aspects.init-base.nixos =
    { lib, ... }:
    let
      # btrfs 分区（disko 自动生成的 partlabel）
      dev = "/dev/disk/by-partlabel/disk-main-root";
      root_subvol = "@root";
      mount_p = "/mnt";
      old_roots = "old_roots";
      keep_days = 30; # 清理超过 N 天的旧 root 快照
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      # --- 1. 开机自动清空 root（btrfs 滚动） ---
      # 参考 impermanence README 的 BTRFS subvolumes 方案；
      # 26.11 默认 systemd initrd，故用 boot.initrd.systemd.services
      # 实现（旧式 boot.initrd.postResumeCommands 已不生效）。
      boot.initrd.supportedFilesystems = [ "btrfs" ];
      boot.initrd.systemd.services.my-btrfs-backup = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        script = ''
          set -eu
          # 等待根分区设备就绪（最多约 30 秒）
          i=0
          while [ ! -e ${dev} ] && [ "$i" -lt 60 ]; do
            sleep 0.5
            i=$((i + 1))
          done

          mkdir -p ${mount_p}
          mount -t btrfs ${dev} ${mount_p}

          if [ -e "${mount_p}/${root_subvol}" ]; then
            timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
            mkdir -p ${mount_p}/${old_roots}
            echo ">>> [Rollback] snapshot current / to ${old_roots}/$timestamp"
            btrfs subvolume snapshot -r ${mount_p}/${root_subvol} ${mount_p}/${old_roots}/$timestamp
            echo ">>> [Rollback] delete old root subvolume"
            btrfs subvolume delete ${mount_p}/${root_subvol}
          fi

          echo ">>> [Rollback] create fresh root subvolume"
          btrfs subvolume create ${mount_p}/${root_subvol}

          # 递归删除旧快照（防止嵌套子卷残留），保留最近 ${toString keep_days} 天
          delete_subvolume_recursively() {
              local sv="$1"
              local child
              for child in $(btrfs subvolume list -o "$sv" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "${mount_p}/$child"
              done
              btrfs subvolume delete "$sv"
          }
          if [ -d "${mount_p}/${old_roots}" ]; then
            for snap in $(find ${mount_p}/${old_roots} -maxdepth 1 -mindepth 1 -mtime +${toString keep_days}); do
              delete_subvolume_recursively "$snap"
            done
          fi

          umount ${mount_p}
        '';
      };

      # --- 2. impermanence：控制哪些目录持久化 ---
      # /persist 需要在 initrd 阶段就挂载（impermanence 模块的断言要求）
      fileSystems."/persist".neededForBoot = true;

      environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos" # 用户/组 uid/gid 分配记录
          "/var/lib/systemd/coredump"
          "/var/lib/flatpak"
          "/etc/NetworkManager/system-connections"
          "/etc/ssh" # ssh host key + sops age key
          "/root"
        ];
        files = [
          "/etc/machine-id"
        ];
      };

      # --- 3. disko 磁盘布局 ---
      # root 用 btrfs subvol @root（每次开机由上面的服务滚动重建）
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
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
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
