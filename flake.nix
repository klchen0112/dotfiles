# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    allow-import-from-derivation = true;
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store?priority=0"
      "https://nix-community.cachix.org?priority=1"
      "https://niri.cachix.org?priority=1"
      "https://cache.nixos.org?priority=1"
      "https://klchen0112.cachix.org?priority=2"
    ];
    trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
    trusted-substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://klchen0112.cachix.org"
    ];
  };

  inputs = {
    agenix = {
      inputs = {
        darwin = {
          follows = "nix-darwin";
        };
        home-manager = {
          follows = "home-manager";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:ryantm/agenix";
    };
    brew-nix = {
      inputs = {
        nix-darwin = {
          follows = "nix-darwin";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:BatteredBunny/brew-nix";
    };
    den = {
      url = "github:vic/den";
    };
    devshell = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:numtide/devshell";
    };
    disko = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/disko";
    };
    emacs-config = {
      inputs = {
        flake-parts = {
          follows = "flake-parts";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
        twist = {
          follows = "twist";
        };
      };
      url = "github:klchen0112/.emacs.d";
    };
    emacs-overlay = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        nixpkgs-stable = {
          follows = "nixpkgs-stable";
        };
      };
      url = "github:nix-community/emacs-overlay/master";
    };
    flake-aspects = {
      url = "github:vic/flake-aspects";
    };
    flake-file = {
      url = "github:vic/flake-file";
    };
    flake-parts = {
      inputs = {
        nixpkgs-lib = {
          follows = "nixpkgs-lib";
        };
      };
      url = "github:hercules-ci/flake-parts";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    git-hooks = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:cachix/git-hooks.nix";
    };
    home-manager = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/home-manager";
    };
    import-tree = {
      url = "github:vic/import-tree";
    };
    mac-app-util = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
        cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
      };
      url = "github:hraban/mac-app-util";
    };
    niri = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        nixpkgs-stable = {
          follows = "nixpkgs-stable";
        };
      };
      url = "github:sodiboo/niri-flake";
    };
    niri-caelestia-shell = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:jutraim/niri-caelestia-shell";
    };
    nix-auto-follow = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:fzakaria/nix-auto-follow";
    };
    nix-darwin = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-darwin/nix-darwin";
    };
    nix-index-database = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/nix-index-database";
    };
    nix-vscode-extensions = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nixpkgs = {
      url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable";
    };
    nixpkgs-lib = {
      follows = "nixpkgs";
    };
    nixpkgs-stable = {
      url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-25.05";
    };
    nixpkgs-unstable = {
      url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable-small";
    };
    nixvim = {
      inputs = {
        flake-parts = {
          follows = "flake-parts";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/nixvim";
    };
    noctalia-shell = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        quickshell = {
          follows = "quickshell";
        };
      };
      url = "github:noctalia-dev/noctalia-shell";
    };
    nur = {
      inputs = {
        flake-parts = {
          follows = "flake-parts";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/NUR";
    };
    pkgs-by-name-for-flake-parts = {
      url = "github:drupol/pkgs-by-name-for-flake-parts";
    };
    quickshell = {
      follows = "niri-caelestia-shell/quickshell";
    };
    rime = {
      flake = false;
      url = "github:klchen0112/rime-snow-combo-pinyin";
    };
    srvos = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/srvos";
    };
    stylix = {
      inputs = {
        flake-parts = {
          follows = "flake-parts";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
        nur = {
          follows = "nur";
        };
      };
      url = "github:nix-community/stylix";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:numtide/treefmt-nix";
    };
    twist = {
      url = "github:emacs-twist/twist.nix";
    };
    zen-browser = {
      inputs = {
        home-manager = {
          follows = "home-manager";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

}
