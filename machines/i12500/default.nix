#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{ config
, pkgs
, username
, system
, inputs
, ...
}: {
  imports =
    [

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/locale
      ../../modules/desktop/wayland
      ../../modules/fonts/fonts.nix
      ../../modules/nixpkgs
      ../../modules/editors
      ../../modules/shells
      ../../modules/network
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;




  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" "networkmanager" "seat" ];
    shell = pkgs.fish; # Default shell
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA7ACzG1nepQnjjHqcVKY1QQjYLQbhDcODoMumPCKQheFNBBTfBOck3nLPBkDhIcDRivHabmogC/nf8AOowl7rRx1qYhLagsZD4fbPmyA97g1xZ9/yip8crGn8s5iCFWQ5o83aZ8GoFOYHJdQmyugX/zbK3Wev3Y2LoL7Tvi9z/tzDlYmZp4zL6XntGXUTe9l3PyU0VR+RdehnTE5/fNC0I5JH+9Vr4H7/b4F26/N5qHdH6k+c+rX9F2ckrd17rAxG1bfmh3CUwOoTdg/8V9OTwecXYPLA8lFKQXG/RMMZvBsVsvxGCG482PFeNoB3beVdHwb9gO3z/fPfS3JUVl19pbkSLmLSG25rTzdFpQgKblGkuQzN9QeeXA5G8FdS3ubZG6eafvnyXFALvaE6bFqIpg2h4UEyMSaJusUoJqhRRng4MchGWxCvCu0l4SmPyq5XUMDdmX4kQhYQ6F7QR9mvztPQ/N23iDH0FdO6oM7gNIF+6UGLp0sOm74KyTULU0c= klchen@chenkailongdeMacBook-Pro.local"
    ];
  };

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.


  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  system.stateVersion = "23.05";


}
