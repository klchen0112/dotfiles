{ pkgs
, ...
}:
{
  programs.gpg = {
    enable = true;
  };

  programs.btop = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

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

  programs.ripgrep = {
    enable = true;
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

}
