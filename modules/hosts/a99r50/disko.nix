{
  flake.modules.nixos.a99r50 =
    { lib, ... }:
    let
      disk_by_id = "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_4TB_ZTA54T0AB251540AHC_1-part3";
      root_volume = "@root";
    in
    {
      boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir /mnt
        mount -t btrfs ${disk_by_id} /mnt
        btrfs subvolume delete /mnt/${root_volume}
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
      '';
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
