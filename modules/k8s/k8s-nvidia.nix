{

  den.aspects.k8s-nvidia.nixos =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {

      hardware.nvidia = {
        open = lib.mkDefault true;
        package = config.boot.kernelPackages.nvidiaPackages.stable; # change to match your kernel
        nvidiaSettings = true;
      };

      # Hack for getting the nvidia driver recognized
      services.xserver = {
        enable = false;
        videoDrivers = [ "nvidia" ];
      };

      nixpkgs.config.allowUnfreePackages = [
        "nvidia-x11"
        "nvidia-settings"
      ];
      virtualisation.docker.enable = true;
      hardware.nvidia-container-toolkit.enable = true;
      hardware.nvidia-container-toolkit.mount-nvidia-executables = true;

      environment.systemPackages = with pkgs; [
        nvidia-container-toolkit
      ];

    };
}
