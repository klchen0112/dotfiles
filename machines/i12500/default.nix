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
      inputs.vscode-server.nixosModules.default
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hyprland.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";



  # Set your time zone.
  time.timeZone = "Asia/Shanghai";





  # Enable CUPS to print documents.
  services.printing.enable = true;


  services.vscode-server.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" "networkmanager" "seat"];
    shell = pkgs.fish; # Default shell
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA7ACzG1nepQnjjHqcVKY1QQjYLQbhDcODoMumPCKQheFNBBTfBOck3nLPBkDhIcDRivHabmogC/nf8AOowl7rRx1qYhLagsZD4fbPmyA97g1xZ9/yip8crGn8s5iCFWQ5o83aZ8GoFOYHJdQmyugX/zbK3Wev3Y2LoL7Tvi9z/tzDlYmZp4zL6XntGXUTe9l3PyU0VR+RdehnTE5/fNC0I5JH+9Vr4H7/b4F26/N5qHdH6k+c+rX9F2ckrd17rAxG1bfmh3CUwOoTdg/8V9OTwecXYPLA8lFKQXG/RMMZvBsVsvxGCG482PFeNoB3beVdHwb9gO3z/fPfS3JUVl19pbkSLmLSG25rTzdFpQgKblGkuQzN9QeeXA5G8FdS3ubZG6eafvnyXFALvaE6bFqIpg2h4UEyMSaJusUoJqhRRng4MchGWxCvCu0l4SmPyq5XUMDdmX4kQhYQ6F7QR9mvztPQ/N23iDH0FdO6oM7gNIF+6UGLp0sOm74KyTULU0c= klchen@chenkailongdeMacBook-Pro.local"
    ];
  };

  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  nix = {
    package = pkgs.nix;
    gc = {
      # Garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      # Manual optimise storage: nix-store --optimise
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      builders-use-substitutes = true;
      # enable flakes globally
      experimental-features = [ "nix-command" "flakes" ];
    };
    settings.trusted-users =
      [
        "${username}"
      ];
  };


  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      # cascadia-code
      # comic-mono
      # fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      symbola
      # noto-fonts
      # noto-fonts-extra
      # noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # noto-fonts-lgc-plus
      lxgw-wenkai
      liberation_ttf
      overpass
      freefont_ttf
      # source-code-pro
      # source-sans-pro
      # source-serif-pro
      # sarasa-gothic
      iosevka
      cm_unicode
      hanazono
      lmodern
      # lmmath
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "CMU Typewriter Text" ];
        sansSerif = [ "IBM Plex Serif" ];
        monospace = [ "jetbrains-mono" ];
      };
    };
  };

  programs.fish = {
    enable = true;
  };



  environment = {
    shells = with pkgs; [ fish ]; # Default shell
    variables = {
      # System variables
      # EDITOR = "nvim";
      # VISUAL = "nvim";
      TERMINAL = "wezterm";
    };
    systemPackages = with pkgs; [
      # Installed Nix packages
      gnumake
    ];
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    allowSFTP = true;
    extraConfig = ''
      HostKeyAlgorithms +ssh-rsa
    ''; # Temporary extra config so ssh will work in guacamole

  };


  services.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  system.stateVersion = "23.05";

  i18n = {

    inputMethod =
      {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [ fcitx5-rime ];
      };
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
  };
}
