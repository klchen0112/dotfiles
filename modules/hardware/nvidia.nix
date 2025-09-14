{
  flake.modules.nixos.nvidia =
    {
      config,
      lib,
      ...
    }:
    {
      hardware.graphics = {
        enable = true;
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      # Load nvidia driver for Xorg and Wayland
      hardware.nvidia = {
        # Modesetting is required.
        modesetting.enable = lib.mkDefault true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = lib.mkDefault true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = lib.mkDefault false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = lib.mkForce false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = lib.mkDefault true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
}
