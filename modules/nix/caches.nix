let
  nix_settings = {
    allow-import-from-derivation = true;
    accept-flake-config = true;
    auto-optimise-store = true;
    use-xdg-base-directories = true;

    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://cache.numtide.com"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.numtide.com"
      "https://noctalia.cachix.org"
      "https://niri.cachix.org"
      "https://klchen0112.cachix.org"
      "https://cache.numtide.com"
      "https://cuda-maintainers.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "cache.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];

  };

in
{
  den.aspects.nix-home.homeManager = {
    nix.settings = nix_settings;
  };
  den.aspects.nix = {
    darwin = {
      nix.settings = nix_settings;
    };
    nixos = { pkgs, ... }: {
      nix.settings = nix_settings;
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc
        # zlib, glib, etc.
      ];

    };
  };
  flake-file.nixConfig = nix_settings // {
    lazy-trees = true;
    submodules = true;
  };
}
