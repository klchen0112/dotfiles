# fish configuration
#
{
  lib,
  inputs,
  pkgs,
  isWork,
  config,
  ...
}:
{
  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      ".devenv"
    ];
    attributes = [ "*.pdf diff=pdf" ];
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
    extraConfig = {
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
  };
  programs.btop = {
    enable = true;
  };

  programs.bash = {
    enable = true;
  };
  programs.zsh = {
    enable = pkgs.stdenv.isDarwin;
    autosuggestion.enable = true; # Auto suggest options and highlights syntax, searches in history for options
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history.size = 100000;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
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
      # conda = "mamba";
      vim = "emacs -nw";
    };
    shellAliases = {
      conda = "mamba";
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
      {
        name = "tide";
        src = tide.src;
      }
    ];
    interactiveShellInit = "
    macchina
    ";
  };
  # code from https://www.reddit.com/r/NixOS/comments/1fcmxxp/comment/lma33h1/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  home.activation.configure-tide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.fish}/bin/fish -c  "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Light --prompt_spacing=Sparse --icons='Few icons' --transient=Yes"
  '';
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
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
      batpipe
      prettybat
    ];
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.tmux = {
    enable = true;
    # defaultKeyMode = "emacs";
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.jq = {
    enable = true;
  };
  programs.man = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
  };

  programs.starship = {
    enable = false;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
  programs.ripgrep = {
    enable = true;
  };

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
      n1 = {
        hostname = "192.168.0.254";
      };
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
