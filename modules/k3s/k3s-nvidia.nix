{

  den.aspects.k3s-nvidia.nixos =
    { pkgs, config, ... }:
    let
      # cachyos kernels come from the nix-cachyos-kernel flake, built with its
      # own pinned nixpkgs. Its glibc can differ from the system's, so mount it
      # too: the injected nvidia executables (nvidia-smi, ...) link against it
      # and otherwise fail with "cannot execute: required file not found".
      driverGlibc = config.boot.kernelPackages.stdenv.cc.libc or pkgs.glibc;
    in
    {
      nixpkgs = {
        config = {
          cudaSupport = true;
        };
      };

      hardware.nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable; # change to match your kernel
        nvidiaSettings = true;
      };

      # Hack for getting the nvidia driver recognized
      services.xserver = {
        enable = false;
        videoDrivers = [ "nvidia" ];
      };
      virtualisation = {
        #containerd = {
        #  enable = true;
        #};
        docker.enable = true;
      };

      nixpkgs.config.allowUnfreePackages = [
        "nvidia-x11"
        "nvidia-settings"
      ];

      hardware.nvidia-container-toolkit.enable = true;
      hardware.nvidia-container-toolkit.mount-nvidia-executables = true;
      hardware.nvidia-container-toolkit.mounts = [
        {
          hostPath = "${driverGlibc}";
          containerPath = "${driverGlibc}";
        }
      ];
      virtualisation.docker.daemon.settings.features.cdi = true;
      environment.systemPackages = with pkgs; [
        nvidia-container-toolkit
        pciutils
      ];

    };
}
