#
# fish configuration
#
{pkgs, ...}: {
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        ls = "exa";
        ll = "exa -lha";
        lt = "exa --tree";
        psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
        e = "emacsclient -nc";
        E = "sudoedit";
        grep = "rg";
        cat = "bat";
        conda = "micromamba";
      };

      # issue from https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /opt/homebrew/bin
                        # # >>> mamba initialize >>>
                        # # !! Contents within this block are managed by 'mamba init' !!
                        set -gx MAMBA_EXE \"/etc/profiles/per-user/$USER/bin/micromamba\"
                        set -gx MAMBA_ROOT_PREFIX \"$HOME/micromamba\"
                        eval \"/etc/profiles/per-user/$USER/bin/micromamba\" shell hook --shell fish --prefix \"$HOME/micromamba\" | source
                        # # <<< mamba initialize <<<
                        ";

      plugins = with pkgs.fishPlugins; [
        {
          name = "async-prompt";
          src = async-prompt;
        }
        {
          name = "z";
          src = z;
        }
        {
          name = "fzf-fish";
          src = fzf-fish;
        }
        {
          name = "colored-man-pages";
          src = colored-man-pages;
        }
        {
          name = "autopair";
          src = autopair-fish;
        }
        # {
        #   name = "tide";
        #   src = tide;
        # }
      ];
    };
  };
  home.packages = with pkgs; [
    exa
    ripgrep
    bat
    fzf
    shfmt
    tmux
  ];
}
