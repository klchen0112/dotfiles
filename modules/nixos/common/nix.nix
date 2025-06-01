{ flake
, pkgs
, lib
, config
, ...
}:
{
  environment.etc."nix/inputs/nixpkgs".source = "${flake.inputs.nixpkgs}";

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    # overlays = (lib.attrValues flake.inputs.self.overlays) ++ [
    #   flake.inputs.nix-vscode-extensions.overlays.default
    #   flake.inputs.nur.overlays.default
    # ];
  };
  nix = {
    channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry = {
      nixpkgs.flake = flake.inputs.nixpkgs;
      nixpkgs-unstable.flake = flake.inputs.nixpkgs-unstable;
    };
    gc.automatic = true;
    settings = {
      max-jobs = "auto";
      # I don't have an Intel mac.
      extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
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
        "https://colmena.cachix.org"
        "https://cache.garnix.io"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
      accept-flake-config = true;
      extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
    };
  };

}
