let
  nix_settings = {
    allow-import-from-derivation = true;
    accept-flake-config = true;
    auto-optimise-store = true;
    use-xdg-base-directories = true;

    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store?priority=0"
      "https://nix-community.cachix.org?priority=1"
      "https://niri.cachix.org?priority=1"
      "https://cache.nixos.org?priority=1"
      "https://klchen0112.cachix.org?priority=2"
      "https://cache.numtide.com"
      "https://cuda-maintainers.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
    trusted-substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://klchen0112.cachix.org"
      "https://cache.numtide.com"
      "https://cuda-maintainers.cachix.org"
      "https://attic.xuyh0120.win/lantian"

    ];
    extra-substituters = [

      "https://cache.numtide.com"
      "https://cuda-maintainers.cachix.org"

    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="

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
    nixos = {
      nix.settings = nix_settings;
      programs.nix-ld.enable = true;

    };
  };
  flake-file.nixConfig = nix_settings // {
    lazy-trees = true;
    submodules = true;
  };
}
