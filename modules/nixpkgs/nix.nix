{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  lib,
  ...
}:
{
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.gc.automatic = true;
  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://klchen0112.cachix.org"
      "https://cosmic.cachix.org"
      "https://colmena.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="

    ];

    trusted-users = [
      "root"
      "@wheel"
      "${username}"
    ];
    accept-flake-config = true;
  };

}
