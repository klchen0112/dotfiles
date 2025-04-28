{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  lib,
  nixpkgs,
  ...
}:
{
  imports = [
    ./base.nix
  ];
  nix.gc = {
    # Garbage collection
    automatic = true;
    interval = {
      Hour = 3;
      Minute = 15;
    };
  };
  programs.nix-index.enable = true;
  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://colmena.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-substituters = [
      "https://klchen0112.cachix.org"
      "https://cosmic.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

    trusted-users = [
      "root"
      "@wheel"
      "${username}"
    ];
    accept-flake-config = true;
  };
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
}
