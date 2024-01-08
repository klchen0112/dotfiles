# fish configuration
#
{
  lib,
  inputs,
  pkgs,
  username,
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
      co = "checkout";
    };
    extraConfig = {
      init.defaultBranch = "master"; # https://srid.ca/unwoke
      core.editor = "emacsclient";
      #protocol.keybase.allow = "always";
      credential.helper = "store --file ~/.git-credentials";
      pull.rebase = "false";
      # For supercede
      core.symlinks = true;
    };
  };

  home.file.".config/btop/themes".source = "${inputs.catppuccin-btop}/themes";
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false; # make btop transparent
    };
  };

  programs.bash = {enable = true;};
  programs.zsh = {
    enable = true;
    enableAutosuggestions =
      true; # Auto suggest options and highlights syntax, searches in history for options
    # syntaxHighlighting.enable = true;
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
      conda = "micromamba";
    };
    shellAliases = {
      conda = "micromamba";
      "..." = "cd ../..";
      "cd" = "z";
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
    ];
  };
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfLight";
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
    # enableFishIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  programs.jq = {enable = true;};
  programs.man = {enable = true;};
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$shlvl"
        "$shell"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$cmake"
        "$python"
        "$nix_shell"
        "$cmd_duration"
        "$sudo"
        "$line_break"
        "$jobs"
        "$character"
      ];
      shlvl = {
        disabled = false;
        style = "bright-red bold";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-black) ";
        zsh_indicator = "[ZSH](bright-black) ";
      };
      username = {
        disabled = false;
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
      hostname = {
        disabled = false;
        style = "bright-green bold";
        ssh_only = true;
      };
      cmd_duration = {
        disabled = false;
        format = "⏱ $duration";
      };
      git_branch = {
        disabled = false;
        format = "[$symbol $branch]($style) ";
        symbol = "שׂ";
        style = "bright-yellow bold";
      };
      conda = {
        disabled = false;
        format = "[$symbol$environment](dimmed green) ";
      };
      git_commit = {
        disabled = false;
        only_detached = true;
        format = "[$hash]($style) ";
        style = "bright-yellow bold";
      };
      git_state = {
        disabled = false;
        style = "bright-purple bold";
      };
      git_status = {disabled = false;};
      sudo = {
        disabled = false;
        format = "as $symbol";
      };
      python = {
        disabled = false;
        format = "[$pyenv_prefix]($version)(($virtualenv))";
      };
      nix_shell = {
        disabled = false;
        format = "[$name]($style)";
      };
      nodejs = {
        disabled = false;
        format = "($version)";
      };
      cmake = {
        disabled = false;
        format = "($version)";
      };
    };
  };
  programs.ripgrep = {enable = true;};

  programs.ssh = {
    enable = true;
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
    fastfetch
    dog
    choose
    du-dust
    duf
  ];
}
