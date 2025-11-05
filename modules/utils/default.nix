{
  flake.modules.homeManager.utils =
    { pkgs, ... }:
    {
     programs.delta.enable = true;
      programs.gpg = {
        enable = true;
      };
      services.gpg-agent = {
        enable = true;
        pinentry = {
          package =
            if pkgs.stdenv.isLinux then

              pkgs.pinentry-gnome3
            else
              pkgs.pinentry_mac;
          program = if pkgs.stdenv.isLinux then "pinentry-gnome3" else "pinentry-mac";
        };
        enableSshSupport = true;
      };
      stylix.targets.btop.enable = true;
      programs.btop = {
        enable = true;
      };

      programs.zoxide = {
        enable = true;
      };

      programs.eza = {
        enable = true;
        icons = "auto";
        git = true;
      };

      stylix.targets.bat.enable = true;
      programs.bat = {
        enable = true;
        config = {
          style = "numbers,header,grid,changes,snip";
        };

        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
#          batgrep
          batwatch
          batpipe
          prettybat
        ];
      };

      stylix.targets.fzf.enable = true;
      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
      };

      stylix.targets.tmux.enable = true;
      programs.tmux = {
        enable = true;
        # defaultKeyMode = "emacs";
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.global = {
          # Make direnv messages less verbose
          hide_env_diff = true;
        };
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

      # programs.mcfly = {
      #   enable = true;
      #   keyScheme = "emacs";
      #   enableLightTheme = true;
      # };
      # A multi-shell completion library.
      programs.carapace = {
        enable = true;
      };

      home.packages = with pkgs; [
        inetutils
        nodePackages.prettier
        shfmt
        shellcheck
        choose
       dust
        duf
        just
        coreutils
        gnugrep
        lrzsz
        python312Packages.editorconfig
        just
        gcr
        dig
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

    };
}
