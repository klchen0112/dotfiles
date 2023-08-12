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
, user
, ...
}: {
  hardware.opengl.enable = true;
  wsl = {
    enable = true;
    defaultUser = "${username}";
    # 创建软件的桌面快捷方式
    startMenuLaunchers = true;
  };
  environment = {
    shells = with pkgs; [ bashInteractive fish ];
    systemPackages = with pkgs; [
      wsl-open
      home-manager
      fish
      coreutils
      fontconfig
    ];
  };

  services = {
    nix-daemon.enable = true; # Auto upgrade daemon
    emacs = {
      enable = true;
      package = pkgs.emacsGit;
    };
  };

  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.fish; # Default shell
    isNormalUser = true;
    extraGroups = [ "whell" ];
  };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      cascadia-code
      comic-mono
      fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      symbola
      # noto-fonts
      # noto-fonts-extra
      noto-fonts-emoji
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
      # iosevka
      cm_unicode
      hanazono
      lmodern
      # lmmath
    ];
  };
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };
  nix = {
    package = pkgs.nix;
    gc = {
      # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };


  };
  system.stateVersion = "23.05";
  time.timeZone = "Asia/Shanghai";
  networking.hostName = "wsl";
}
