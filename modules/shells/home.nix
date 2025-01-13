# fish configuration
#
{
  lib,
  inputs,
  pkgs,
  isWork,
  ...
}: {
  programs.gpg = {enable = true;};

  programs.git = {
    enable = true;
    package = pkgs.git;
    ignores = ["*~" "*.swp" ".DS_Store" ".devenv"];
    attributes = ["*.pdf diff=pdf"];
    lfs.enable = true;
    userName = "klchen0112";
    userEmail = "klchen0112@gmail.com";
    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
    delta = {
      enable = true;
      options = {
        features = lib.mkDefault "side-by-side";
      };
    };
    extraConfig = let
      base_config = {
        init.defaultBranch = "master"; # https://srid.ca/unwoke

        core.editor = "emacsclient";
        core.quotepath = false;
        core.autocrlf = false;
        # For supercede
        core.symlinks = true;
        #protocol.keybase.allow = "always";
        credential.helper = "store --file ~/.config/git/git-credentials";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      work_config = {
        "http \"github.com\"" = {
          "proxy" = "socks5h://127.0.0.1:7890";
        };
        "http \"https://github.com\"" = {
          "proxy" = "socks5h://127.0.0.1:7890";
        };
      };
    in
      if isWork
      then lib.recursiveUpdate base_config work_config
      else base_config;
  };

  catppuccin.btop.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      theme_background = true; # make btop transparent
    };
  };

  programs.bash = {enable = true;};
  programs.zsh = {
    enable = pkgs.stdenv.isDarwin;
    autosuggestion.enable =
      true; # Auto suggest options and highlights syntax, searches in history for options
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history.size = 100000;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  catppuccin.fish.enable = true;
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      lt = "exa --tree";
      htop = "btop";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      E = "emacs -nw";
      grep = "rg";
      cat = "bat";
      # conda = "micromamba";
      vim = "emacs -nw";
    };
    shellAliases = {
      # conda = "micromamba";
      "..." = "cd ../..";
      # "cd" = "z";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
      {
        name = "autopair";
        src = autopair-fish.src;
      }
      {
        name = "sponge";
        src = sponge.src;
      }
      # {
      #   name = "pure";
      #   src = pure.src;
      # }
    ];
    interactiveShellInit = "
    macchina
    ";
  };
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
  catppuccin.bat.enable = true;
  programs.bat = {
    enable = true;
    config = {
      style = "numbers,header,grid,changes,snip";
    };

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
      prettybat
    ];
  };
  catppuccin.fzf.enable = true;
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  catppuccin.tmux.enable = true;
  programs.tmux = {
    enable = true;
    # defaultKeyMode = "emacs";
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.jq = {enable = true;};
  programs.man = {enable = true;};

  programs.atuin = {
    enable = true;
  };
  catppuccin.starship.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings =
      builtins.fromTOML (builtins.readFile ./starship.toml);
  };
  programs.ripgrep = {enable = true;};

  programs.ssh = {
    enable = false;
    serverAliveInterval = 30;
    serverAliveCountMax = 6;
    compression = true;
    matchBlocks = {
      xiaomi = {
        # hostkeyAlgorithms = "+ssh-rsa";
        # pubkeyAcceptedAlgorithms = "+ssh-rsa";
        hostname = "192.168.31.1";
        port = 22;
        user = "root";
      };
      ax5 = {
        # hostkeyAlgorithms = "+ssh-rsa";
        # pubkeyAcceptedAlgorithms = "+ssh-rsa";
        hostname = "192.168.0.1";
        port = 22;
        user = "root";
      };
      cyd = {
        hostname = "10.160.199.34";
        port = 30614;
        user = "root";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      cy = {
        hostname = "10.160.199.103";
        port = 30614;
        user = "root";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      i12500 = {
        hostname = "192.168.1.189";
        port = 22;
        user = "klchen";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      n1 = {hostname = "192.168.0.254";};
      tower = {
        hostname = "192.168.0.200";
        user = "root";
      };
      ningbo40 = {
        hostname = "10.82.68.40";
        port = 18022;
        user = "ckl";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      ningbo203 = {
        hostname = "10.82.68.203";
        port = 18022;
        user = "ckl";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      ningbo214 = {
        hostname = "10.82.1.214";
        port = 18022;
        user = "ckl";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      ningbo204 = {
        hostname = "10.82.68.204";
        port = 18022;
        user = "ckl";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };

  programs.mcfly = {
    enable = true;
    keyScheme = "emacs";
    enableLightTheme = true;
  };

  home.packages = with pkgs; [
    inetutils
    nodePackages.prettier
    shfmt
    shellcheck
    macchina
    dog
    choose
    du-dust
    duf
    just
    coreutils
    gnugrep
    lrzsz
    python312Packages.editorconfig
  ];
  home.sessionVariables = {
    "EIDTOR" = "emacs";
  };
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 80;
        indent_style = "space";
        indent_size = 4;
      };
    };
  };
  programs.nushell = {
    enable = true;
  };
}
