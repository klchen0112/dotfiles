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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

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
  programs.fish.enable = true;

  users.users.${username} = {
    # macOS user
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish; # Default shell
  };

  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.



  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      # jetbrains-mono
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
      # Terminal
      # bash
      fish
      # zsh
      fontconfig
      home-manager
      coreutils
      cachix
      jq # for yabai json parser
      # sketchybar
      gzip
      nixpkgs-fmt
    ];
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  services = {
    # ariang.enable = true;
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      ''; # Temporary extra config so ssh will work in guacamole

    };

    emacs = {
      enable = false;
      package = pkgs.emacs29;
      # https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#emacs-daemon
      # package = inputs.nix-doom-emacs.packages.${system}.doom-emacs.override {
      #  doomPrivateDir = ../../doom;
      #  emacsPackage = pkgs.emacs-unstable;
      # };
    };

  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  system.stateVersion = "23.11";
}
