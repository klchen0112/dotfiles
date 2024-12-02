{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}: {
  nixpkgs.system = "x86_64-linux";

  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;
  services = {
    openssh = {
      enable = true;
    };
  };
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [fish];
    systemPackages = with pkgs; [
      git
      neovim
      wget
      exa
      gcc
      clang
      cargo
      zig
      p7zip
      atool
      unzip
      joshuto
      ffmpeg
      ffmpegthumbnailer
      glib
      xdg-utils
      pciutils
      gdb
      killall
      nodejs
      socat
      zip
      rar
      frp
      sops
    ];
  };
  services.dbus.enable = true;

  nix = {
    settings = {
      # substituters = [
      #   "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      #   "https://cache.nixos.org/"
      # ];
      nix.optimise.automatic = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "25.05";
  };
}
